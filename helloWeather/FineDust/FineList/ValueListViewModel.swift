//
//  ValueListViewModel.swift
//  helloWeather
//
//  Created by 김태담 on 5/17/24.
//
import Foundation
import SwiftUI
import Combine

class ValueListViewModel: ObservableObject {
    @Published var forecasts: [Forecastday] = []
    @Published var airQualityInfo: [String] = []
    
    func loadData() {
        let searchModel = SearchModel(
            keyWord: "Seoul",
            fullAddress: "Seoul, South Korea",
            lat: 37.5665,
            lon: 126.9780,
            city: "Seoul"
        )
        WebServiceManager.shared.getForecastWeather(searchModel: searchModel) { [weak self] weatherAPIModel in
            DispatchQueue.main.async {
                self?.forecasts = Array(weatherAPIModel.forecast.forecastday.prefix(5))
                self?.airQualityInfo = self?.forecasts.compactMap { forecast in
                    if let airQuality = forecast.day.airQuality {
                        let micro = airQuality.micro ?? 0.0
                        let fine = airQuality.fine ?? 0.0
                        return "PM10: \(micro) µg/m³, PM2.5: \(fine) µg/m³"
                    }
                    return "Air quality data not available"
                } ?? []
            }
        }
    }
}
