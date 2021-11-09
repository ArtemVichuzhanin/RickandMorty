import Foundation
import Alamofire

public struct EpisodesModel {
  private var baseURL: String = "https://rickandmortyapi.com/api"
  private let sessionManager = Alamofire.Session.default
  private var request: DataRequest?

  func getEpisodesByPageNumber(pageNumber: Int, completion: @escaping (Result<EpisodeInfo, AFError>) -> Void) {
    guard let url = URL(string: "\(baseURL)/episode?page=\(String(pageNumber))") else {
      print("invalid URL")
      return
    }

    sessionManager.request(url)
      .validate()
      .responseDecodable(of: EpisodeInfo.self) { response in
        switch response.result {
        case .success(let episodeInfo):
          completion(.success(episodeInfo))

        case .failure(let error):
          completion(.failure(error))
        }
      }
  }
}
