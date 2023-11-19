import AlwaysPopover
import CongruentScrollingHStack
import OrderedCollections
import SwiftUI

struct ContentView: View {

    @State
    var isEndlessColorsDescriptionPresented = false
    @State
    var isColorGridDescriptionPresented = false
    @State
    var isPagingDescriptionPresented = false
    @State
    var isSelfSizingDescriptionPresented = false
    @State
    var isFractionalColumnDescriptionPresented = false
    @State
    var isVariadicWidthsDescriptionPresented = false

    @State
    var uuids = OrderedSet((0 ..< 100).map { _ in UUID() })

    let colors: [Color] = [
        .blue,
        .green,
        .yellow,
        .red,
        .orange,
        .purple,
        .pink,
        .cyan,
        .indigo,
        .mint,
        .teal,
    ]
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack {
                    CongruentScrollingHStack(0 ..< 20) { i in
                        ZStack {
                            Color.secondary
                            
                            Text("\(i)")
                        }
                        .cornerRadius(5)
                        .aspectRatio(1, contentMode: .fill)
                        .frame(width: 75)
                    }
                }
            }
        }
    }

    var abody: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack {

                    CongruentScrollingHStack(0 ..< 10, columns: 1, scrollBehavior: .itemPaging) { _ in
                        AsyncImage(
                            url: URL(string: "https://picsum.photos/750/500"),
                            transaction: Transaction(animation: .easeInOut)
                        ) { phase in
                            switch phase {
                            case let .success(image):
                                image
                                    .resizable()
                                    .transition(.opacity)
                            default:
                                Color.secondary
                                    .opacity(0.2)
                            }
                        }
                        .aspectRatio(1.5, contentMode: .fill)
                        .cornerRadius(5)
                    }

                    Button {
                        isEndlessColorsDescriptionPresented = true
                    } label: {
                        Text("Endless Colors")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    .alwaysPopover(isPresented: $isEndlessColorsDescriptionPresented) {
                        VStack {
                            Text("Top: 3 columns/50 columnTrailingInset/continuous")

                            Text("Bottom: 3 columns/continuousLeadingEdge")
                        }
                        .font(.subheadline.weight(.light))
                        .foregroundStyle(.secondary)
                        .padding()
                    }

                    CongruentScrollingHStack(
                        items: $uuids,
                        columns: 3,
                        columnTrailingInset: 50
                    ) { uuid in
                        Button {
                            print(uuid.uuidString)
                        } label: {
                            ZStack {
                                Color.secondary

                                colors.randomElement()!
                                    .aspectRatio(2 / 3, contentMode: .fill)
                            }
                            .cornerRadius(5)
                        }
                    }
                    .onReachedTrailingEdge(offset: 300) {
                        let newUUIDS = (0 ..< 100).map { _ in UUID() }
                        uuids.append(contentsOf: newUUIDS)
                    }

                    CongruentScrollingHStack(items: $uuids, columns: 3, scrollBehavior: .continuousLeadingEdge) { uuid in
                        Button {
                            print(uuid.uuidString)
                        } label: {
                            ZStack {
                                Color.secondary

                                colors.randomElement()!
                                    .aspectRatio(2 / 3, contentMode: .fill)
                            }
                            .cornerRadius(5)
                        }
                    }
                    .onReachedTrailingEdge(offset: 300) {
                        let newUUIDS = (0 ..< 100).map { _ in UUID() }
                        uuids.append(contentsOf: newUUIDS)
                    }

                    Button {
                        isColorGridDescriptionPresented = true
                    } label: {
                        Text("Color Grid")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    .alwaysPopover(isPresented: $isColorGridDescriptionPresented) {
                        Text("4 columns/0 insets/0 spacing/continuousLeadingEdge")
                            .font(.subheadline.weight(.light))
                            .foregroundStyle(.secondary)
                            .padding()
                    }

                    VStack(spacing: 0) {
                        CongruentScrollingHStack(
                            0 ..< 100,
                            columns: 4,
                            inset: 0,
                            spacing: 0,
                            scrollBehavior: .continuousLeadingEdge
                        ) { _ in
                            colors.randomElement()!
                                .aspectRatio(1, contentMode: .fill)
                        }

                        CongruentScrollingHStack(
                            0 ..< 100,
                            columns: 4,
                            inset: 0,
                            spacing: 0,
                            scrollBehavior: .continuousLeadingEdge
                        ) { _ in
                            colors.randomElement()!
                                .aspectRatio(1, contentMode: .fill)
                        }

                        CongruentScrollingHStack(
                            0 ..< 100,
                            columns: 4,
                            inset: 0,
                            spacing: 0,
                            scrollBehavior: .continuousLeadingEdge
                        ) { _ in
                            colors.randomElement()!
                                .aspectRatio(1, contentMode: .fill)
                        }

                        CongruentScrollingHStack(
                            0 ..< 100,
                            columns: 4,
                            inset: 0,
                            spacing: 0,
                            scrollBehavior: .continuousLeadingEdge
                        ) { _ in
                            colors.randomElement()!
                                .aspectRatio(1, contentMode: .fill)
                        }
                    }

                    Button {
                        isPagingDescriptionPresented = true
                    } label: {
                        Text("Paging")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    .alwaysPopover(isPresented: $isPagingDescriptionPresented) {
                        Text("1 column/item paging")
                            .font(.subheadline.weight(.light))
                            .foregroundStyle(.secondary)
                            .padding()
                    }

                    CongruentScrollingHStack(0 ..< 10, columns: 1, scrollBehavior: .itemPaging) { _ in
                        colors.randomElement()!
                            .aspectRatio(3, contentMode: .fill)
                    }

                    Button {
                        isSelfSizingDescriptionPresented = true
                    } label: {
                        Text("Self Sizing")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    .alwaysPopover(isPresented: $isSelfSizingDescriptionPresented) {
                        Text("self sizing/continuousLeadingEdge")
                            .font(.subheadline.weight(.light))
                            .foregroundStyle(.secondary)
                            .padding()
                    }

                    CongruentScrollingHStack(0 ..< 20, scrollBehavior: .continuousLeadingEdge) { _ in
                        colors.randomElement()!
                            .frame(width: 200, height: 200)
                    }

                    Button {
                        isFractionalColumnDescriptionPresented = true
                    } label: {
                        Text("Fractional Columns")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    .alwaysPopover(isPresented: $isFractionalColumnDescriptionPresented) {
                        Text("1.5 columns/itemPaging")
                            .font(.subheadline.weight(.light))
                            .foregroundStyle(.secondary)
                            .padding()
                    }

                    CongruentScrollingHStack(
                        0 ..< 10,
                        columns: 1.5,
                        scrollBehavior: .itemPaging
                    ) { _ in
                        HStack(spacing: 0) {
                            Color.purple

                            Color.cyan
                        }
                        .aspectRatio(3, contentMode: .fill)
                    }

                    Button {
                        isVariadicWidthsDescriptionPresented = true
                    } label: {
                        Text("Variadic Widths")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    .alwaysPopover(isPresented: $isVariadicWidthsDescriptionPresented) {
                        Text("self sizing/variadic width/continuousLeadingEdge")
                            .font(.subheadline.weight(.light))
                            .foregroundStyle(.secondary)
                            .padding()
                    }

                    CongruentScrollingHStack(0 ..< 20, scrollBehavior: .continuousLeadingEdge, variadicWidths: true) { i in
                        colors.randomElement()!
                            .frame(width: 50 * (CGFloat(i % 3) + 1), height: 200)
                    }

                    CongruentScrollingHStack(0 ..< 5, scrollBehavior: .continuousLeadingEdge, variadicWidths: true) { i in
                        if i == 0 {
                            colors.randomElement()!
                                .aspectRatio(2 / 3, contentMode: .fill)
                                .frame(height: 200)
                        } else {
                            colors.randomElement()!
                                .frame(width: 300, height: 200)
                        }
                    }
                }
            }
            .navigationTitle("Example")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
