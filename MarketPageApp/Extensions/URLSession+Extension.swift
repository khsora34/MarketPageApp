import Foundation

extension URLSession {
    func dataTask(with url: URL, completionHandler: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { data, response, error in
            if let error = error {
                completionHandler(.failure(error))
            } else if let data = data {
                completionHandler(.success(data))
            } else {
                completionHandler(.failure(GenericError()))
            }
        }
    }
}
