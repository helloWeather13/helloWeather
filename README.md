# HelloWeather
![Static Badge](https://img.shields.io/badge/Swift-F05138?style=flat-square&logo=Swift&logoColor=white)
---
## 설명 :

날씨 어플 . (변경 예정)

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

#### SearchViewController
----
 SearchViewController는 사용자가 정확한 주소를 손쉽게 검색할 수 있도록 설계되었습니다. 카카오 주소 검색 API를 활용하여 정확한 이름과 좌표를 받아옵니다. 또한, 최근 검색 기록을 UserDefaults에 저장하여 사용자에게 이전 검색 기록을 보여줍니다. 검색 결과를 클릭하면 해당 주소의 날씨 정보를 MainViewController에서 확인할 수 있습니다.
##### 기능
- 정확한 주소 검색: 카카오 주소 검색 API를 사용하여 정확한 주소명과 좌표를 가져옵니다.
- 연관 검색: 카카오 주소 검색 API를 사용하여 쿼리에 해당하는 주소명들을 가져옵니다. 
- 최근 검색 기록: UserDefaults를 활용하여 최근 검색 기록을 저장하고, 사용자에게 표시합니다.







