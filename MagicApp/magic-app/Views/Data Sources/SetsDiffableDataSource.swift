import Combine
import UIKit

final class SetsDiffableDataSource: UITableViewDiffableDataSource<MagicSetsSection, MagicSetsCellViewModel> {
    private let setsPublisher: Published<[MagicSetsListViewModel]>.Publisher
    private var cancellablesStore = Set<AnyCancellable>()
    private(set) var sections: [String] = []
    
    init(setsPublisher: Published<[MagicSetsListViewModel]>.Publisher,
         for tableView: UITableView,
         cellProvider: @escaping UITableViewDiffableDataSource<MagicSetsSection, MagicSetsCellViewModel>.CellProvider) {
        self.setsPublisher = setsPublisher
        super.init(tableView: tableView, cellProvider: cellProvider)
        bind()
        defaultRowAnimation = .fade
    }
    
    private func bind() {
        setsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] viewModels in
                self?.sections = []
                var snapshot = NSDiffableDataSourceSnapshot<MagicSetsSection, MagicSetsCellViewModel>()
                viewModels.forEach {
                    self?.sections.append($0.section.title)
                    snapshot.appendSections([$0.section])
                    snapshot.appendItems($0.sets)
                }
                self?.apply(snapshot)
            }.store(in: &cancellablesStore)
    }
}
