import Foundation

class QuestionStore {
    static let shared = QuestionStore()
    
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
        
        // App Group 디버깅
        print("iMessage App - App Group ID: \(appGroupId)")
        if let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupId) {
            print("iMessage App - App Group URL: \(url)")
        } else {
            print("iMessage App - WARNING: App Group container not found!")
        }
    }
    
    func getTodayQuestion() -> Question {
        userDefaults.synchronize()
        
        let today = dateKey(for: Date())
        let savedDate = userDefaults.string(forKey: questionDateKey) ?? ""
        let savedQuestionId = userDefaults.string(forKey: questionIdKey) ?? ""
        
        print("iMessage App - UserDefaults Debug:")
        print("  Today: \(today)")
        print("  Saved Date: \(savedDate)")
        print("  Saved Question ID: \(savedQuestionId)")
        
        // UserDefaults의 모든 키 값 확인
        let allKeys = ["TodayQuestionId", "QuestionDate", "UsedQuestionIds"]
        for key in allKeys {
            let value = userDefaults.object(forKey: key)
            print("  \(key): \(value ?? "nil")")
        }
        
        if savedDate == today && !savedQuestionId.isEmpty {
            // 오늘 이미 설정된 질문이 있는 경우
            if let question = Question.samples.first(where: { $0.id == savedQuestionId }) {
                print("iMessage App - Existing question: \(question.id) - \(question.text)")
                return question
            } else {
                print("iMessage App - Question with ID \(savedQuestionId) not found in samples")
            }
        }
        
        print("iMessage App - No valid question found, selecting new one")
        // 새로운 질문 선택
        return selectNewQuestion(for: today)
    }
    
    private func selectNewQuestion(for dateKey: String) -> Question {
        let usedIds = Set(userDefaults.stringArray(forKey: usedQuestionIdsKey) ?? [])
        let availableQuestions = Question.samples.filter { !usedIds.contains($0.id) }
        
        print("iMessage App - Used IDs: \(usedIds)")
        print("iMessage App - Available questions: \(availableQuestions.count)")
        
        let selectedQuestion: Question
        if availableQuestions.isEmpty {
            // 모든 질문을 사용했으면 처음부터 다시 시작
            selectedQuestion = Question.samples.randomElement()!
            userDefaults.removeObject(forKey: usedQuestionIdsKey)
            print("iMessage App - Reset and selected: \(selectedQuestion.id)")
        } else {
            selectedQuestion = availableQuestions.randomElement()!
            print("iMessage App - New question selected: \(selectedQuestion.id)")
        }
        
        // 새 질문 저장
        userDefaults.set(selectedQuestion.id, forKey: questionIdKey)
        userDefaults.set(dateKey, forKey: questionDateKey)
        
        // 사용된 질문 ID 추가
        var newUsedIds = usedIds
        newUsedIds.insert(selectedQuestion.id)
        userDefaults.set(Array(newUsedIds), forKey: usedQuestionIdsKey)
        
        userDefaults.synchronize()
        
        print("iMessage App - Final selected question: \(selectedQuestion.id) - \(selectedQuestion.text)")
        return selectedQuestion
    }
    
    private func dateKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func getNextQuestion() {
        print("iMessage App - getNextQuestion called")
        
        let usedIds = Set(userDefaults.stringArray(forKey: usedQuestionIdsKey) ?? [])
        let availableQuestions = Question.samples.filter { !usedIds.contains($0.id) }
        
        print("iMessage App - Used IDs: \(usedIds)")
        print("iMessage App - Available questions: \(availableQuestions.count)")
        
        let selectedQuestion: Question
        if availableQuestions.isEmpty {
            // 모든 질문을 사용했으면 처음부터 다시 시작
            selectedQuestion = Question.samples.randomElement() ?? Question.samples[0]
            userDefaults.removeObject(forKey: usedQuestionIdsKey)
            print("iMessage App - Reset all questions, selected: \(selectedQuestion.id)")
        } else {
            selectedQuestion = availableQuestions.randomElement() ?? Question.samples[0]
            print("iMessage App - Selected from available: \(selectedQuestion.id)")
        }
        
        // 새 질문 저장
        let today = dateKey(for: Date())
        userDefaults.set(selectedQuestion.id, forKey: questionIdKey)
        userDefaults.set(today, forKey: questionDateKey)
        
        // 사용된 질문 ID 추가
        var newUsedIds = usedIds
        newUsedIds.insert(selectedQuestion.id)
        userDefaults.set(Array(newUsedIds), forKey: usedQuestionIdsKey)
        
        print("iMessage App - Saved to UserDefaults:")
        print("  Question ID: \(selectedQuestion.id)")
        print("  Date: \(today)")
        print("  New Used IDs: \(Array(newUsedIds))")
        
        userDefaults.synchronize()
        
        print("iMessage App - New question set: \(selectedQuestion.id) - \(selectedQuestion.text)")
    }
    
    func resetUsedQuestions() {
        userDefaults.removeObject(forKey: usedQuestionIdsKey)
        userDefaults.removeObject(forKey: questionDateKey)
        userDefaults.removeObject(forKey: questionIdKey)
        userDefaults.synchronize()
    }
} 