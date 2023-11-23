import CongruentScrollingHStack
import SwiftUI

extension MusicGenreView {
    struct SingleRowHStack: View {

        let title: String

        var body: some View {
            VStack(alignment: .leading) {
                HeaderView(title: title)
                    .padding(.leading, 18)

                CongruentScrollingHStack(
                    sampleAlbums.random(in: 21 ..< 31),
                    columns: 2
                ) { album in
                    SquareView(album: album)
                }
                .scrollBehavior(.continuousLeadingEdge)
                .horizontalInset(18)
                .itemSpacing(8)
            }
        }
    }
}
