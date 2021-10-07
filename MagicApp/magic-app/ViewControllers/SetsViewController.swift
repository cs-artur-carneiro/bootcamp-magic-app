import UIKit
import Combine

final class SetsViewController: UITableViewController {
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
        view.backgroundColor = .systemGray
        tableView.register(SetsTableViewCell.self, forCellReuseIdentifier: SetsTableViewCell.identifier)
        tableView.register(SetsSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SetsSectionHeaderView.identifier)
        tableView.dataSource = dataSource
        
        let imageView = UIImageView(image: UIImage(named: "fundo"))
        tableView.backgroundView = imageView
        
        tableView.separatorStyle = .none
        
        viewModel.requestSets()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.setSelected(at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView
                .dequeueReusableHeaderFooterView(withIdentifier: SetsSectionHeaderView.identifier) as? SetsSectionHeaderView else {
            return nil
        }
        
        header.index = dataSource.sections[section]
        
        return header
    }
}

