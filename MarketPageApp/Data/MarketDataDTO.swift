import Foundation

struct MarketDataDTO: Decodable {
    let current_price: [Currency: Double]
    let market_cap_rank: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.market_cap_rank = try container.decode(Int.self, forKey: .market_cap_rank)
        let tempDict = try container.decode([String: Double].self, forKey: .current_price)
        var current_price: [Currency: Double] = [:]
        for (key, value) in tempDict {
            guard let currency = Currency(rawValue: key) else { continue }
            current_price[currency] = value
        }
        self.current_price = current_price
    }
    
    init(current_price: [Currency: Double], market_cap_rank: Int) {
        self.current_price = current_price
        self.market_cap_rank = market_cap_rank
    }
    
    enum CodingKeys: CodingKey {
        case current_price
        case market_cap_rank
    }
}
