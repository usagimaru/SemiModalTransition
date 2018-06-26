//
//  SemiModalPresentationController.swift
//
//  Created by usagimaru on 2017.11.05.
//  Copyright © 2017 Satori Maru. All rights reserved.
//

import UIKit

class SemiModalPresentationController: UIPresentationController {
	
	private(set) var tapGestureRecognizer: UITapGestureRecognizer?
	private var overlay = UIView()
	
	/// 呼び出し先ビューのframeを決定
	override var frameOfPresentedViewInContainerView: CGRect {
		var frame = containerView!.frame
		frame.origin.y = frame.height - self.modalViewHeight
		frame.size.height = self.modalViewHeight
		return frame
	}
	
	/// 外側をタップして閉じる
	var dismissesOnTappingOutside: Bool = true {
		didSet {
			self.tapGestureRecognizer?.isEnabled = self.dismissesOnTappingOutside
		}
	}
	
	private var modalViewHeight: CGFloat = 0
	
	/*
	memo:
	presented... 呼び出し先ViewController
	presenting.. 呼び出し元ViewController
	*/
	
	var backdropViewController: UIViewController {
		return self.presentingViewController
	}
	
	var frontViewController: UIViewController {
		return self.presentedViewController
	}
	
	
	// MARK: -
	
	/// モーダルビューの高さを設定
	func setModalViewHeight(_ newHeight: CGFloat, animated: Bool) {
		guard let presentedView = self.presentedView else {return}
		
		self.modalViewHeight = newHeight
		
		let frame = self.frameOfPresentedViewInContainerView
		
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
		}, completion: nil)
	}
	
	private func setupOverlay(toContainerView: UIView) {
		self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnOverlay(_:)))
		self.tapGestureRecognizer!.isEnabled = self.dismissesOnTappingOutside
		
		self.overlay.frame = toContainerView.bounds
		self.overlay.backgroundColor = UIColor.black
		self.overlay.alpha = 0.0
		self.overlay.gestureRecognizers = [self.tapGestureRecognizer!]
		
		toContainerView.insertSubview(self.overlay, at: 0)
	}
	
	/// 表示直前
	override func presentationTransitionWillBegin() {
		guard let containerView = self.containerView else {return}
		
		setupOverlay(toContainerView: containerView)
		
		self.frontViewController.transitionCoordinator?.animate(
			alongsideTransition: { [weak self] (context) in
				self?.overlay.alpha = 0.35
		}, completion: nil)
	}
	
	/// 隠蔽直前
	override func dismissalTransitionWillBegin() {
		self.frontViewController.transitionCoordinator?.animate(
			alongsideTransition: { [weak self] (context) in
				self?.overlay.alpha = 0.0
		}, completion: nil)
	}
	
	override func dismissalTransitionDidEnd(_ completed: Bool) {
		if completed {
			self.overlay.removeFromSuperview()
		}
	}
	
	/// ビューのレイアウト直前
	override func containerViewWillLayoutSubviews() {
		if let containerView = containerView {
			self.overlay.frame = containerView.bounds
		}
		
		self.presentedView?.frame = self.frameOfPresentedViewInContainerView
	}
	
	/// 背景透過部分のタップで閉じる
	@objc private func tapOnOverlay(_ gesture: UITapGestureRecognizer) {
		self.frontViewController.dismiss(animated: true, completion: nil)
	}
	
	
	// MARK: -
	
	/// 背景ビューのスケールとずれを適用するアフィン行列を返す
	static func backdropTransform(withScale scale: CGFloat, translates: CGPoint) -> CGAffineTransform {
		return CGAffineTransform(scaleX: scale, y: scale).translatedBy(x: translates.x, y: translates.y)
	}
	
	/// 前景ビューを表示するトランジションを描画
	func performPresentingTransition(withFrontMargin frontMargin: CGFloat,
									 backdropMargins: CGPoint,
									 backdropScale: CGFloat,
									 backdropCornerRadius: CGFloat,
									 animated: Bool,
									 additionalAnimations parallelAnimations: (() -> Swift.Void)?) {
		// モーダルビューの高さを設定
		setModalViewHeight(self.frontViewController.view.frame.size.height - frontMargin, animated: false)
		
		// 背景ビューの縮小とずれ
		let t = SemiModalPresentationController.backdropTransform(withScale: backdropScale, translates: backdropMargins)
		
		if animated {
			UIView.perform(.delete,
						   on: [],
						   options: .beginFromCurrentState,
						   animations: {
							self.backdropViewController.view.transform = t
							self.backdropViewController.view.layer.cornerRadius = backdropCornerRadius
							self.frontViewController.setNeedsStatusBarAppearanceUpdate()
							parallelAnimations?()
			}, completion: nil)
		}
		else {
			self.backdropViewController.view.transform = t
			self.backdropViewController.view.layer.cornerRadius = backdropCornerRadius
			self.frontViewController.setNeedsStatusBarAppearanceUpdate()
		}
	}
	
	/// 前景ビューを閉じるトランジションを描画
	func performDismissingTransition(withCustomTransfrom customTransfrom: CGAffineTransform?,
									 backdropCornerRadius: CGFloat,
									 animated: Bool,
									 additionalAnimations parallelAnimations: (() -> Swift.Void)?) {
		var t = CGAffineTransform.identity
		if let customTransfrom = customTransfrom {
			t = customTransfrom
		}
		
		if animated {
			UIView.perform(.delete,
						   on: [],
						   options: .beginFromCurrentState,
						   animations: {
							self.backdropViewController.view.transform = t
							self.backdropViewController.view.layer.cornerRadius = backdropCornerRadius
							//self.frontViewController.setNeedsStatusBarAppearanceUpdate()
							parallelAnimations?()
			}, completion: nil)
		}
		else {
			self.backdropViewController.view.transform = t
			self.backdropViewController.view.layer.cornerRadius = backdropCornerRadius
			//self.frontViewController.setNeedsStatusBarAppearanceUpdate()
		}
	}
	
	/// スクロール割合によって背景ビューのスケール・ずれを動的変化させる
	func updateBackdropTransform(withScrollRate scrollRate: CGFloat,
								 backdropScale: CGFloat,
								 backdropScaleLimit: CGFloat,
								 backdropMargins: CGPoint) {
		let scale = max(min(backdropScale - scrollRate, backdropScaleLimit), backdropScale)
		let t = SemiModalPresentationController.backdropTransform(withScale: scale, translates: backdropMargins)
		self.backdropViewController.view.transform = t
	}

}
