import Foundation
import UIKit

// 답변 상태를 관리하는 enum
enum AnswerStatus: String, Codable {
    case unanswered = "unanswered"
    case answered = "answered"
}

struct Answer: Codable, Identifiable {
    let id: String
    let questionId: String
    let questionText: String
    let questionCategory: Question.Category
    let answerText: String
    let createdDate: Date
    let imageData: Data?
    let status: AnswerStatus
    let partnerAnswerText: String?
    let partnerImageData: Data?
    let partnerAnswerDate: Date?
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: createdDate)
    }
    
    var image: UIImage? {
        guard let imageData = imageData else { return nil }
        return UIImage(data: imageData)
    }
    
    var partnerImage: UIImage? {
        guard let partnerImageData = partnerImageData else { return nil }
        return UIImage(data: partnerImageData)
    }
    
    var partnerFormattedDate: String? {
        guard let partnerAnswerDate = partnerAnswerDate else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: partnerAnswerDate)
    }
    
    // 상대방 답변을 볼 수 있는지 확인
    var canViewPartnerAnswer: Bool {
        return status == .answered && partnerAnswerText != nil
    }
    
    init(questionId: String, questionText: String, questionCategory: Question.Category, answerText: String, image: UIImage? = nil, status: AnswerStatus = .answered) {
        self.id = UUID().uuidString
        self.questionId = questionId
        self.questionText = questionText
        self.questionCategory = questionCategory
        self.answerText = answerText
        self.createdDate = Date()
        self.imageData = image?.jpegData(compressionQuality: 0.8)
        self.status = status
        self.partnerAnswerText = nil
        self.partnerImageData = nil
        self.partnerAnswerDate = nil
    }
    
    // 상대방 답변을 추가하는 메서드
    func withPartnerAnswer(_ partnerAnswerText: String, partnerImage: UIImage? = nil) -> Answer {
        return Answer(
            id: self.id,
            questionId: self.questionId,
            questionText: self.questionText,
            questionCategory: self.questionCategory,
            answerText: self.answerText,
            createdDate: self.createdDate,
            imageData: self.imageData,
            status: self.status,
            partnerAnswerText: partnerAnswerText,
            partnerImageData: partnerImage?.jpegData(compressionQuality: 0.8),
            partnerAnswerDate: Date()
        )
    }
    
    // 내부 초기화 메서드 (상대방 답변 포함)
    private init(id: String, questionId: String, questionText: String, questionCategory: Question.Category, answerText: String, createdDate: Date, imageData: Data?, status: AnswerStatus, partnerAnswerText: String?, partnerImageData: Data?, partnerAnswerDate: Date?) {
        self.id = id
        self.questionId = questionId
        self.questionText = questionText
        self.questionCategory = questionCategory
        self.answerText = answerText
        self.createdDate = createdDate
        self.imageData = imageData
        self.status = status
        self.partnerAnswerText = partnerAnswerText
        self.partnerImageData = partnerImageData
        self.partnerAnswerDate = partnerAnswerDate
    }
} 