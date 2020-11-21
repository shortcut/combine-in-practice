import SwiftUI

struct ContentView: View {
    @State private var type: PageType = .loading
    var body: some View {
        VStack {
            TypePicker(type: $type)
            TypeView(viewModel: TypeViewModel(type: type))
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
