//
//  ContentView.swift
//  CameraFilters
//
//  Created by Roberto Rojo Sahuquillo on 30/10/22.
//

import SwiftUI

struct RootView: View {
  var body: some View {
//    ZStack {
//      Color.black.edgesIgnoringSafeArea(.all)
//
//      Text("Filter the World!")
//        .foregroundColor(.white)
//    }
      FrameView(image: nil)
        .edgesIgnoringSafeArea(.all)

  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    RootView()
  }
}
