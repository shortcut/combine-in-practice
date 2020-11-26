import Foundation

enum PageType: CaseIterable, Identifiable, Hashable {
    case loading
    case error
    case empty
    case single
    case paged
    case stream

    var id: Self { self }
}

extension PageType: CustomStringConvertible {
    var description: String {
        switch self {
        case .loading: return "Loading"
        case .error: return "Error"
        case .empty: return "Empty"
        case .single: return "Single"
        case .paged: return "Paged"
        case .stream: return "Stream"
        }
    }
}
