import Foundation

protocol CoinRepresentable {
    var id: String { get }
    var symbol: String { get }
    var smallImage: String { get }
    var largeImage: String { get }
    var marketCapRank: Int { get }
    func displayName(language: String) -> String
    func currentPrice(currency: Currency) -> Double?
}

extension CoinRepresentable {
    var smallImageUrl: URL? {
        return URL(string: smallImage)
    }
    
    var largeImageUrl: URL? {
        return URL(string: largeImage)
    }
}
