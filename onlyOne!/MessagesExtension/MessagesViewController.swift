import UIKit
import Messages
import Combine

class MessagesViewController: MSMessagesAppViewController {
    private let questionStore = QuestionStore.shared
    private let answerStore = AnswerStore.shared
    private let sharedDataManager = SharedDataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
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
    
    private lazy var answerStatusView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var answerStatusIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark.circle.fill")
        imageView.tintColor = .systemGreen
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var answerStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "답변 완료"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var answerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("답변 작성하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(answerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateQuestion()
        setupDataSyncObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 화면이 나타날 때마다 데이터 동기화
        sharedDataManager.forceSynchronize()
        updateAnswerStatusIfNeeded()
    }
    
    private func setupDataSyncObserver() {
        // AnswerStore의 답변 변경을 관찰
        answerStore.$answers
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateAnswerStatusIfNeeded()
            }
            .store(in: &cancellables)
        
        // SharedDataManager의 데이터 변경을 관찰
        sharedDataManager.$dataChanged
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateAnswerStatusIfNeeded()
            }
            .store(in: &cancellables)
    }
    
    private func updateAnswerStatusIfNeeded() {
        guard let question = questionStore.todayQuestion else { return }
        updateAnswerStatus(for: question)
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
        containerView.addSubview(answerStatusView)
        containerView.addSubview(answerButton)
        
        categoryContainer.addSubview(categoryIcon)
        categoryContainer.addSubview(categoryLabel)
        
        answerStatusView.addSubview(answerStatusIcon)
        answerStatusView.addSubview(answerStatusLabel)
        
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
            
            categoryIcon.leadingAnchor.constraint(equalTo: categoryContainer.leadingAnchor, constant: 12),
            categoryIcon.centerYAnchor.constraint(equalTo: categoryContainer.centerYAnchor),
            categoryIcon.widthAnchor.constraint(equalToConstant: 20),
            categoryIcon.heightAnchor.constraint(equalToConstant: 20),
            
            categoryLabel.leadingAnchor.constraint(equalTo: categoryIcon.trailingAnchor, constant: 8),
            categoryLabel.trailingAnchor.constraint(equalTo: categoryContainer.trailingAnchor, constant: -12),
            categoryLabel.centerYAnchor.constraint(equalTo: categoryContainer.centerYAnchor),
            categoryContainer.heightAnchor.constraint(equalToConstant: 32),
            
            // 답변 상태 뷰
            answerStatusView.topAnchor.constraint(equalTo: categoryContainer.bottomAnchor, constant: 15),
            answerStatusView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            answerStatusView.heightAnchor.constraint(equalToConstant: 30),
            
            answerStatusIcon.leadingAnchor.constraint(equalTo: answerStatusView.leadingAnchor, constant: 12),
            answerStatusIcon.centerYAnchor.constraint(equalTo: answerStatusView.centerYAnchor),
            answerStatusIcon.widthAnchor.constraint(equalToConstant: 16),
            answerStatusIcon.heightAnchor.constraint(equalToConstant: 16),
            
            answerStatusLabel.leadingAnchor.constraint(equalTo: answerStatusIcon.trailingAnchor, constant: 6),
            answerStatusLabel.trailingAnchor.constraint(equalTo: answerStatusView.trailingAnchor, constant: -12),
            answerStatusLabel.centerYAnchor.constraint(equalTo: answerStatusView.centerYAnchor),
            
            // 답변 버튼
            answerButton.topAnchor.constraint(equalTo: answerStatusView.bottomAnchor, constant: 20),
            answerButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            answerButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            answerButton.heightAnchor.constraint(equalToConstant: 44),
            answerButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
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
        
        // 답변 상태 업데이트
        updateAnswerStatus(for: question)
    }
    
    private func updateAnswerStatus(for question: Question) {
        let hasAnswer = answerStore.hasAnswer(for: question.id)
        answerStatusView.isHidden = !hasAnswer
        
        if hasAnswer {
            answerButton.setTitle("답변 수정하기", for: .normal)
        } else {
            answerButton.setTitle("답변 작성하기", for: .normal)
        }
    }
    
    @objc private func answerButtonTapped() {
        guard let question = questionStore.todayQuestion else { return }
        
        let existingAnswer = answerStore.getAnswer(for: question.id)
        let alertTitle = existingAnswer != nil ? "답변 수정" : "답변 작성"
        let alertMessage = question.text
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "답변을 입력하세요..."
            textField.text = existingAnswer?.answerText ?? ""
        }
        
        let saveAction = UIAlertAction(title: "저장", style: .default) { [weak self] _ in
            guard let textField = alert.textFields?.first,
                  let answerText = textField.text,
                  !answerText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                return
            }
            
            let answer = Answer(
                questionId: question.id,
                questionText: question.text,
                questionCategory: question.category,
                answerText: answerText.trimmingCharacters(in: .whitespacesAndNewlines)
            )
            
            self?.answerStore.saveAnswer(answer)
            self?.updateAnswerStatus(for: question)
            
            // 메시지로 답변 공유
            self?.shareAnswerAsMessage(answer: answer, question: question)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func shareAnswerAsMessage(answer: Answer, question: Question) {
        let message = MSMessage()
        let layout = MSMessageTemplateLayout()
        
        // 메시지 내용 설정
        layout.image = renderAnswerMessageImage(answer: answer, question: question)
        layout.caption = "\(question.emoji) \(question.text)"
        layout.subcaption = "답변: \(answer.answerText)"
        message.layout = layout
        
        // 메시지 전송
        activeConversation?.insert(message) { error in
            if let error = error {
                print("Failed to insert message: \(error.localizedDescription)")
            }
        }
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
    
    private func renderAnswerMessageImage(answer: Answer, question: Question) -> UIImage? {
        let size = CGSize(width: 300, height: 200)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            let rect = CGRect(origin: .zero, size: size)
            
            // 배경
            UIColor.systemBackground.setFill()
            context.fill(rect)
            
            // 질문
            let questionRect = CGRect(x: 20, y: 20, width: 260, height: 80)
            let questionText = "\(question.emoji) \(question.text)"
            let questionAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 16, weight: .medium),
                .foregroundColor: UIColor.label
            ]
            questionText.draw(in: questionRect, withAttributes: questionAttributes)
            
            // 답변
            let answerRect = CGRect(x: 20, y: 110, width: 260, height: 70)
            let answerText = "답변: \(answer.answerText)"
            let answerAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.secondaryLabel
            ]
            answerText.draw(in: answerRect, withAttributes: answerAttributes)
        }
    }
} 