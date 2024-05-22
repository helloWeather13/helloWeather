//
//  FineDustView.swift
//  helloWeather
//
//  Created by 김태담 on 5/14/24.
//

import Foundation
import SwiftUI
import Charts

struct ScrollChartView: View {

    var body: some View {
        ScrollView {
            LineChartView()
                .frame(height: 1100)
        }
    }
}

#Preview {
    VStack {
        ScrollChartView()
    }
}

