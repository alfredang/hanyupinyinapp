import SwiftUI

// MARK: - Session definition

struct PracticeSession: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let prompts: [PinyinPrompt]

    /// Build a session of `count` randomly-ordered prompts.
    func round(count: Int = 10) -> [PinyinPrompt] {
        Array(prompts.shuffled().prefix(count))
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
