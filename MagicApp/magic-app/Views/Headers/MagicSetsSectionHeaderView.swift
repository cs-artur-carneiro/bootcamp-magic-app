import UIKit

final class MagicSetsSectionHeaderView: UITableViewHeaderFooterView {
    static var identifier: String {
        return String(describing: self)
    }
    
    private let indexLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .black
        return label
    }()
    
    var index: String = "" {
        didSet {
            if oldValue != index {
                indexLabel.text = index
            }
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(indexLabel)
        
        NSLayoutConstraint.activate([
            indexLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            indexLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 16),
            indexLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            indexLabel.heightAnchor.constraint(equalToConstant: 21)
        ])
    }
}
