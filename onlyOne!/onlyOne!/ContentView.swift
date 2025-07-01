//
//  ContentView.swift
//  onlyOne!
//
//  Created by 차원준 on 7/1/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var questionStore = QuestionStore.shared
    @State private var showResetAlert = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                if let question = questionStore.todayQuestion {
                    // 이모지
                    Text(question.emoji)
                        .font(.system(size: 80))
                        .padding(.top, 20)
                    
                    // 질문 텍스트
                    Text(question.text)
                        .font(.title2)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // 카테고리 태그
                    HStack {
                        Image(systemName: categoryIcon(for: question.category))
                            .foregroundColor(Color(question.category.color))
                        Text(question.category.displayName)
                            .foregroundColor(Color(question.category.color))
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color(question.category.color).opacity(0.1))
                    .cornerRadius(20)
                    
                    Spacer()
                    
                    // 공유 버튼
                    Button(action: {
                        shareQuestion(question)
                    }) {
                        Label("질문 공유하기", systemImage: "square.and.arrow.up")
                            .font(.headline)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.bottom, 30)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(uiColor: .systemBackground))
            .navigationTitle("오늘의 질문")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showResetAlert = true
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .alert("질문 초기화", isPresented: $showResetAlert) {
                Button("취소", role: .cancel) { }
                Button("초기화", role: .destructive) {
                    questionStore.resetUsedQuestions()
                }
            } message: {
                Text("모든 질문 기록을 초기화하시겠습니까?")
            }
        }
    }
    
    private func categoryIcon(for category: Question.Category) -> String {
        switch category {
        case .memory: return "heart.fill"
        case .present: return "star.fill"
        case .future: return "sparkles"
        case .imagination: return "wand.and.stars"
        }
    }
    
    private func shareQuestion(_ question: Question) {
        let text = "\(question.emoji) \(question.text)\n\n#OnlyOne #커플질문"
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}

#Preview {
    ContentView()
}
