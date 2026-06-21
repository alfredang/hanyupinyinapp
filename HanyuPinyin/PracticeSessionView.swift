import SwiftUI

struct PracticeSessionView: View {
    let session: PracticeSession

    @State private var prompts: [PinyinPrompt]
    @State private var index = 0
    @State private var entry = ""
    @State private var feedback: Feedback? = nil
    @State private var correctCount = 0
    @State private var startDate = Date()
    @State private var finished = false
    @FocusState private var focused: Bool

    enum Feedback: Equatable { case correct, wrong(String) }

    init(session: PracticeSession) {
        self.session = session
        _prompts = State(initialValue: session.round())
    }

    var body: some View {
        Group {
            if finished {
                ResultView(total: prompts.count,
                           correct: correctCount,
                           seconds: Date().timeIntervalSince(startDate),
                           onRestart: restart)
            } else {
                sessionBody
            }
        }
        .background(Theme.background)
        .navigationTitle(session.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if prompts.isEmpty { prompts = session.round() }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                focused = true
                Speaker.shared.speak(current.prompt)
            }
        }
    }

    private var current: PinyinPrompt {
        prompts.indices.contains(index) ? prompts[index] : prompts[0]
    }

    private var sessionBody: some View {
        VStack(spacing: 20) {
            // Progress
            VStack(spacing: 8) {
                ProgressView(value: Double(index), total: Double(max(prompts.count, 1)))
                    .tint(Theme.accent)
                HStack {
                    Text("第 \(index + 1) / \(prompts.count) 题")
                        .font(.subheadline).foregroundStyle(Theme.mutedInk)
                    Spacer()
                    Label("\(correctCount)", systemImage: "checkmark.circle.fill")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.success)
                }
            }

            // Prompt card
            VStack(spacing: 10) {
                Text(current.prompt)
                    .font(.system(size: 64, weight: .bold))
                    .foregroundStyle(Theme.ink)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                Text(current.meaning)
                    .font(.subheadline)
                    .foregroundStyle(Theme.mutedInk)
                if !current.abbr.isEmpty {
                    Text("简拼快捷键：\(current.abbr)（输入首字母也算对）")
                        .font(.caption)
                        .foregroundStyle(Theme.highlight)
                }
                if case .correct = feedback {
                    Text(current.toned)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(Theme.highlight)
                }
                Text("点一下朗读")
                    .font(.caption2)
                    .foregroundStyle(Theme.secondary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            .appCard()
            .contentShape(Rectangle())
            .onTapGesture { Speaker.shared.speak(current.prompt) }

            // Input
            VStack(spacing: 12) {
                TextField("输入拼音…", text: $entry)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .submitLabel(.go)
                    .focused($focused)
                    .padding(.vertical, 14)
                    .background(Theme.surface, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(borderColor, lineWidth: 2)
                    )
                    .onSubmit(handleSubmit)
                    .disabled(feedback != nil)

                if let feedback {
                    feedbackBanner(feedback)
                }

                Button(action: primaryAction) {
                    Text(feedback == nil ? "确认" : "下一题")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Theme.accent, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .disabled(feedback == nil && entry.trimmingCharacters(in: .whitespaces).isEmpty)
                .opacity(feedback == nil && entry.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1)
            }

            Spacer()
        }
        .padding(20)
    }

    private var borderColor: Color {
        switch feedback {
        case .correct: return Theme.success
        case .wrong: return Theme.error
        case nil: return .clear
        }
    }

    @ViewBuilder
    private func feedbackBanner(_ feedback: Feedback) -> some View {
        switch feedback {
        case .correct:
            Label("正确！", systemImage: "checkmark.circle.fill")
                .font(.headline).foregroundStyle(Theme.success)
                .frame(maxWidth: .infinity, alignment: .leading)
        case .wrong(let answer):
            HStack(spacing: 8) {
                Image(systemName: "xmark.circle.fill").foregroundStyle(Theme.error)
                Text("正确答案：")
                    .foregroundStyle(Theme.ink)
                Text(answer).font(.headline).foregroundStyle(Theme.error)
                Spacer()
            }
            .font(.subheadline)
        }
    }

    // MARK: - Logic

    private func handleSubmit() {
        if feedback == nil { check() } else { next() }
    }

    private func primaryAction() {
        if feedback == nil { check() } else { next() }
    }

    private func check() {
        let typed = entry.pinyinPlain
        guard !typed.isEmpty else { return }
        let abbr = current.abbr.lowercased()
        if typed == current.answer || (!abbr.isEmpty && typed == abbr) {
            correctCount += 1
            feedback = .correct
        } else {
            feedback = .wrong(current.answer)
        }
        Speaker.shared.speak(current.prompt)   // reinforce correct pronunciation
    }

    private func next() {
        if index + 1 >= prompts.count {
            finished = true
        } else {
            index += 1
            entry = ""
            feedback = nil
            focused = true
            Speaker.shared.speak(current.prompt)
        }
    }

    private func restart() {
        prompts = session.round()
        index = 0
        entry = ""
        feedback = nil
        correctCount = 0
        finished = false
        startDate = Date()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { focused = true }
    }
}

// MARK: - Result

private struct ResultView: View {
    let total: Int
    let correct: Int
    let seconds: TimeInterval
    let onRestart: () -> Void

    private var accuracy: Int { total == 0 ? 0 : Int(round(Double(correct) / Double(total) * 100)) }
    private var perMinute: Int { seconds <= 0 ? 0 : Int(round(Double(correct) / seconds * 60)) }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Image(systemName: accuracy >= 80 ? "star.circle.fill" : "checkmark.seal.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(accuracy >= 80 ? Theme.highlight : Theme.success)
                    .padding(.top, 30)

                Text(accuracy >= 80 ? "太棒了！" : "完成练习")
                    .font(.largeTitle.bold())
                    .foregroundStyle(Theme.ink)

                HStack(spacing: 12) {
                    stat(value: "\(correct)/\(total)", label: "正确")
                    stat(value: "\(accuracy)%", label: "准确率")
                    stat(value: "\(perMinute)", label: "字/分钟")
                }

                Button(action: onRestart) {
                    Label("再来一次", systemImage: "arrow.clockwise")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Theme.accent, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .padding(.top, 8)
            }
            .padding(24)
        }
    }

    private func stat(value: String, label: String) -> some View {
        VStack(spacing: 6) {
            Text(value).font(.title2.bold()).foregroundStyle(Theme.accent)
            Text(label).font(.caption).foregroundStyle(Theme.mutedInk)
        }
        .frame(maxWidth: .infinity)
        .appCard(padding: 14)
    }
}
