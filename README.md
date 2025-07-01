# OnlyOne!

매일 하나의 특별한 질문으로 연인과의 대화를 시작하세요.

## 주요 기능

- 매일 새로운 커플 질문 제공
- 4가지 카테고리의 질문:
  - 추억 (Memory): 과거의 특별한 순간들
  - 현재 (Present): 지금의 감정과 생각
  - 미래 (Future): 함께할 미래에 대한 계획
  - 상상 (Imagination): 가정하고 상상하는 질문들
- 이모지와 함께 제공되는 질문
- 깔끔하고 모던한 UI

## 기술 스택

- SwiftUI
- UserDefaults (App Group을 통한 데이터 공유)
- Swift 5.0+
- iOS 15.0+

## 프로젝트 구조

```
onlyOne!/
├── Models/
│   └── Question.swift     # 질문 모델 정의
├── Services/
│   └── QuestionStore.swift # 질문 관리 서비스
├── ContentView.swift      # 메인 앱 UI
└── onlyOne_App.swift     # 앱 진입점
```

## 설치 및 실행

1. Xcode로 프로젝트 열기
2. App Group 설정 확인
3. 시뮬레이터 또는 실제 기기에서 실행

## 개발자

- 차원준 (Wonjun Cha)
