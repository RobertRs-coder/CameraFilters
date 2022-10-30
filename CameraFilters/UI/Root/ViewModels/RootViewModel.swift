//
//  RootViewModel.swift
//  CameraFilters
//
//  Created by Roberto Rojo Sahuquillo on 30/10/22.
//

import CoreImage
//The view model will then feed your view all the data it needs to display what you want
class RootViewModel: ObservableObject {
  // 1 frame will hold the images that FrameView will display.
  @Published var frame: CGImage?
  // 2 Data used to generate frame will come from FrameManager.
  private let frameManager = FrameManager.shared

  init() {
    setupSubscriptions()
  }
  // 3 You’ll add all your Combine pipelines to setupSubscriptions() to keep them in one place.
  func setupSubscriptions() {
      //To transform the CVPixelBuffer data FrameManager provides to a CGImage your FrameView
      
      // 1 Tap into the Publisher that was automatically created for you when you used @Published.
      frameManager.$current
        // 2 Receive the data on the main run loop. It should already be on main, but just in case, it doesn’t hurt to be sure.
        .receive(on: RunLoop.main)
        // 3 Convert CVPixelBuffer to CGImage and filter out all nil values through compactMap.
        .compactMap { buffer in
          return CGImage.create(from: buffer)
        }
        // 4 Assign the output of the pipeline — which is, itself, a publisher — to your published frame.
        .assign(to: &$frame)

  }
}
