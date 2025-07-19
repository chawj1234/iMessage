import Foundation
import Combine
import UIKit

/// 앱과 iMessage 확장 간의 실시간 데이터 동기화를 관리하는 클래스
class SharedDataManager: ObservableObject {
    static let shared = SharedDataManager()
    
    private let appGroupId = "group.com.Wonjun.onlyOne-"
    private let userDefaults: UserDefaults
    private let answersKey = "SavedAnswers"
    private let dataChangedNotificationName = "AnswerDataChanged"
    
    // 데이터 변경 알림을 위한 Publisher
    @Published var dataChanged = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        guard let userDefaults = UserDefaults(suiteName: appGroupId) else {
            fatalError("Failed to create UserDefaults with App Group: \(appGroupId)")
        }
        self.userDefaults = userDefaults
        
        setupNotificationObserver()
        setupUserDefaultsObserver()
    }
    
    // MARK: - Notification Setup
    
    private func setupNotificationObserver() {
        // 앱 간 데이터 변경 알림 수신
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(dataChangedNotificationName),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.handleDataChanged()
        }
        
        // 앱이 활성화될 때 데이터 동기화
        NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.handleDataChanged()
        }
        
        // 메모리 경고 시에도 동기화
        NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.handleDataChanged()
        }
    }
    
    private func setupUserDefaultsObserver() {
        // UserDefaults 변경 감지 (iOS 앱 간 실시간 동기화)
        Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.checkForDataChanges()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Data Synchronization
    
    private func handleDataChanged() {
        DispatchQueue.main.async {
            self.dataChanged.toggle()
            // AnswerStore에 동기화 신호 전송
            AnswerStore.shared.synchronizeAnswers()
        }
    }
    
    private func checkForDataChanges() {
        // 마지막 수정 시간을 체크하여 데이터 변경 감지
        let lastModifiedKey = "AnswersLastModified"
        let currentModified = userDefaults.double(forKey: lastModifiedKey)
        let now = Date().timeIntervalSince1970
        
        // 1초 이내에 변경된 데이터가 있으면 동기화
        if now - currentModified < 2.0 && currentModified > 0 {
            handleDataChanged()
        }
    }
    
    // MARK: - Public Methods
    
    /// 데이터 변경을 알림 (저장 후 호출)
    func notifyDataChanged() {
        let lastModifiedKey = "AnswersLastModified"
        userDefaults.set(Date().timeIntervalSince1970, forKey: lastModifiedKey)
        userDefaults.synchronize()
        
        // 로컬 알림 전송
        NotificationCenter.default.post(
            name: NSNotification.Name(dataChangedNotificationName),
            object: appGroupId
        )
    }
    
    /// 강제 동기화
    func forceSynchronize() {
        handleDataChanged()
    }
}

 