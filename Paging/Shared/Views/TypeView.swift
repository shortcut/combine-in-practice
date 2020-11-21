import SwiftUI
import Combine

struct TypeView: View {
    @ObservedObject private(set) var viewModel: TypeViewModel

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                itemsView
                switch viewModel.state {
                case .error:
                    errorView
                case .loading:
                    loadingView
                case .hasMoreData:
                    loadingView
                        .onAppear(perform: viewModel.loadNext)
                case .finished:
                    if viewModel.items.isEmpty {
                        Text("Nothing to see here")
                    } else {
                        EmptyView()
                    }
                }
            }
        }.frame(minWidth: 200, minHeight: 200)
    }

    var itemsView: some View {
        ForEach(viewModel.items) { item in
            Text(item.text)
        }
    }

    var errorView: some View {
        HStack {
            Spacer()
            VStack(alignment: .center) {
                Text("An error has occurred")
                Button("Retry", action: viewModel.retry)
            }
            Spacer()
        }
    }

    var loadingView: some View {
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }
}
