//
//  ReloadTableViewCell.swift
//  MarketPageApp
//
//  Created by Francisco del Real Escudero on 6/8/22.
//

import UIKit

final class ReloadTableViewCell: UITableViewCell {
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var reloadButton: UIButton!
    private var reloadAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        errorLabel.text = "An error arised while getting more results. Try again."
        reloadButton.setTitle("Reload", for: .normal)
    }
    
    func setReloadAction(_ action: @escaping () -> Void) {
        self.reloadAction = action
    }
    
    @IBAction func didTapOnReloadButton(_ sender: Any) {
        reloadAction?()
    }
}
