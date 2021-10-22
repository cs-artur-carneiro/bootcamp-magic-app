import UIKit
import Combine

protocol MagicSetsViewProtocol: UIView {
    var didSelectSetAt: ((IndexPath) -> Void)? { get set }
    var didPullToRefresh: (() -> Void)? { get set }
    func configureSetsDataSource(for publisher: Published<[MagicSetsListViewModel]>.Publisher)
    func bind(state: Published<MagicSetsState>.Publisher)
}

final class MagicSetsView: UIView, MagicSetsViewProtocol {
    private var state: MagicSetsState = .loading {
        didSet {
            if oldValue != state {
                switch state {
                case .loading:
                    activityIndicator.startAnimating()
                    setsTableView.isHidden = true
                    errorStackView.isHidden = true
                case .usable:
                    activityIndicator.stopAnimating()
                    setsTableView.refreshControl?.endRefreshing()
                    setsTableView.isHidden = false
                    setsTableView.isUserInteractionEnabled = true
                    errorStackView.isHidden = true
                case .error(let message):
                    activityIndicator.stopAnimating()
                    setsTableView.isHidden = true
                    errorMessageLabel.text = message
                    errorStackView.isHidden = false
                }
            }
        }
    }
    
    private let setsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        
        tableView.register(MagicSetsTableViewCell.self,
                           forCellReuseIdentifier: MagicSetsTableViewCell.identifier)
        tableView.register(MagicSetsSectionHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: MagicSetsSectionHeaderView.identifier)
        tableView.backgroundColor = .clear
        tableView.isHidden = true
        return tableView
    }()
    
    private let backgroundImageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "fundo"))
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let errorMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tryAgainButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Try again", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let errorStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.isHidden = true
        return stack
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }()
    
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
        
        tryAgainButton.addTarget(self, action: #selector(didRefresh), for: .touchUpInside)
    }
    
    @objc
    private func didRefresh() {
        didPullToRefresh?()
    }
    
    private func setUpViewHierarchy() {
        errorStackView.addArrangedSubview(errorMessageLabel)
        errorStackView.addArrangedSubview(tryAgainButton)
        addSubview(backgroundImageView)
        addSubview(activityIndicator)
        addSubview(errorStackView)
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
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: guides.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: guides.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalTo: guides.widthAnchor),
            activityIndicator.heightAnchor.constraint(equalTo: guides.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            errorStackView.centerXAnchor.constraint(equalTo: guides.centerXAnchor),
            errorStackView.centerYAnchor.constraint(equalTo: guides.centerYAnchor),
            errorStackView.widthAnchor.constraint(equalTo: guides.widthAnchor, multiplier: 0.75),
            errorStackView.heightAnchor.constraint(equalTo: guides.heightAnchor, multiplier: 0.5)
        ])
        
        NSLayoutConstraint.activate([
            tryAgainButton.widthAnchor.constraint(equalTo: errorStackView.widthAnchor, multiplier: 0.75),
            tryAgainButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            errorMessageLabel.widthAnchor.constraint(equalTo: errorStackView.widthAnchor, multiplier: 0.75)
        ])
    }
    
    // MARK: - API
    var didSelectSetAt: ((IndexPath) -> Void)?
    
    var didPullToRefresh: (() -> Void)?
    
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
    
    func bind(state: Published<MagicSetsState>.Publisher) {
        state
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                self?.state = state
            }.store(in: &cancellableStore)
            
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

