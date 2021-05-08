//
//  ViewController.swift
//  GettMobileDelivery
//
//  Created by Gett on 5/5/21.
//

import CoreLocation
import UIKit
import MapKit
import GoogleMaps
import Combine

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var goToButton: UIButton!

//    var notifyFinish = PassthroughSubject<MyLocation, Never>()

    private var locationManager = CLLocationManager()
    private let geoCoder = CLGeocoder()
    private var viewModel: MapViewModel!
    private var directionsArray = [MKDirections]()

    func configur(with viewModel: MapViewModel) {
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLocationManager()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupViews()
        centerViewOnUserLocation()
    }

    private func setupViews() {
        setupMapView()
        setupGoToNexButton()
    }

    private func setupMapView() {
        mapView.delegate = self
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.userTrackingMode = .follow
        mapView.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 100,
                                                            maxCenterCoordinateDistance: 30)
        mapView.showsUserLocation = true
    }

    private func setupGoToNexButton() {
        goToButton.layer.cornerRadius = 8
    }

    private func setupLocationManager() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        guard CLLocationManager.locationServicesEnabled() else { return }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }

    private func centerViewOnUserLocation() {
        guard let location = locationManager.location?.coordinate else { return }
        let regin = MKCoordinateRegion.init(center: location,
                                            latitudinalMeters: viewModel!.regionInMetars,
                                            longitudinalMeters: viewModel!.regionInMetars)
        mapView.setRegion(regin, animated: true)
    }

    private func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }

    private func getDirections() {
        guard let location = locationManager.location?.coordinate else  {
            //TODO show alert
            return
        }

        let destinatonCoordinate = CLLocationCoordinate2D(latitude: viewModel!.nextLocation.geo.latitue,
                                                          longitude: viewModel!.nextLocation.geo.longitude)
        let request = viewModel!.createDirectionsrequest(from: location, to: destinatonCoordinate)
        let directions = MKDirections(request: request)
        resetMapVeiw(withNew: directions)

        calculateDirections(directions)
    }

    private func resetMapVeiw(withNew directions: MKDirections) {
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel() }
    }

    private func calculateDirections(_ directions: MKDirections) {
        directions.calculate { [weak self] response, error in

            guard error == nil else { return }//TODO: handle error
            guard let response = response else { return }//TODO: show response not available alest

            for rout in response.routes {
                self?.mapView.addOverlay(rout.polyline)
                self?.mapView.setVisibleMapRect(rout.polyline.boundingMapRect, animated: true)
            }
        }
    }

    @IBAction func GoToNexButtonTapped(_ sender: UIButton) {
        getDirections()
    }
    @IBAction func finishButtonTpped(_ sender: Any) {
//        notifyFinish.send(viewModel.nextLocation)
        NotificationCenter.default.post(name: Notification.Name.finishTask, object: viewModel.nextLocation)

        navigationController?.popViewController(animated: true)
    }
}

extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)

        guard let previousLocation = viewModel!.previousLocation else { return }

        guard center.distance(from: previousLocation) > 50 else { return }
        viewModel!.previousLocation = center

        geoCoder.cancelGeocode()

        geoCoder.reverseGeocodeLocation(center) { [weak self] placemarks, error in
            guard let self = self else { return }

            guard error == nil else {
                //TODO: show alert
                return
            }

            guard let placemark = placemarks?.first else {
                //TODO: show alert
                return
            }

            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""

            DispatchQueue.main.async {
                //TODO: update ui
            }
        }
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolygonRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue

        return renderer
    }
}
