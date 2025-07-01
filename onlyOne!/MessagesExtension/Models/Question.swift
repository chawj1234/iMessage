import Foundation

struct Question: Codable, Identifiable {
    let id: String
    let text: String
    let category: Category
    let emoji: String
    
    enum Category: String, Codable, CaseIterable {
        case memory = "memory"      // 추억, 과거
        case present = "present"    // 현재, 감정
        case future = "future"      // 미래, 계획
        case imagination = "imagination" // 상상, 가정
        
        var displayName: String {
            switch self {
            case .memory: return "추억"
            case .present: return "현재"
            case .future: return "미래"
            case .imagination: return "상상"
            }
        }
        
        var color: String {
            switch self {
            case .memory: return "memoryColor"
            case .present: return "presentColor"
            case .future: return "futureColor"
            case .imagination: return "imaginationColor"
            }
        }
    }
    
    static let samples: [Question] = [
        Question(id: "1", text: "처음 만났던 날, 가장 인상 깊었던 순간은?", category: .memory, emoji: "💝"),
        Question(id: "2", text: "내가 요즘 어떤 부분에서 많이 바뀌었다고 느껴?", category: .present, emoji: "🌟"),
        Question(id: "3", text: "지금 둘이 가고 싶은 여행지는 어디야?", category: .future, emoji: "✈️"),
        Question(id: "4", text: "우리가 처음 만난 날이 다시 온다면, 어떻게 달라질까?", category: .imagination, emoji: "🎬"),
        Question(id: "5", text: "지금까지 함께한 시간 중 가장 행복했던 순간은?", category: .memory, emoji: "💫"),
        Question(id: "6", text: "서로에게 가장 고마웠던 순간은 언제였어?", category: .memory, emoji: "🙏"),
        Question(id: "7", text: "요즘 나의 어떤 모습이 가장 매력적으로 보여?", category: .present, emoji: "✨"),
        Question(id: "8", text: "우리의 첫 데이트를 다시 한다면 어떻게 보내고 싶어?", category: .imagination, emoji: "📅"),
        Question(id: "9", text: "10년 후 우리는 어떤 모습일까?", category: .future, emoji: "🔮"),
        Question(id: "10", text: "지금 이 순간 나에게 가장 하고 싶은 말은?", category: .present, emoji: "💌"),
        Question(id: "11", text: "우리의 첫 키스는 어땠어?", category: .memory, emoji: "💋"),
        Question(id: "12", text: "지금 가장 설레는 순간은 언제야?", category: .present, emoji: "💓"),
        Question(id: "13", text: "우리의 결혼식은 어떤 모습일까?", category: .future, emoji: "👰"),
        Question(id: "14", text: "서로의 장점을 바꿀 수 있다면 어떤 걸 바꾸고 싶어?", category: .imagination, emoji: "🔄"),
        Question(id: "15", text: "처음 고백했던 순간이 기억나?", category: .memory, emoji: "💘")
    ]
} 