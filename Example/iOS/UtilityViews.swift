import SwiftUI

struct ColorTrailingEdgeView: View {

    @Binding
    var color: Color

    var body: some View {
        color
            .aspectRatio(2 / 3, contentMode: .fill)
            .cornerRadius(5)
    }
}

struct NumberView: View {
    
    let i: Int
    
    var body: some View {
        ZStack {
            Color.secondary
                .opacity(0.7)
            
            Text("\(i)")
        }
        .aspectRatio(2 / 3, contentMode: .fill)
    }
}
