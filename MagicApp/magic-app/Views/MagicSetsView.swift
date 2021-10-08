import UIKit

protocol MagicSetsViewProtocol: UIView {
    var didSelectSetAt: ((IndexPath) -> Void)? { get set }
}

final class MagicSetsView: UIView, MagicSetsViewProtocol {
    private let setsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        
        tableView.register(MagicSetsTableViewCell.self,
                           forCellReuseIdentifier: MagicSetsTableViewCell.identifier)
        tableView.register(MagicSetsSectionHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: MagicSetsSectionHeaderView.identifier)
        
        let imageView = UIImageView(image: UIImage(named: "fundo"))
        tableView.backgroundView = imageView
        
        return tableView
    }()
    
    private let setsPublisher: Published<[MagicSetsListViewModel]>.Publisher
    
    private lazy var setsDataSource = MagicSetsDiffableDataSource(setsPublisher: setsPublisher, for: setsTableView) { (tableView, index, viewModel) -> UITableViewCell? in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MagicSetsTableViewCell.identifier, for: index) as? MagicSetsTableViewCell else {
            return nil
        }
        
        cell.set(viewModel: viewModel)
        return cell
    }
    
    init(setsPublisher: Published<[MagicSetsListViewModel]>.Publisher) {
        self.setsPublisher = setsPublisher
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
        
        setsTableView.dataSource = setsDataSource
        setsTableView.delegate = self
    }
    
    private func setUpViewHierarchy() {
        addSubview(setsTableView)
    }
    
    private func layoutConstraints() {
        NSLayoutConstraint.activate([
            setsTableView.centerXAnchor.constraint(equalTo: centerXAnchor),
            setsTableView.centerYAnchor.constraint(equalTo: centerYAnchor),
            setsTableView.widthAnchor.constraint(equalTo: widthAnchor),
            setsTableView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    // MARK: - API
    var didSelectSetAt: ((IndexPath) -> Void)?
}

extension MagicSetsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectSetAt?(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView
                .dequeueReusableHeaderFooterView(withIdentifier: MagicSetsSectionHeaderView.identifier) as? MagicSetsSectionHeaderView else {
            return nil
        }
        
        header.index = setsDataSource.sections[section]
        
        return header
    }
}

