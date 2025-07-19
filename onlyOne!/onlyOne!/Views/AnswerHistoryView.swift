import SwiftUI

struct AnswerHistoryView: View {
    @StateObject private var answerStore = AnswerStore.shared
    @Environment(\.dismiss) private var dismiss
    @State private var selectedSegment = 0
    
    private var groupedAnswers: [String: [Answer]] {
        answerStore.getAnswersByMonth()
    }
    
    private var sortedMonths: [String] {
        groupedAnswers.keys.sorted(by: >)
    }
    
    private var answersByCategory: [Question.Category: [Answer]] {
        answerStore.getAnswersByCategory()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // 세그먼트 컨트롤
                Picker("View Mode", selection: $selectedSegment) {
                    Text("날짜별").tag(0)
                    Text("카테고리별").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if answerStore.answers.isEmpty {
                    // 빈 상태
                    VStack(spacing: 20) {
                        Image(systemName: "heart.text.square")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("아직 작성한 답변이 없어요")
                            .font(.title2)
                            .fontWeight(.medium)
                        
                        Text("오늘의 질문에 답변을 작성해보세요!")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // 답변 목록
                    if selectedSegment == 0 {
                        // 날짜별 보기
                        List {
                            ForEach(sortedMonths, id: \.self) { month in
                                Section(header: Text(month)) {
                                    ForEach(groupedAnswers[month] ?? []) { answer in
                                        NavigationLink(destination: AnswerDetailView(answer: answer)) {
                                            AnswerRowView(answer: answer)
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        // 카테고리별 보기
                        List {
                            ForEach(Question.Category.allCases, id: \.self) { category in
                                if let categoryAnswers = answersByCategory[category], !categoryAnswers.isEmpty {
                                    Section(header: HStack {
                                        Image(systemName: categoryIcon(for: category))
                                            .foregroundColor(Color(category.color))
                                        Text(category.displayName)
                                    }) {
                                        ForEach(categoryAnswers) { answer in
                                            NavigationLink(destination: AnswerDetailView(answer: answer)) {
                                                AnswerRowView(answer: answer)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("답변 기록")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("완료") {
                        dismiss()
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
}

struct AnswerRowView: View {
    let answer: Answer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(answer.questionText)
                    .font(.body)
                    .fontWeight(.medium)
                    .lineLimit(2)
                
                Spacer()
                
                if answer.image != nil {
                    Image(systemName: "photo")
                        .foregroundColor(.blue)
                        .font(.caption)
                }
            }
            
            Text(answer.answerText)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            HStack {
                CategoryTagView(
                    icon: categoryIcon(for: answer.questionCategory),
                    title: answer.questionCategory.displayName,
                    color: answer.questionCategory.color
                )
                .scaleEffect(0.8)
                
                Spacer()
                
                Text(answer.formattedDate)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
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
    AnswerHistoryView()
} 