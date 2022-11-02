//
//  RootViewModel.swift
//  CameraFilters
//
//  Created by Roberto Rojo Sahuquillo on 30/10/22.
//

import CoreImage
//The view model will then feed your view all the data it needs to display what you want
class RootViewModel: ObservableObject {
    
    @Published var frame: CGImage?
    private let frameManager = FrameManager.shared
    
    @Published var error: Error?
    private let cameraManager = CameraManager.shared
    
    var comicFilter = false
    var monoFilter = false
    var crystalFilter = false
    private let context = CIContext()

    init() {
        setupSubscriptions()
    }
    // All Combine pipelines to setupSubscriptions() to keep them in one place.
    func setupSubscriptions() {
        
        // 1 Tap into the Publisher provided automatically for the published CameraManager.error.
        cameraManager.$error
        // 2 Receive it on the main thread.
            .receive(on: RunLoop.main)
        // 3 Map it to itself, because otherwise Swift will complain in the next line that you can’t assign a CameraError to an Error
            .map { $0 }
        // 4 Assign it to error.
            .assign(to: &$error)
        
        //To transform the CVPixelBuffer data FrameManager provides to a CGImage your FrameView
        
        //        // 1 Tap into the Publisher that was automatically created for you when you used @Published.
        //        frameManager.$current
        //        // 2 Receive the data on the main run loop. It should already be on main, but just in case, it doesn’t hurt to be sure.
        //            .receive(on: RunLoop.main)
        //        // 3 Convert CVPixelBuffer to CGImage and filter out all nil values through compactMap.
        //            .compactMap { buffer in
        //                return CGImage.create(from: buffer)
        //            }
        //        // 4 Assign the output of the pipeline — which is, itself, a publisher — to your published frame.
        //            .assign(to: &$frame)
        
        frameManager.$current
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .compactMap { buffer in
                // 1 Try to convert CVPixelBuffer to a CGImage, and if it fails, you return early.
                guard let image = CGImage.create(from: buffer) else {
                    return nil
                }
                // 2 Convert CGImage to a CIImage, since you’ll be working with Core Image filters.
                var ciImage = CIImage(cgImage: image)
                // 3 Apply the appropriate filters, which have been turned on.
                if self.comicFilter {
                    ciImage = ciImage.applyingFilter("CIComicEffect")
                }
                if self.monoFilter {
                    ciImage = ciImage.applyingFilter("CIPhotoEffectNoir")
                }
                if self.crystalFilter {
                    ciImage = ciImage.applyingFilter("CICrystallize")
                }
                // 4 Render CIImage back to a CGImage.
                return self.context.createCGImage(ciImage, from: ciImage.extent)
            }
            .assign(to: &$frame)
    }
}
