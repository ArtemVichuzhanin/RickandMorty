import Foundation
import Alamofire

protocol CharactersModelDelegate: AnyObject {
  func getCharactersByPageNumber(pageNumber: Int, completion: @escaping (Result<CharacterInfo, AFError>) -> Void)
  func getCharactersByNameFilter(nameFilter: String, completion: @escaping (Result<CharacterInfo, AFError>) -> Void)
}

protocol LocationsModelDelegate: AnyObject {
  func getLocationsByPageNumber(pageNumber: Int, completion: @escaping (Result<LocationInfo, AFError>) -> Void)
}

protocol EpisodesModelDelegate: AnyObject {
  func getEpisodesByPageNumber(pageNumber: Int, completion: @escaping (Result<EpisodeInfo, AFError>) -> Void)
}
