import UIKit

protocol CoinListCoordinator: Coordinator {
    func goToDetail(_ model: CoinRepresentable)
}

final class DefaultCoinListCoordinator: CoinListCoordinator {
    private let externalDependencies: CoinListExternalDependenciesResolver
    private var childCoordinators: [Coordinator] = []
    private lazy var dependency: Dependency = {
        return Dependency(external: externalDependencies, coordinator: self)
    }()
    
    init(dependencies: CoinListExternalDependenciesResolver) {
        self.externalDependencies = dependencies
    }
    
    func start() {
        let navigation: UINavigationController = externalDependencies.resolve()
        let view: CoinListViewController = dependency.resolve()
        navigation.pushViewController(view, animated: true)
    }
    
    func goToDetail(_ model: CoinRepresentable) {
        let coordinator = externalDependencies.coinDetailCoordinator()
        childCoordinators.append(coordinator)
        (coordinator as? CoinDetailCoordinator)?.setCoinId(model.id)
            .start()
    }
    
    struct Dependency: CoinListDependenciesResolver {
        let external: CoinListExternalDependenciesResolver
        let coordinator: CoinListCoordinator
        
        init(external: CoinListExternalDependenciesResolver, coordinator: CoinListCoordinator) {
            self.external = external
            self.coordinator = coordinator
        }
        
        func resolve() -> CoinListCoordinator {
            return coordinator
        }
    }
}
