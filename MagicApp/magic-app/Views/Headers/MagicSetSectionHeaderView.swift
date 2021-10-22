import UIKit

final class MagicSetSectionHeaderView: UICollectionReusableView {
    private let cardsTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    var cardsType: String = "" {
        didSet {
            cardsTypeLabel.text = cardsType
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        buildViewHierarchy()
        layoutConstraints()
    }
    
    private func buildViewHierarchy() {
        addSubview(cardsTypeLabel)
    }
    
    private func layoutConstraints() {
        NSLayoutConstraint.activate([
            cardsTypeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            cardsTypeLabel.widthAnchor.constraint(equalTo: widthAnchor),
            cardsTypeLabel.heightAnchor.constraint(equalTo: heightAnchor),
            cardsTypeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 26)
        ])
    }
}
