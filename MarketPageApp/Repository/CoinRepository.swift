import Foundation

protocol CoinRepository {
    func fetchCoinsList(page: Int, didFetch: @escaping (Result<[CoinRepresentable], Error>) -> Void)
    func fetchCoinDetail(id: String, didFetch: @escaping (Result<CoinDetailRepresentable, Error>) -> Void)
}

extension CoinRepository {
    func fetchCoinsList(didFetch: @escaping (Result<[CoinRepresentable], Error>) -> Void) {
        fetchCoinsList(page: 1, didFetch: didFetch)
    }
}

struct DefaultCoinRepository {
    private var urlSession: URLSession
    
    init() {
        self.urlSession = URLSession(configuration: URLSessionConfiguration.default)
    }
}

extension DefaultCoinRepository: CoinRepository {
    func fetchCoinsList(page: Int, didFetch: @escaping (Result<[CoinRepresentable], Error>) -> Void) {
        urlSession.dataTask(with: coinListUrl(page: page)) { result in
            switch result {
            case .success(let data):
                do {
                    let dto = try JSONDecoder().decode([CoinDTO].self, from: data)
                    didFetch(.success(dto))
                } catch let error {
                    didFetch(.failure(error))
                }
            case .failure(let error):
                didFetch(.failure(error))
            }
        }
        .resume()
    }
    
    func fetchCoinDetail(id: String, didFetch: @escaping (Result<CoinDetailRepresentable, Error>) -> Void) {
        urlSession.dataTask(with: coinDetailUrl(coinId: id)) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    let dto = try decoder.decode(CoinDetailDTO.self, from: data)
                    didFetch(.success(dto))
                } catch let error {
                    didFetch(.failure(error))
                }
            case .failure(let error):
                didFetch(.failure(error))
            }
        }
        .resume()
    }
}

private extension DefaultCoinRepository {
    var mainStringUrl: String {
        return "https://api.coingecko.com/api/v3"
    }
    
    func coinListUrl(page: Int) -> URL! {
        let stringUrl = mainStringUrl + "/coins?per_page=20&page=\(page)"
        return URL(string: stringUrl)
    }
    
    func coinDetailUrl(coinId: String) -> URL! {
        let stringUrl = mainStringUrl + "/coins/\(coinId)?tickers=false&community_data=false&developer_data=false&sparkline=false"
        return URL(string: stringUrl)
    }
}
