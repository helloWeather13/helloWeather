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
