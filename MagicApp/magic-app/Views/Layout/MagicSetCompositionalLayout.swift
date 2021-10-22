import UIKit

final class MagicSetCompositionalLayout: UICollectionViewCompositionalLayout {
    
    init(widthReference: CGFloat) {
        let section = MagicSetCompositionalLayout.setUp(with: widthReference)
        super.init(section: section)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private static func setUp(with reference: CGFloat) -> NSCollectionLayoutSection {
        let itemWidth = reference/4.17
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
        return section
    }
}
