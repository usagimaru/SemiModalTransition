//
//  HalfModalTransition
//
//  Created by usagimaru on 2017.11.05.
//  Copyright © 2017年 usagimaru. All rights reserved.
//

import UIKit

class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
	
	func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
		// HalfModalPresentationControllerを返す
		let controller = HalfModalPresentationController(presentedViewController: presented, presenting: presenting)
		controller.dismissesOnTappingOutside = false
		return controller
	}
	
}

class HalfModalTransitionSegue: UIStoryboardSegue {
	
	private(set) var transitioningDelegatee = TransitioningDelegate()
	
	override func perform() {
		// 今回は遷移をStoryboardSegueで定義したので、遷移実行時にTransitioningDelegateを適用するようにした
		destination.modalPresentationStyle = .custom
		destination.transitioningDelegate = transitioningDelegatee
		super.perform()
	}
	
}
