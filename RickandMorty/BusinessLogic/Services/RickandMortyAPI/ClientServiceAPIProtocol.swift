import Foundation

protocol ClientServiceAPIDelegate: AnyObject {
  func characters() -> CharactersModel
}
