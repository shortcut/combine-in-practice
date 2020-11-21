import Foundation
import Combine

enum TypeService {
    static func info(type: PageType, page: Int) -> AnyPublisher<PageResult, Error> {
        switch type {
        case .error:
            return Fail<PageResult, Error>(error: OpaqueError.generic)
                .delay(for: .seconds(0.5), scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
        case .loading:
            return Empty(completeImmediately: false,
                         outputType: PageResult.self,
                         failureType: Error.self)
                .eraseToAnyPublisher()
        case .empty:
            return Just<PageResult>(PageResult(items: [], hasMoreData: false))
                .setFailureType(to: Error.self)
                .delay(for: .seconds(0.5), scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
        case .single:
            return Just<PageResult>(.simple)
                .setFailureType(to: Error.self)
                .delay(for: .seconds(0.5), scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
        case .paged:
            return Just<PageResult>(.paged(page: page))
                .setFailureType(to: Error.self)
                .delay(for: .seconds(0.5), scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
    }
}

enum OpaqueError: Error {
    case generic
}

// MARK: - Data Mocking
private extension PageResult {
    static let simple = PageResult(items: .simple, hasMoreData: false)
    static func paged(page: Int) -> PageResult {
        let tail = [Item].neuromancer.dropFirst(page * .pageSize)
        return PageResult(items: Array(tail.prefix(.pageSize)),
                          hasMoreData: tail.count > .pageSize)
    }
}

private extension Int {
    static let pageSize = 10
}

private extension Array where Element == Item {
    static let simple: [Item] = "Just a few items here".split(separator: " ").map { text in
        Item(id: UUID(), text: "\(text)")
    }

    static let neuromancer = String.neuromancer.split(separator: " ").map { text in
        Item(id: UUID(), text: "\(text)")
    }
}

private extension String {
    static let neuromancer = "The sky above the port was the color of television, tuned to a dead channel.`It's not like I'm using,' Case heard someone say, as he shouldered his way through the crowd around the door of the Chat. `It's like my body's developed this massive drug deficiency.' It was a Sprawl voice and a Sprawl joke. The Chatsubo was a bar for professional expatriates; you could drink there for a week and never hear two words in Japanese. Ratz was tending bar, his prosthetic arm jerking monotonously as he filled a tray of glasses with draft Kirin. He saw Case and smiled, his teeth a webwork of East European steel and brown decay. Case found a place at the bar, between the unlikely tan on one of Lonny Zone's whores and the crisp naval uniform of a tall African whose cheekbones were ridged with precise rows of tribal scars. `Wage was in here early, with two joeboys,' Ratz said, shoving a draft across the bar with his good hand. `Maybe some business with you, Case?'"
}
