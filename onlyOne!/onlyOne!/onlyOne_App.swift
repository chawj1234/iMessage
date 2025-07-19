//
//  onlyOne_App.swift
//  onlyOne!
//
//  Created by 차원준 on 7/1/25.
//

import SwiftUI

@main
struct onlyOne_App: App {
    @StateObject private var notificationManager = NotificationManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // 앱 시작 시 알림 권한 요청
                    notificationManager.checkNotificationPermission { granted in
                        if !granted {
                            print("Notification permission not granted")
                        }
                    }
                }
        }
    }
}
