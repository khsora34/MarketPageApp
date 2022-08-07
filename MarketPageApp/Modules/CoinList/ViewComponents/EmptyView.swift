import UIKit

final class EmptyView: UIView {
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .title1)
        addSubview(label)
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 15.0, *) {
            button.configuration = nil
        }
        addSubview(button)
        button.addTarget(self, action: #selector(performButtonAction), for: .touchUpInside)
        return button
    }()
    private var action: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setMessage(_ message: String) {
        label.text = message
    }
    
    func setButtonAction(text: String, action: @escaping () -> Void) {
        self.action = action
        button.setTitle(text, for: .normal)
        button.isHidden = false
    }
    
    @objc func performButtonAction() {
        action?()
    }
}

extension EmptyView {
    func setup() {
        let stack = UIStackView(arrangedSubviews: [label, button])
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        stack.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: -20).isActive = true
        button.isHidden = true
    }
}
