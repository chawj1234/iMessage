import Foundation

class MessagePointStore {
    static let shared = MessagePointStore()
    
    private let userDefaults: UserDefaults
    private let pointsKey = "messagePoints"
    
    private init() {
        guard let userDefaults = UserDefaults(suiteName: "group.com.Wonjun.OnlyOne.foriMessage") else {
            fatalError("Failed to initialize UserDefaults with App Group")
        }
        self.userDefaults = userDefaults
    }
    
    func addPoint(to messageId: String) {
        var points = getAllPoints()
        let newPoint = MessagePoint(messageId: messageId)
        points.append(newPoint)
        save(points: points)
    }
    
    func getSummary() -> MessagePointSummary {
        let points = getAllPoints()
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let todayPoints = points.filter { calendar.isDate($0.timestamp, inSameDayAs: today) }
            .reduce(0) { $0 + $1.points }
        
        let totalPoints = points.reduce(0) { $0 + $1.points }
        
        let topMessage = points.max(by: { $0.points < $1.points })
        
        return MessagePointSummary(
            todayPoints: todayPoints,
            totalPoints: totalPoints,
            topMessage: topMessage
        )
    }
    
    private func getAllPoints() -> [MessagePoint] {
        guard let data = userDefaults.data(forKey: pointsKey),
              let points = try? JSONDecoder().decode([MessagePoint].self, from: data) else {
            return []
        }
        return points
    }
    
    private func save(points: [MessagePoint]) {
        guard let data = try? JSONEncoder().encode(points) else { return }
        userDefaults.set(data, forKey: pointsKey)
    }
} 