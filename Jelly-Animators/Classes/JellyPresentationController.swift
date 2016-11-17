//
//  JellyPresentationController.swift
//  Created by Sebastian Boldt on 17.11.16.

import UIKit

class JellyPresentationController : UIPresentationController {
    
    private var presentation: JellyPresentation
    fileprivate var dimmingView: UIView! // The PresentationController manages the dimmingView
    
    init(presentedViewController: UIViewController, presentingViewController: UIViewController?, presentation: JellyPresentation) {
        
        presentedViewController.view.layer.masksToBounds = true
        presentedViewController.view.layer.cornerRadius = CGFloat(presentation.cornerRadius)
        
        self.presentation = presentation
        super.init(presentedViewController: presentedViewController,
                   presenting: presentingViewController)
        self.setupDimmingView()
    }
    
    /// Presentation and Dismissal stuff
    override func presentationTransitionWillBegin() {
        
        containerView?.insertSubview(dimmingView, at: 0)
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimmingView]|",
                                           options: [], metrics: nil, views: ["dimmingView": dimmingView]))
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[dimmingView]|",
                                           options: [], metrics: nil, views: ["dimmingView": dimmingView]))
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func size(forChildContentContainer container: UIContentContainer,
                       withParentContainerSize parentSize: CGSize) -> CGSize {
        return self.presentation.sizeForPresentedVC
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController,
                          withParentContainerSize: containerView!.bounds.size)
        
        if (frame.size.height > (containerView?.frame.size.height)!) {
            print("JELLY_ANIMATORS: Height for presentedViewController is to high")
            frame.size.height = (containerView?.frame.size.height)!
            print("JELLY_ANIMATORS: Resizing to \(frame.size.height)")
        }
        
        if (frame.size.width > (containerView?.frame.size.width)!) {
            print("JELLY_ANIMATORS: Width for presentedViewController is to wide")
            frame.size.width = (containerView?.frame.size.width)!
            print("JELLY_ANIMATORS: Resizing to \(frame.size.width)")
        }
        
        frame.origin.x = (containerView!.frame.size.width/2)-(frame.size.width/2)
        frame.origin.y = (containerView!.frame.size.height/2)-(frame.size.height/2)
        return frame
    }
}

fileprivate extension JellyPresentationController {
    
    func setupDimmingView() {
        dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.alpha = 0.0
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        dimmingView.addGestureRecognizer(recognizer)
    }
    
    dynamic func handleTap(recognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true)
    }
}