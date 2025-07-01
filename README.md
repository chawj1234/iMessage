# onlyOne! - 커플을 위한 하루 하나의 질문

## 📱 앱 소개
onlyOne!은 매일 하나의 특별한 질문을 통해 연인과의 소중한 대화를 이끌어내는 커플 앱입니다. iMessage 확장 기능을 통해 서로의 생각과 감정을 더 깊이 있게 나눌 수 있습니다. 매일 새로운 질문으로 당신의 연인과 특별한 대화를 시작하세요.

## ✨ 주요 기능

### iOS 앱
- 매일 새로운 커플 맞춤 질문 제공
- 4가지 카테고리의 질문:
  - 추억 (Memory): 연인과의 특별했던 순간들
  - 현재 (Present): 서로에 대한 지금의 감정과 생각
  - 미래 (Future): 함께 그려나갈 미래에 대한 이야기
  - 상상 (Imagination): 연인과 함께 나누는 상상과 가정
- 답변 작성 및 저장
- 커플을 위한 감성적이고 모던한 UI/UX

### iMessage 확장 앱
- iOS 앱과 동일한 일일 질문 동기화
- 연인과 실시간으로 질문 공유
- 서로의 답변을 통한 깊이 있는 대화
- 감성적인 메시지 레이아웃

## 🛠 기술 스택
- SwiftUI
- MVVM 아키텍처
- UserDefaults (App Groups를 통한 데이터 공유)
- MessageUI Framework
- StoreKit

## 📂 프로젝트 구조

```
onlyOne!/
├── onlyOne! (iOS 앱)
│   ├── Models
│   ├── ViewModels
│   ├── Views
│   └── Services
├── onlyOneiM (iMessage 확장)
│   ├── Models
│   ├── Services
│   └── Assets
└── Shared
    └── QuestionStore
```

## 💡 주요 컴포넌트

### Models
- `Question`: 질문 데이터 모델

### ViewModels
- `QuestionViewModel`: 질문 상태 관리 및 비즈니스 로직

### Services
- `QuestionStore`: 질문 데이터 관리 및 앱 간 동기화

### Views
- `SafeText`: 안전한 텍스트 입력 처리
- `ContentView`: 메인 UI 구성

## 🔄 동기화 메커니즘
- App Groups를 통한 iOS 앱과 iMessage 확장 간 데이터 동기화
- UserDefaults를 활용한 질문 ID 및 날짜 동기화
- 앱 실행 시 자동 동기화로 연인과 같은 질문 공유

## 🎨 디자인
- 로맨틱하고 감성적인 컬러 테마
- 커플을 위한 모던하고 미니멀한 UI
- 직관적이고 친근한 사용자 경험

## 💕 이런 분들께 추천드려요
- 연인과의 대화 주제를 찾고 계신 분
- 서로에 대해 더 깊이 알아가고 싶은 커플
- 매일 특별한 대화로 관계를 발전시키고 싶은 분
- 연인과 함께 추억을 기록하고 싶으신 분

## 📝 라이센스
Copyright © 2024 onlyOne! All rights reserved.
