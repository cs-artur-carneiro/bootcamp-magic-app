import UIKit
import Combine

protocol MagicSetViewProtocol: UIView {
    func configureDataSource(for publisher: Published<[MagicSetListViewModel]>.Publisher)
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
    
    private let widthReference: CGFloat
    
    private var cardsDataSource: MagicSetDiffableDataSource?
    
    init(widthReference: CGFloat = UIScreen.main.bounds.width) {
        self.widthReference = widthReference
        super.init(frame: .zero)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    }
    
    private func setUpViewHierarchy() {
        addSubview(backgroundImageView)
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
}

extension MagicSetView: UICollectionViewDelegate {
    
}
