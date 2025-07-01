import Foundation
import SwiftUI

@MainActor
class QuestionViewModel: ObservableObject {
    @Published private(set) var currentQuestion: Question
    @Published private(set) var isLoading: Bool = false
    
    private let questionStore: QuestionStore
    
    init() {
        self.questionStore = QuestionStore.shared
        self.currentQuestion = questionStore.getTodayQuestion()
        
        refreshQuestion()
        
        print("iOS Main App - Initial question loaded: \(currentQuestion.id) - \(currentQuestion.text)")
    }
    
    // 안전한 텍스트 접근
    var questionText: String {
        return currentQuestion.text.isEmpty ? "질문을 불러오는 중..." : currentQuestion.text
    }
    
    var questionEmoji: String {
        return currentQuestion.emoji.isEmpty ? "💭" : currentQuestion.emoji
    }
    
    var categoryDisplayName: String {
        return currentQuestion.category.displayName
    }
    
    var categoryColor: String {
        return currentQuestion.category.color
    }
    
    private func refreshQuestion() {
        questionStore.synchronizeFromUserDefaults()
        let syncedQuestion = questionStore.getTodayQuestion()
        
        if syncedQuestion.id != currentQuestion.id {
            currentQuestion = syncedQuestion
        }
    }
    
    func refreshQuestionFromUserDefaults() {
        refreshQuestion()
    }
    
    func getNextQuestion() {
        isLoading = true
        
        Task {
            await withCheckedContinuation { continuation in
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    guard let self = self else {
                        continuation.resume()
                        return
                    }
                    
                    self.questionStore.getNextQuestion()
                    let newQuestion = self.questionStore.getTodayQuestion()
                    
                    DispatchQueue.main.async {
                        self.currentQuestion = newQuestion
                        self.isLoading = false
                        continuation.resume()
                    }
                }
            }
        }
    }
    
    func shareQuestion() -> String {
        return "\(questionEmoji) \(questionText)\n\n#OnlyOne #커플질문"
    }
    
    func categoryIcon() -> String {
        switch currentQuestion.category {
        case .memory: return "heart.fill"
        case .present: return "star.fill"
        case .future: return "sparkles"
        case .imagination: return "wand.and.stars"
        }
    }
} 