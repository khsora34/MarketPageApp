import UIKit

protocol CoinDetailCoordinator: Coordinator {
    func setCoinId(_ id: String) -> Self 
}

final class DefaultCoinDetailCoordinator: CoinDetailCoordinator {
    private let externalDependencies: CoinDetailExternalDependenciesResolver
    
    private lazy var dependency: Dependency = {
        return Dependency(external: externalDependencies)
    }()
    
    init(externalDependencies: CoinDetailExternalDependenciesResolver) {
        self.externalDependencies = externalDependencies
    }
    
    func start() {
        guard let coinId = dependency.config.coinId else { return }
        showLoading()
        let coinRepository: CoinRepository = externalDependencies.resolve()
        coinRepository.fetchCoinDetail(id: coinId) { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                self?.hideLoading()
                guard case .success(let detail) = result else { return }
                self?.goToDetail(detail)
            }
        }
    }
    
    func goToDetail(_ detail: CoinDetailRepresentable) {
        dependency.config.detail = detail
        let nav: UINavigationController = externalDependencies.resolve()
        let view: CoinDetailViewController = dependency.resolve()
        nav.pushViewController(view, animated: true)
    }
    
    func setCoinId(_ id: String) -> Self {
        dependency.config.coinId = id
        return self
    }
    
    struct Dependency: CoinDetailDependenciesResolver {
        var external: CoinDetailExternalDependenciesResolver
        var config: CoinDetailConfiguration
        
        init(external: CoinDetailExternalDependenciesResolver) {
            self.external = external
            self.config = CoinDetailConfiguration()
        }
        
        func resolve() -> CoinDetailConfiguration {
            return config
        }
    }
}

struct CoinDetailConfiguration {
    var coinId: String?
    var detail: CoinDetailRepresentable?
}

extension DefaultCoinDetailCoordinator: LoadingShowableCapable {
    var loadingViewController: UIViewController {
        return externalDependencies.resolve() as UINavigationController
    }
}
