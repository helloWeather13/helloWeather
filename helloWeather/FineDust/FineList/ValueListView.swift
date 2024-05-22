//
//  ValueList.swift
//  helloWeather
//
//  Created by 김태담 on 5/17/24.
//
import Foundation
import SwiftUI
import Charts



struct ValueList: View {
    
    @ObservedObject var viewModel: FineListViewModel
    
    var body: some View {
        
        let testvalue = [viewModel.o3, viewModel.no2, viewModel.co, viewModel.so2]
        var test: [Valuetype2] {
            return testvalue.compactMap { value in
                //print(value)
                if let doubleValue = Double(value) {
                    return Valuetype2.from(value: doubleValue)
                }
                return nil
            }
        }
        
        VStack{
            HStack{
                Spacer()
                Text("대기오염 물질")
                    .font(.system(size: 18, weight: .medium))
                
                ForEach(0..<8){ _ in
                    Spacer()
                }
            }
            .padding(.bottom, 20)
            ZStack{
                HStack{
                    Spacer()
                    VStack(alignment: .leading){
                        Text("오존")
                        HStack{
                            Text(test[0].rawValue)
                                .foregroundColor(test[0].color)
                            Text(testvalue[0] + "ppm")
                                .foregroundColor(test[0].color)
                        }
                    }
                    ForEach(0..<14){ _ in
                        Spacer()
                    }
                }
                HStack{
                    ForEach(0..<5){ _ in
                        Spacer()
                    }
                    VStack(alignment: .leading){
                        Text("이산화질소")
                        HStack{
                            Text(test[1].rawValue)
                                .foregroundColor(test[1].color)
                            Text(testvalue[1] + "ppm")
                                .foregroundColor(test[1].color)
                        }
                    }
                    Spacer()
                }
            }
            ZStack{
                HStack{
                    Spacer()
                    VStack(alignment: .leading){
                        Text("일산화탄소")
                        HStack{
                            Text(test[2].rawValue)
                                .foregroundColor(test[2].color)
                            Text(testvalue[2] + "ppm")
                                .foregroundColor(test[2].color)
                        }
                    }
                    ForEach(0..<14){ _ in
                        Spacer()
                    }
                }
                HStack{
                    ForEach(0..<5){ _ in
                        Spacer()
                    }
                    VStack(alignment: .leading){
                        Text("아황산가스")
                        HStack{
                            Text(test[3].rawValue)
                                .foregroundColor(test[3].color)
                            Text(testvalue[3] + "ppm")
                                .foregroundColor(test[3].color)
                        }
                    }
                    Spacer()
                }
            }
        }
        .onAppear {
            viewModel.fineListTrigger.onNext(())
        }
    }
}

