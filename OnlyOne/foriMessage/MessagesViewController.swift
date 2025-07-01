import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    private let pointStore = MessagePointStore.shared
    
    private lazy var pointButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("👏 +1점", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.isEnabled = false
        button.addTarget(self, action: #selector(addPointButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var guideLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "메시지를 선택하여 점수를 주세요"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var compactView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(guideLabel)
        view.addSubview(pointButton)
        
        NSLayoutConstraint.activate([
            guideLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            guideLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            guideLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            guideLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            pointButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pointButton.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: 20),
            pointButton.widthAnchor.constraint(equalToConstant: 120),
            pointButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        return view
    }()
    
    private lazy var expandedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        
        let todayLabel = UILabel()
        todayLabel.translatesAutoresizingMaskIntoConstraints = false
        todayLabel.textAlignment = .center
        todayLabel.font = .systemFont(ofSize: 20, weight: .medium)
        todayLabel.tag = 1
        
        let totalLabel = UILabel()
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.textAlignment = .center
        totalLabel.font = .systemFont(ofSize: 20, weight: .medium)
        totalLabel.tag = 2
        
        stackView.addArrangedSubview(todayLabel)
        stackView.addArrangedSubview(totalLabel)
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(compactView)
        view.addSubview(expandedView)
        
        NSLayoutConstraint.activate([
            compactView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            compactView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            compactView.topAnchor.constraint(equalTo: view.topAnchor),
            compactView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            expandedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            expandedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            expandedView.topAnchor.constraint(equalTo: view.topAnchor),
            expandedView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        updateExpandedView()
    }
    
    private func updateExpandedView() {
        let summary = pointStore.getSummary()
        
        if let todayLabel = expandedView.viewWithTag(1) as? UILabel {
            todayLabel.text = "오늘 받은 점수: \(summary.todayPoints)점 🎉"
        }
        
        if let totalLabel = expandedView.viewWithTag(2) as? UILabel {
            totalLabel.text = "전체 받은 점수: \(summary.totalPoints)점 ⭐️"
        }
    }
    
    private func createPointMessage() -> MSMessage {
        let message = MSMessage()
        var components = URLComponents()
        components.scheme = "message-point"
        components.host = "point"
        components.queryItems = [
            URLQueryItem(name: "timestamp", value: "\(Date().timeIntervalSince1970)")
        ]
        message.url = components.url
        
        let layout = MSMessageTemplateLayout()
        layout.image = UIImage(systemName: "hand.thumbsup.fill")
        layout.caption = "메시지에 +1점을 주었습니다! 👏"
        message.layout = layout
        
        return message
    }
    
    @objc private func addPointButtonTapped() {
        let message = createPointMessage()
        
        // 버튼 애니메이션
        UIView.animate(withDuration: 0.15, animations: {
            self.pointButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                self.pointButton.transform = .identity
            }
        }
        
        activeConversation?.insert(message) { [weak self] error in
            if let error = error {
                print("Failed to insert message: \(error.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async {
                self?.requestPresentationStyle(.expanded)
                self?.updateExpandedView()
            }
        }
    }
    
    // MARK: - MSMessagesAppViewController
    
    override func willBecomeActive(with conversation: MSConversation) {
        super.willBecomeActive(with: conversation)
        pointButton.isEnabled = false
        guideLabel.text = "메시지를 선택하여 점수를 주세요"
    }
    
    override func didSelect(_ message: MSMessage, conversation: MSConversation) {
        super.didSelect(message, conversation: conversation)
        pointButton.isEnabled = true
        guideLabel.text = "선택한 메시지에 점수를 주시겠어요?"
    }
    
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        super.didReceive(message, conversation: conversation)
        
        guard let url = message.url,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              components.scheme == "message-point",
              components.host == "point",
              let timestampItem = components.queryItems?.first(where: { $0.name == "timestamp" }),
              let timestamp = Double(timestampItem.value ?? "") else {
            return
        }
        
        let messageId = "\(timestamp)"
        pointStore.addPoint(to: messageId)
        updateExpandedView()
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        super.willTransition(to: presentationStyle)
        
        compactView.isHidden = presentationStyle == .expanded
        expandedView.isHidden = presentationStyle == .compact
        
        if presentationStyle == .expanded {
            updateExpandedView()
        }
    }
} 