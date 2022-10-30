//
//  CameraManager.swift
//  CameraFilters
//
//  Created by Roberto Rojo Sahuquillo on 30/10/22.
//

import AVFoundation
// 1 Class that conforms to ObservableObject to use Combine
class CameraManager: ObservableObject {
  // 2 enum to represent the status of the camera
  
  // 3 Create static shared instance to easy acess
    static let shared = CameraManager()

    @Published var error: CameraError?

    let session = AVCaptureSession()

    private let sessionQueue = DispatchQueue(label: "com.robertrs.SessionQ")
    private let videoOutput = AVCaptureVideoDataOutput()
    private var status = CameraStatus.unconfigured
    
  // 4 Create singleton of camera manager with private init
  private init() {
    configure()
  }
  // 5 Create a method to configure the camera later
  private func configure() {
  }
}
