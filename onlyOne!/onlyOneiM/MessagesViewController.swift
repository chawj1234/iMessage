//
//  MessagesViewController.swift
//  onlyOneiM
//
//  Created by 차원준 on 7/1/25.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    private let questionStore = QuestionStore.shared
    
    // UI 요소들
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 60)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var categoryContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var categoryIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateQuestion()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 앱이 나타날 때마다 질문을 새로고침
        updateQuestion()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // 컨테이너 뷰 추가
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        // UI 요소들 추가
        containerView.addSubview(emojiLabel)
        containerView.addSubview(questionLabel)
        containerView.addSubview(categoryContainer)
        
        categoryContainer.addSubview(categoryIcon)
        categoryContainer.addSubview(categoryLabel)
        
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            emojiLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            emojiLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            questionLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 20),
            questionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            questionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            categoryContainer.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20),
            categoryContainer.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            categoryContainer.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            categoryIcon.leadingAnchor.constraint(equalTo: categoryContainer.leadingAnchor, constant: 12),
            categoryIcon.centerYAnchor.constraint(equalTo: categoryContainer.centerYAnchor),
            categoryIcon.widthAnchor.constraint(equalToConstant: 20),
            categoryIcon.heightAnchor.constraint(equalToConstant: 20),
            
            categoryLabel.leadingAnchor.constraint(equalTo: categoryIcon.trailingAnchor, constant: 8),
            categoryLabel.trailingAnchor.constraint(equalTo: categoryContainer.trailingAnchor, constant: -12),
            categoryLabel.centerYAnchor.constraint(equalTo: categoryContainer.centerYAnchor),
            categoryContainer.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        // 탭 제스처 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func updateQuestion() {
        let question = questionStore.getTodayQuestion()
        
        emojiLabel.text = question.emoji
        questionLabel.text = question.text
        categoryLabel.text = question.category.displayName
        
        // 카테고리 아이콘 설정
        let iconName: String
        switch question.category {
        case .memory: iconName = "heart.fill"
        case .present: iconName = "star.fill"
        case .future: iconName = "sparkles"
        case .imagination: iconName = "wand.and.stars"
        }
        
        if let image = UIImage(systemName: iconName) {
            categoryIcon.image = image
        }
        
        // 카테고리 색상 설정
        let color = UIColor(named: question.category.color) ?? .systemBlue
        categoryIcon.tintColor = color
        categoryLabel.textColor = color
        categoryContainer.backgroundColor = color.withAlphaComponent(0.1)
    }
    
    @objc private func handleTap() {
        let question = questionStore.getTodayQuestion()
        
        // 텍스트 메시지 생성
        let questionText = "\(question.emoji) \(question.text)"
        
        // 텍스트 메시지 전송
        activeConversation?.insertText(questionText) { error in
            if let error = error {
                print("Failed to send message: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dismisses the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    
        // Use this method to prepare for the change in presentation style.
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }

}
