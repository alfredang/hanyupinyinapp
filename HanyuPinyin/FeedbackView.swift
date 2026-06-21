import SwiftUI

struct FeedbackView: View {
    private let whatsAppNumber = "6588666375"   // +65 8866 6375, no "+"/spaces
    @State private var title = ""
    @State private var message = ""

    private var canSend: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("欢迎反馈意见或建议，我们会尽快回复。")
                        .font(.subheadline)
                        .foregroundStyle(Theme.mutedInk)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("标题").font(.caption.weight(.semibold)).foregroundStyle(Theme.mutedInk)
                        TextField("标题", text: $title)
                            .padding(14)
                            .background(Theme.surface, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("内容").font(.caption.weight(.semibold)).foregroundStyle(Theme.mutedInk)
                        ZStack(alignment: .topLeading) {
                            if message.isEmpty {
                                Text("你的留言…")
                                    .foregroundStyle(Theme.mutedInk)
                                    .padding(.horizontal, 18)
                                    .padding(.vertical, 22)
                            }
                            TextEditor(text: $message)
                                .scrollContentBackground(.hidden)
                                .frame(minHeight: 160)
                                .padding(8)
                        }
                        .background(Theme.surface, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }

                    Button(action: send) {
                        Label("通过 WhatsApp 发送", systemImage: "paperplane.fill")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(canSend ? Theme.accent : Theme.mutedInk,
                                        in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                    .disabled(!canSend)
                }
                .padding(22)
            }
            .background(Theme.background)
            .navigationTitle("反馈")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func send() {
        var text = ""
        let t = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let m = message.trimmingCharacters(in: .whitespacesAndNewlines)
        if !t.isEmpty { text += "*\(t)*\n" }
        text += m
        var comps = URLComponents()
        comps.scheme = "https"
        comps.host = "wa.me"
        comps.path = "/\(whatsAppNumber)"
        comps.queryItems = [URLQueryItem(name: "text", value: text)]
        if let url = comps.url { UIApplication.shared.open(url) }
    }
}

#Preview { FeedbackView() }
