import UIKit

protocol CoinListTableViewDataSourceDelegate: AnyObject {
    func performPagination()
    func goToDetail(for model: CoinRepresentable)
}

final class CoinListTableViewDataSource: NSObject {
    enum Constant {
        static let coinCellId = "CoinCell"
        static let paginationId = "PaginationCell"
        static let reloadCellId = "ReloadCell"
    }
    private var selectedCurrency: Currency
    private var models: [CoinRepresentable] = []
    private var isPaginating: Bool = false
    private var paginationDidFail: Bool = false
    private var isLastPage: Bool = false
    weak var delegate: CoinListTableViewDataSourceDelegate?

    init(selectedCurrency: Currency, delegate: CoinListTableViewDataSourceDelegate) {
        self.selectedCurrency = selectedCurrency
        self.delegate = delegate
    }
    
    func setup(tableView: UITableView) {
        tableView.register(
            UINib(nibName: "CoinListTableViewCell", bundle: nil),
            forCellReuseIdentifier: Constant.coinCellId
        )
        tableView.register(
            UINib(nibName: "PaginationTableViewCell", bundle: nil),
            forCellReuseIdentifier: Constant.paginationId
        )
        tableView.register(
            UINib(nibName: "ReloadTableViewCell", bundle: nil),
            forCellReuseIdentifier: Constant.reloadCellId
        )
    }
    
    func setModels(_ models: [CoinRepresentable]) {
        self.models = models
    }
    
    func appendModels(_ models: [CoinRepresentable]) {
        self.models.append(contentsOf: models)
        isLastPage = models.isEmpty
        isPaginating = false
    }
    
    func setDefaultCurrency(_ currency: Currency) {
        selectedCurrency = currency
    }
    
    func setErrorOnPagination() {
        paginationDidFail = true
        isPaginating = false
    }
}

extension CoinListTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.isEmpty ? 0: models.count + (isLastPage ? 0: 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < models.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.coinCellId, for: indexPath)
            let model = models[indexPath.row]
            (cell as? CoinListTableViewCell)?.setModel(model, selectedCurrency: selectedCurrency)
            return cell
        } else {
            if paginationDidFail {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constant.reloadCellId, for: indexPath)
                (cell as? ReloadTableViewCell)?.setReloadAction { [weak self] in
                    self?.paginate()
                    self?.paginationDidFail = false
                }
                return cell
            } else {
                paginate()
                return tableView.dequeueReusableCell(withIdentifier: Constant.paginationId, for: indexPath)
            }
        }
    }
}

extension CoinListTableViewDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < models.count else { return }
        let model = models[indexPath.row]
        delegate?.goToDetail(for: model)
    }
}


private extension CoinListTableViewDataSource {
    func paginate() {
        guard !isPaginating else { return }
        isPaginating = true
        delegate?.performPagination()
    }
}
