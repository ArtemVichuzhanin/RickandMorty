import Foundation

public struct LocationResult: Codable, Identifiable {
  public let id: Int
  public let name: String
  public let type: String
  public let dimension: String
  public let residents: [String]
  public let url: String
  public let created: String
}
