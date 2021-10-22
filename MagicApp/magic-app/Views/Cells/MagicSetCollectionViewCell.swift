import UIKit

final class MagicSetCollectionViewCell: UICollectionViewCell {
    private let cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .red
        return imageView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .white
        return activityIndicator
    }()
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        activityIndicator.stopAnimating()
    }
    
    private func buildViewHierarchy() {
        contentView.addSubview(cardImageView)
        contentView.addSubview(activityIndicator)
    }
    
    private func layoutConstraints() {
        NSLayoutConstraint.activate([
            cardImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cardImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cardImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            cardImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            activityIndicator.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
    }
    
    func start() {
        activityIndicator.startAnimating()
    }
}
