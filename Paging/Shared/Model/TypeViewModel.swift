import Combine

class TypeViewModel: ObservableObject {
    private let type: PageType
    @Published private(set) var state: TypeViewModel.CurrentState = .hasMoreData
    @Published private(set) var items: [Item] = []
    @Published private var page: Int = 0

    init(type: PageType) {
        self.type = type
    }

    func load() {
        // Create a shareable publisher
        let shareable = TypeService.info(type: type, page: page)
            .map(Result<PageResult, Error>.success)
            .catch { Just(Result<PageResult, Error>.failure($0)) }
            .share()


        // Update the state
        shareable.map { result -> TypeViewModel.CurrentState in
            switch result {
            case .success(let page): return page.hasMoreData ? .hasMoreData : .loadedContent
            case .failure: return .error
            }
        }
        .prepend(.loading)
        .assign(to: &$state)

        // Assign new values to items
        shareable.map { result -> [Item] in
            switch result {
            case .success(let page): return page.items
            case .failure: return []
            }
        }
        .scan(items) { items, item in
            items + item
        }
        .assign(to: &$items)

        // Update the page number
        shareable.map { result in
            switch result {
            case .failure: return 0
            case .success: return 1
            }
        }
        .scan(page) { page, advance in
            page + advance
        }
        .assign(to: &$page)
    }
}

// MARK: - States
extension TypeViewModel {
    enum CurrentState {
        case loading
        case loadedContent
        case hasMoreData
        case error
    }
}
