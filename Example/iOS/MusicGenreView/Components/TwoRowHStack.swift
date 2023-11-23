import CongruentScrollingHStack
import SwiftUI

extension MusicGenreView {
    struct TwoRowHStack: View {

        let title: String

        var body: some View {
            VStack(alignment: .leading) {
                HeaderView(title: title)
                    .padding(.leading, 18)

                CongruentScrollingHStack(
                    sampleAlbums.random(in: 25 ..< 35),
                    columns: 2,
                    rows: 2
                ) { album in
                    SquareView(album: album)
                }
                .scrollBehavior(.fullPaging)
                .horizontalInset(18)
                .itemSpacing(8)
            }
        }
    }
}
