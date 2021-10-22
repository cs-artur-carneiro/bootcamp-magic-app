import UIKit
import Combine

protocol MagicSetViewProtocol: UIView {
    var didRefresh: (() -> Void)? { get set }
    func configureDataSource(for publisher: Published<[MagicSetListViewModel]>.Publisher)
    func bind(state: Published<MagicSetState>.Publisher)
}

final class MagicSetView: UIView, MagicSetViewProtocol {
    private lazy var cardsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let backgroundImageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "fundo"))
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let errorMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tryAgainButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Try again", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let errorStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.isHidden = true
        return stack
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }()
    
    private let widthReference: CGFloat
    
    private var cardsDataSource: MagicSetDiffableDataSource?
    private var cancellableStore =  Set<AnyCancellable>()
    
    private var state: MagicSetState = .loading {
        didSet {
            if oldValue != state {
                switch state {
                case .loading:
                    activityIndicator.startAnimating()
                    cardsCollectionView.isHidden = true
                    errorStackView.isHidden = true
                case .usable:
                    activityIndicator.stopAnimating()
                    cardsCollectionView.isHidden = false
                    cardsCollectionView.isUserInteractionEnabled = true
                    errorStackView.isHidden = true
                case .error(let message):
                    activityIndicator.stopAnimating()
                    cardsCollectionView.isHidden = true
                    errorMessageLabel.text = message
                    errorStackView.isHidden = false
                }
            }
        }
    }
    
    init(widthReference: CGFloat = UIScreen.main.bounds.width) {
        self.widthReference = widthReference
        super.init(frame: .zero)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func didTapRefresh() {
        didRefresh?()
    }
    
    private func setUp() {
        setUpViewHierarchy()
        layoutConstraints()
        
        cardsCollectionView.backgroundColor = .clear
        cardsCollectionView.delegate = self
        cardsCollectionView.register(MagicSetCollectionViewCell.self,
                                     forCellWithReuseIdentifier: MagicSetCollectionViewCell.identifier)
        cardsCollectionView.register(MagicSetSectionHeaderView.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: MagicSetSectionHeaderView.identifier)
        
        tryAgainButton.addTarget(self, action: #selector(didTapRefresh), for: .touchUpInside)
    }
    
    private func setUpViewHierarchy() {
        errorStackView.addArrangedSubview(errorMessageLabel)
        errorStackView.addArrangedSubview(tryAgainButton)
        addSubview(backgroundImageView)
        addSubview(activityIndicator)
        addSubview(errorStackView)
        addSubview(cardsCollectionView)
    }
    
    private func layoutConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            backgroundImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            backgroundImageView.widthAnchor.constraint(equalTo: widthAnchor),
            backgroundImageView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
        
        let guides = safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            cardsCollectionView.centerXAnchor.constraint(equalTo: guides.centerXAnchor),
            cardsCollectionView.centerYAnchor.constraint(equalTo: guides.centerYAnchor),
            cardsCollectionView.widthAnchor.constraint(equalTo: guides.widthAnchor),
            cardsCollectionView.heightAnchor.constraint(equalTo: guides.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: guides.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: guides.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalTo: guides.widthAnchor),
            activityIndicator.heightAnchor.constraint(equalTo: guides.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            errorStackView.centerXAnchor.constraint(equalTo: guides.centerXAnchor),
            errorStackView.centerYAnchor.constraint(equalTo: guides.centerYAnchor),
            errorStackView.widthAnchor.constraint(equalTo: guides.widthAnchor, multiplier: 0.75),
            errorStackView.heightAnchor.constraint(equalTo: guides.heightAnchor, multiplier: 0.5)
        ])
        
        NSLayoutConstraint.activate([
            tryAgainButton.widthAnchor.constraint(equalTo: errorStackView.widthAnchor, multiplier: 0.75),
            tryAgainButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            errorMessageLabel.widthAnchor.constraint(equalTo: errorStackView.widthAnchor, multiplier: 0.75)
        ])
    }
    
    private func flowLayout() -> UICollectionViewCompositionalLayout {
        let itemWidth = widthReference/4.17
        let itemLayoutSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth),
                                                    heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
        
        let groupHeight = itemWidth * 1.4
        let groupLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                     heightDimension: .absolute(groupHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupLayoutSize, subitems: [item])
        group.interItemSpacing = .flexible(26)
        group.contentInsets = .init(top: 0, leading: 26, bottom: 0, trailing: 26)
        
        let headerLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                      heightDimension: .absolute(40))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerLayoutSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 18
        section.boundarySupplementaryItems = [header]
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    // MARK: - API
    var didRefresh: (() -> Void)?
    
    func configureDataSource(for publisher: Published<[MagicSetListViewModel]>.Publisher) {
        cardsDataSource = MagicSetDiffableDataSource(
            cardsPublisher: publisher,
            for: cardsCollectionView
        ) { (collection, index, viewModel) -> UICollectionViewCell? in
            guard let cell = collection
                    .dequeueReusableCell(withReuseIdentifier: MagicSetCollectionViewCell.identifier,
                                         for: index) as? MagicSetCollectionViewCell else {
                return nil
            }
            cell.start()
            return cell
        }
        
        cardsDataSource?.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard let header = collectionView
                        .dequeueReusableSupplementaryView(ofKind: kind,
                                                          withReuseIdentifier: MagicSetSectionHeaderView.identifier,
                                                          for: indexPath) as? MagicSetSectionHeaderView else {
                    return UICollectionReusableView()
                }
                
                header.cardsType = self?.cardsDataSource?.sections[indexPath.section] ?? ""
                return header
            default:
                return UICollectionReusableView()
            }
        }
        
        cardsCollectionView.dataSource = cardsDataSource
    }
    
    func bind(state: Published<MagicSetState>.Publisher) {
        state
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                self?.state = state
            }.store(in: &cancellableStore)
    }
}

extension MagicSetView: UICollectionViewDelegate {
    
}
