//
//  ViewController.swift
//  SemiModalTransition
//
//  Created by usagimaru on 2017.11.04.
//  Copyright © 2017年 usagimaru. All rights reserved.
//
// これらはすべてモックです。


import UIKit

let BGColor = UIColor(displayP3Red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)

class ModalNavigationController: UINavigationController {
	
	weak var semiModalPresentationController: SemiModalPresentationController?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		semiModalPresentationController = presentationController as? SemiModalPresentationController
		
		navigationBar.barTintColor = BGColor
		view.backgroundColor = BGColor
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		view.layoutSubviews()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
	}
	
}

class FirstViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}

}

class SecondViewController: UIViewController {
	
	@IBOutlet weak var cardNameLabel: UILabel! {
		didSet {
			cardNameLabel.text = "クレジットカード"
		}
	}
	@IBOutlet weak var cardDetailLabel: UILabel! {
		didSet {
			cardDetailLabel.text = "•••• 0000"
		}
	}
	
	private var isFirst: Bool = true
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = BGColor
	}
	
	
	// MARK: - Navigation
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		view.layoutIfNeeded()
		navigationController?.view.layoutIfNeeded()
		
		if isFirst {
			fitting(animated: false)
			isFirst = false
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if !isFirst {
			fitting(animated: true)
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
	}
	
	private func fitting(animated: Bool) {
		if let navi = navigationController as? ModalNavigationController {
			// `edgesForExtendedLayout = UIRectEdge()` として、ナビバーの下に潜らせないようにしておかないと、初回表示時にナビバーの高さ分縮んでしまう
			var height = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
			height += navi.navigationBar.frame.height
			navi.semiModalPresentationController?.setModalViewHeight(height, animated: animated)
		}
	}
	
	@IBAction func done(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
}

class ThirdViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	private var selectedIndexPath: IndexPath?
	
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = BGColor
		tableView.backgroundColor = BGColor
		
		CardCell.registerTo(tableView: tableView)
		
		selectedIndexPath = IndexPath(row: 0, section: 0)
	}
	
	
	// MARK: - Navigation
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		view.layoutIfNeeded()
		tableView.reloadData()
		view.layoutIfNeeded()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if let navi = navigationController as? ModalNavigationController {
			navi.semiModalPresentationController?.setModalViewHeight(tableView.frame.height + navi.navigationBar.frame.height, animated: true)
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
	}
	
	
	// MARK: -
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return 1
		case 1:
			return 2
		default:
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = UITableViewCell()
		
		switch indexPath.section {
		case 0:
			let cardCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CardCell
			cardCell.nameLabel.text = "クレジットカード"
			cardCell.detailLabel.text = "•••• 0000"
			cardCell.selectionStyle = .default
			cell = cardCell
			
		case 1:
			switch indexPath.row {
			case 0:
				let cardCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CardCell
				cardCell.nameLabel.text = "電子マネー"
				cardCell.detailLabel.text = "¥1,234（App内のお支払いはできません）"
				cardCell.selectionStyle = .none
				cell = cardCell
			case 1:
				let cardCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CardCell
				cardCell.nameLabel.text = "デビットカード"
				cardCell.detailLabel.text = "•••• 0000（App内のお支払いはできません）"
				cardCell.selectionStyle = .none
				cell = cardCell
			default: break
			}
			
		default: break
		}
		
		cell.accessoryType = indexPath == selectedIndexPath ? .checkmark : .none
		cell.backgroundColor = UIColor.clear
		
		let backgroundView = UIView()
		backgroundView.backgroundColor = BGColor
		cell.backgroundView = backgroundView
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return CardCell.cellHeight
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 26
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return UIView()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let cell = tableView.cellForRow(at: indexPath), cell.selectionStyle == .none {
			return
		}
		
		for visibleIndexPath in tableView.indexPathsForVisibleRows ?? [] {
			if let cell = tableView.cellForRow(at: visibleIndexPath) {
				cell.accessoryType = visibleIndexPath == indexPath ? .checkmark : .none
			}
		}
		
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
}

