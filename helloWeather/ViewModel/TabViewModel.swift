import UIKit
import SwiftUI
import RAMAnimatedTabBarController

class TabViewModel{
    
    var tabs : [TabModel] = [
        TabModel(title: "메인", image: UIImage(named: "tabBar01-0")!,selectedImage:UIImage(named: "tabBar01-0")!, vc: HomeViewController()),
        TabModel(title: "검색", image: UIImage(named: "tabBar01-0")!,selectedImage:UIImage(named: "tabBar01-0")!, vc: SearchViewController()),
        TabModel(title: "알람", image: UIImage(named: "tabBar01-0")!,selectedImage: UIImage(named: "tabBar01-0")!, vc: TempListViewController()),
        TabModel(title: "날씨", image: UIImage(named: "tabBar01-0")!,selectedImage: UIImage(named: "tabBar01-0")!, vc: WeatherDetailViewController()),
        TabModel(title: "미세먼지", image: UIImage(named: "tabBar01-0")!,selectedImage: UIImage(named: "tabBar01-0")!, vc: UIHostingController(rootView: LineChartView())),
        
        
        
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
        tab.vc.view.backgroundColor = .systemBackground
        let nav = UINavigationController(rootViewController: tab.vc)
        let item = RAMAnimatedTabBarItem(title: "", image: tab.image, selectedImage: tab.selectedImage)
        item.animation = CustomBounceAnimation(selectedImage: tab.selectedImage, deSelectedImage: tab.image)
        item.iconColor = .label
        item.textColor = .label
        item.textFontSize = 5
        nav.tabBarItem = item
        nav.tabBarItem.title = nil
//        nav.viewControllers.first?.navigationItem.title = tab.title
        nav.navigationBar.isTranslucent = true
        return nav
    }

}
