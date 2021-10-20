import UIKit
import Combine

final class MagicSetDiffableDataSource: UICollectionViewDiffableDataSource<MagicSetSection, MagicSetCardCellViewModel> {
    private let cardsPublisher: Published<[MagicSetListViewModel]>.Publisher
    private var cancellableStore = Set<AnyCancellable>()
    private(set) var sections: [String] = []
    
    init(cardsPublisher: Published<[MagicSetListViewModel]>.Publisher,
         for collectionView: UICollectionView,
         cellProvider: @escaping UICollectionViewDiffableDataSource<MagicSetSection, MagicSetCardCellViewModel>.CellProvider) {
        self.cardsPublisher = cardsPublisher
        super.init(collectionView: collectionView, cellProvider: cellProvider)
        bind()
    }
    
    private func bind() {
        cardsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] viewModels in
                self?.sections = []
                var snapshot = NSDiffableDataSourceSnapshot<MagicSetSection, MagicSetCardCellViewModel>()
                viewModels.forEach {
                    self?.sections.append($0.section.name)
                    snapshot.appendSections([$0.section])
                    snapshot.appendItems($0.cards)
                }
                self?.apply(snapshot)
            }.store(in: &cancellableStore)
    }
}
