
/*:
 # Tunery
 
 Tunery is simple Music composer or MIDI creator.
 
 The Concept is how to easly create music, simple and yet still create a great music.
 
 ## How To Use
 
 - You can slide each Note to Key you want.
 ![`Slide`](slide.mov "Slide")
 
 - If you running out of Sheet, you can go to Adjust > add the Sheet there
 - You can also choose template provided on Tunery
 */


 import PlaygroundSupport

 let viewController = MainViewController()
 viewController.preferredContentSize = .init(width: 750, height: 700)

 PlaygroundPage.current.liveView = viewController
