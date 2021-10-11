import UIKit

protocol MagicSetsViewProtocol: UIView {
    var didSelectSetAt: ((IndexPath) -> Void)? { get set }
    func configureSetsDataSource(for publisher: Published<[MagicSetsListViewModel]>.Publisher)
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
    
    private var setsDataSource: MagicSetsDiffableDataSource?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        setUpViewHierarchy()
        layoutConstraints()
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
    
    func configureSetsDataSource(for publisher: Published<[MagicSetsListViewModel]>.Publisher) {
        setsDataSource = MagicSetsDiffableDataSource(setsPublisher: publisher, for: setsTableView) { (tableView, index, viewModel) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MagicSetsTableViewCell.identifier, for: index) as? MagicSetsTableViewCell else {
                return nil
            }
            
            cell.set(viewModel: viewModel)
            return cell
        }
        
        setsTableView.dataSource = setsDataSource
    }
}

extension MagicSetsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectSetAt?(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let dataSource = setsDataSource,
              let header = tableView
                .dequeueReusableHeaderFooterView(withIdentifier: MagicSetsSectionHeaderView.identifier) as? MagicSetsSectionHeaderView else {
            return nil
        }
        
        header.index = dataSource.sections[section]
        
        return header
    }
}

