import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    private init() {
        requestNotificationPermission()
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }
    
    // 상대방 답변 알림 예약
    func schedulePartnerAnswerNotification(for questionText: String) {
        let content = UNMutableNotificationContent()
        content.title = "상대방이 답변을 남겼어요! 💕"
        content.body = "오늘의 질문에 대한 상대방의 답변을 확인해보세요."
        content.sound = .default
        
        // 3초 후 알림 (실제로는 상대방이 답변을 완료했을 때 호출)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: "partnerAnswer", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification scheduling error: \(error)")
            }
        }
    }
    
    // 답변 완료 알림 예약
    func scheduleAnswerCompletionNotification() {
        let content = UNMutableNotificationContent()
        content.title = "답변 완료! 🎉"
        content.body = "상대방이 답변을 완료하면 알려드릴게요."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "answerCompletion", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification scheduling error: \(error)")
            }
        }
    }
    
    // 알림 권한 상태 확인
    func checkNotificationPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        }
    }
} 