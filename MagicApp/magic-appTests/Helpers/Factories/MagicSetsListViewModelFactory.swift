import Foundation
@testable import magic_app

struct MagicSetsListViewModelFactory {
    func makeLettersOnly() -> [MagicSetsListViewModel] {
        return [MagicSetsListViewModel(section: MagicSetsSection(id: 0, title: "E"),
                                       sets: [MagicSetsCellViewModel(id: 0,
                                                                     title: "Exemplo",
                                                                     lastInSection: false),
                                              MagicSetsCellViewModel(id: 1,
                                                                     title: "Exemplo",
                                                                     lastInSection: true)])]
    }
    
    func makeNumbersAndLetters() -> [MagicSetsListViewModel] {
        return [MagicSetsListViewModel(section: MagicSetsSection(id: 0, title: "#"),
                                       sets: [MagicSetsCellViewModel(id: 0,
                                                                     title: "10th Edition",
                                                                     lastInSection: false),
                                              MagicSetsCellViewModel(id: 1,
                                                                     title: "2017 Set",
                                                                     lastInSection: true)]),
                MagicSetsListViewModel(section: MagicSetsSection(id: 1, title: "T"),
                                       sets: [MagicSetsCellViewModel(id: 0,
                                                                     title: "Teste",
                                                                     lastInSection: false),
                                              MagicSetsCellViewModel(id: 1,
                                                                     title: "Teste",
                                                                     lastInSection: true)])]
    }
}
