//
//  ViewController.swift
//  magic-app
//
//  Created by artur.carneiro on 01/10/21.
//

import UIKit
import Combine

final class ViewController: UITableViewController {
    private let viewModel = MagicSetsViewModel()
    private var cancellablesStore = Set<AnyCancellable>()
    private lazy var diffable: UITableViewDiffableDataSource<MagicSetsSection, MagicSetsCellViewModel> = .init(tableView: tableView) { (tableView, index, viewModel) -> UITableViewCell? in
        let cell = tableView.dequeueReusableCell(withIdentifier: CellCell.identifier, for: index)
        cell.textLabel?.text = viewModel.title
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
        
        tableView.register(CellCell.self, forCellReuseIdentifier: CellCell.identifier)
        tableView.dataSource = diffable
        
        viewModel.$sets
            .receive(on: RunLoop.main)
            .sink { [weak self] sets in
                var snapshot = NSDiffableDataSourceSnapshot<MagicSetsSection, MagicSetsCellViewModel>()
                snapshot.appendSections([MagicSetsSection(title: "")])
                snapshot.appendItems(sets.map { MagicSetsCellViewModel(title: $0.name) })
                self?.diffable.apply(snapshot)
            }.store(in: &cancellablesStore)
        
        viewModel.requestSets()
    }
}

final class CellCell: UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

struct MagicSetsSection: Hashable {
    let id: UUID = UUID()
    let title: String
}

struct MagicSetsCellViewModel: Hashable {
    let id: UUID = UUID()
    let title: String
}

