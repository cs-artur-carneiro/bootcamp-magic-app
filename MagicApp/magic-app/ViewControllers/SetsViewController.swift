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
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemGray
        tableView.register(SetsTableViewCell.self, forCellReuseIdentifier: SetsTableViewCell.identifier)
        tableView.register(SetsSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SetsSectionHeaderView.identifier)
        tableView.dataSource = dataSource
        
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

final class SetsSectionHeaderView: UITableViewHeaderFooterView {
    static var identifier: String {
        return String(describing: self)
    }
    
    private let indexLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .black
        return label
    }()
    
    var index: String = "" {
        didSet {
            if oldValue != index {
                indexLabel.text = index
            }
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(indexLabel)
        
        NSLayoutConstraint.activate([
            indexLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            indexLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 16),
            indexLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            indexLabel.heightAnchor.constraint(equalToConstant: 21)
        ])
    }
}

