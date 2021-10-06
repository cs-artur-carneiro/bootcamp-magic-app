import UIKit
import Combine

final class ExpansionsViewController: UITableViewController {
    private let viewModel: MagicSetsViewModelProtocol = MagicSetsViewModel()
    private lazy var dataSource = SetsDiffableDataSource(setsPublisher: viewModel.sets, for: tableView) { (tableView, index, viewModel) -> UITableViewCell? in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SetsTableViewCell.identifier, for: index) as? SetsTableViewCell else {
            return nil
        }
        cell.set(viewModel: viewModel)
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Expansions"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemGray
        tableView.register(SetsTableViewCell.self, forCellReuseIdentifier: SetsTableViewCell.identifier)
        tableView.dataSource = dataSource
        
        tableView.separatorStyle = .none
        
        viewModel.requestSets()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.setSelected(at: indexPath)
    }
}

