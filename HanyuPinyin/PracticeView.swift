import SwiftUI

// MARK: - Session definition

struct PracticeSession: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let prompts: [PinyinPrompt]
    /// If set, this is a timed speed challenge (seconds) instead of a fixed-count round.
    var timed: Int? = nil
    /// If true, only the 简拼 (first-letter shortcut) is accepted — trains fast input.
    var shortcutOnly: Bool = false

    /// Build a list of `count` randomly-ordered prompts, repeating the pool if needed.
    func round(count: Int = 10) -> [PinyinPrompt] {
        var out: [PinyinPrompt] = []
        while out.count < count && !prompts.isEmpty { out += prompts.shuffled() }
        return Array(out.prefix(count))
    }
}

extension PinyinUnit {
    /// Turn an initial/final into a "show hanzi, type pinyin" prompt.
    var asPrompt: PinyinPrompt {
        PinyinPrompt(prompt: exampleHanzi,
                     toned: example,
                     answer: example.pinyinPlain,
                     meaning: exampleMeaning)
    }
}

extension String {
    /// Lowercased, diacritic-folded (tone marks & ü removed), spaces stripped.
    var pinyinPlain: String {
        folding(options: .diacriticInsensitive, locale: Locale(identifier: "en_US"))
            .lowercased()
            .replacingOccurrences(of: " ", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

enum PracticeCatalog {
    static let sessions: [PracticeSession] = [
        .init(title: "汉字练习", subtitle: "看汉字，打拼音 · Characters",
              icon: "character.book.closed.fill", color: Theme.accent,
              prompts: PinyinData.characters),
        .init(title: "词语练习", subtitle: "看词语，打拼音 · Words",
              icon: "text.word.spacing", color: Theme.secondary,
              prompts: PinyinData.words),
        .init(title: "声母练习", subtitle: "声母拼读 · Initials",
              icon: "a.square.fill", color: Theme.highlight,
              prompts: PinyinData.initials.map(\.asPrompt)),
        .init(title: "韵母练习", subtitle: "韵母拼读 · Finals",
              icon: "o.square.fill", color: Theme.success,
              prompts: PinyinData.finals.map(\.asPrompt)),
        .init(title: "长句练习", subtitle: "整句快打 · 可用简拼 · Sentences",
              icon: "bolt.fill", color: Color(red: 0.90, green: 0.45, blue: 0.10),
              prompts: PinyinData.sentences),
        .init(title: "简拼速打", subtitle: "只打首字母 · Shortcut drill",
              icon: "hare.fill", color: Color(red: 0.0, green: 0.55, blue: 0.55),
              prompts: PinyinData.sentences, shortcutOnly: true),
        .init(title: "限时挑战", subtitle: "60 秒速度挑战 · Speed challenge",
              icon: "timer", color: Color(red: 0.80, green: 0.15, blue: 0.40),
              prompts: PinyinData.characters + PinyinData.words, timed: 60),
        .init(title: "综合练习", subtitle: "汉字 + 词语混合 · Mixed",
              icon: "shuffle", color: Color(red: 0.55, green: 0.28, blue: 0.72),
              prompts: PinyinData.characters + PinyinData.words),
    ]
}

// MARK: - Practice home

struct PracticeHomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("练习输入")
                            .font(.largeTitle.bold())
                            .foregroundStyle(Theme.ink)
                        Text("选择一个练习，输入拼音，越快越好！")
                            .font(.subheadline)
                            .foregroundStyle(Theme.mutedInk)
                    }

                    ForEach(PracticeCatalog.sessions) { session in
                        NavigationLink {
                            PracticeSessionView(session: session)
                        } label: {
                            HStack(spacing: 16) {
                                Image(systemName: session.icon)
                                    .font(.title2)
                                    .foregroundStyle(.white)
                                    .frame(width: 48, height: 48)
                                    .background(session.color, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(session.title).font(.headline).foregroundStyle(Theme.ink)
                                    Text(session.subtitle).font(.subheadline).foregroundStyle(Theme.mutedInk)
                                }
                                Spacer()
                                Image(systemName: "chevron.right").foregroundStyle(Theme.mutedInk)
                            }
                            .appCard()
                        }
                    }
                }
                .padding(20)
            }
            .background(Theme.background)
            .navigationTitle("练习")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview { PracticeHomeView() }
