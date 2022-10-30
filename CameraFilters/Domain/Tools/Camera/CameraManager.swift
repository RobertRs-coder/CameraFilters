//
//  CameraManager.swift
//  CameraFilters
//
//  Created by Roberto Rojo Sahuquillo on 30/10/22.
//

import AVFoundation

class CameraManager: ObservableObject {
    
    static let shared = CameraManager()
    
    @Published var error: CameraError?
    
    let session = AVCaptureSession()
    
    private let sessionQueue = DispatchQueue(label: "com.robertrs.SessionQ")
    private let videoOutput = AVCaptureVideoDataOutput()
    private var status = CameraStatus.unconfigured
    
    private init() {
        configure()
    }
    
    private func configure() {
    }
    
    private func set(error: CameraError?) {
        DispatchQueue.main.async {
            self.error = error
        }
    }
    
    private func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video) { authorized in
                
                if !authorized {
                    self.status = .unauthorized
                    self.set(error: .deniedAuthorization)
                }
                self.sessionQueue.resume()
            }
        case .restricted:
            status = .unauthorized
            set(error: .restrictedAuthorization)
        case .denied:
            status = .unauthorized
            set(error: .deniedAuthorization)
        case .authorized:
            break
            
        @unknown default:
            status = .unauthorized
            set(error: .unknownAuthorization)
        }
    }
    
    
    
}
