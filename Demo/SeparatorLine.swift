//
//  SeparatorLine.swift
//  HalfModalTransition
//
//  Created by usagimaru on 2017.11.10.
//  Copyright © 2017年 usagimaru. All rights reserved.
//
// これらはすべてモックです。

import UIKit

class SeparatorLine: UIView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		_init()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		_init()
	}
	
	private func _init() {
		let constant = 1 / UIScreen.main.scale
		let layout = NSLayoutConstraint(item: self,
										attribute: .height,
										relatedBy: .equal,
										toItem: nil,
										attribute: .height,
										multiplier: 1,
										constant: constant)
		layout.priority = .init(999)
		addConstraint(layout)
	}

}
