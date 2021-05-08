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
    var dataModel = [PickupPoint]()
    var currentLocation: CLLocation?
    var previousLocation: CLLocation?

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

    func fetchData() {
        do {
            let data = try filedataProvider.readLocalFile(forName: "journey")
            dataModel = try JSONDecoder().decode(jsonData: data, type:[PickupPoint].self)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }

    func getAnnotation(for pickupPoint: PickupPoint) -> MKPointAnnotation {
        let location = CLLocationCoordinate2D(latitude: pickupPoint.geo.latitue, longitude: pickupPoint.geo.longitude)
        let annotation = MKPointAnnotation()
        annotation.title = pickupPoint.type
        annotation.subtitle = pickupPoint.state.getValue
        annotation.coordinate = location
        return annotation
    }
}
