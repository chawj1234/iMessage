//
//  ContentView.swift
//  onlyOne!
//
//  Created by 차원준 on 7/1/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = QuestionViewModel()
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // 이모지
                SafeText(
                    viewModel.questionEmoji,
                    font: .system(size: 80)
                )
                .padding(.top, 20)
                .safeTextTransition()
                
                // 질문 텍스트
                SafeText(
                    viewModel.questionText,
                    font: .title2,
                    weight: .medium,
                    alignment: .center
                )
                .padding(.horizontal)
                .safeTextTransition()
                
                // 카테고리 태그
                CategoryTagView(
                    icon: viewModel.categoryIcon(),
                    title: viewModel.categoryDisplayName,
                    color: viewModel.categoryColor
                )
                .safeTextTransition()
                
                Spacer()
                
                // 공유 버튼
                ShareButton(shareText: viewModel.shareQuestion())
                    .padding(.bottom, 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(uiColor: .systemBackground))
            .navigationTitle("오늘의 질문")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    RefreshButton(isLoading: viewModel.isLoading) {
                        viewModel.getNextQuestion()
                    }
                }
            }
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .active {
                    // 앱이 활성화될 때마다 동기화
                    viewModel.refreshQuestionFromUserDefaults()
                }
            }
        }
    }
}

struct CategoryTagView: View {
    let icon: String
    let title: String
    let color: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color(color))
            SafeText(
                title,
                color: Color(color)
            )
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color(color).opacity(0.1))
        .cornerRadius(20)
    }
}

struct ShareButton: View {
    let shareText: String
    
    var body: some View {
        Button(action: {
            shareQuestion()
        }) {
            Label("질문 공유하기", systemImage: "square.and.arrow.up")
                .font(.headline)
        }
        .buttonStyle(.borderedProminent)
    }
    
    private func shareQuestion() {
        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}

struct RefreshButton: View {
    let isLoading: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: isLoading ? "arrow.clockwise" : "arrow.clockwise")
                .rotationEffect(.degrees(isLoading ? 360 : 0))
                .animation(
                    isLoading ? .linear(duration: 1).repeatForever(autoreverses: false) : .default,
                    value: isLoading
                )
        }
        .disabled(isLoading)
    }
}

#Preview {
    ContentView()
}
