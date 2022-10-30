//
//  CameraManager.swift
//  CameraFilters
//
//  Created by Roberto Rojo Sahuquillo on 30/10/22.
//

import AVFoundation
// 1 Class that conforms to ObservableObject to use Combine
class CameraManager: ObservableObject {

    static let shared = CameraManager()

    private init() {
        configure()
    }

    private func configure() {
    }
    
}
