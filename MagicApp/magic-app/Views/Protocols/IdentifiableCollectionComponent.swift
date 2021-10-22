import Foundation

protocol IdentifiableCollectionComponent: AnyObject {
    static var identifier: String { get }
}

extension IdentifiableCollectionComponent {
    static var identifier: String {
        return String(describing: self)
    }
}
