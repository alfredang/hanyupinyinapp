#!/usr/bin/env python3
"""Create (or reuse) an iOS Development provisioning profile via the ASC API and
install it locally, so a device build can be signed manually without an Apple ID
in Xcode. Idempotent.

Env: ASC_KEY_ID, ASC_ISSUER_ID, ASC_PRIVATE_KEY_PATH, ASC_BUNDLE_ID
Args: <device_udid> <device_name>
"""
import base64, json, os, sys, time, urllib.error, urllib.request
import jwt  # PyJWT

BASE = "https://api.appstoreconnect.apple.com"
KEY_ID = os.environ["ASC_KEY_ID"]
ISSUER = os.environ["ASC_ISSUER_ID"]
KEY_PATH = os.path.expanduser(os.environ["ASC_PRIVATE_KEY_PATH"])
BUNDLE = os.environ["ASC_BUNDLE_ID"]
UDID = sys.argv[1]
DEVNAME = sys.argv[2] if len(sys.argv) > 2 else "iPhone"
PROFILE_NAME = "HanyuPinyin AppStore " + BUNDLE.replace(".", "-")


def token():
    with open(KEY_PATH) as f:
        key = f.read()
    now = int(time.time())
    payload = {"iss": ISSUER, "iat": now, "exp": now + 1200, "aud": "appstoreconnect-v1"}
    return jwt.encode(payload, key, algorithm="ES256", headers={"kid": KEY_ID, "typ": "JWT"})


TOK = token()


def call(method, path, body=None):
    url = path if path.startswith("http") else BASE + path
    req = urllib.request.Request(
        url, data=(json.dumps(body).encode() if body else None), method=method,
        headers={"Authorization": f"Bearer {TOK}", "Content-Type": "application/json"})
    try:
        r = urllib.request.urlopen(req)
        b = r.read().decode()
        return r.status, (json.loads(b) if b.strip().startswith(("{", "[")) else b)
    except urllib.error.HTTPError as e:
        b = e.read().decode()
        return e.code, (json.loads(b) if b.strip().startswith(("{", "[")) else b)


def find(path):
    s, d = call("GET", path)
    if s != 200:
        sys.exit(f"GET {path} -> {s}: {d}")
    return d.get("data", [])


# 1. Development certificate
certs = find("/v1/certificates?limit=200")
dev_certs = [c for c in certs if c["attributes"]["certificateType"] in ("DISTRIBUTION", "IOS_DISTRIBUTION")]
if not dev_certs:
    sys.exit("No DEVELOPMENT certificate in the account.")
cert_id = dev_certs[0]["id"]
print(f"cert: {cert_id} ({dev_certs[0]['attributes'].get('displayName')})")

# 3. Bundle ID (create if missing)
bids = find("/v1/bundleIds?limit=200&filter[identifier]=" + BUNDLE)
bid = next((b for b in bids if b["attributes"]["identifier"] == BUNDLE), None)
if bid:
    bundle_id = bid["id"]
    print(f"bundleId: existing {bundle_id}")
else:
    s, d = call("POST", "/v1/bundleIds", {"data": {"type": "bundleIds", "attributes": {
        "identifier": BUNDLE, "name": "HanyuPinyin", "platform": "IOS"}}})
    if s not in (200, 201):
        sys.exit(f"create bundleId -> {s}: {d}")
    bundle_id = d["data"]["id"]
    print(f"bundleId: created {bundle_id}")

# 4. Profile — delete any stale one with our name, then create fresh (to include the device)
for p in find("/v1/profiles?limit=200"):
    if p["attributes"]["name"] == PROFILE_NAME:
        call("DELETE", f"/v1/profiles/{p['id']}")
        print("deleted stale profile")

s, d = call("POST", "/v1/profiles", {"data": {
    "type": "profiles",
    "attributes": {"name": PROFILE_NAME, "profileType": "IOS_APP_STORE"},
    "relationships": {
        "bundleId": {"data": {"type": "bundleIds", "id": bundle_id}},
        "certificates": {"data": [{"type": "certificates", "id": cert_id}]},
    }}})
if s not in (200, 201):
    sys.exit(f"create profile -> {s}: {d}")
content = d["data"]["attributes"]["profileContent"]
uuid = d["data"]["attributes"]["uuid"]
print(f"profile: created {PROFILE_NAME} uuid={uuid}")

# 5. Install locally
dest_dir = os.path.expanduser("~/Library/MobileDevice/Provisioning Profiles")
os.makedirs(dest_dir, exist_ok=True)
dest = os.path.join(dest_dir, uuid + ".mobileprovision")
with open(dest, "wb") as f:
    f.write(base64.b64decode(content))
print(f"installed: {dest}")
print(f"PROFILE_NAME={PROFILE_NAME}")
