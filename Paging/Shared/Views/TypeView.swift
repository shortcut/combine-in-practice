import SwiftUI
import Combine

struct TypeView: View {
    @ObservedObject private(set) var viewModel: TypeViewModel

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .center) {
                itemsView
                switch viewModel.state {
                case .error:
                    errorView
                case .loading:
                    ProgressView()
                case .hasMoreData:
                    ProgressView()
                        .onAppear(perform: viewModel.load)
                case .loadedContent where viewModel.items.isEmpty:
                    Text("Nothing to see here")
                case .loadedContent:
                    EmptyView()
                }
            }
        }
        .frame(minWidth: 200, minHeight: 200)
    }

    var itemsView: some View {
        ForEach(viewModel.items) { item in
            Text(item.text)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var errorView: some View {
        VStack {
            Text("An error has occurred")
            Button("Retry", action: viewModel.load)
        }
    }
}

struct TypeView_Previews: PreviewProvider {
    static var previews: some View {
        TypeView(viewModel: TypeViewModel(type: .empty))
    }
}
