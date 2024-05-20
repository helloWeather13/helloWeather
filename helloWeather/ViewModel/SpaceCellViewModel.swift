//
//  File.swift
//  helloWeather
//
//  Created by Seungseop Lee on 5/18/24.
//

import UIKit

class SpaceCellViewModel {
    var alarmText: String
    var alarmTextColor: UIColor
    var alarmTextFont: UIFont
    var alarmTextAlignment: NSTextAlignment

    init(alarmText: String = "비소식이 생기면 알람이 울려요",
         alarmTextColor: UIColor = .gray,
         alarmTextFont: UIFont = UIFont.systemFont(ofSize: 11),
         alarmTextAlignment: NSTextAlignment = .center) {
        self.alarmText = alarmText
        self.alarmTextColor = alarmTextColor
        self.alarmTextFont = alarmTextFont
        self.alarmTextAlignment = alarmTextAlignment
    }
}
