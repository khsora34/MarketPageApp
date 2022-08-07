import UIKit

protocol CoinListViewProtocol: AnyObject {
    func didLoadCoins(models: [CoinRepresentable])
    func didFailToLoadCoins()
    func loadMoreCoins(models: [CoinRepresentable])
    func didFailPagination()
}

final class CoinListViewController: UIViewController {
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    private lazy var emptyView: EmptyView = {
        let view = EmptyView()
        tableView.backgroundView = view
        view.isHidden = true
        return view
    }()
    private lazy var currencyButton = {
        return UIBarButtonItem(
            title: Currency.dollar.rawValue,
            style: .plain,
            target: self,
            action: #selector(changeCurrency)
        )
    }()
    private lazy var dataSource = CoinListTableViewDataSource(selectedCurrency: selectedCurrency, delegate: self)
    private var models: [CoinRepresentable] = []
    private var viewModel: CoinListViewModel
    private var selectedCurrency: Currency = .euro {
        didSet {
            dataSource.setDefaultCurrency(selectedCurrency)
            currencyButton.title = selectedCurrency.rawValue
            reloadNavigation()
            tableView.reloadData()
        }
    }
    
    init(dependencies: CoinListDependenciesResolver) {
        self.viewModel = dependencies.resolve()
        super.init(nibName: "CoinListViewController", bundle: nil)
        self.viewModel.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoading()
        dataSource.setup(tableView: tableView)
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        tableView.separatorStyle = .none
        title = "Coin list"
        viewModel.viewDidLoad()
        reloadNavigation()
    }
}

extension CoinListViewController: CoinListViewProtocol {
    func didLoadCoins(models: [CoinRepresentable]) {
        hideLoading()
        dataSource.setModels(models)
        tableView.reloadData()
    }
    
    func didFailToLoadCoins() {
        hideLoading()
        emptyView.setMessage("Unable to get the data from server")
        emptyView.setButtonAction(text: "Reload") { [weak self] in
            self?.viewModel.viewDidLoad()
        }
        emptyView.isHidden = false
    }
    
    func loadMoreCoins(models: [CoinRepresentable]) {
        dataSource.appendModels(models)
        tableView.reloadData()
    }
    
    func didFailPagination() {
        dataSource.setErrorOnPagination()
        tableView.reloadData()
    }
}

private extension CoinListViewController {    
    @objc func changeCurrency() {
        if selectedCurrency == .dollar {
            self.selectedCurrency = .euro
        } else if selectedCurrency == .euro {
            self.selectedCurrency = .dollar
        }
    }
    
    func reloadNavigation() {
        navigationItem.rightBarButtonItem = currencyButton
    }
}

extension CoinListViewController: CoinListTableViewDataSourceDelegate {
    func performPagination() {
        tableView.reloadData()
        viewModel.paginate()
    }
    
    func goToDetail(for model: CoinRepresentable) {
        viewModel.goToDetail(model)
    }
}

extension CoinListViewController: LoadingShowableCapable {}
