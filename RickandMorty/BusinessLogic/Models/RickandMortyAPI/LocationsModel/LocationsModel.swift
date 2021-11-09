import Foundation
import Alamofire

public struct LocationsModel {
  private var baseURL: String = "https://rickandmortyapi.com/api"
  private let sessionManager = Alamofire.Session.default
  private var request: DataRequest?

  func getLocationsByPageNumber(pageNumber: Int, completion: @escaping (Result<LocationInfo, AFError>) -> Void) {
    guard let url = URL(string: "\(baseURL)/location?page=\(String(pageNumber))") else {
      print("invalid URL")
      return
    }

    sessionManager.request(url)
      .validate()
      .responseDecodable(of: LocationInfo.self) { response in
        switch response.result {
        case .success(let locationInfo):
          completion(.success(locationInfo))

        case .failure(let error):
          completion(.failure(error))
        }
      }
  }
}
