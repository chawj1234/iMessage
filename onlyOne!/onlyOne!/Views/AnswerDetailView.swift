import SwiftUI

struct AnswerDetailView: View {
    let answer: Answer
    @StateObject private var answerStore = AnswerStore.shared
    @Environment(\.dismiss) private var dismiss
    @State private var showingDeleteAlert = false
    @State private var showingEditView = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 질문 영역
                VStack(spacing: 15) {
                    Text(questionEmoji(for: answer.questionCategory))
                        .font(.system(size: 60))
                    
                    Text(answer.questionText)
                        .font(.title2)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                    
                    CategoryTagView(
                        icon: categoryIcon(for: answer.questionCategory),
                        title: answer.questionCategory.displayName,
                        color: answer.questionCategory.color
                    )
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // 답변 영역
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("내 답변")
                            .font(.headline)
                        Spacer()
                        Text(answer.formattedDate)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Text(answer.answerText)
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemBackground))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                    
                    // 첨부된 사진이 있으면 표시
                    if let image = answer.image {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("첨부 사진")
                                .font(.headline)
                            
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(8)
                                .clipped()
                        }
                    }
                }
                
                Spacer(minLength: 20)
            }
            .padding()
        }
        .navigationTitle("답변 보기")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("수정") {
                    showingEditView = true
                }
                
                Button("삭제") {
                    showingDeleteAlert = true
                }
                .foregroundColor(.red)
            }
        }
        .alert("답변을 삭제하시겠습니까?", isPresented: $showingDeleteAlert) {
            Button("취소", role: .cancel) { }
            Button("삭제", role: .destructive) {
                answerStore.deleteAnswer(answer)
                dismiss()
            }
        } message: {
            Text("삭제된 답변은 복구할 수 없습니다.")
        }
        .sheet(isPresented: $showingEditView) {
            AnswerWriteView(question: Question(
                id: answer.questionId,
                text: answer.questionText,
                category: answer.questionCategory,
                emoji: questionEmoji(for: answer.questionCategory)
            ))
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
    
    private func questionEmoji(for category: Question.Category) -> String {
        switch category {
        case .memory: return "💝"
        case .present: return "🌟"
        case .future: return "✈️"
        case .imagination: return "🎬"
        }
    }
}

#Preview {
    NavigationView {
        AnswerDetailView(answer: Answer(
            questionId: "1",
            questionText: "처음 만났던 날, 가장 인상 깊었던 순간은?",
            questionCategory: .memory,
            answerText: "첫 만남에서 당신의 미소가 가장 인상적이었어요. 그 순간부터 마음이 설레기 시작했던 것 같아요."
        ))
    }
} 