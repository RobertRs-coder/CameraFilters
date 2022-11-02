//
//  ContentView.swift
//  CameraFilters
//
//  Created by Roberto Rojo Sahuquillo on 30/10/22.
//

import SwiftUI

struct RootView: View {
    @StateObject private var viewModel = RootViewModel()
    
    var body: some View {
        ZStack{
            FrameView(image: viewModel.frame)
                .edgesIgnoringSafeArea(.all)
            
            ErrorView(error: viewModel.error)
            
            ControlView(
                comicSelected: $viewModel.comicFilter,
                monoSelected: $viewModel.monoFilter,
                crystalSelected: $viewModel.crystalFilter)
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
