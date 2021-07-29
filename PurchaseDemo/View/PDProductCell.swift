//
//  ProductCell.swift
//  PurchaseDemo
//
//  Created by 廖冠翰 on 2021/7/29.
//

import UIKit

class PDProductCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    
    public var model: PDProduct? {
        didSet {
            guard let model = model else { return }
            nameLabel.text = model.name
            priceLabel.text = model.price
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()

    }
}
