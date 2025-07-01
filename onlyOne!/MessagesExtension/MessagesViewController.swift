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
        guard let question = questionStore.todayQuestion else { return }
        
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
        guard let question = questionStore.todayQuestion else { return }
        
        // 메시지 생성
        let message = MSMessage()
        let layout = MSMessageTemplateLayout()
        
        // 메시지 내용 설정
        layout.image = renderMessageImage()
        layout.caption = "\(question.emoji) \(question.text)"
        message.layout = layout
        
        // 메시지 전송
        activeConversation?.insert(message) { error in
            if let error = error {
                print("Failed to insert message: \(error.localizedDescription)")
            }
        }
    }
    
    private func renderMessageImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        return renderer.image { context in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
    }
} 