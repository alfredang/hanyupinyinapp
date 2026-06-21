import SwiftUI

struct AboutView: View {
    private let developerURL = URL(string: "https://www.tertiaryinfotech.com")!

    private var versionString: String {
        let i = Bundle.main.infoDictionary
        let s = i?["CFBundleShortVersionString"] as? String ?? "1.0"
        let b = i?["CFBundleVersion"] as? String ?? "1"
        return "\(s) (\(b))"
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // App card
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 14) {
                            Image(systemName: "character.bubble.fill")
                                .font(.title)
                                .foregroundStyle(.white)
                                .frame(width: 52, height: 52)
                                .background(Theme.accent, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("汉语拼音").font(.title3.bold()).foregroundStyle(Theme.ink)
                                Text("Hanyu Pinyin").font(.subheadline).foregroundStyle(Theme.mutedInk)
                            }
                        }
                        Text("学习汉语拼音的声母、韵母和声调，并通过多种练习快速掌握拼音输入。")
                            .font(.subheadline)
                            .foregroundStyle(Theme.mutedInk)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .appCard()

                    // Developer card
                    Text("开发者 · DEVELOPER")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.mutedInk)
                    VStack(alignment: .leading, spacing: 0) {
                        Label("Tertiary Infotech Academy Pte Ltd", systemImage: "building.2.fill")
                            .foregroundStyle(Theme.ink)
                            .padding(.vertical, 14)
                        Divider()
                        Link(destination: developerURL) {
                            Label("tertiaryinfotech.com", systemImage: "globe")
                                .foregroundStyle(Theme.secondary)
                        }
                        .padding(.vertical, 14)
                    }
                    .appCard()

                    // Version row
                    HStack {
                        Text("版本").foregroundStyle(Theme.ink)
                        Spacer()
                        Text(versionString).foregroundStyle(Theme.mutedInk)
                    }
                    .appCard()
                }
                .padding(22)
            }
            .background(Theme.background)
            .navigationTitle("关于")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview { AboutView() }
