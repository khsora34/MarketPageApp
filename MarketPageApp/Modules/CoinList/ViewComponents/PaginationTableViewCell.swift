//
//  PaginationTableViewCell.swift
//  MarketPageApp
//
//  Created by Francisco del Real Escudero on 6/8/22.
//

import UIKit

final class PaginationTableViewCell: UITableViewCell {
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.startAnimating()
    }
}
