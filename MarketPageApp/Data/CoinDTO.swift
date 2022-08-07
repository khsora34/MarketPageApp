import Foundation

struct CoinDTO: Decodable {
    let id: String
    let symbol: String
    let name: String
    let image: CoinImageDTO
    let market_data: MarketDataDTO
    let localization: [String: String]
}

extension CoinDTO: CoinRepresentable {
    var smallImage: String {
        return image.small
    }
    
    var largeImage: String {
        return image.large
    }
    
    func currentPrice(currency: Currency) -> Double? {
        return market_data.current_price[currency]
    }
    
    var marketCapRank: Int {
        return market_data.market_cap_rank
    }
    
    func displayName(language: String) -> String {
        return localization[language] ?? name
    }
}
