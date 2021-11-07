import Foundation
import Alamofire

public struct CharactersModel {
  private var baseURL: String = "https://rickandmortyapi.com/api/"

  func getCharactersByPageNumber(pageNumber: Int, completion: @escaping (Result<CharacterInfo, AFError>) -> Void) {
    guard let url = URL(string: "\(baseURL)/character?page=\(String(pageNumber))") else {
      print("invalid URL")
      return
    }

    AF.request(url)
      .validate()
      .responseDecodable(of: CharacterInfo.self) { response in
        switch response.result {
        case .success(let charactersInfo):
          completion(.success(charactersInfo))

        case .failure(let error):
          completion(.failure(error))
        }
      }
  }

  func getCharactersByNameFilter(nameFilter: String, completion: @escaping (Result<CharacterInfo, AFError>) -> Void) {
    guard let url = URL(string: "\(baseURL)/character/?name=\(nameFilter)") else {
      print("invalid URL")
      return
    }

    AF.request(url)
      .validate()
      .responseDecodable(of: CharacterInfo.self) { response in
        switch response.result {
        case .success(let charactersInfo):
          completion(.success(charactersInfo))

        case .failure(let error):
          completion(.failure(error))
        }
      }
  }
}
