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
//        self.tabBar.isTranslucent = false
//        self.tabBar.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.01)
//        self.tabBar.isOpaque = true
//        
//        let appearance = UITabBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
//        tabBar.standardAppearance = appearance
//        tabBar.scrollEdgeAppearance = appearance
    }
    
    
    
    func deleteRecentSearch(){
        //        recentSearch.removeAll()
        UserDefaults.standard.removeObject(forKey: "recentSearch")
        //        self.applySnapshot()
    }
    
}
