//
//  CardCell.swift
//  HalfModalTransition
//
//  Created by usagimaru on 2017.11.13.
//  Copyright © 2017年 usagimaru. All rights reserved.
//
// これらはすべてモックです。

import UIKit

class CardCell: UITableViewCell {
	
	@IBOutlet weak var cardImageView: UIImageView! {
		didSet {
			cardImageView.clipsToBounds = true
			cardImageView.layer.cornerRadius = 2
		}
	}
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var detailLabel: UILabel!
	
	// MARK: -
	
	static var reuseIdentifier: String {
		return "cell"
	}
	
	class func nib() -> UINib {
		return UINib(nibName: "\(self)", bundle: nil)
	}
	
	static var cellHeight: CGFloat {
		return 55
	}
	
	class func registerTo(tableView: UITableView) {
		tableView.register(CardCell.nib(), forCellReuseIdentifier: CardCell.reuseIdentifier)
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func fittingSize() -> CGSize {
		updateConstraints()
		layoutIfNeeded()
		return systemLayoutSizeFitting(UILayoutFittingCompressedSize)
	}

}
