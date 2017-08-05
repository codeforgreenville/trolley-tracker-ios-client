//
//  MapViewDelegate.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/11/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import MapKit

class TrolleyMapViewDelegate: NSObject, MKMapViewDelegate {

    private enum Identifiers {
        static let trolley = "TrolleyAnnotation"
        static let stop = "StopAnnotation"
        static let user = "UserAnnotation"
    }
    
    typealias MapViewSelectionAction = (_ annotationView: MKAnnotationView) -> Void
    
    var annotationSelectionAction: MapViewSelectionAction?
    var annotationDeselectionAction: MapViewSelectionAction?
    var shouldShowCallouts: Bool = false
    
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        // User
        if (annotation is MKUserLocation) {

            let view = mapView.dequeueAnnotationView(ofType: MKAnnotationView.self,
                                                     for: annotation)

            let image = UIImage.ttUserPin
            view.image = image
            view.centerOffset = CGPoint(x: 0,
                                        y: -(image.size.height / 2))

            view.annotation = annotation

            return view
        }
            
        // Trolley Stops
        if let stopAnnotation = annotation as? TrolleyStop {

            let view = mapView.dequeueAnnotationView(ofType: TrolleyStopAnnotationView.self,
                                                     for: annotation)

            view.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
            view.canShowCallout = shouldShowCallouts
            view.annotation = annotation
            view.tintColor = .stopColorForIndex(stopAnnotation.colorIndex)
            
            return view
        }
            
            
        // Trolleys
        if let trolleyAnnotation = annotation as? Trolley {

            let view = mapView.dequeueAnnotationView(ofType: TrolleyAnnotationView.self,
                                                     for: annotation)

            view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            view.tintColor = trolleyAnnotation.tintColor
            view.trolleyNumber = trolleyAnnotation.ID
            view.annotation = trolleyAnnotation
            
            return view
        }

        return nil
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        
        renderer.lineWidth = 6.0
        
        if let routeOverlay = overlay as? TrolleyRouteOverlay {
            renderer.strokeColor = .routeColorForIndex(routeOverlay.colorIndex)
        }
        
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        annotationSelectionAction?(view)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.deSelectIfNeeded(mapView, view: view)
        }
    }

    private func deSelectIfNeeded(_ mapView: MKMapView, view: MKAnnotationView) {
        guard mapView.selectedAnnotations.isEmpty else { return }
        annotationDeselectionAction?(view)
    }
}

extension MKMapView {

    func dequeueAnnotationView<T>(ofType type: T.Type,
                                  for annotation: MKAnnotation) -> T where T: MKAnnotationView {

        let id = String(describing: type)
        let view = dequeueReusableAnnotationView(withIdentifier: id)

        if let typedView = view as? T {
            return typedView
        }

        return T(annotation: annotation, reuseIdentifier: id)
    }
}
