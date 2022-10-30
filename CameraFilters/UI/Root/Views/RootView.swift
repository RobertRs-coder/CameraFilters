//
//  ContentView.swift
//  CameraFilters
//
//  Created by Roberto Rojo Sahuquillo on 30/10/22.
//

import SwiftUI

struct RootView: View {
    
  var body: some View {
      FrameView(image: nil)
        .edgesIgnoringSafeArea(.all)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    RootView()
  }
}
