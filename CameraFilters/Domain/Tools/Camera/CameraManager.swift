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
        checkPermissions()
        sessionQueue.async {
            self.configureCaptureSession()
            self.session.startRunning()
        }
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
    
    private func configureCaptureSession() {
        guard status == .unconfigured else {
            return
        }
        session.beginConfiguration()
        
        //Execute finally at the exit of the scope of configureCaptureSession method
        defer {
            session.commitConfiguration()
        }
        // This code gets your capture device.
        let device = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .front)
        guard let camera = device else {
            set(error: .cameraUnavailable)
            status = .failed
            return
        }
        
        //  Add the device input to AVCaptureSession:
        do {
            let cameraInput = try AVCaptureDeviceInput(device: camera)
            if session.canAddInput(cameraInput) {
                session.addInput(cameraInput)
            } else {
                set(error: .cannotAddInput)
                status = .failed
                return
            }
        } catch {
            set(error: .createCaptureInput(error))
            status = .failed
            return
        }
        
        // Connect the capture output to the AVCaptureSession!
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
            videoOutput.videoSettings =
            [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
            let videoConnection = videoOutput.connection(with: .video)
            videoConnection?.videoOrientation = .portrait
        } else {
            set(error: .cannotAddOutput)
            status = .failed
            return
        }
        //Turn status configured
        status = .configured
        
    }
    
    // Frame manager will be able to set itself as the delegate that receives that camera data.
    func set(
        _ delegate: AVCaptureVideoDataOutputSampleBufferDelegate,
        queue: DispatchQueue
    ) {
        sessionQueue.async {
            self.videoOutput.setSampleBufferDelegate(delegate, queue: queue)
        }
    }
    
}
