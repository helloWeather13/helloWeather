import UIKit
import RAMAnimatedTabBarController

class TabViewModel{
    
    var tabs : [TabModel] = [
        TabModel(title: "검색", image: UIImage(systemName: "magnifyingglass.circle")!,selectedImage:UIImage(systemName: "magnifyingglass.circle.fill")!, vc: SearchViewController()),
        TabModel(title: "홈", image: UIImage(systemName: "location")!,selectedImage: UIImage(systemName: "location.fill")!, vc: HomeViewController()),
        TabModel(title: "알람", image: UIImage(systemName: "alarm")!,selectedImage: UIImage(systemName: "alarm.fill")!, vc: ListViewController()),
        
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
    
    private func createNav(with tab: TabModel) -> UINavigationController{
        tab.vc.view.backgroundColor = .systemBackground
        let nav = UINavigationController(rootViewController: tab.vc)
        let item = RAMAnimatedTabBarItem(title: "", image: tab.image, selectedImage: tab.selectedImage)
        item.animation = CustomBounceAnimation(selectedImage: tab.selectedImage, deSelectedImage: tab.image )
        item.textFontSize = 3
        item.iconColor = .label
        item.playAnimation()
        nav.tabBarItem = item
        nav.viewControllers.first?.navigationItem.title = tab.title
        nav.navigationBar.isTranslucent = true
        return nav
    }
}
