//
//  ContentView.swift
//  SwiftUiUber
//
//  Created by Shaik Ahron on 05/02/23.
//

import SwiftUI
import CoreData

struct HomeView: View {
    
    @State private var mapState = MapViewState.noInput

    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .top){
                UberMapViewRepresentable(mapState: $mapState)
                    .ignoresSafeArea()
                
                if mapState == .searchingForLocation {
                    LocationSearchView(mapState: $mapState)
                } else if mapState == .noInput{
                    LocationSearchActivationView()
                        .padding(.top, 72)
                        .onTapGesture{
                            withAnimation(.spring()){
                                mapState = .searchingForLocation
                            }
                        }
                }
            
                
                MapViewActionButton(mapState: $mapState)
                    .padding(.leading)
                    .padding(.top, 4)
            }
            
            if mapState == .locationSelected {
                RideRequestView()
                    .transition(.move(edge: .bottom))
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }

    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
