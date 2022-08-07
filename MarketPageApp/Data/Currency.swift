import Foundation

enum Currency: String {
    case dollar = "USD"
    case euro = "EUR"
    
    init?(rawValue: String) {
        switch rawValue {
        case "eur", "EUR":
            self = .euro
        case "usd", "USD":
            self = .dollar
        default:
            return nil
        }
    }
}
