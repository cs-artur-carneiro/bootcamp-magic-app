//
//  ViewController.swift
//  magic-app
//
//  Created by artur.carneiro on 01/10/21.
//

import UIKit
import Combine

final class ViewController: UIViewController {
    private let viewModel = MagicSetsViewModel()
    private var cancellablesStore = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
        viewModel.$sets.sink { (sets) in
            print(sets)
        }.store(in: &cancellablesStore)
        
        viewModel.requestSets()
    }
}

