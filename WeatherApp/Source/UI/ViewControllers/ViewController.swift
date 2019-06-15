//
//  ViewController.swift
//  WeatherAppLecture
//
//  Created by Daria on 6/26/17.
//  Copyright © 2017 Daria. All rights reserved.
//

import UIKit
import MapKit


fileprivate struct Constants {
    static let WeatherForecastViewHeight: CGFloat = UIScreen.main.bounds.size.height
    static let AnimationDuration = 0.5
}


class ViewController: UIViewController, CLLocationManagerDelegate, CityDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var weatherView: WeatherView!
    @IBOutlet weak var weatherForecastView: WeatherForecastView!
    @IBOutlet weak var weatherForecastViewBottomOffset: NSLayoutConstraint!
    
    let locationManager = CLLocationManager()
    var latitude: Double? = 0
    var longitude: Double? = 0
    
    var currentWeatherRequest: APIRequest?
    var forecastRequest: WeatherForecastRequest?
    
    var currentWeatherModel: WeatherModel? {
        didSet {
            if isViewLoaded {
                self.weatherView.fillWithModel(weatherModel: currentWeatherModel)
                self.navigationController?.navigationBar.topItem?.title = currentWeatherModel?.city
            }
        }
    }
    
    var weatherModels: [WeatherModel] = [] {
        didSet {
            self.weatherForecastView.fillWith(currentWeatherModel: self.currentWeatherModel, weatherModels: weatherModels)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = CitiesList.sharedInstance
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        self.weatherForecastViewBottomOffset.constant =  -Constants.WeatherForecastViewHeight
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture(gesture:)))
        swipeDown.direction = .down
        self.weatherForecastView.addGestureRecognizer(swipeDown)
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.down {
            self.showWeatherForecat(NSObject())
        }
    }
    
    
// MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCitySearchViewController" {
            let citySearchViewController = segue.destination as! CitySearchViewController
            citySearchViewController.delegate = self
        }
    }
    
    @IBAction func location(_ sender: Any) {
        latitude = mapView.userLocation.coordinate.latitude
        longitude = mapView.userLocation.coordinate.longitude
        
        if let lat = self.latitude, let lon = self.longitude {
            let initialLocation = CLLocation(latitude: lat, longitude: lon)
            centerMapOnLocation(location: initialLocation)
            
            createRequest(latitude: lat, longitude: lon)
        }
    }
    
    func createRequest(latitude: Double, longitude: Double) {
        currentWeatherRequest = WeatherCoordinateRequest(latitude: latitude, longitude: longitude)
        currentWeatherRequest?.execute { (result, error) in
            self.currentWeatherModel = result as? WeatherModel
        }
        
        forecastRequest = WeatherForecastRequest(latitude: latitude, longitude: longitude)
        forecastRequest?.execute(completion: { [weak self] (result, error) in
            self?.weatherModels = result as? [WeatherModel] ?? []
        })
    }
   
    
    @IBAction func showWeatherForecat(_ sender: Any) {
        self.weatherForecastViewBottomOffset.constant = self.weatherForecastViewBottomOffset.constant == 0 ? -Constants.WeatherForecastViewHeight : 0
        UIView.animate(withDuration: Constants.AnimationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
// MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        mapView.showsUserLocation = (status == .authorizedAlways)
    }
    
// MARK: CityDelegate
    
    func setCoorinates(city: [String : Any]?) {
        let coord = city?["coord"] as? [String : Any]
        latitude = coord?["lat"] as? Double
        longitude = coord?["lon"] as? Double
        
        if let lat = self.latitude, let lon = self.longitude{
            createRequest(latitude: lat, longitude: lon)
            
            let initialLocation = CLLocation(latitude: lat, longitude: lon)
            centerMapOnLocation(location: initialLocation)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            mapView.addAnnotation(annotation)
        }
    }
    
    
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 300000
        let coordinateRegion = MKCoordinateRegion.init(center: location.coordinate,
                                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

