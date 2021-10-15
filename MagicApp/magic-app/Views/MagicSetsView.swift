import UIKit
import Combine

protocol MagicSetsViewProtocol: UIView {
    var didSelectSetAt: ((IndexPath) -> Void)? { get set }
    var didPullToRefresh: (() -> Void)? { get set }
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
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private let backgroundImageView = UIImageView(image: UIImage(named: "fundo"))
    
    private var setsDataSource: MagicSetsDiffableDataSource?
    private var cancellableStore =  Set<AnyCancellable>()
    
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
        
        setsTableView.refreshControl = UIRefreshControl()
        setsTableView.refreshControl?.addTarget(self, action: #selector(didRefresh), for: .valueChanged)
        setsTableView.refreshControl?.tintColor = .white
    }
    
    @objc
    private func didRefresh() {
        didPullToRefresh?()
    }
    
    private func setUpViewHierarchy() {
        addSubview(backgroundImageView)
        addSubview(setsTableView)
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
            setsTableView.centerXAnchor.constraint(equalTo: guides.centerXAnchor),
            setsTableView.centerYAnchor.constraint(equalTo: guides.centerYAnchor),
            setsTableView.widthAnchor.constraint(equalTo: guides.widthAnchor),
            setsTableView.heightAnchor.constraint(equalTo: guides.heightAnchor)
        ])
    }
    
    // MARK: - API
    var didSelectSetAt: ((IndexPath) -> Void)?
    
    var didPullToRefresh: (() -> Void)?
    
    func configureSetsDataSource(for publisher: Published<[MagicSetsListViewModel]>.Publisher) {
        let shared = publisher.share()
        
        shared
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.setsTableView.refreshControl?.endRefreshing()
            }.store(in: &cancellableStore)
        
        setsDataSource = MagicSetsDiffableDataSource(setsPublisher: shared, for: setsTableView) { (tableView, index, viewModel) -> UITableViewCell? in
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

