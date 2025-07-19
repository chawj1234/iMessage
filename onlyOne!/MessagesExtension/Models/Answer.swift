import Foundation
import UIKit

struct Answer: Codable, Identifiable {
    let id: String
    let questionId: String
    let questionText: String
    let questionCategory: Question.Category
    let answerText: String
    let createdDate: Date
    let imageData: Data?
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: createdDate)
    }
    
    var image: UIImage? {
        guard let imageData = imageData else { return nil }
        return UIImage(data: imageData)
    }
    
    init(questionId: String, questionText: String, questionCategory: Question.Category, answerText: String, image: UIImage? = nil) {
        self.id = UUID().uuidString
        self.questionId = questionId
        self.questionText = questionText
        self.questionCategory = questionCategory
        self.answerText = answerText
        self.createdDate = Date()
        self.imageData = image?.jpegData(compressionQuality: 0.8)
    }
} 