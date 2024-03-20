import SwiftUI
import CollectionHStack

struct ContentView: View {

    var body: some View {
        NavigationView {
            Form {
                Section("Features") {

                    NavigationLink("Layout") {
                        LayoutView()
                    }

                    NavigationLink("Scroll Behavior") {
                        ScrollBehaviorView()
                    }

                    NavigationLink("Other") {
                        OtherBehaviorView()
                    }
                }

                Section("Examples") {

                    NavigationLink("App Store Apps") {
                        AppStoreAppsView()
                    }

                    NavigationLink("Apple Music Genre") {
                        MusicGenreView()
                    }

//                    NavigationLink("Apple TV Home") {
//                        Text("TODO")
//                    }

//                    NavigationLink("Books Book Store") {
//                        Text("TODO")
//                    }

//                    NavigationLink("Podcasts Browse") {
//                        Text("TODO")
//                    }
                }
            }
            .navigationTitle("CollectionHStack")
            .navigationBarTitleDisplayMode(.inline)
        }
        .if(UIDevice.current.userInterfaceIdiom == .phone) { view in
            view.navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
