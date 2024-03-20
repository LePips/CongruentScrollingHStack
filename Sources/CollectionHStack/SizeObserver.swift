import SwiftUI

class SizeObserver: ObservableObject {
    
    @Published
    var contentSize: CGSize = .zero

    var onSizeChanged: (CGSize) -> Void

    init() {
        self.onSizeChanged = { _ in }
    }
}

// TODO: can this just be replaced with a view in the `ZStack` in `CollectionHStack`?

struct SizeObserverView: UIViewControllerRepresentable {

    let sizeObserver: SizeObserver

    func makeUIViewController(context: Context) -> some UIViewController {
        SizeObserverViewController(sizeObserver: sizeObserver)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

class SizeObserverViewController: UIViewController {

    let sizeObserver: SizeObserver

    init(sizeObserver: SizeObserver) {
        self.sizeObserver = sizeObserver
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    #if os(iOS)
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        // only pass new size if the overall orientation and the new size is of the same form
        //
        // this prevents a layout issue with other SwiftUI views when used within a view controller
        // has a mask on `supportedInterfaceOrientations`
        var mask = UIInterfaceOrientationMask.all
        var c: UIResponder? = self

        while c != nil {
            c = c?.next

            if let vc = c as? UIViewController {
                mask = mask.intersection(vc.supportedInterfaceOrientations)
            }
        }

        if mask.contains(.allButUpsideDown) {
            sizeObserver.onSizeChanged(size)
        } else if mask.contains(.landscape) && size.isLandscape {
            sizeObserver.onSizeChanged(size)
        } else if mask.contains(.portrait) && size.isPortrait {
            sizeObserver.onSizeChanged(size)
        }
    }
    #endif

    #if os(tvOS)
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        sizeObserver.onSizeChanged(size)
    }
    #endif

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Necessary as this is the first size call
        // I don't believe this is the same size that you will get from `viewWillTransition` but it works
        sizeObserver.onSizeChanged(view.bounds.size)
    }
}
