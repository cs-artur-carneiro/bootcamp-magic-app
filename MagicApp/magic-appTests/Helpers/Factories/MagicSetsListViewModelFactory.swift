import Foundation
@testable import magic_app

struct MagicSetsListViewModelFactory {
    func makeLettersOnly() -> [MagicSetsListViewModel] {
        return [MagicSetsListViewModel(section: MagicSetsSection(id: 0, title: "E"),
                                       sets: [MagicSetsCellViewModel(id: "AAA",
                                                                     title: "Exemplo",
                                                                     lastInSection: false),
                                              MagicSetsCellViewModel(id: "BBB",
                                                                     title: "Exemplo",
                                                                     lastInSection: true)])]
    }
    
    func makeNumbersAndLetters() -> [MagicSetsListViewModel] {
        return [MagicSetsListViewModel(section: MagicSetsSection(id: 0, title: "#"),
                                       sets: [MagicSetsCellViewModel(id: "AAA",
                                                                     title: "10th Edition",
                                                                     lastInSection: false),
                                              MagicSetsCellViewModel(id: "BBB",
                                                                     title: "2017 Set",
                                                                     lastInSection: true)]),
                MagicSetsListViewModel(section: MagicSetsSection(id: 1, title: "T"),
                                       sets: [MagicSetsCellViewModel(id: "CCC",
                                                                     title: "Teste",
                                                                     lastInSection: false),
                                              MagicSetsCellViewModel(id: "DDD",
                                                                     title: "Teste",
                                                                     lastInSection: true)])]
    }
}
