import Foundation

struct MessagePoint: Codable {
    let messageId: String
    let points: Int
    let timestamp: Date
    
    init(messageId: String, points: Int = 1, timestamp: Date = Date()) {
        self.messageId = messageId
        self.points = points
        self.timestamp = timestamp
    }
}

struct MessagePointSummary {
    let todayPoints: Int
    let totalPoints: Int
    let topMessage: MessagePoint?
} 