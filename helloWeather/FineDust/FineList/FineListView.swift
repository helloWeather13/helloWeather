import SwiftUI

struct FineListView: View {
    @ObservedObject var viewModel: FineListViewModel
    @SwiftUI.State private var isToggleOn = false
    
    var titleFontSize = 18
    let day1 = Date()
    let day2: Date? = Calendar.current.date(byAdding: .day, value: 1, to: Date())
    let day3: Date? = Calendar.current.date(byAdding: .day, value: 2, to: Date())
    let day4: Date? = Calendar.current.date(byAdding: .day, value: 3, to: Date())
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("주간 미세먼지")
                    .font(.system(size: CGFloat(titleFontSize), weight: .bold))
                ForEach(0..<10) { _ in
                    Spacer()
                }
                Toggle("", isOn: $isToggleOn)
                    .toggleStyle(CustomToggleStyle(viewModel: viewModel))
                    .opacity(0.7)
            }
            
            HStack {
                Spacer()
                VStack {
                    Text(formattedDateWithWeekdays(date: day1))
                        .foregroundColor(isWeekend(date: day1) ? .red : .black)
                    Text(createTimeFormatter().string(from: day1))
                    viewModel.faceType1.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: CGFloat(titleFontSize * 2), height: CGFloat(titleFontSize * 2))
                }
                Spacer()
                VStack {
                    Text(formattedDateWithWeekdays(date: day2!))
                        .foregroundColor(isWeekend(date: day2!) ? .red : .black)
                    Text(createTimeFormatter().string(from: day2!))
                    viewModel.faceType2.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: CGFloat(titleFontSize * 2), height: CGFloat(titleFontSize * 2))
                }
                Spacer()
                VStack {
                    Text(formattedDateWithWeekdays(date: day3!))
                        .foregroundColor(isWeekend(date: day3!) ? .red : .black)
                    Text(createTimeFormatter().string(from: day3!))
                    viewModel.faceType3.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: CGFloat(titleFontSize * 2), height: CGFloat(titleFontSize * 2))
                }
                Spacer()
                VStack {
                    Text(formattedDateWithWeekdays(date: day4!))
                        .foregroundColor(isWeekend(date: day4!) ? .red : .black)
                    Text(createTimeFormatter().string(from: day4!))
                    viewModel.faceType4.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: CGFloat(titleFontSize * 2), height: CGFloat(titleFontSize * 2))
                }
                Spacer()
            }

        }
        .onAppear {
            viewModel.fineListTrigger.onNext(())
        }
    }
}

struct CustomToggleStyle: ToggleStyle {
    @ObservedObject var viewModel: FineListViewModel
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            ZStack {
                Rectangle()
                    .frame(width: 90, height: 30)
                    .foregroundColor(.gray)
                    .cornerRadius(8)
                Rectangle()
                    .cornerRadius(4)
                    .frame(width: 42, height: 24)
                    .foregroundColor(.white)
                    .padding()
                    .offset(x: configuration.isOn ? 20 : -20)
                    .animation(.easeInOut(duration: 0.1), value: configuration.isOn)
                HStack {
                    Text("미세")
                        .foregroundColor(configuration.isOn ? .white : .black)
                        .font(.system(size: 12, weight: .bold))
                        .padding(.leading, 14)
                    
                    Spacer()
                    
                    Text("초미세")
                        .foregroundColor(configuration.isOn ? .black : .white)
                        .font(.system(size: 12, weight: .bold))
                        .padding(.trailing, 8)
                }
                .frame(width: 90, height: 30)
            }
            .onTapGesture {
                configuration.isOn.toggle()
                viewModel.changeToggle()
            }
        }
        .padding()
    }
}



