import Foundation

enum MagicSetsState: Equatable {
    case loading
    case usable
    case error(String)
}
