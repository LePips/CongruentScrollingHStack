import AlwaysPopover
import SwiftUI

extension MusicGenreView {
    struct SongItem: View {

        @State
        private var isBooPresented = false

        let album: SampleAlbum

        var body: some View {
            HStack {
                album.color
                    .opacity(0.5)
                    .aspectRatio(1, contentMode: .fill)
                    .cornerRadius(2)
                    .frame(width: 50, height: 50)

                VStack(alignment: .leading) {
                    Color.secondary
                        .opacity(0.5)
                        .frame(height: 0.2)

                    HStack {
                        VStack(alignment: .leading, spacing: 2) {

                            Text(album.album)
                                .font(.body)

                            Text(album.artist)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Button {
                            if Int.random(in: 0 ..< 10) == 0 {
                                UINotificationFeedbackGenerator()
                                    .notificationOccurred(.success)
                                isBooPresented = true
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.body)
                                .padding()
                        }
                        .alwaysPopover(isPresented: $isBooPresented) {
                            Text("👻 Boo")
                                .padding()
                        }
                        .foregroundStyle(.primary)
                    }
                }
            }
        }
    }
}
