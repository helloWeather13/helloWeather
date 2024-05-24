import UIKit
import SwiftUI
import RAMAnimatedTabBarController

class TabViewModel{
    var firstTab = RAMAnimatedTabBarItem()
    var secondTab = RAMAnimatedTabBarItem()
    
    let homeViewModel = HomeViewModel()
      
      
    
    var tabs : [TabModel] = [
        TabModel(title: "메인", image: UIImage(named: "tabBar01-0")!,selectedImage:UIImage(named: "tabBar01-1")!, vc: MainViewController()),
        TabModel(title: "알람", image: UIImage(named: "tabBar02-0")!,selectedImage: UIImage(named: "tabBar02-1")!, vc: TempListViewController()),
    ]
    var navs : [UINavigationController] = []
    
    init(){
        setupTabs()
    }
    
    private func setupTabs(){
        tabs.forEach{
            navs.append(self.createNav(with: $0))
        }
    }
    
   
    
    private func createNav(with tab: TabModel) -> UINavigationController {
        tab.vc.view.backgroundColor = UIColor(red: 0.988, green: 0.988, blue: 0.992, alpha: 1)
        let nav = UINavigationController(rootViewController: tab.vc)
        if tab.title == "메인"{
            firstTab = RAMAnimatedTabBarItem(title: "", image: tab.image, selectedImage: tab.selectedImage)
            firstTab.animation = CustomBounceAnimation(selectedImage: tab.selectedImage, deSelectedImage: tab.image)
            firstTab.iconColor = .label
            firstTab.textColor = .label
            firstTab.textFontSize = 5
            nav.tabBarItem = firstTab
        }else if tab.title == "알람"{
            secondTab = RAMAnimatedTabBarItem(title: "", image: tab.image, selectedImage: tab.selectedImage)
            secondTab.animation = CustomBounceAnimation(selectedImage: tab.selectedImage, deSelectedImage: tab.image)
            secondTab.iconColor = .label
            secondTab.textColor = .label
            secondTab.textFontSize = 5
            nav.tabBarItem = secondTab
        }else{
            let tabItem = RAMAnimatedTabBarItem(title: "", image: tab.image, selectedImage: tab.selectedImage)
            tabItem.animation = CustomBounceAnimation(selectedImage: tab.selectedImage, deSelectedImage: tab.image)
            tabItem.iconColor = .label
            tabItem.textColor = .label
            tabItem.textFontSize = 5
            nav.tabBarItem = tabItem
        }
        
        
        nav.tabBarItem.title = nil
//        nav.viewControllers.first?.navigationItem.title = tab.title
        return nav
    }

}
