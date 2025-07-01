import Foundation

class QuestionStore: ObservableObject {
    static let shared = QuestionStore()
    
    @Published private(set) var todayQuestion: Question = Question.samples[0]
    
    private let userDefaults: UserDefaults
    private let appGroupId = "group.com.Wonjun.onlyOne-"
    private let questionIdKey = "TodayQuestionId"
    private let questionDateKey = "QuestionDate"
    private let usedQuestionIdsKey = "UsedQuestionIds"
    
    private init() {
        guard let userDefaults = UserDefaults(suiteName: appGroupId) else {
            fatalError("Failed to create UserDefaults with App Group: \(appGroupId)")
        }
        self.userDefaults = userDefaults
        loadTodayQuestion()
    }
    
    private func loadTodayQuestion() {
        let today = dateKey(for: Date())
        let savedDate = userDefaults.string(forKey: questionDateKey) ?? ""
        
        if savedDate == today {
            // 오늘 이미 설정된 질문이 있는 경우
            if let questionId = userDefaults.string(forKey: questionIdKey),
               let question = Question.samples.first(where: { $0.id == questionId }) {
                self.todayQuestion = question
                return
            }
        }
        
        // 새로운 질문 선택
        selectNewQuestion(for: today)
    }
    
    private func selectNewQuestion(for dateKey: String) {
        let usedIds = Set(userDefaults.stringArray(forKey: usedQuestionIdsKey) ?? [])
        let availableQuestions = Question.samples.filter { !usedIds.contains($0.id) }
        
        let selectedQuestion: Question
        if availableQuestions.isEmpty {
            // 모든 질문을 사용했으면 처음부터 다시 시작
            selectedQuestion = Question.samples.randomElement()!
            userDefaults.removeObject(forKey: usedQuestionIdsKey)
        } else {
            selectedQuestion = availableQuestions.randomElement()!
        }
        
        // 새 질문 저장
        userDefaults.set(selectedQuestion.id, forKey: questionIdKey)
        userDefaults.set(dateKey, forKey: questionDateKey)
        
        // 사용된 질문 ID 추가
        var newUsedIds = usedIds
        newUsedIds.insert(selectedQuestion.id)
        userDefaults.set(Array(newUsedIds), forKey: usedQuestionIdsKey)
        
        userDefaults.synchronize()
        
        self.todayQuestion = selectedQuestion
    }
    
    private func dateKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func getTodayQuestion() -> Question {
        return todayQuestion
    }
    
    func getNextQuestion() {
        let usedIds = Set(userDefaults.stringArray(forKey: usedQuestionIdsKey) ?? [])
        let availableQuestions = Question.samples.filter { !usedIds.contains($0.id) }
        
        let selectedQuestion: Question
        if availableQuestions.isEmpty {
            // 모든 질문을 사용했으면 처음부터 다시 시작
            selectedQuestion = Question.samples.randomElement()!
            userDefaults.removeObject(forKey: usedQuestionIdsKey)
        } else {
            selectedQuestion = availableQuestions.randomElement()!
        }
        
        // 새 질문 저장
        let today = dateKey(for: Date())
        userDefaults.set(selectedQuestion.id, forKey: questionIdKey)
        userDefaults.set(today, forKey: questionDateKey)
        
        // 사용된 질문 ID 추가
        var newUsedIds = usedIds
        newUsedIds.insert(selectedQuestion.id)
        userDefaults.set(Array(newUsedIds), forKey: usedQuestionIdsKey)
        
        userDefaults.synchronize()
        
        // UI 업데이트
        DispatchQueue.main.async {
            self.todayQuestion = selectedQuestion
        }
    }
    
    func resetUsedQuestions() {
        userDefaults.removeObject(forKey: usedQuestionIdsKey)
        userDefaults.removeObject(forKey: questionDateKey)
        userDefaults.removeObject(forKey: questionIdKey)
        userDefaults.synchronize()
        
        DispatchQueue.main.async {
            self.loadTodayQuestion()
        }
    }
} 