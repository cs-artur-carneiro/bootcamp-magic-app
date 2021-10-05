import Foundation

public enum MagicNetworkError: Error, Equatable {
    case invalidResource
    case requestFailed
    case unexpectedResponseType
    case statusCodeOutOfSuccessRange
    case decodingFailed
}
