//
//  LocationSearchView.swift
//  SwiftUiUber
//
//  Created by Shaik Ahron on 05/02/23.
//

import SwiftUI

struct LocationSearchView: View {
    @State private var startLocationText = ""
    @Binding var mapState: MapViewState
    @EnvironmentObject private var viewModel: LocationSearchViewModel

    var body: some View {
        VStack{
            HStack{
                VStack{
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 6,height: 6)
                    
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 1,height: 24)
                    
                    Rectangle()
                        .fill(.black)
                        .frame(width: 6,height: 6)
                }
                
                VStack{
                    TextField("Current Location", text: $startLocationText)
                        .frame(height: 32)
                        .padding(.trailing)
                        .background(Color(.systemGroupedBackground))
                    
                    TextField("Where to?", text: $viewModel.queryFragment)
                        .frame(height: 32)
                        .padding(.trailing)
                        .background(Color(.systemGray4))
                }
            }
            .padding(.horizontal)
            .padding(.top, 64)
            
            Divider()
                .padding(.vertical)
            
            ScrollView{
                VStack(alignment: .leading) {
                    ForEach(viewModel.results, id: \.self){ location in
                        LocationSearchResultCell(title: location.title, subtitle: location.subtitle)
                            .onTapGesture {
                                withAnimation(.spring()){
                                    viewModel.selectLocation(location)
                                    mapState = .locationSelected
                                }
                            }
                    }
                }
            }
        }
        .background(.white)
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView(mapState: .constant(.searchingForLocation))
    }
}
