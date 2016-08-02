//
//  FlipPresentAnimationController.swift
//  suracare
//
//  Created by hoi on 7/29/16.
//  Copyright © 2016 Sugar Rain. All rights reserved.
//

import Foundation
import UIKit

class FlipPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var originFrame: CGRect = CGRectZero
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 2.0
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewKey),
            let containerView = transitionContext.containerView(),
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewKey) else {
                return
        }
        
        let initialFrame = originFrame
        let finalFrame = transitionContext.finalFrameForViewController(toVC)
        
        let snapshot = toVC.view.snapshotViewAfterScreenUpdates(true)
        snapshot.frame = initialFrame
        snapshot.layer.cornerRadius = 20
        snapshot.layer.masksToBounds = true
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        toVC.view.hidden = true
    }
    
}