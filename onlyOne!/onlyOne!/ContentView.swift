//
//  ContentView.swift
//  onlyOne!
//
//  Created by 차원준 on 7/1/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = QuestionViewModel()
    @StateObject private var answerStore = AnswerStore.shared
    @StateObject private var sharedDataManager = SharedDataManager.shared
    @Environment(\.scenePhase) private var scenePhase
    @State private var showingAnswerWrite = false
    @State private var showingAnswerHistory = false
    
    // 현재 질문에 대한 답변이 있는지 확인
    private var hasCurrentAnswer: Bool {
        answerStore.hasAnswer(for: viewModel.currentQuestion.id)
    }
    
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
                
                // 답변 상태 표시
                if hasCurrentAnswer {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("답변 완료")
                            .font(.subheadline)
                            .foregroundColor(.green)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(20)
                }
                
                // 상대방 답변 영역
                if hasCurrentAnswer {
                    PartnerAnswerView(answer: answerStore.getAnswer(for: viewModel.currentQuestion.id)!)
                        .padding(.horizontal)
                }
                    
                    Spacer()
                    
                    // 버튼들
                VStack(spacing: 15) {
                    // 답변 작성/수정 버튼
                    Button(action: {
                        showingAnswerWrite = true
                    }) {
                        Label(hasCurrentAnswer ? "답변 수정하기" : "답변 작성하기", systemImage: hasCurrentAnswer ? "pencil" : "square.and.pencil")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    
                    // 답변 히스토리 버튼
                    Button(action: {
                        showingAnswerHistory = true
                    }) {
                        HStack {
                            Label("답변 기록 보기", systemImage: "book")
                                .font(.subheadline)
                            
                            if !answerStore.answers.isEmpty {
                                Spacer()
                                Text("\(answerStore.answers.count)개")
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                    }
                    .buttonStyle(.bordered)
                    
                    // 공유 버튼
                    ShareButton(shareText: viewModel.shareQuestion())
                    
                    // 상대방 답변 시뮬레이션 버튼 (테스트용)
                    if hasCurrentAnswer {
                        Button(action: {
                            answerStore.simulatePartnerAnswer(for: viewModel.currentQuestion.id)
                        }) {
                            Label("상대방 답변 시뮬레이션", systemImage: "person.2")
                                .font(.subheadline)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                        }
                        .buttonStyle(.bordered)
                        .padding(.horizontal)
                    }
                }
                .padding(.horizontal)
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
                    sharedDataManager.forceSynchronize()
                }
            }
            .onChange(of: sharedDataManager.dataChanged) { _, _ in
                // 외부에서 데이터가 변경되었을 때 UI 업데이트
                // AnswerStore는 이미 자동으로 업데이트되므로 추가 작업 불필요
                // @StateObject answerStore가 자동으로 UI를 다시 그림
            }
            .sheet(isPresented: $showingAnswerWrite) {
                AnswerWriteView(question: viewModel.currentQuestion)
            }
            .sheet(isPresented: $showingAnswerHistory) {
                AnswerHistoryView()
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
