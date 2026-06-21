import SwiftUI

struct LearnView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    header

                    NavigationLink {
                        UnitGridView(title: "声母", subtitle: "23 个声母 · Initials", units: PinyinData.initials)
                    } label: {
                        LearnCard(icon: "a.square.fill", color: Theme.accent,
                                  title: "声母", subtitle: "23 个声母 · Initials")
                    }

                    NavigationLink {
                        UnitGridView(title: "韵母", subtitle: "常用韵母 · Finals", units: PinyinData.finals)
                    } label: {
                        LearnCard(icon: "o.square.fill", color: Theme.secondary,
                                  title: "韵母", subtitle: "常用韵母 · Finals")
                    }

                    NavigationLink {
                        TonesView()
                    } label: {
                        LearnCard(icon: "waveform", color: Theme.highlight,
                                  title: "声调", subtitle: "四个声调 · Four tones")
                    }

                    NavigationLink {
                        InputMethodView()
                    } label: {
                        LearnCard(icon: "keyboard", color: Theme.success,
                                  title: "拼音输入法", subtitle: "如何用拼音打字 · Typing")
                    }

                    NavigationLink {
                        FastTypingView()
                    } label: {
                        LearnCard(icon: "bolt.fill", color: Color(red: 0.90, green: 0.45, blue: 0.10),
                                  title: "快速输入技巧", subtitle: "简拼与快捷打字 · Fast typing")
                    }
                }
                .padding(20)
            }
            .background(Theme.background)
            .navigationTitle("学习拼音")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("汉语拼音")
                .font(.largeTitle.bold())
                .foregroundStyle(Theme.ink)
            Text("从声母、韵母到声调，掌握拼音输入。")
                .font(.subheadline)
                .foregroundStyle(Theme.mutedInk)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 2)
    }
}

private struct LearnCard: View {
    let icon: String
    let color: Color
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(color, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.headline).foregroundStyle(Theme.ink)
                Text(subtitle).font(.subheadline).foregroundStyle(Theme.mutedInk)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(Theme.mutedInk)
        }
        .appCard()
    }
}

// MARK: - Initials / Finals grid

struct UnitGridView: View {
    let title: String
    let subtitle: String
    let units: [PinyinUnit]

    private let columns = [GridItem(.adaptive(minimum: 96), spacing: 12)]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(Theme.mutedInk)
                Label("点一下卡片即可朗读发音", systemImage: "speaker.wave.2.fill")
                    .font(.caption)
                    .foregroundStyle(Theme.secondary)
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(units) { unit in
                        Button {
                            Speaker.shared.speak(unit.exampleHanzi)
                        } label: {
                            VStack(spacing: 6) {
                                Text(unit.symbol)
                                    .font(.system(size: 30, weight: .bold, design: .rounded))
                                    .foregroundStyle(Theme.accent)
                                Text(unit.example)
                                    .font(.headline)
                                    .foregroundStyle(Theme.ink)
                                Text(unit.exampleMeaning)
                                    .font(.caption2)
                                    .foregroundStyle(Theme.mutedInk)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 110)
                            .appCard(padding: 8)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(20)
        }
        .background(Theme.background)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Tones

struct TonesView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("普通话有四个声调，声调不同，意思不同。")
                    .font(.subheadline)
                    .foregroundStyle(Theme.mutedInk)
                Label("点一下卡片即可朗读发音", systemImage: "speaker.wave.2.fill")
                    .font(.caption)
                    .foregroundStyle(Theme.secondary)
                ForEach(Array(PinyinData.tones.enumerated()), id: \.offset) { idx, tone in
                    Button {
                        Speaker.shared.speak(String(tone.mark.split(separator: " ").last ?? ""))
                    } label: {
                        HStack(spacing: 16) {
                            Text("\(idx + 1)")
                                .font(.title.bold())
                                .foregroundStyle(.white)
                                .frame(width: 48, height: 48)
                                .background(Theme.highlight, in: Circle())
                            VStack(alignment: .leading, spacing: 4) {
                                Text(tone.mark).font(.title3.bold()).foregroundStyle(Theme.ink)
                                Text(tone.name).font(.subheadline).foregroundStyle(Theme.ink)
                                Text(tone.desc).font(.caption).foregroundStyle(Theme.mutedInk)
                            }
                            Spacer()
                        }
                        .appCard()
                    }
                    .buttonStyle(.plain)
                }
                Text("提示：用拼音输入法打字时，一般不用输入声调，直接打字母即可。")
                    .font(.footnote)
                    .foregroundStyle(Theme.mutedInk)
                    .padding(.top, 4)
            }
            .padding(20)
        }
        .background(Theme.background)
        .navigationTitle("声调")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Input method how-to

struct InputMethodView: View {
    private let steps: [(String, String)] = [
        ("输入字母", "打出拼音字母，例如 “nihao” 表示「你好」。"),
        ("无需声调", "拼音输入法不需要输入声调符号，直接打字母。"),
        ("整词输入", "可以一次输入整个词语，例如 “zhongguo” → 中国。"),
        ("选字", "用数字键或空格选择候选字，常用字通常排在最前。"),
        ("动手练习", "光看不够，马上动手输入拼音，越练越快！"),
    ]

    /// The 限时挑战 and 简拼速打 sessions, surfaced right from the lesson.
    private var speedChallenge: PracticeSession? {
        PracticeCatalog.sessions.first { $0.title == "限时挑战" }
    }
    private var shortcutDrill: PracticeSession? {
        PracticeCatalog.sessions.first { $0.title == "简拼速打" }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("拼音输入法把拼音字母转换成汉字，是最常用的中文输入方式。")
                    .font(.subheadline)
                    .foregroundStyle(Theme.mutedInk)
                ForEach(Array(steps.enumerated()), id: \.offset) { idx, step in
                    HStack(alignment: .top, spacing: 16) {
                        Text("\(idx + 1)")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: 32, height: 32)
                            .background(Theme.success, in: Circle())
                        VStack(alignment: .leading, spacing: 4) {
                            Text(step.0).font(.headline).foregroundStyle(Theme.ink)
                            Text(step.1).font(.subheadline).foregroundStyle(Theme.mutedInk)
                        }
                        Spacer()
                    }
                    .appCard()
                }

                Text("立即练习")
                    .font(.headline)
                    .foregroundStyle(Theme.ink)
                    .padding(.top, 6)
                if let s = speedChallenge {
                    NavigationLink { PracticeSessionView(session: s) } label: {
                        practiceButton(icon: "timer", title: "限时挑战",
                                       subtitle: "60 秒内尽量多打 · 测速度", color: Color(red: 0.80, green: 0.15, blue: 0.40))
                    }
                }
                if let s = shortcutDrill {
                    NavigationLink { PracticeSessionView(session: s) } label: {
                        practiceButton(icon: "hare.fill", title: "简拼速打",
                                       subtitle: "只打首字母 · 练快捷输入", color: Color(red: 0.0, green: 0.55, blue: 0.55))
                    }
                }
            }
            .padding(20)
        }
        .background(Theme.background)
        .navigationTitle("拼音输入法")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func practiceButton(icon: String, title: String, subtitle: String, color: Color) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2).foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(color, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.headline).foregroundStyle(Theme.ink)
                Text(subtitle).font(.subheadline).foregroundStyle(Theme.mutedInk)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(Theme.mutedInk)
        }
        .appCard()
    }
}

// MARK: - Fast typing tips

struct FastTypingView: View {
    private let tips: [(String, String)] = [
        ("整句输入", "一次连续打出整句拼音，不用空格、不用声调。例如 “woaini” → 我爱你，输入法会自动分词。"),
        ("简拼（首字母）", "只打每个字的第一个字母即可。例如 “bjdx” → 北京大学，“wan” → 我爱你。常用词用简拼最快。"),
        ("空格选词", "打完拼音按空格键就选中第一个候选词；常用字一般排在最前面。"),
        ("数字选字", "候选栏里用数字键 1–9 快速选择对应的字或词。"),
        ("ü 用 v 代替", "韵母 ü 在键盘上打字母 v。例如 “lv” → 绿，“nv” → 女。"),
        ("善用联想", "选完一个词后，输入法会联想下一个常用词，直接按数字即可，省去重复输入。"),
        ("多用长句练习", "到「练习 › 长句练习」里用整句和简拼来训练，速度会越来越快！"),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("掌握这些技巧，拼音输入又快又准。")
                    .font(.subheadline)
                    .foregroundStyle(Theme.mutedInk)
                ForEach(Array(tips.enumerated()), id: \.offset) { idx, tip in
                    HStack(alignment: .top, spacing: 16) {
                        Image(systemName: "bolt.fill")
                            .font(.subheadline)
                            .foregroundStyle(.white)
                            .frame(width: 32, height: 32)
                            .background(Color(red: 0.90, green: 0.45, blue: 0.10), in: Circle())
                        VStack(alignment: .leading, spacing: 4) {
                            Text(tip.0).font(.headline).foregroundStyle(Theme.ink)
                            Text(tip.1).font(.subheadline).foregroundStyle(Theme.mutedInk)
                        }
                        Spacer()
                    }
                    .appCard()
                }
            }
            .padding(20)
        }
        .background(Theme.background)
        .navigationTitle("快速输入技巧")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview { LearnView() }
