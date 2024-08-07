# HelloWeather
![Static Badge](https://img.shields.io/badge/Swift-F05138?style=flat-square&logo=Swift&logoColor=white)
---
## 설명 :

날씨 어플

---
## 실제 작동화면  
|![simulator_screenshot_577F9678-C4F0-4EE9-9328-484AB6DF37CA](https://github.com/sam98528/Swift_Assignment/assets/12388297/e921867e-a9dd-4377-9e29-996fe5c95f5f)|![simulator_screenshot_62370FD7-11D9-4F9D-9D84-9764184E982A](https://github.com/sam98528/Swift_Assignment/assets/12388297/3d6905e7-64ed-4575-ad5d-e9bf07e02043)|![simulator_screenshot_B37B7D10-A4C3-41EB-8C83-3D1F69A6CBA9](https://github.com/sam98528/Swift_Assignment/assets/12388297/a898ac3b-167c-4eb0-b4f8-6be3fe3a60df)|![simulator_screenshot_643B9CCD-DCCF-4625-957B-347749BE122E](https://github.com/sam98528/Swift_Assignment/assets/12388297/c9fff66b-a6fa-404e-9ff1-05f18fb0d5c5)|
|---|---|---|---|
---

### MVVM 정의
![Group 21039](https://github.com/sam98528/Swift_Assignment/assets/12388297/b19dddb9-a7c5-4e2f-98f0-a6ffd99f9d16)

### 개발 기능 정리:
---
#### 사용한 API, 라이브러리, SDK, 프레임워크 등
- [WeatherAPI](https://www.weatherapi.com/docs/)
- [카카오 주소 검색 API](https://developers.kakao.com/docs/latest/ko/local/dev-guide#address-coord)
- [SnapKit](https://github.com/SnapKit/SnapKit) (5.7.1)
- [Alamofire](https://github.com/Alamofire/Alamofire) (5.9.1)
- [DGChart](https://github.com/ChartsOrg/Charts) (5.1.0)
- [Lottie](https://github.com/airbnb/lottie-ios) (4.4.3)
- [Rxswift](https://github.com/ReactiveX/RxSwift) (6.7.1)
- [Pageboy](https://github.com/uias/Pageboy) (4.2.0)
- [RAMAnimatedTabBarController](https://github.com/Ramotion/animated-tab-bar) (5.2.0)
- [Tabman](https://github.com/uias/Tabman) (3.2.0)
- [SkeletonView](https://github.com/Juanpe/SkeletonView) (1.31.0)

### Feature
---
- MainViewController
- SearchViewController
- ListViewController
- WeatherDetailViewController
- FineDustView

#### HomeViewController
----
HomeViewController는 사용자 위치 정보를 받아와 위치 기반 날씨 정보를 보여줍니다. 또한 검색 및 즐겨찾기 기능을 제공합니다.
#### 기능
- 사용자 위치 정보: CoreLocation을 이용하여 사용자의 현재 위치정보(위도, 경도, 지역명)를 가져옵니다.
- 날씨 정보: Weather API를 사용하여 사용자 위치 혹은 검색 위치의 현재 날씨 정보를 가져옵니다.
- 새로고침: 화면을 아래로 당겨 현재 시간의 날씨 정보로 업데이트 할 수 있습니다.
- 즐겨찾기: 해당 지역을 즐겨찾기 하면 UserDefaults에 저장되어 나의 관심 지역 목록에 추가됩니다.

#### SearchViewController
----
 SearchViewController는 사용자가 정확한 주소를 손쉽게 검색할 수 있도록 설계되었습니다. 카카오 주소 검색 API를 활용하여 정확한 이름과 좌표를 받아옵니다. 또한, 최근 검색 기록을 UserDefaults에 저장하여 사용자에게 이전 검색 기록을 보여줍니다. 검색 결과를 클릭하면 해당 주소의 날씨 정보를 MainViewController에서 확인할 수 있습니다.
##### 기능
- 정확한 주소 검색: 카카오 주소 검색 API를 사용하여 정확한 주소명과 좌표를 가져옵니다.
- 연관 검색: 카카오 주소 검색 API를 사용하여 쿼리에 해당하는 주소명들을 가져옵니다. 
- 최근 검색 기록: UserDefaults를 활용하여 최근 검색 기록을 저장하고, 사용자에게 표시합니다.
- 
#### FineDustView
---
- `@ObservedObject var data: ChartData: ChartData` 객체의 변화를 감시합니다.
- `title, legend, style, darkModeStyle, valueSpecifier, legendSpecifier`: 차트를 커스터마이징하기 위한 속성들입니다.
- `@Binding public var ...`: 다른 뷰와 상태를 공유하기 위한 바인딩입니다.
- `@Environment(\.colorScheme) var colorScheme`: 현재 컬러 스킴(라이트/다크 모드)을 추적합니다.
- `@State private var ...`: 내부 상태 속성입니다

```swift
public struct ChartView2: View {
    @ObservedObject var data: ChartData
    public var title: String?
    public var legend: String?
    public var style: ChartStyle2
    public var darkModeStyle: ChartStyle2
    public var valueSpecifier: String
    public var legendSpecifier: String
    @Binding public var move: CGFloat
    @Binding public var widthmove: CGPoint
    @Binding public var currentDataNumber: Double
    @Binding public var dragLocation: CGPoint
    @Binding public var colorline: Gradient

    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State private var showLegend = false
    @State public var indicatorLocation: CGPoint = .zero
    @State public var closestPoint: CGPoint = .zero
    @State public var opacity: Double = 0
    @State public var hideHorizontalLines: Bool = false
```
- 다양한 속성을 통해 차트를 커스터마이징할 수 있으며, 바인딩을 통해 다른 뷰와 상태를 공유합니다.
- updateDragLocationY 함수는 사용자 상호작용에 따라 드래그 위치를 조정하고 표시되는 데이터를 업데이트합니다.
```swift
public var body: some View {
    GeometryReader { geometry in
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                GeometryReader { reader in
                    MagnifierRect(currentNumber: self.$currentDataNumber, valueSpecifier: self.valueSpecifier)
                        .opacity(self.opacity)
                        .offset(x: self.dragLocation.x - geometry.frame(in: .local).size.width/2, y: 36)
                    Rectangle()
                        .foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.backgroundColor : self.style.backgroundColor)
                    if self.showLegend { /* legend view */ }
                    Line3(data: self.data,
                          frame: .constant(CGRect(x: 0, y: 0, width: reader.frame(in: .local).width - 30, height: reader.frame(in: .local).height + 25)),
                          currentNumber: self.$currentDataNumber,
                          touchLocation: self.$indicatorLocation,
                          dragLocation: self.$dragLocation,
                          showIndicator: self.$hideHorizontalLines,
                          minDataValue: .constant(nil),
                          maxDataValue: .constant(nil),
                          showBackground: false,
                          gradient: self.style.gradientColor,
                          colorline: self.$colorline
                    )
                    .offset(x: 30, y: 0)
                    .onAppear { self.showLegend = true }
                    .onDisappear { self.showLegend = false }
                    .onChange(of: dragLocation) { newLocation in
                        self.updateDragLocationY(geometry: reader.frame(in: .local))
                    }
                }
                .frame(width: geometry.frame(in: .local).size.width, height: 180)
                .offset(x: 0, y: 40)
            }
            .frame(width: geometry.frame(in: .local).size.width, height: 240)
        }
    }
}
```

#### WeatherDetailView
---

**클로저와 RxSwift 사용한 뷰모델과 컬렉션뷰 연결**  </br>
API 호출을 담당하는 WebServiceManager에서 클로저를 사용해 비동기 작업을 처리하고 있는데, 이 작업 결과를 WeatherDetailViewModel에서 RXSwift를 활용해 사용했습니다.

</br>

- **RxSwift** </br>
Observable과 Observer를 활용해 데이터를 전달하고 바인딩해주었습니다.
Observable과 동시에 Observer의 역할을 수행하는 BehaviorSubject를 활용해 데이터를 전달하고 바인딩해주었습니다.
- **클로저** </br>
WebServiceManager에서 API 호출 시 클로저를 사용하여 비동기 작업의 결과를 처리하고, 이를 뷰모델의 함수에서 Observable로 변환했습니다.

</br>

- **WeatherDetailViewModel** </br>
날씨 데이터를 가져오고 온도 단위를 변경하는 로직을 만들었습니다. </br>
Observable.create로 Observable을 생성해 구독자(subscribe)에게 데이터를 전달해줄 수 있도록 했습니다. </br>
BehaviorSubject를 생성해 구독자(subscribe)에게 데이터를 전달해줄 수 있도록 했습니다.

- **WeatherDetailViewModel 사용 뷰** </br>
날씨 상세 정보 데이터가 필요한 다양한 뷰에서 뷰모델을 바인딩해 사용해주었습니다. </br>
TodayTimeCelsiusCollectionView, TomorrowTimeCelsiusCollectionView, TodayTimeWeatherCollectionView, TomorrowTimeWeatherCollectionView, WeekCollectionView, HumidityCollectionView

- **TodayTimeCelsiusCollectionView** </br>
`func bindViewModel()` 내부에서 `subscribe(onNext:)`를 사용해 WeatherDetailViewModel의 Observable과 BehaviorSubject를 구독해 데이터를 수신할 수 있도록 했습니다.


#### ListView
---
- **FrameWork** </br>
UIKit, CoreLocation
- **Library** </br>
SnapKit, RxSwift, RxCocoa
- **기능** </br>
1. 홈 화면 <-> 북마크화면 간 북마크 기능 및 알람 기능 on/off 기능이 홈 화면과 동기화. on/off시 토스트 메세지가 일정 시간 유지된 후 사라짐!
2. 북마크화면의 Cell을 누를 경우 해당 지역 날씨 페이지로 이동 가능 (현재 위치에 대한 날씨정보를 눌러도 현재위치의 날씨 정보를 가져와서 표시함)
3. 홈 화면 좌측 상단 뒤로가기를 누를 경우 현재 위치에 대한 날씨 다시 보여줌 (현재위치 날씨 정보를 리로드합니다)
4. 북마크화면 셀을 길게 눌러서 저장된 셀 간 Switching 가능 (드래그 하는 순간 UserDefaults에서 해당 내용을 삭제하고 맞는 순번에 다시 입력하는 방식으로 구현)
5. 셀을 우측으로 밀어 나타난 삭제 버튼을 눌러 저장된 셀 삭제 가능 (UserDefaults 삭제)
