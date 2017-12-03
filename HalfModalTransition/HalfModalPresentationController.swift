//
//  HalfModalPresentationController.swift
//
//  Created by usagimaru on 2017.11.05.
//  Copyright © 2017年 usagimaru. All rights reserved.
//

import UIKit

/*
presented:  呼び出し先ViewController
presenting: 呼び出し元ViewController
*/
class HalfModalPresentationController: UIPresentationController {
	
	private(set) var tapGestureRecognizer: UITapGestureRecognizer?
	private var overlay = UIView()
	
	/// 呼び出し先ビューのframeを決定
	override var frameOfPresentedViewInContainerView: CGRect {
		var frame = containerView!.frame
		frame.origin.y = frame.height - modalHeight
		frame.size.height = modalHeight
		return frame
	}
	
	/// 外側をタップして閉じる
	var dismissesOnTappingOutside: Bool = true {
		didSet {
			tapGestureRecognizer?.isEnabled = dismissesOnTappingOutside
		}
	}
	
	private var modalHeight: CGFloat = 0
	
	func setModalHeight(_ newHeight: CGFloat, animated: Bool) {
		guard let presentedView = presentedView else {return}
		
		modalHeight = newHeight
		
		let frame = frameOfPresentedViewInContainerView
		
		if animated == false {
			presentedView.frame = frame
			return
		}
		
		UIView.perform(.delete,
					   on: [],
					   options: [.beginFromCurrentState, .allowUserInteraction],
					   animations: {
						presentedView.frame = frame
						presentedView.layoutIfNeeded()
		},
					   completion: nil)
	}
	
	private func setupOverlay(toContainerView: UIView) {
		tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnOverlay(_:)))
		tapGestureRecognizer!.isEnabled = dismissesOnTappingOutside
		
		overlay.frame = toContainerView.bounds
		overlay.backgroundColor = UIColor.black
		overlay.alpha = 0.0
		overlay.gestureRecognizers = [tapGestureRecognizer!]
		
		toContainerView.insertSubview(overlay, at: 0)
	}
	
	/// 表示直前
	override func presentationTransitionWillBegin() {
		guard let containerView = self.containerView else {return}
		
		setupOverlay(toContainerView: containerView)
		
		presentedViewController.transitionCoordinator?.animate(
			alongsideTransition: { [weak self] (context) in
				self?.overlay.alpha = 0.35
		}, completion: nil)
	}
	
	/// 隠蔽直前
	override func dismissalTransitionWillBegin() {
		presentedViewController.transitionCoordinator?.animate(
			alongsideTransition: { [weak self] (context) in
				self?.overlay.alpha = 0.0
		}, completion: nil)
	}
	
	override func dismissalTransitionDidEnd(_ completed: Bool) {
		if completed {
			overlay.removeFromSuperview()
		}
	}
	
	/// ビューのレイアウト直前
	override func containerViewWillLayoutSubviews() {
		if let containerView = containerView {
			overlay.frame = containerView.bounds
		}
		
		presentedView?.frame = frameOfPresentedViewInContainerView
	}
	
	@objc private func tapOnOverlay(_ gesture: UITapGestureRecognizer) {
		presentedViewController.dismiss(animated: true, completion: nil)
	}

}
