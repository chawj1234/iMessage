# onlyOne! - 커플을 위한 하루 하나의 질문

## 📱 앱 소개
onlyOne!은 매일 하나의 특별한 질문을 통해 연인과의 소중한 대화를 이끌어내는 커플 앱입니다. iMessage 확장 기능을 통해 서로의 생각과 감정을 더 깊이 있게 나눌 수 있으며, **개인 답변을 작성하고 저장하여 소중한 추억을 기록**할 수 있습니다. 매일 새로운 질문으로 당신의 연인과 특별한 대화를 시작하고, 함께 쌓아가는 이야기들을 간직하세요.

## ✨ 주요 기능

### iOS 앱
- 매일 새로운 커플 맞춤 질문 제공
- 4가지 카테고리의 질문:
  - 추억 (Memory): 연인과의 특별했던 순간들
  - 현재 (Present): 서로에 대한 지금의 감정과 생각
  - 미래 (Future): 함께 그려나갈 미래에 대한 이야기
  - 상상 (Imagination): 연인과 함께 나누는 상상과 가정
- **답변 작성 및 저장 시스템**:
  - 질문별 개인 답변 작성 및 저장
  - 사진과 함께 답변 작성 가능
  - 답변 수정 및 삭제 기능
  - 월별/카테고리별 답변 히스토리 확인
  - 일기처럼 답변을 기록하고 추억 저장
- 커플을 위한 감성적이고 모던한 UI/UX

### iMessage 확장 앱
- iOS 앱과 동일한 일일 질문 동기화
- 연인과 실시간으로 질문 공유
- **답변 작성 및 공유 기능**:
  - iMessage 내에서 직접 답변 작성
  - 답변을 포함한 메시지 전송
  - iOS 앱과 답변 데이터 동기화
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
│   │   ├── Question.swift
│   │   └── Answer.swift
│   ├── ViewModels
│   │   └── QuestionViewModel.swift
│   ├── Views
│   │   ├── ContentView.swift
│   │   ├── AnswerWriteView.swift
│   │   ├── AnswerDetailView.swift
│   │   ├── AnswerHistoryView.swift
│   │   └── SafeText.swift
│   └── Services
│       ├── QuestionStore.swift
│       └── AnswerStore.swift
├── onlyOneiM (iMessage 확장)
│   ├── Models
│   │   ├── Question.swift
│   │   └── Answer.swift
│   ├── Services
│   │   ├── QuestionStore.swift
│   │   └── AnswerStore.swift
│   └── Assets
└── Shared
    └── App Groups (데이터 동기화)
```

## 💡 주요 컴포넌트

### Models
- `Question`: 질문 데이터 모델 (ID, 텍스트, 카테고리, 이모지)
- `Answer`: 답변 데이터 모델 (텍스트, 사진, 날짜, 질문 정보)

### ViewModels
- `QuestionViewModel`: 질문 상태 관리 및 비즈니스 로직

### Services
- `QuestionStore`: 질문 데이터 관리 및 앱 간 동기화
- `AnswerStore`: 답변 저장/불러오기 및 데이터 관리

### Views
- `ContentView`: 메인 UI 구성 (질문 표시, 답변 작성 버튼)
- `AnswerWriteView`: 답변 작성 페이지 (텍스트, 사진 첨부)
- `AnswerDetailView`: 답변 상세 보기 (수정, 삭제 기능)
- `AnswerHistoryView`: 답변 히스토리 (월별, 카테고리별 정렬)
- `SafeText`: 안전한 텍스트 입력 처리

## 🔄 동기화 메커니즘
- App Groups를 통한 iOS 앱과 iMessage 확장 간 데이터 동기화
- UserDefaults를 활용한 질문 ID 및 날짜 동기화
- **답변 데이터 동기화**: JSON 인코딩을 통한 답변 저장 및 동기화
- 앱 실행 시 자동 동기화로 연인과 같은 질문 공유
- 실시간 답변 상태 업데이트 및 UI 반영

## 🎨 디자인
- 로맨틱하고 감성적인 컬러 테마
- 커플을 위한 모던하고 미니멀한 UI
- 직관적이고 친근한 사용자 경험

## 💕 이런 분들께 추천드려요
- 연인과의 대화 주제를 찾고 계신 분
- 서로에 대해 더 깊이 알아가고 싶은 커플
- 매일 특별한 대화로 관계를 발전시키고 싶은 분
- **연인과 함께 추억을 기록하고 저장하고 싶으신 분**
- **일기처럼 매일의 생각과 감정을 정리하고 싶은 분**
- **사진과 함께 소중한 순간들을 보관하고 싶은 커플**
- **지난 답변들을 되돌아보며 관계의 성장을 확인하고 싶은 분**

## 📝 라이센스
Copyright © 2024 onlyOne! All rights reserved.
