import Combine

class TypeViewModel: ObservableObject {
    let type: PageType
    @Published private(set) var state: TypeViewModel.CurrentState = .hasMoreData
    @Published private(set) var items: [Item] = []
    private var page: Int = 0
    private var cancellable: Cancellable?

    init(type: PageType) {
        self.type = type
    }

    func loadNext() {
        self.state = .loading
        cancellable = TypeService.info(type: type, page: page)
            .sink { [unowned self] completion in
                switch completion {
                case .failure: self.state = .error
                case .finished: self.page += 1
                }
            }
            receiveValue: { [unowned self] result in
                self.items += result.items
                self.state = result.hasMoreData ? .hasMoreData : .finished
            }
    }

    func retry() {
        loadNext()
    }
}

// MARK: - States
extension TypeViewModel {
    enum CurrentState {
        case loading
        case hasMoreData
        case error
        case finished
    }
}
