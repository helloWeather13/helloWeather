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
        let standard = UITabBarAppearance()
        standard.backgroundColor = UIColor(red: 0.988, green: 0.988, blue: 0.992, alpha: 1)
        self.tabBar.standardAppearance = standard
        self.tabBar.scrollEdgeAppearance = standard
        self.tabBar.layer.addBorder([.top], color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.05), width: 1)
        
    }
    
    @objc func switchToMainTab() {
        self.selectedIndex = 0
        self.tabViewModel.firstTab.playAnimation()
        self.tabViewModel.secondTab.deselectedState()
    }
    
    func deleteRecentSearch(){
        UserDefaults.standard.removeObject(forKey: "bookMark")
    }
    
}


