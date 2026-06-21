import SwiftUI

struct SettingsView: View {
    @StateObject private var speaker = Speaker.shared
    @AppStorage("voiceGender") private var gender: String = VoiceGender.female.rawValue

    private var selected: VoiceGender { VoiceGender(rawValue: gender) ?? .female }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("设置发音朗读使用的声音。")
                        .font(.subheadline)
                        .foregroundStyle(Theme.mutedInk)

                    // Voice card
                    VStack(alignment: .leading, spacing: 14) {
                        Label("朗读声音", systemImage: "speaker.wave.2.fill")
                            .font(.headline)
                            .foregroundStyle(Theme.ink)

                        Picker("声音", selection: $gender) {
                            ForEach(VoiceGender.allCases) { g in
                                Text("\(g.label) · \(g.englishLabel)").tag(g.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)

                        if !speaker.isAvailable(selected) {
                            Label("此设备未安装\(selected.label)，将使用可用的中文语音。可在 设置 › 辅助功能 › 朗读内容 › 声音 中下载。",
                                  systemImage: "exclamationmark.triangle.fill")
                                .font(.footnote)
                                .foregroundStyle(Theme.highlight)
                        } else {
                            Label("当前使用\(selected.label)（\(selected.englishLabel)）",
                                  systemImage: "checkmark.circle.fill")
                                .font(.footnote)
                                .foregroundStyle(Theme.success)
                        }

                        Button {
                            speaker.speak("你好，欢迎学习汉语拼音")
                        } label: {
                            Label("试听发音", systemImage: "play.circle.fill")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Theme.accent, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .appCard()
                }
                .padding(20)
            }
            .background(Theme.background)
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview { SettingsView() }
