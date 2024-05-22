import SwiftUI

struct FineListView: View {
    @ObservedObject var viewModel: FineListViewModel
    @SwiftUI.State private var isToggleOn = false
    
    var titleFontSize = 19
    let day1 = Date()
    let day2: Date? = Calendar.current.date(byAdding: .day, value: 1, to: Date())
    let day3: Date? = Calendar.current.date(byAdding: .day, value: 2, to: Date())
    let day4: Date? = Calendar.current.date(byAdding: .day, value: 3, to: Date())
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("주간 미세먼지")
                    .font(.system(size: CGFloat(titleFontSize), weight: .medium))
                //.font(.custom("Pretendard", size: titleFontSize))
                    .padding(.leading, 22)
                    .padding(.top, 16)
                ForEach(0..<10) { _ in
                    Spacer()
                }
                Toggle("", isOn: $isToggleOn)
                    .toggleStyle(CustomToggleStyle(viewModel: viewModel))
                    .opacity(0.7)
                    .padding(.trailing, 8)
                    .padding(.top, 16)
            }
            HStack {
                Spacer()
                VStack {
                    Text("오늘")
                        .foregroundColor(isWeekend(date: day1) ? .red : .black)
                        .font(.system(size: 11, weight: .medium))
                        //.opacity(isWeekend(date: day1) ? 1 : 0.8)
                    Text(createTimeFormatter().string(from: day1))
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(isWeekend(date: day1) ? .red : .black)
                        //.opacity(isWeekend(date: day1) ? 1 : 0.8)
                        .padding(.bottom, 2)
                    viewModel.faceType1.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: CGFloat(titleFontSize * 2), height: CGFloat(titleFontSize * 2))
                    Text(viewModel.faceType1.rawValue)
                        .font(.system(size: 11, weight: .medium))
                        //.foregroundColor(viewModel.faceType1.color)
                }
                Spacer()
                VStack {
                    Text(formattedDateWithWeekdays(date: day2!))
                        .foregroundColor(isWeekend(date: day2!) ? .red : .black)
                        .font(.system(size: 11, weight: .medium))
                        .opacity(isWeekend(date: day2!) ? 1 : 0.7)
                    Text(createTimeFormatter().string(from: day2!))
                        .foregroundColor(isWeekend(date: day2!) ? .red : .black)
                        .font(.system(size: 11, weight: .medium))
                        .opacity(isWeekend(date: day2!) ? 1 : 0.7)
                        .padding(.bottom, 2)
                    viewModel.faceType2.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: CGFloat(titleFontSize * 2), height: CGFloat(titleFontSize * 2))
                    Text(viewModel.faceType2.rawValue)
                        .font(.system(size: 11, weight: .medium))
                        .opacity(0.7)
                        //.foregroundColor(viewModel.faceType2.color)
                }
                Spacer()
                VStack {
                    Text(formattedDateWithWeekdays(date: day3!))
                        .foregroundColor(isWeekend(date: day3!) ? .red : .black)
                        .font(.system(size: 11, weight: .medium))
                        .opacity(isWeekend(date: day3!) ? 1 : 0.7)
                    Text(createTimeFormatter().string(from: day3!))
                        .font(.system(size: 11, weight: .medium))
                        .opacity(isWeekend(date: day3!) ? 1 : 0.7)
                        .foregroundColor(isWeekend(date: day3!) ? .red : .black)
                        .padding(.bottom, 2)
                    viewModel.faceType3.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: CGFloat(titleFontSize * 2), height: CGFloat(titleFontSize * 2))
                    Text(viewModel.faceType3.rawValue)
                        .font(.system(size: 11, weight: .medium))
                        .opacity(0.7)
                        //.opacity(isWeekend(date: day3!) ? 1 : 0.7)
                        //.foregroundColor(viewModel.faceType3.color)
                }
                Spacer()
                VStack {
                    Text(formattedDateWithWeekdays(date: day4!))
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(isWeekend(date: day4!) ? .red : .black)
                        .opacity(isWeekend(date: day4!) ? 1 : 0.7)
                    Text(createTimeFormatter().string(from: day4!))
                        .font(.system(size: 11, weight: .medium))
                        .opacity(isWeekend(date: day4!) ? 1 : 0.7)
                        .foregroundColor(isWeekend(date: day4!) ? .red : .black)
                        .padding(.bottom, 2)
                    viewModel.faceType4.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: CGFloat(titleFontSize * 2), height: CGFloat(titleFontSize * 2))
                    Text(viewModel.faceType4.rawValue)
                        .font(.system(size: 11, weight: .medium))
                        .opacity(0.7)
                        //.opacity(isWeekend(date: day4!) ? 1 : 0.7)
                        //.foregroundColor(viewModel.faceType4.color)
                }
                Spacer()
            }

        }
        .onAppear {
            viewModel.fineListTrigger.onNext(())
        }
        //.padding(.top)
        .padding(.bottom, 50)
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
                    .opacity(0.4)
                    .cornerRadius(10)
                Rectangle()
                    .cornerRadius(6)
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


