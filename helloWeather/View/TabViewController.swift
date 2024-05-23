//
//  TabViewController.swift
//  helloWeather
//
//  Created by Sam.Lee on 5/13/24.
//

import UIKit
import RAMAnimatedTabBarController

class TabViewController: RAMAnimatedTabBarController  {
    
    
    let tabViewModel = TabViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        NotificationCenter.default.addObserver(self, selector: #selector(switchToMainTab), name: NSNotification.Name("SwitchTabNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(switchToMainTab), name: NSNotification.Name("SwitchTabNotificationCurrent"), object: nil)
        //        deleteRecentSearch()
    }
    
    func configure(){
        self.setViewControllers(tabViewModel.navs, animated: true)
        guard let items = tabBar.items as? [RAMAnimatedTabBarItem] else { return }
        items.forEach{
            let oldCenter = $0.iconView!.icon.frame.origin.x
            $0.iconView!.icon.frame = CGRect(x: $0.iconView!.icon.frame.origin.x, y: $0.iconView!.icon.frame.origin.y + 14, width: 24, height: 40)
            $0.iconView!.icon.frame.origin.x = oldCenter
        }
        self.tabBar.configureMaterialBackground()
    }
    
    @objc func switchToMainTab() {
        self.selectedIndex = 0
        self.tabViewModel.firstTab.playAnimation()
        self.tabViewModel.secondTab.deselectedState()
    }
    
    func deleteRecentSearch(){
        UserDefaults.standard.removeObject(forKey: "recentSearch")
    }
    
}
