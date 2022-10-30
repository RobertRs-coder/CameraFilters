//
//  FrameManager.swift
//  CameraFilters
//
//  Created by Roberto Rojo Sahuquillo on 30/10/22.
//

import AVFoundation
// Class responsible for receiving data from CameraManager and publishing a frame for use elsewhere in the app
class FrameManager: NSObject, ObservableObject {
    static let shared = FrameManager()
    @Published var current: CVPixelBuffer?
    let videoOutputQueue = DispatchQueue(
        label: "com.robertrs.VideoOutputQ",
        qos: .userInitiated,
        attributes: [],
        autoreleaseFrequency: .workItem)
    
    private override init() {
        super.init()
        CameraManager.shared.set(self, queue: videoOutputQueue)
    }
}
