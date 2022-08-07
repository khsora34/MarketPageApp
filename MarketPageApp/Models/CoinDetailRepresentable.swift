import Foundation

protocol CoinDetailRepresentable {
    var id: String { get }
    var symbol: String { get }
    func displayName(language: String) -> String
    var hashingAlgorithm: String? { get }
    func description(language: String) -> String?
    var smallImage: String { get }
    var largeImage: String { get }
    var creationDate: Date? { get }
    var marketCapRank: Int { get }
    func currentPrice(currency: Currency) -> Double?
    var linksRepresentable: CoinLinksRepresentable { get }
}

extension CoinDetailRepresentable {
    var smallImageUrl: URL? {
        return URL(string: smallImage)
    }
    
    var largeImageUrl: URL? {
        return URL(string: largeImage)
    }
}
