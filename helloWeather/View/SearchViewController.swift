//
//  SearchViewController.swift
//  helloWeather
//
//  Created by Sam.Lee on 5/13/24.
//

import UIKit

class SearchViewController: UIViewController {
    var searchViewModel = SearchViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchViewModel.getResult(apiModel : searchViewModel.kakaoAddress, expecting: KakaoAddressModel.self)
    }
    

}
