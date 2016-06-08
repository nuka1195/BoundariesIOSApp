//
//  ViewController.swift
//  Boundaries
//
//  Created by Raymond Scott Johns on 6/8/16.
//  Copyright © 2016 Raymond Scott Johns. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        self.map.delegate = self
        self.map.mapType = .Satellite
        self.map.rotateEnabled = true
        self.map.showsUserLocation = true
        
        var markerCoords = [
            CLLocationCoordinate2D(latitude: 43.363019506233776, longitude: -82.62508727610111),
            CLLocationCoordinate2D(latitude: 43.363099700514766, longitude: -82.62259215116501),
            CLLocationCoordinate2D(latitude: 43.36678852284535, longitude: -82.62283757328987),
            CLLocationCoordinate2D(latitude: 43.36671247696878, longitude: -82.62530520558357),
            CLLocationCoordinate2D(latitude: 43.363019506233776, longitude: -82.62508727610111),
            ]
        
        let routePolyline = MKPolyline(coordinates: &markerCoords, count: markerCoords.count)
        self.map.addOverlay(routePolyline)
        
        if let first = self.map.overlays.first {
            let rect = self.map.overlays.reduce(first.boundingMapRect) { MKMapRectUnion($0, $1.boundingMapRect) }
            self.map.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 50, left: 0, bottom: 30, right: 0), animated: false)
        }
        
        for coordinate in markerCoords.dropLast() {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            self.map.addAnnotation(annotation)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        guard overlay is MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor(red: 255, green: 0, blue: 0, alpha: 1)
        polylineRenderer.lineWidth = 1.5
        
        return polylineRenderer
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier("Marker")
        if view == nil {
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: "Marker")
        } else {
            view?.annotation = annotation
        }
        
        view?.image = UIImage(named: "Marker")
        
        return view
    }
    
    @IBOutlet weak var map: MKMapView!
}
