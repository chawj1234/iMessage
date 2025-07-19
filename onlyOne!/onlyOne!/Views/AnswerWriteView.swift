import SwiftUI
import PhotosUI

struct AnswerWriteView: View {
    let question: Question
    @StateObject private var answerStore = AnswerStore.shared
    @StateObject private var notificationManager = NotificationManager.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var answerText: String = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var isLoading = false
    @State private var showingSaveAlert = false
    
    // 기존 답변이 있는지 확인
    private var existingAnswer: Answer? {
        answerStore.getAnswer(for: question.id)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 질문 표시 영역
                VStack(spacing: 15) {
                    Text(question.emoji)
                        .font(.system(size: 60))
                    
                    Text(question.text)
                        .font(.title2)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    CategoryTagView(
                        icon: categoryIcon(for: question.category),
                        title: question.category.displayName,
                        color: question.category.color
                    )
                }
                .padding(.vertical)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // 답변 작성 영역
                VStack(alignment: .leading, spacing: 15) {
                    Text("답변 작성")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    TextEditor(text: $answerText)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .frame(minHeight: 120)
                        .padding(.horizontal)
                    
                    // 사진 첨부 영역
                    VStack(spacing: 10) {
                        HStack {
                            Text("사진 첨부")
                                .font(.headline)
                            Spacer()
                            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                                Label("사진 선택", systemImage: "photo")
                                    .font(.subheadline)
                            }
                        }
                        .padding(.horizontal)
                        
                        if let selectedImage = selectedImage {
                            HStack {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipped()
                                    .cornerRadius(8)
                                
                                Spacer()
                                
                                Button("삭제") {
                                    self.selectedImage = nil
                                    self.selectedPhoto = nil
                                }
                                .foregroundColor(.red)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                Spacer()
                
                // 저장 버튼
                Button(action: saveAnswer) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text(existingAnswer != nil ? "답변 수정" : "답변 저장")
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(answerText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.horizontal)
                .disabled(answerText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading)
            }
            .navigationTitle("답변 작성")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
            }
            .alert("답변이 저장되었습니다", isPresented: $showingSaveAlert) {
                Button("확인") {
                    dismiss()
                }
            }
        }
        .onAppear {
            // 기존 답변이 있으면 불러오기
            if let existingAnswer = existingAnswer {
                answerText = existingAnswer.answerText
                selectedImage = existingAnswer.image
            }
        }
        .onChange(of: selectedPhoto) { _, newPhoto in
            Task {
                if let newPhoto = newPhoto {
                    if let data = try? await newPhoto.loadTransferable(type: Data.self) {
                        selectedImage = UIImage(data: data)
                    }
                }
            }
        }
    }
    
    private func saveAnswer() {
        isLoading = true
        
        let answer = Answer(
            questionId: question.id,
            questionText: question.text,
            questionCategory: question.category,
            answerText: answerText.trimmingCharacters(in: .whitespacesAndNewlines),
            image: selectedImage
        )
        
        // 약간의 지연을 주어 사용자 경험 개선
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            answerStore.saveAnswer(answer)
            
            // 답변 완료 알림
            notificationManager.scheduleAnswerCompletionNotification()
            
            // 상대방 답변 시뮬레이션 (테스트용 - 실제로는 상대방이 답변할 때 호출)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                answerStore.simulatePartnerAnswer(for: question.id)
                notificationManager.schedulePartnerAnswerNotification(for: question.text)
            }
            
            isLoading = false
            showingSaveAlert = true
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
}

#Preview {
    AnswerWriteView(question: Question.samples[0])
} 