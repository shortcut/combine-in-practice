import SwiftUI

struct TypePicker: View {
    @Binding var type: PageType

    var body: some View {
        Picker(selection: $type, label: EmptyView()) {
            ForEach(PageType.allCases) { type in
                Text(type.description)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
        TypePicker(type: .constant(.loading))
    }
}
