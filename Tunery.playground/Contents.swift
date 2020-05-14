import PlaygroundSupport

let viewController = MainViewController()
viewController.preferredContentSize = .init(width: 750, height: 700)

PlaygroundPage.current.liveView = viewController
