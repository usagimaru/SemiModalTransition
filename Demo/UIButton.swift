//
//  CellButton.swift
//  HalfModalTransition
//
//  Created by usagimaru on 2017.11.06.
//  Copyright © 2017年 usagimaru. All rights reserved.
//
// これらはすべてモックです。

import UIKit

protocol UIButtonHighlighting {
	
	var highlightLayer: UIView {get set}
	
	func makeHighlighted(aniamted: Bool)
	func breakHighlighted(aniamted: Bool)
	
}

extension UIButtonHighlighting where Self: UIButton {
	
	func makeHighlighted(aniamted: Bool) {
		// ハイライトレイヤーを用意
		if highlightLayer.superview == nil {
			highlightLayer.alpha = 0.0
			highlightLayer.isUserInteractionEnabled = false
			highlightLayer.translatesAutoresizingMaskIntoConstraints = false // これやっておかないとAutoSizingと衝突する
			addSubview(highlightLayer)
			
			addConstraints(NSLayoutConstraint.constraints(
				withVisualFormat: "V:|[highlightLayer]|",
				options: NSLayoutFormatOptions(),
				metrics: nil,
				views: ["highlightLayer" : highlightLayer]))
			addConstraints(NSLayoutConstraint.constraints(
				withVisualFormat: "H:|[highlightLayer]|",
				options: NSLayoutFormatOptions(),
				metrics: nil,
				views: ["highlightLayer" : highlightLayer]))
		}
		
		let nextAlpha: CGFloat = 1.0
		
		if aniamted {
			UIView.animate(
				withDuration: 0.25,
				delay: 0,
				options: [.beginFromCurrentState],
				animations: {
					self.highlightLayer.alpha = nextAlpha
			}, completion: nil)
		}
		else {
			highlightLayer.alpha = nextAlpha
		}
	}
	
	func breakHighlighted(aniamted: Bool) {
		let nextAlpha: CGFloat = 0
		
		if aniamted {
			UIView.animate(
				withDuration: 0.3,
				delay: 0,
				options: [.beginFromCurrentState],
				animations: {
					self.highlightLayer.alpha = nextAlpha
			}, completion: nil)
		}
		else {
			highlightLayer.alpha = nextAlpha
		}
	}
	
}

class CellButton: UIButton, UIButtonHighlighting {
	
	var highlightLayer = UIView()
	
	@IBInspectable var highlightColor: UIColor? {
		didSet {
			highlightLayer.backgroundColor = highlightColor
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		_init()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		_init()
	}
	
	private func _init() {
		highlightColor = UIColor.init(displayP3Red: 0.87, green: 0.87, blue: 0.87, alpha: 1.0)
		
		addTarget(self, action: #selector(_highlight), for: .touchDown)
		addTarget(self, action: #selector(_highlightWithAnimation), for: .touchDragEnter)
		addTarget(self, action: #selector(_unhighlightWithAnimation), for: .touchDragExit)
		addTarget(self, action: #selector(_unhighlightWithAnimation), for: .touchCancel)
		addTarget(self, action: #selector(_unhighlightWithAnimation), for: .touchUpInside)
	}
	
	override var isSelected: Bool {
		didSet {
			if isSelected {
				makeHighlighted(aniamted: false)
			}
			else {
				breakHighlighted(aniamted: true)
			}
		}
	}
	
	@objc private func _highlight(_ sender: Any) {
		makeHighlighted(aniamted: false)
	}
	
	@objc private func _highlightWithAnimation(_ sender: Any) {
		makeHighlighted(aniamted: true)
	}
	
	@objc private func _unhighlightWithAnimation(_ sender: Any) {
		breakHighlighted(aniamted: true)
	}
	
}
