//
//  TabViewController.swift
//  helloWeather
//
//  Created by 김태담 on 5/21/24.
//

import Tabman
import Pageboy
import UIKit
import SwiftUI

class TabViewController2: TabmanViewController {

    private var viewControllers = [WeatherDetailViewController(), UIHostingController(rootView: ScrollChartView()) ]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self

        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap // Customize
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        bar.layout.interButtonSpacing = 0
        bar.layout.alignment = .centerDistributed
        bar.layout.contentMode = .fit
        //bar.layout.
        bar.indicator.tintColor = .black

        
        bar.buttons.customize { (button) in
            button.tintColor = .gray
            button.selectedTintColor = .black
        }

        addBar(bar, dataSource: self, at: .top)
    }
}

extension TabViewController2: PageboyViewControllerDataSource, TMBarDataSource {

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }

    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0 :
            let title = "날씨"
            return TMBarItem(title: title)
        case 1 :
            let title = "미세 먼지"
            return TMBarItem(title: title)
        default:
            return TMBarItem(title: "")
        }
    }
}
