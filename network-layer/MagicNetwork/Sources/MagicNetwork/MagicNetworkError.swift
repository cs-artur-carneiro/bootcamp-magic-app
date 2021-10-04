import Foundation

public enum MagicNetworkError: Error {
    case invalidResource
    case requestFailed
    case unexpectedResponseType
    case statusCodeOutOfSuccessRange
}
