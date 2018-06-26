//
//  SemiModalTransition
//
//  Created by usagimaru on 2017.11.05.
//  Copyright © 2017 Satori Maru. All rights reserved.
//

import UIKit

class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
	
	func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
		// SemiModalPresentationControllerを返す
		let semiModalPresentationController = SemiModalPresentationController(presentedViewController: presented, presenting: presenting)
		// 外側タップで閉じられるようにするか
		semiModalPresentationController.dismissesOnTappingOutside = false
		
		return semiModalPresentationController
	}
	
}

class SemiModalTransitionSegue: UIStoryboardSegue {
	
	private(set) var transitioningDelegatee = TransitioningDelegate()
	
	override func perform() {
		// 今回は遷移をStoryboardSegueで定義したので、遷移実行時にTransitioningDelegateを適用するようにした
		destination.modalPresentationStyle = .custom
		destination.transitioningDelegate = self.transitioningDelegatee
		super.perform()
	}
	
}
