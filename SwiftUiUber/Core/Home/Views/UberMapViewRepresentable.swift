//
//  UberMapViewRepresentable.swift
//  SwiftUiUber
//
//  Created by Shaik Ahron on 05/02/23.
//

import Foundation
import SwiftUI
import MapKit

struct UberMapViewRepresentable: UIViewRepresentable{
    
    let mapView = MKMapView()
    let locationManager = LocationManager()
    @EnvironmentObject var viewModel: LocationSearchViewModel
    @Binding var mapState: MapViewState
    
    
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
        switch mapState {
        case .noInput:
            context.coordinator.clearMapView()
            break
        case .locationSelected:
            if let coordinate = viewModel.selectedLocationCoordinate{
                context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
                context.coordinator.configurePolyline(withDestinationCoordinate: coordinate)
            }
            break
        case .searchingForLocation:
            break
        }
        
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}

extension UberMapViewRepresentable {
    
    class MapCoordinator: NSObject, MKMapViewDelegate {
        let parent: UberMapViewRepresentable
        var userLocation: CLLocationCoordinate2D?
        var currentRegion: MKCoordinateRegion?
        
        init(parent: UberMapViewRepresentable){
            self.parent = parent
            super.init()
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocation = userLocation.coordinate
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            self.currentRegion = region
            parent.mapView.setRegion(region, animated: true)
        }
        
        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D){
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            self.parent.mapView.addAnnotation(anno)
            self.parent.mapView.selectAnnotation(anno, animated: true)
        }
        
        func configurePolyline(withDestinationCoordinate coordinate: CLLocationCoordinate2D){
            guard let userLocation = self.userLocation else {
                return
            }
            
            getDestinationRoute(from: userLocation, to: coordinate){ route in
                self.parent.mapView.addOverlay(route.polyline)
                let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect, edgePadding: .init(top: 64, left: 32, bottom: 500, right: 32))
                self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
        
        func getDestinationRoute(from userLocation: CLLocationCoordinate2D,to destinationLocation: CLLocationCoordinate2D, completion: @escaping(MKRoute) -> Void){
            let userPlaceMark = MKPlacemark(coordinate: userLocation)
            let destPlaceMark = MKPlacemark(coordinate: destinationLocation)
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: userPlaceMark)
            request.destination = MKMapItem(placemark: destPlaceMark)
            let directions = MKDirections(request: request)
            
            directions.calculate{ respone, error in
                if let error = error {
                    print("DEBUG: Failed to get directions \(error)")
                    return
                }
                
                guard let route = respone?.routes.first else { return }
                completion(route)
            }
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let overlay = MKPolylineRenderer(overlay: overlay)
            overlay.strokeColor = .systemBlue
            overlay.lineWidth = 6
            return overlay
        }
        
        func clearMapView(){
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)
            
            if let currentRegion = currentRegion {
                parent.mapView.setRegion(currentRegion, animated: true)
            }
        }
    }
}

