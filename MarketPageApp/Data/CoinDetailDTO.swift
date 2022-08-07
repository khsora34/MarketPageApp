import Foundation

struct CoinDetailDTO: Decodable {
    let id: String
    let symbol: String
    let name: String
    let hashing_algorithm: String?
    let localization: [String: String]
    let description: [String: String]
    let image: CoinImageDTO
    let links: CoinDetailLinksDTO
    let genesis_date: Date?
    let market_data: MarketDataDTO
}

extension CoinDetailDTO: CoinDetailRepresentable {
    func displayName(language: String) -> String {
        return localization[language] ?? name
    }
    
    var hashingAlgorithm: String? {
        return hashing_algorithm
    }
    
    func description(language: String) -> String? {
        guard let htmlDesc = description[language] else { return nil }
        return try? NSAttributedString(
            data: Data(htmlDesc.utf8),
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        )
        .string
    }
    
    var smallImage: String {
        return image.small
    }
    
    var largeImage: String {
        return image.large
    }
    
    var creationDate: Date? {
        return genesis_date
    }
    
    var marketCapRank: Int {
        return market_data.market_cap_rank
    }
    
    func currentPrice(currency: Currency) -> Double? {
        return market_data.current_price[currency]
    }
    
    var linksRepresentable: CoinLinksRepresentable {
        return links
    }
}
