//
//  LaunchScreen.swift
//  helloWeather
//
//  Created by CaliaPark on 5/20/24.
//

import UIKit
import Lottie

class LaunchViewController: UIViewController {
    
    let animationView: LottieAnimationView = {
        let lottieAnimationView = LottieAnimationView(name: "Launch")
        return lottieAnimationView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLaunchScreen()
    }
    
    func setupLaunchScreen() {
        view.addSubview(animationView)

        animationView.frame = view.bounds
        animationView.center = view.center
        animationView.alpha = 1

        animationView.play { _ in
          UIView.animate(withDuration: 0.3, animations: {
            self.animationView.alpha = 0
          }, completion: { _ in
            self.animationView.isHidden = true
            self.animationView.removeFromSuperview()
              
            guard let vc = TabViewController() as? UIViewController else { return }
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
          })
        }
    }
}
