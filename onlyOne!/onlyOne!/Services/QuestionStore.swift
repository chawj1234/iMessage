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
        
        // App Group 디버깅
        print("iOS Main App - App Group ID: \(appGroupId)")
        if let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupId) {
            print("iOS Main App - App Group URL: \(url)")
        } else {
            print("iOS Main App - WARNING: App Group container not found!")
        }
        
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
    
    func synchronizeFromUserDefaults() {
        // UserDefaults 강제 동기화
        userDefaults.synchronize()
        
        let today = dateKey(for: Date())
        let savedDate = userDefaults.string(forKey: questionDateKey) ?? ""
        let savedQuestionId = userDefaults.string(forKey: questionIdKey) ?? ""
        
        print("iOS Main App - UserDefaults Debug:")
        print("  Today: \(today)")
        print("  Saved Date: \(savedDate)")
        print("  Saved Question ID: \(savedQuestionId)")
        print("  Current Question ID: \(todayQuestion.id)")
        
        // UserDefaults의 모든 키 값 확인
        let allKeys = ["TodayQuestionId", "QuestionDate", "UsedQuestionIds"]
        for key in allKeys {
            let value = userDefaults.object(forKey: key)
            print("  \(key): \(value ?? "nil")")
        }
        
        // 오늘 날짜와 일치하는 질문이 있는지 확인
        if savedDate == today && !savedQuestionId.isEmpty {
            if let question = Question.samples.first(where: { $0.id == savedQuestionId }) {
                print("iOS Main App - Found synced question: \(question.id) - \(question.text)")
                // 현재 질문과 다르면 업데이트
                if question.id != todayQuestion.id {
                    print("iOS Main App - Updating to synced question")
                    self.todayQuestion = question
                }
                return
            } else {
                print("iOS Main App - Question with ID \(savedQuestionId) not found in samples")
            }
        }
        
        print("iOS Main App - No valid synced question found, loading today's question")
        // 저장된 질문이 없으면 새로 로드
        loadTodayQuestion()
    }
    
    func getNextQuestion() {
        print("iOS Main App - getNextQuestion called")
        
        // 백그라운드에서 안전하게 처리
        let usedIds = Set(userDefaults.stringArray(forKey: usedQuestionIdsKey) ?? [])
        let availableQuestions = Question.samples.filter { !usedIds.contains($0.id) }
        
        print("iOS Main App - Used IDs: \(usedIds)")
        print("iOS Main App - Available questions: \(availableQuestions.count)")
        
        let selectedQuestion: Question
        if availableQuestions.isEmpty {
            // 모든 질문을 사용했으면 처음부터 다시 시작
            selectedQuestion = Question.samples.randomElement() ?? Question.samples[0]
            userDefaults.removeObject(forKey: usedQuestionIdsKey)
            print("iOS Main App - Reset all questions, selected: \(selectedQuestion.id)")
        } else {
            selectedQuestion = availableQuestions.randomElement() ?? Question.samples[0]
            print("iOS Main App - Selected from available: \(selectedQuestion.id)")
        }
        
        // 새 질문 저장
        let today = dateKey(for: Date())
        userDefaults.set(selectedQuestion.id, forKey: questionIdKey)
        userDefaults.set(today, forKey: questionDateKey)
        
        // 사용된 질문 ID 추가
        var newUsedIds = usedIds
        newUsedIds.insert(selectedQuestion.id)
        userDefaults.set(Array(newUsedIds), forKey: usedQuestionIdsKey)
        
        print("iOS Main App - Saved to UserDefaults:")
        print("  Question ID: \(selectedQuestion.id)")
        print("  Date: \(today)")
        print("  New Used IDs: \(Array(newUsedIds))")
        
        // 즉시 동기화
        userDefaults.synchronize()
        
        // 안전하게 UI 업데이트
        self.todayQuestion = selectedQuestion
        
        print("iOS Main App - Question updated to: \(selectedQuestion.id) - \(selectedQuestion.text)")
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