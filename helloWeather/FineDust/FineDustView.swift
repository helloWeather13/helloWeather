import Foundation
import SwiftUI
import Charts

struct ScrollChartView: View {

    let homeViewModel: HomeViewModel
    
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
    }

    var body: some View {
        ScrollView {
            LineChartView(homeViewModel: homeViewModel)
                .frame(height: 1100)
        }
    }
}
