//
//  NetworkManager.swift
//  
//
//  Created by Roman Trekhlebov on 23.05.2021.
//

import Foundation
import Alamofire

protocol NetworkManagerProtocol {

}


final class NetworkManager: NetworkManagerProtocol{
  // MARK: - Public Properties
  // MARK: - Private Properties
  // MARK: - Initializers
  // MARK: - Lifecycle
  // MARK: - Private Methods

  func checkUploadProgress<Output,Input>(resource: Resource<Output,Input>, completion: @escaping (Result<Output, UploadManagerErrors>) -> Void)
  where Output: Codable, Input: Codable {
    
    let url = resource.url
    var request = URLRequest(url: url)
    request.httpMethod = HTTPMethod.put.rawValue

    if let parameters = resource.parameters {
      let encoder = JSONEncoder()
      let jsonData = try! encoder.encode(parameters)
      request.httpBody = jsonData
    }

    if let headers = resource.headers {
      request.allHTTPHeaderFields = headers
    } else {
      request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
    }

    AF.request(request).responseDecodable { (response: DataResponse<Output, AFError>) in
      switch response.result {
      case .success(let output):
        print("Received object: \(output)")
        completion(.success(output))

      case .failure(let error):
        print("Failed with error: \(error)")
        completion(.failure(.networkError))
      }
    }
  }

//  func fetchGenericJsonData<T>(resource: Resource<T>,
//                               completion: @escaping (Result<T, NetworkError>) -> Void)
//  where T: Codable {
//    networkService.request(url: resource.url,
//                           method: resource.httpMethod,
//                           headers: resource.headers,
//                           body: resource.body) { result in
//      do {
//        let data = try result.get()
//        if let decoded = self.decodeJSON(type: T.self, data: data) {
//          completion(.success(decoded))
//        } else if let decodedError = self.decodeJSON(type: NetworErrorResponse.self, data: data) {
//
//          if let cpError = CpError.initFrom(decodedError) {
//            completion(.failure(.cpError(cpError)))
//          } else {
//            completion(.failure(.errorWithData(data, decodedError.message)))
//          }
//        } else {
//          completion(.failure(.decodingError))}
//      } catch {
//        switch result {
//        case.failure(let error):
//          completion(.failure(error))
//        default:
//          break
//        }
//      }
//    }
//  }
  // MARK: - Public Methods
}




struct Resource<Output, Input: Codable> {
  let url: URL
  var httpMethod: HTTPMethod = .get
  var uploadTask: UploadTask?
  var body: Data?
  var parameters: Input?
  var headers: [String: String]?
}

struct InputParam: Codable {
  let fileName: String
  let chunkSize: UInt64
  let length: UInt64
}


struct OutputParam: Codable {
  let offset: UInt64
}
