
import Foundation
import Alamofire

class WebServiceManager{
    static let shared: WebServiceManager = WebServiceManager()
    
    private init(){
        
    }
    enum CustomError: Error{
        case invalidUrl
        case invalidData
    }
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
}
