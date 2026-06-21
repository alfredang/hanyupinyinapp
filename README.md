# 汉语拼音 · Hanyu Pinyin

A native iOS app for learning **Hanyu Pinyin** (Chinese romanization) and practicing fast
**pinyin input** — the way you actually type Chinese on a keyboard. Inspired by
[pinyinput.com](https://www.pinyinput.com/).

![汉语拼音 — Learn, Practice, and typing session](screenshot.png)

![Platform](https://img.shields.io/badge/platform-iOS%2017%2B-black?logo=apple)
![Swift](https://img.shields.io/badge/Swift-5-orange?logo=swift)
![SwiftUI](https://img.shields.io/badge/SwiftUI-white?logo=swift&logoColor=blue)
![XcodeGen](https://img.shields.io/badge/XcodeGen-project-blue)

## Features

- **学习 (Learn)** — the building blocks of pinyin, each with example characters:
  - 声母 (23 initials), 韵母 (finals), 声调 (the four tones), and how a 拼音输入法 works.
- **练习 (Practice)** — five typing sessions that show Chinese and ask you to type the pinyin
  (no tone marks needed, just like a real IME):
  - 汉字 (characters), 词语 (words), 声母, 韵母, and a 综合 (mixed) round.
  - Live correct/wrong feedback, the toned answer revealed, and an end screen scoring
    **accuracy** and **字/分钟 (characters per minute)** to push your input speed.
- **反馈 (Feedback)** — send feedback straight to the team via WhatsApp.
- **关于 (About)** — app info, developer, and version.

White theme, Simplified-Chinese interface, iPhone, portrait.

## Tech stack

| Layer | Choice |
|-------|--------|
| UI | SwiftUI (`TabView`, `NavigationStack`) |
| Language | Swift 5 |
| Min OS | iOS 17 |
| Project gen | [XcodeGen](https://github.com/yonatankra/XcodeGen) (`project.yml`) |
| Theme | Single `Theme.swift` token file |

## Project structure

```
HanyuPinyin/
  HanyuPinyinApp.swift      app entry
  MainTabView.swift         bottom tab bar (学习 / 练习 / 反馈 / 关于)
  Theme.swift               white-theme color tokens + card modifier
  PinyinData.swift          initials, finals, tones, characters, words
  LearnView.swift           learn screens
  PracticeView.swift        session catalog + home
  PracticeSessionView.swift typing flow, scoring, results
  FeedbackView.swift        WhatsApp feedback form
  AboutView.swift           developer + version
project.yml                 XcodeGen config
```

## Build & run

```bash
brew install xcodegen          # one-time
xcodegen generate
open HanyuPinyin.xcodeproj
```

Or from the command line, onto the booted simulator:

```bash
xcodegen generate
xcodebuild -project HanyuPinyin.xcodeproj -scheme HanyuPinyin \
  -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 17' build
```

## Acknowledgements

Concept reference: [pinyinput.com](https://www.pinyinput.com/).
Developed by [Tertiary Infotech Academy Pte Ltd](https://www.tertiaryinfotech.com).
