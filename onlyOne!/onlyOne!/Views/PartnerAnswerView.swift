import SwiftUI

struct PartnerAnswerView: View {
    let answer: Answer
    @State private var showingPartnerAnswer = false
    
    var body: some View {
        VStack(spacing: 16) {
            // 상대방 답변 영역
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "person.2.fill")
                        .foregroundColor(.blue)
                    Text("상대방 답변")
                        .font(.headline)
                        .foregroundColor(.blue)
                    Spacer()
                }
                
                if answer.canViewPartnerAnswer {
                    // 상대방 답변 표시
                    VStack(alignment: .leading, spacing: 12) {
                        Text(answer.partnerAnswerText ?? "")
                            .font(.body)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                        
                        if let partnerImage = answer.partnerImage {
                            Image(uiImage: partnerImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxHeight: 200)
                                .cornerRadius(12)
                        }
                        
                        if let partnerDate = answer.partnerFormattedDate {
                            Text("답변일: \(partnerDate)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .transition(.opacity.combined(with: .scale))
                } else {
                    // 잠금 상태 표시
                    VStack(spacing: 12) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        
                        Text("상대방 답변을 보려면\n먼저 답변을 작성해주세요")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        if answer.status == .answered {
                            Text("상대방이 아직 답변하지 않았어요")
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
}

#Preview {
    PartnerAnswerView(answer: Answer(
        questionId: "1",
        questionText: "오늘 가장 기억에 남는 순간은?",
        questionCategory: .memory,
        answerText: "내 답변입니다.",
        status: .answered
    ))
} 