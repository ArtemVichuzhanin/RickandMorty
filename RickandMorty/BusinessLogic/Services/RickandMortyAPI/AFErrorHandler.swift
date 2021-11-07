import Foundation
import Alamofire

// swiftlint:disable cyclomatic_complexity
public func errorHandling(error: Error) -> (outputMsg: String, code: Int) {
  var output = ""
  var statusCode = 0

  if let error = error as? AFError {
    switch error {
    case .invalidURL(let url):
      output += "Invalid URL: \(url) - \(error.localizedDescription)\n"
    case .parameterEncodingFailed(let reason):
      output += "Parameter encoding failed: \(error.localizedDescription)\nFailure Reason: \(reason)\n"
    case .multipartEncodingFailed(let reason):
      output += "Multipart encoding failed: \(error.localizedDescription)\nFailure Reason: \(reason)\n"
    case .responseValidationFailed(let reason):
      output += "Response validation failed: \(error.localizedDescription)\nFailure Reason: \(reason)\n"

      switch reason {
      case .dataFileNil, .dataFileReadFailed:
        output += "Downloaded file could not be read\n"
      case .missingContentType(let acceptableContentTypes):
        output += "Content Type Missing: \(acceptableContentTypes)\n"
      case let .unacceptableContentType(acceptableContentTypes, responseContentType):
        output += "Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)/n"
      case .unacceptableStatusCode(let code):
        output += "Response status code was unacceptable: \(code)\n"
        statusCode = code
      case .customValidationFailed(error: let error):
        output += "Custom validation failed: \(error.localizedDescription)\n"
      }
    case .responseSerializationFailed(let reason):
      output += "Response serialization failed: \(error.localizedDescription)\nFailure Reason: \(reason)\n"
    case .createUploadableFailed(error: let error):
      output += "Create upload failed: \(error.localizedDescription)\n"
    case .createURLRequestFailed(error: let error):
      output += "Create URL request failed: \(error.localizedDescription)\n"
    case let .downloadedFileMoveFailed(error: error, source: source, destination: destination):
      output += "Downloaded file: \(source) move to: \(destination) failed with error: \(error)\n"
    case .explicitlyCancelled:
      output += "Explicity cancelled\n"
    case .parameterEncoderFailed(reason: let reason):
      output += "Parameter encoded failed\nReason: \(reason)\n"
    case .requestAdaptationFailed(error: let error):
      output += "Request adaptation failed: \(error.localizedDescription)\n"
    case let .requestRetryFailed(retryError: retryError, originalError: originalError):
      output += "Request retry failed: \(retryError.localizedDescription)\nOriginal error: \(originalError.localizedDescription)\n"
    case .serverTrustEvaluationFailed(reason: let reason):
      output += "Server trust evaluation failed\nReason: \(reason)\n"
    case .sessionDeinitialized:
      output += "Session deinitialized\n"
    case .sessionInvalidated(error: let error):
      output += "Session invalidated: \(String(describing: error?.localizedDescription))\n"
    case .sessionTaskFailed(error: let error):
      output += "Session task failed: \(error.localizedDescription)\n"
    case .urlRequestValidationFailed(reason: let reason):
      output += "URL request validation failed\nReason: \(reason)\n"
    }

    if let underlyingError = error.underlyingError {
      output += "Underlying error: \(underlyingError)\n"
    }
  } else if let error = error as? URLError {
    output += "URLError occurred: \(error)\n"
  } else {
    output += "Unknown error: \(error)\n"
  }
  return (outputMsg: output, code: statusCode)
}
