import Foundation
import UIKit
import Combine

class AnswerStore: ObservableObject {
    static let shared = AnswerStore()
    
    @Published private(set) var answers: [Answer] = []
    
    private let userDefaults: UserDefaults
    private let appGroupId = "group.com.Wonjun.onlyOne-"
    private let answersKey = "SavedAnswers"
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        guard let userDefaults = UserDefaults(suiteName: appGroupId) else {
            fatalError("Failed to create UserDefaults with App Group: \(appGroupId)")
        }
        self.userDefaults = userDefaults
        loadAnswers()
        setupSyncObserver()
    }
    
    private func setupSyncObserver() {
        // SharedDataManager의 데이터 변경 알림 구독
        SharedDataManager.shared.$dataChanged
            .dropFirst() // 초기값 무시
            .sink { [weak self] _ in
                // 외부에서 데이터가 변경되었을 때 자동으로 다시 로드
                self?.loadAnswers()
            }
            .store(in: &cancellables)
    }
    
    private func loadAnswers() {
        guard let data = userDefaults.data(forKey: answersKey) else {
            answers = []
            return
        }
        
        do {
            answers = try JSONDecoder().decode([Answer].self, from: data)
            // 최신 순으로 정렬
            answers.sort { $0.createdDate > $1.createdDate }
        } catch {
            print("Failed to load answers: \(error)")
            answers = []
        }
    }
    
    private func saveAnswers() {
        do {
            let data = try JSONEncoder().encode(answers)
            userDefaults.set(data, forKey: answersKey)
            userDefaults.synchronize()
            
            // 데이터 변경을 다른 앱에 알림
            SharedDataManager.shared.notifyDataChanged()
        } catch {
            print("Failed to save answers: \(error)")
        }
    }
    
    func saveAnswer(_ answer: Answer) {
        // 같은 질문에 대한 기존 답변이 있는지 확인
        if let existingIndex = answers.firstIndex(where: { $0.questionId == answer.questionId }) {
            // 기존 답변을 업데이트
            answers[existingIndex] = answer
        } else {
            // 새로운 답변 추가
            answers.insert(answer, at: 0) // 맨 앞에 추가 (최신순)
        }
        
        saveAnswers()
    }
    
    // 상대방 답변 추가
    func addPartnerAnswer(for questionId: String, partnerAnswerText: String, partnerImage: UIImage? = nil) {
        guard let existingIndex = answers.firstIndex(where: { $0.questionId == questionId }) else {
            print("Question not found for partner answer")
            return
        }
        
        let updatedAnswer = answers[existingIndex].withPartnerAnswer(partnerAnswerText, partnerImage: partnerImage)
        answers[existingIndex] = updatedAnswer
        saveAnswers()
    }
    
    // 상대방 답변 시뮬레이션 (테스트용)
    func simulatePartnerAnswer(for questionId: String) {
        let sampleAnswers = [
            "정말 좋은 질문이네요! 저는 오늘 가장 기억에 남는 순간은 우리가 함께 저녁을 먹으면서 나눈 대화였어요.",
            "오늘은 정말 특별한 하루였어요. 특히 우리가 함께 산책하면서 나눈 이야기가 가장 기억에 남아요.",
            "오늘 가장 기억에 남는 순간은 우리가 함께 영화를 보면서 나눈 대화였어요. 정말 행복했어요.",
            "오늘은 정말 바쁜 하루였지만, 우리가 함께 저녁을 먹으면서 나눈 이야기가 가장 기억에 남아요."
        ]
        
        let randomAnswer = sampleAnswers.randomElement() ?? "오늘도 좋은 하루였어요!"
        addPartnerAnswer(for: questionId, partnerAnswerText: randomAnswer)
    }
    
    func deleteAnswer(_ answer: Answer) {
        answers.removeAll { $0.id == answer.id }
        saveAnswers()
    }
    
    func getAnswer(for questionId: String) -> Answer? {
        return answers.first { $0.questionId == questionId }
    }
    
    func hasAnswer(for questionId: String) -> Bool {
        return getAnswer(for: questionId) != nil
    }
    
    // 날짜별로 답변 그룹화
    func getAnswersByMonth() -> [String: [Answer]] {
        let groupedAnswers = Dictionary(grouping: answers) { answer in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy년 MM월"
            return formatter.string(from: answer.createdDate)
        }
        return groupedAnswers
    }
    
    // 카테고리별로 답변 그룹화
    func getAnswersByCategory() -> [Question.Category: [Answer]] {
        return Dictionary(grouping: answers) { $0.questionCategory }
    }
    
    // 답변 동기화 (외부에서 변경된 답변 반영)
    func synchronizeAnswers() {
        loadAnswers()
    }
} 
