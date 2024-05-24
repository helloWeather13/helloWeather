
import Foundation
import Alamofire

class WebServiceManager{
    static let shared: WebServiceManager = WebServiceManager()
    
    private init(){
        
    }
    // MARK: - kakaoAddress 주소 검색 API 호출용
    var kakaoAddress = ApiModel(
        url: "https://dapi.kakao.com/v2/local/search/address.json",
        header: ["Authorization" : "KakaoAK 9f7d574ec38f35d53233f50e7bd2a13e"],
        parameter : [ "query" : "", "analyze_type" :"exact"]
    )
    
    // MARK: - forcastWeather 미래 5일 날씨 검색 API 호출용
    var forcastWeather = ApiModel(
        url: "https://api.weatherapi.com/v1/forecast.json",
        header: ["key" : "c9b70526c91341798a493546241305"],
        parameter: [
            "q" : "",
            "days" : "7",
            "aqi" : "yes",
            "lang" : "ko"
        ])
    // MARK: - historyWeather 과거 날씨 검색 API 호출용 (전날 검색 용)
    var historyWeather = ApiModel(
        url: "https://api.weatherapi.com/v1/history.json",
        header: ["key" : "c9b70526c91341798a493546241305"],
        parameter: [
            "q" : "",
            "dt" : "",
            "lang" : "ko"
        ])
    
    //MARK: - CustomError
    enum CustomError: Error{
        case invalidUrl
        case invalidData
    }
    
    //MARK: - requestAPI Generic으로 구성되어 있는 API 호출 함수
    func requestAPI <T: Codable> (
        url: String,
        expecting: T.Type,
        headers: HTTPHeaders?,
        parameters: Parameters?,
        completion: @escaping(Result<T, Error>) -> Void
    ){
        guard let url = URL(string: url) else{
            completion(.failure(CustomError.invalidUrl))
            return
        }
        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   headers: headers)
        .response{ response in
            switch response.result{
            case .success(let data):
                do{
                    guard let data = data else{
                        completion(.failure(CustomError.invalidData))
                        return
                    }
                    let result = try JSONDecoder().decode(expecting, from: data)
                    completion(.success(result))
                }catch{
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //MARK: - getForecastWeather SearchModel에서 좌표 정보만 빼서 미래 날씨 API 호출
    // escaping 클로저를 사용해서 어디에서든 데이터 받을 수 있음
    func getForecastWeather(searchModel : SearchModel, completion: @escaping (WeatherAPIModel) -> Void){
        
        let q = String(searchModel.lat) + "," + String(searchModel.lon)
        self.forcastWeather.parameter!["q"] = q
        
        self.requestAPI(url: self.forcastWeather.url, expecting: WeatherAPIModel.self, headers: self.forcastWeather.header, parameters: self.forcastWeather.parameter){  result in
            switch result{
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK: - getHistoryWeather SearchModel에서 좌표 정보만 빼서 과거 날씨 API 호출
    // escaping 클로저를 사용해서 어디에서든 데이터 받을 수 있음
    func getHistoryWeather(searchModel : SearchModel, completion: @escaping (WeatherAPIModel) -> Void){
        
        let q = String(searchModel.lat) + "," + String(searchModel.lon)
        self.historyWeather.parameter!["q"] = q
        guard let yesterday = Calendar.getYesterday() else {return}
        self.historyWeather.parameter!["dt"] = yesterday
        self.requestAPI(url: self.historyWeather.url, expecting: WeatherAPIModel.self, headers: self.historyWeather.header, parameters: self.historyWeather.parameter){  result in
            switch result{
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK: - getKakaoAddressResult 입력된 정보로 주소 반환 API 호출
    // escaping 클로저를 사용해서 어디에서든 데이터 받을 수 있음
    func getKakaoAddressResult(address : String ,completion: @escaping (KakaoAddressModel) -> Void){
        self.kakaoAddress.parameter?["query"] = address
        
        self.requestAPI(url: self.kakaoAddress.url, expecting: KakaoAddressModel.self, headers: self.kakaoAddress.header, parameters: self.kakaoAddress.parameter){  result in
            switch result{
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
