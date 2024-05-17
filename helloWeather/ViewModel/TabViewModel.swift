import UIKit
import RAMAnimatedTabBarController

class TabViewModel{
    
    var tabs : [TabModel] = [
        TabModel(title: "메인", image: UIImage(named: "bookmark_off")!,selectedImage:UIImage(named: "bookmark_on")!, vc: HomeViewController()),
        TabModel(title: "검색", image: UIImage(named: "bookmark_off")!,selectedImage:UIImage(named: "bookmark_on")!, vc: SearchViewController()),
        TabModel(title: "알람", image: UIImage(named: "location_off")!,selectedImage: UIImage(named: "location_on")!, vc: TempListViewController()),
        
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
