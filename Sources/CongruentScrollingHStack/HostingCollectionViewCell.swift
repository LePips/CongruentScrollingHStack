import SwiftUI

class HostingCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "HostingCollectionViewCell"

    override func prepareForReuse() {
        super.prepareForReuse()

        for subview in subviews {
            subview.removeFromSuperview()
        }
    }

    func setupHostingView(with view: any View) {
        let hostingController = UIHostingController(rootView: AnyView(view))
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = nil

        addSubview(hostingController.view)
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    func setupHostingView(premade hostingController: UIHostingController<AnyView>) {
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = nil

        addSubview(hostingController.view)
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
