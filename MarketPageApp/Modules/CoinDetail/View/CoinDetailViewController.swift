import Kingfisher
import UIKit

protocol CoinDetailViewControllerProtocol: AnyObject {
    func goToUrl(_ url: URL)
    func setImage(url: URL)
    func addDefaultSection(title: String, subtitle: String)
    func addLinksSection(title: String, availableLinks: [CoinDetailLink])
    func addDescriptionSection(title: String, subtitle: String)
}

final class CoinDetailViewController: UIViewController {
    @IBOutlet private weak var coinImageView: UIImageView!
    @IBOutlet private weak var stackView: UIStackView!
    
    private let dependencies: CoinDetailDependenciesResolver
    private let viewModel: CoinDetailViewModel
    
    init(dependencies: CoinDetailDependenciesResolver) {
        self.dependencies = dependencies
        self.viewModel = dependencies.resolve()
        super.init(nibName: "CoinDetailViewController", bundle: nil)
        self.viewModel.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        viewModel.viewDidLoad()
    }
    
}

extension CoinDetailViewController: CoinDetailViewControllerProtocol {
    func goToUrl(_ url: URL) {
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }

    func setImage(url: URL) {
        coinImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "photo"))
    }
    
    func addDefaultSection(title: String, subtitle: String) {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = subtitle
        embedInStack(views: [
            createTitleLabel(title: title),
            descriptionLabel
        ])
    }
    
    func addLinksSection(title: String, availableLinks: [CoinDetailLink]) {
        var buttons: [UIView] = []
        for link in availableLinks {
            let button = UIButton(type: link.shouldUseCustomButton ? .custom: .system)
            button.setImage(link.image, for: .normal)
            button.tag = link.rawValue
            button.tintColor = .label
            button.widthAnchor.constraint(equalToConstant: 24).isActive = true
            button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
            button.addTarget(self, action: #selector(didTapOnButton), for: .touchUpInside)
            buttons.append(button)
        }
        let horizontalStack = UIStackView(arrangedSubviews: buttons + [UIView()])
        horizontalStack.spacing = 8
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .fill
        embedInStack(views: [
            createTitleLabel(title: title),
            horizontalStack
        ])
    }
    
    func addDescriptionSection(title: String, subtitle: String) {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = subtitle
        descriptionLabel.font = .preferredFont(forTextStyle: .body)
        descriptionLabel.textAlignment = .justified
        embedInStack(views: [
            createTitleLabel(title: title),
            descriptionLabel
        ])
    }
}

private extension CoinDetailViewController {
    func createTitleLabel(title: String) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.text = title
        return titleLabel
    }
    
    func embedInStack(views: [UIView]) {
        let stack = UIStackView(arrangedSubviews: views)
        stack.axis = .vertical
        stack.spacing = 6
        stackView.addArrangedSubview(stack)
    }
    
    @objc func didTapOnButton(sender: UIView) {
        viewModel.goToLink(sender.tag)
    }
}

extension CoinDetailLink {
    var shouldUseCustomButton: Bool {
        switch self {
        case .homepage, .blockchainSite, .forum:
            return false
        case .subreddit, .twitterUser, .github, .bitbucket:
            return true
        }
    }
    
    var image: UIImage! {
        switch self {
        case .homepage:
            return UIImage(systemName: "house")
        case .blockchainSite:
            return UIImage(systemName: "bitcoinsign.circle")
        case .forum:
            return UIImage(systemName: "character.bubble")
        case .subreddit:
            return UIImage(named: "reddit")
        case .twitterUser:
            return UIImage(named: "twitter")
        case .github:
            return UIImage(named: "github")
        case .bitbucket:
            return UIImage(named: "bitbucket")
        }
    }
}
