//
//  ContentView.swift
//  onlyOne!
//
//  Created by 차원준 on 7/1/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var questionStore = QuestionStore.shared
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // 이모지
                Text(questionStore.todayQuestion.emoji)
                    .font(.system(size: 80))
                    .padding(.top, 20)
                
                // 질문 텍스트
                Text(questionStore.todayQuestion.text)
                    .font(.title2)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // 카테고리 태그
                HStack {
                    Image(systemName: categoryIcon(for: questionStore.todayQuestion.category))
                        .foregroundColor(Color(questionStore.todayQuestion.category.color))
                    Text(questionStore.todayQuestion.category.displayName)
                        .foregroundColor(Color(questionStore.todayQuestion.category.color))
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color(questionStore.todayQuestion.category.color).opacity(0.1))
                .cornerRadius(20)
                
                Spacer()
                
                // 공유 버튼
                Button(action: {
                    shareQuestion(questionStore.todayQuestion)
                }) {
                    Label("질문 공유하기", systemImage: "square.and.arrow.up")
                        .font(.headline)
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom, 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(uiColor: .systemBackground))
            .navigationTitle("오늘의 질문")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        questionStore.getNextQuestion()
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
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
