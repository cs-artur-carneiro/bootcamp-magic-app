import UIKit

final class MagicSetsTableViewCell: UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
    
    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private let chevronImageView: UIImageView = {
        let image = UIImage(systemName: "chevron.forward",
                            withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = nil
    }
    
    private func setUp() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        textLabel?.textColor = .white
        textLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        selectionStyle = .none
        
        setUpViewHierarchy()
        layoutConstraints()
    }
    
    private func setUpViewHierarchy() {
        contentView.addSubview(separatorView)
        contentView.addSubview(chevronImageView)
    }
    
    private func layoutConstraints() {
        let guides = contentView.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.widthAnchor.constraint(equalTo: guides.widthAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 2),
            separatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            chevronImageView.rightAnchor.constraint(equalTo: guides.rightAnchor),
            chevronImageView.heightAnchor.constraint(equalToConstant: 12),
            chevronImageView.widthAnchor.constraint(equalToConstant: 6),
            chevronImageView.centerYAnchor.constraint(equalTo: guides.centerYAnchor)
        ])
    }
    
    func set(viewModel: MagicSetsCellViewModel) {
        textLabel?.text = viewModel.title
        separatorView.isHidden = viewModel.lastInSection
    }
}
