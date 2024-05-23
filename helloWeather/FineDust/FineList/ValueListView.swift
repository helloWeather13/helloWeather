import Foundation
import SwiftUI
import Charts



struct ValueList: View {
    
    @ObservedObject var viewModel: FineListViewModel
    @SwiftUI.State private var isToggleOn = false
    
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
        
        func formatToFourDigits(_ number: Double) -> String {
                let intPart = Int(abs(number))
                let intDigitsCount = String(intPart).count
                let maxFractionDigits = max(0, 4 - intDigitsCount)
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                formatter.maximumFractionDigits = maxFractionDigits
                formatter.minimumFractionDigits = 0
                if let formattedNumber = formatter.string(from: NSNumber(value: number)) {
                    return formattedNumber
                } else {
                    return String(number)
                }
            }
        
        return VStack{
            HStack{
                Spacer()
                Text("대기오염물질")
                    .font(.custom("Pretendard-Regular", size: 19))
                //.font(.custom("Pretendard", size: titleFontSize))
                    .padding(.leading, 22)
                //.padding(.top, )
                ForEach(0..<8){ _ in
                    Spacer()
                }
                Toggle("", isOn: $isToggleOn)
                    .toggleStyle(CustomToggleStyle(viewModel: viewModel))
                    .padding(.trailing, 8)
                //.padding(.top, 16)
                    .opacity(0)
                    .disabled(true)
            }
            ZStack{
                HStack{
                    VStack(alignment: .leading){
                        Text("오존")
                            .font(.custom("Pretendard-Regular", size: 15))
                            .padding(.bottom, 0.5)
                        HStack{
                            Text(test[0].rawValue)
                                .foregroundColor(test[0].color)
                                .font(.custom("Pretendard-Regular", size: 15))
                            Text(formatToFourDigits(Double(testvalue[0])!) + "ppm")
                                .foregroundColor(test[0].color)
                                .font(.custom("Pretendard-Regular", size: 15))
                        }
                    }
                   Spacer()
                }
                .padding(.leading ,40)
                HStack{
                    VStack(alignment: .leading){
                        Text("이산화질소")
                            .font(.custom("Pretendard-Regular", size: 15))
                            .padding(.bottom, 0.5)
                        HStack{
                            Text(test[1].rawValue)
                                .foregroundColor(test[1].color)
                                .font(.custom("Pretendard-Regular", size: 15))
                            Text(formatToFourDigits(Double(testvalue[1])!) + "ppm")
                                .foregroundColor(test[1].color)
                                .font(.custom("Pretendard-Regular", size: 15))
                        }
                    }
                    Spacer()
                }
                .padding(.leading ,220)
            }
            .padding(.bottom, 20)
            ZStack{
                HStack{
                    VStack(alignment: .leading){
                        Text("일산화탄소")
                            .font(.custom("Pretendard-Regular", size: 15))
                            .padding(.bottom, 0.5)
                        HStack{
                            Text(test[2].rawValue)
                                .foregroundColor(test[2].color)
                                .font(.custom("Pretendard-Regular", size: 15))
                            Text(formatToFourDigits(Double(testvalue[2])!) + "ppm")
                                .foregroundColor(test[2].color)
                            .font(.custom("Pretendard-Regular", size: 15))                        }
                    }
                   Spacer()
                }
                .padding(.leading ,40)
                HStack{
                    VStack(alignment: .leading){
                        Text("아황산가스")
                            .font(.custom("Pretendard-Regular", size: 15))
                            .padding(.bottom, 0.5)
                        HStack{
                            Text(test[3].rawValue)
                                .foregroundColor(test[3].color)
                                .font(.custom("Pretendard-Regular", size: 15))
                            Text(formatToFourDigits(Double(testvalue[1])!) + "ppm")
                                .foregroundColor(test[3].color)
                                .font(.custom("Pretendard-Regular", size: 15))
                        }
                    }
                    Spacer()
                }
                .padding(.leading ,220)
            }
            Spacer()
        }
        .onAppear {
            viewModel.fineListTrigger.onNext(())
        }
    }
}
