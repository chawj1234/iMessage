import Foundation

class QuestionStore {
    static let shared = QuestionStore()
    
    private let userDefaults: UserDefaults
    private let lastQuestionDateKey = "lastQuestionDate"
    private let lastQuestionIdKey = "lastQuestionId"
    private let usedQuestionIdsKey = "usedQuestionIds"
    
    private init() {
        guard let userDefaults = UserDefaults(suiteName: "group.com.Wonjun.OnlyOne.foriMessage") else {
            fatalError("Failed to initialize UserDefaults with App Group")
        }
        self.userDefaults = userDefaults
    }
    
    func getTodayQuestion() -> Question {
        let today = Calendar.current.startOfDay(for: Date())
        let lastDate = userDefaults.object(forKey: lastQuestionDateKey) as? Date ?? Date.distantPast
        
        // 날짜가 바뀌었으면 새로운 질문 선택
        if !Calendar.current.isDate(lastDate, inSameDayAs: today) {
            let usedIds = getAllUsedQuestionIds()
            let availableQuestions = Question.samples.filter { !usedIds.contains($0.id) }
            
            // 모든 질문을 다 사용했으면 초기화
            let question = availableQuestions.isEmpty ? 
                Question.samples.randomElement()! :
                availableQuestions.randomElement()!
            
            // 새 질문 저장
            userDefaults.set(today, forKey: lastQuestionDateKey)
            userDefaults.set(question.id, forKey: lastQuestionIdKey)
            markQuestionAsUsed(question.id)
            
            return question
        }
        
        // 오늘 이미 질문이 있으면 그 질문 반환
        if let lastQuestionId = userDefaults.string(forKey: lastQuestionIdKey),
           let question = Question.samples.first(where: { $0.id == lastQuestionId }) {
            return question
        }
        
        // 기본값으로 랜덤 질문 반환
        return Question.samples.randomElement()!
    }
    
    private func getAllUsedQuestionIds() -> Set<String> {
        let ids = userDefaults.array(forKey: usedQuestionIdsKey) as? [String] ?? []
        return Set(ids)
    }
    
    private func markQuestionAsUsed(_ questionId: String) {
        var ids = getAllUsedQuestionIds()
        ids.insert(questionId)
        userDefaults.set(Array(ids), forKey: usedQuestionIdsKey)
    }
    
    func resetUsedQuestions() {
        userDefaults.removeObject(forKey: usedQuestionIdsKey)
        userDefaults.removeObject(forKey: lastQuestionDateKey)
        userDefaults.removeObject(forKey: lastQuestionIdKey)
    }
} 