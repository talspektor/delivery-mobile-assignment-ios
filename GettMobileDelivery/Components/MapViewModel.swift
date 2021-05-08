//
//  MapViewModel.swift
//  GettMobileDelivery
//
//  Created by Tal talspektor on 08/05/2021.
//

import MapKit

class MapViewModel {

    private let filedataProvider = FileDataPrivider()
    let regionInMetars = 10000.0

    var currentLocation: CLLocation?
    var previousLocation: CLLocation?
    let nextLocation: MyLocation

    init(with nextLocation: MyLocation) {
        self.nextLocation = nextLocation
    }

    func createDirectionsrequest(from coordinate: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> MKDirections.Request {
        let destinatonCoordinate = to//TODO: set it to the real
        let staringLocation = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: destinatonCoordinate)

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: staringLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile

        return request
    }

    func getAnnotation() -> MKPointAnnotation {
        let location = CLLocationCoordinate2D(latitude: nextLocation.geo.latitue, longitude: nextLocation.geo.longitude)
        let annotation = MKPointAnnotation()
        annotation.title = nextLocation.type
        annotation.subtitle = nextLocation.state.getValue
        annotation.coordinate = location
        return annotation
    }
}
