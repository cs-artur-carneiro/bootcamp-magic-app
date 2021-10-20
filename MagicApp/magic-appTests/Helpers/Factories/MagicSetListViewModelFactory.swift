@testable import magic_app

struct MagicSetListViewModelFactory {
    func make() -> [MagicSetListViewModel] {
        return [
            MagicSetListViewModel(
                section: MagicSetSection(id: 0, name: "Creature"),
                cards: [
                    MagicSetCardCellViewModel(id: "AAA", imageUrl: "url", isFavorite: false),
                    MagicSetCardCellViewModel(id: "BBB", imageUrl: "url", isFavorite: false),
                    MagicSetCardCellViewModel(id: "CCC", imageUrl: "url", isFavorite: false)
                ]
            ),
            MagicSetListViewModel(
                section: MagicSetSection(id: 1, name: "Enchantment"),
                cards: [
                    MagicSetCardCellViewModel(id: "TTT", imageUrl: "url", isFavorite: false),
                    MagicSetCardCellViewModel(id: "UUU", imageUrl: "url", isFavorite: false),
                    MagicSetCardCellViewModel(id: "VVV", imageUrl: "url", isFavorite: false)
                ]
            )
        ]
    }
    
    func makeCreatureOnly() -> [MagicSetListViewModel] {
        return [
            MagicSetListViewModel(
                section: MagicSetSection(id: 0, name: "Creature"),
                cards: [
                    MagicSetCardCellViewModel(id: "AAA", imageUrl: "url", isFavorite: false),
                    MagicSetCardCellViewModel(id: "BBB", imageUrl: "url", isFavorite: false),
                    MagicSetCardCellViewModel(id: "CCC", imageUrl: "url", isFavorite: false)
                ]
            )
        ]
    }
}
