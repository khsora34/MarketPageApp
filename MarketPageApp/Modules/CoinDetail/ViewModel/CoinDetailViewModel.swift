import Foundation

final class CoinDetailViewModel {
    private let dependencies: CoinDetailDependenciesResolver
    private let model: CoinDetailRepresentable!
    weak var view: CoinDetailViewControllerProtocol?
    
    init(dependencies: CoinDetailDependenciesResolver) {
        self.dependencies = dependencies
        let config: CoinDetailConfiguration = dependencies.resolve()
        self.model = config.detail
    }
    
    func viewDidLoad() {
        if let url = model.largeImageUrl {
            view?.setImage(url: url)
        }
        view?.addDefaultSection(title: "ID", subtitle: model.id)
        view?.addDefaultSection(title: "Symbol", subtitle: model.symbol)
        view?.addDefaultSection(title: "Name", subtitle: model.displayName(language: ""))
        if let hashingAlgorithm = model.hashingAlgorithm {
            view?.addDefaultSection(title: "Hash Algorithm", subtitle: hashingAlgorithm)
        }
        if let creationDate = model.creationDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            view?.addDefaultSection(title: "Created Date", subtitle: dateFormatter.string(from: creationDate))
        }
        if let description = model.description(language: "en") {
            view?.addDescriptionSection(title: "Description", subtitle: description)
        }
        view?.addLinksSection(title: "Links", availableLinks: Array(model.linksRepresentable.availableLinks.keys))
    }
    
    func goToLink(_ tag: Int) {
        let links = model.linksRepresentable.availableLinks
        guard
            let selectedLink = CoinDetailLink(rawValue: tag),
            let stringUrl = links[selectedLink],
            let url = URL(string: stringUrl)
        else { return }
        view?.goToUrl(url)
    }
}

enum CoinDetailLink: Int, CaseIterable {
    case homepage = 1, blockchainSite, forum, subreddit, twitterUser, github, bitbucket
}
