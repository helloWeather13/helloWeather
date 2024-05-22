//
//  TSBlurEffectView.swift
//  MazeLogics
//
//  Created by Tallha Sarwar on 20/05/2021.
//  Copyright © 2021 Finja Pvt Limited. All rights reserved.
//

import UIKit

// https://github.com/tallhasarwar/TSBlurEffectView/blob/main/TSBlurEffectView.swift 참고
class TSBlurEffectView: UIVisualEffectView {
    
    var animator = UIViewPropertyAnimator(duration: 1, curve: .linear)
    
    var intensity = 1.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        frame = superview?.bounds ?? CGRect.zero
        setupBlur()
    }
    
    override func didMoveToSuperview() {
        guard superview != nil else { return }
        backgroundColor = .clear
        setupBlur()
    }
    
    private func setupBlur() {
        animator.stopAnimation(true)
        effect = nil

        animator.addAnimations { [weak self] in
            self?.effect = UIBlurEffect(style: .light)
        }
        
        if intensity > 0 && intensity <= 10 {
            
            let value = CGFloat(intensity)/10
            animator.fractionComplete = value
            
        }
        else {
            animator.fractionComplete = 0.05
        }
        
    }
    
    deinit {
        animator.stopAnimation(true)
    }
}
