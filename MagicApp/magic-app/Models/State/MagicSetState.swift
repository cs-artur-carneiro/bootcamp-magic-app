import Foundation

enum MagicSetState: Equatable {
    case loading
    case usable
    case error(String)
}
