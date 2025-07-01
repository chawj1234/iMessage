//
//  ContentView.swift
//  onlyOne!
//
//  Created by 차원준 on 7/1/25.
//

import SwiftUI

struct ContentView: View {
    @State private var todayQuestion: Question
    
    init() {
        _todayQuestion = State(initialValue: QuestionStore.shared.getTodayQuestion())
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("오늘의 질문")
                .font(.title)
                .fontWeight(.bold)
            
            Text(todayQuestion.emoji)
                .font(.system(size: 60))
            
            Text(todayQuestion.text)
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text(todayQuestion.category.rawValue.capitalized)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(20)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemBackground))
    }
}

#Preview {
    ContentView()
}
