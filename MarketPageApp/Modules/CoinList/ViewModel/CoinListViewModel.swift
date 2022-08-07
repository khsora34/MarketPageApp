import Foundation

final class CoinListViewModel {
    private var dependencies: CoinListDependenciesResolver
    private var coinRepository: CoinRepository
    weak var view: CoinListViewProtocol?
    private var page: Int = 1
    private var semaphore = DispatchSemaphore(value: 1)
    private var isLoadingCoins = false
    
    init(dependencies: CoinListDependenciesResolver) {
        self.dependencies = dependencies
        self.coinRepository = dependencies.external.resolve()
    }
    
    func viewDidLoad() {
        coinRepository.fetchCoinsList { [weak self] result in
            self?.onReceivedFirstCoins(result: result)
        }
    }
    
    func onReceivedFirstCoins(result: Result<[CoinRepresentable], Error>) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch result {
            case .success(let list):
                self.page += 1
                self.view?.didLoadCoins(models: list)
            case .failure(let error):
                self.view?.didFailToLoadCoins()
            }
        }
    }
    
    func paginate() {
        semaphore.wait()
        coinRepository.fetchCoinsList(page: page, didFetch: onReceivedNewPage(result:))
        semaphore.signal()
    }
    
    func onReceivedNewPage(result: Result<[CoinRepresentable], Error>) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch result {
            case .success(let list):
                self.page += 1
                self.view?.loadMoreCoins(models: list)
            case .failure(let error):
                self.view?.didFailPagination()
            }
        }
    }
    
    func goToDetail(_ model: CoinRepresentable) {
        let coordinator: CoinListCoordinator = dependencies.resolve()
        coordinator.goToDetail(model)
    }
}
