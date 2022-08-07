//
//  CoinListTableViewCell.swift
//  MarketPageApp
//
//  Created by Francisco del Real Escudero on 5/8/22.
//

import Kingfisher
import UIKit

final class CoinListTableViewCell: UITableViewCell {
    @IBOutlet private weak var positionLabel: UILabel!
    @IBOutlet private weak var coinImageView: UIImageView!
    @IBOutlet private weak var coinNameLabel: UILabel!
    @IBOutlet private weak var coinMarketValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setModel(_ model: CoinRepresentable, selectedCurrency: Currency) {
        positionLabel.text = String(model.marketCapRank)
        coinImageView.kf.setImage(with: model.largeImageUrl, placeholder: UIImage(systemName: "photo"))
        coinNameLabel.text = model.displayName(language: "es")
        if let currentPrice = model.currentPrice(currency: selectedCurrency) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencyCode = selectedCurrency.rawValue
            formatter.maximumFractionDigits = 2
            coinMarketValueLabel.text = formatter.string(from: NSNumber(value: currentPrice))
        }
    }
}
