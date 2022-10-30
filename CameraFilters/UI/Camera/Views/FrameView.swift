//
//  FrameView.swift
//  CameraFilters
//
//  Created by Roberto Rojo Sahuquillo on 30/10/22.
//

import SwiftUI

struct FrameView: View {
    
    var image: CGImage?
    private let label = Text("Camera feed")

    var body: some View {
        // 1 Unwrap optional
        if let image = image {
          // 2 Set up GeometryReader to acess the size of the view which is necessary to ensure the image is clipped to the screen bounds
          GeometryReader { geometry in
            // 3 Create Image from CGImage, scale it to fill the frame and clip it to the bounds -> .upMirrored (front camera)
            Image(image, scale: 1.0, orientation: .upMirrored, label: label)
              .resizable()
              .scaledToFill()
              .frame(
                width: geometry.size.width,
                height: geometry.size.height,
                alignment: .center)
              .clipped()
          }
        } else {
          // 4 Return a black view if the image property is nil
          Color.black
        }

    }
}

struct FrameView_Previews: PreviewProvider {
    static var previews: some View {
        FrameView()
    }
}
