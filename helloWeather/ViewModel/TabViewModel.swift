import UIKit

class TabViewModel{
    
    var tabs : [TabModel] = [
        TabModel(title: "검색", image: UIImage(systemName: "magnifyingglass")!, vc: HomeViewController()),
        TabModel(title: "리스트", image: UIImage(systemName: "basket.fill")!, vc: ListViewController()),
        TabModel(title: "알람", image: UIImage(systemName: "basket.fill")!, vc: AlarmViewController()),
        TabModel(title: "검색", image: UIImage(systemName: "magnifyingglass")!, vc: SearchViewController()),
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
        nav.tabBarItem.title = tab.title
        nav.tabBarItem.image = tab.image
        nav.viewControllers.first?.navigationItem.title = tab.title
        nav.navigationBar.isTranslucent = true
        return nav
    }
}
