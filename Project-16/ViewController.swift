//
//  ViewController.swift
//  Project-16
//
//  Created by Serhii Prysiazhnyi on 14.11.2024.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    var cities = [Capital]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showMapTypeSelection()
        
        loadSity()
        
        /* альтернатива, без json
         let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
         let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
         let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
         let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
         let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
         
         mapView.addAnnotation(london)
         mapView.addAnnotation(oslo)
         mapView.addAnnotation(paris)
         mapView.addAnnotation(rome)
         mapView.addAnnotation(washington)
         */
        
        // mapView.addAnnotations([london, oslo, paris, rome, washington]) // альтернатива
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 1
        guard annotation is Capital else { return nil }
        
        // 2
        let identifier = "Capital"
        
        // 3
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            //4
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            // 5
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
            
            // Изменяем цвет маркера
            if let markerAnnotationView = annotationView as? MKMarkerAnnotationView {
                markerAnnotationView.markerTintColor = .yellow
            }
        } else {
            // 6
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        let placeName = capital.title
        let placeInfo = capital.info
        
        let vc = DetailWebViewController()
        vc.infoCountry = capital.title
        navigationController?.pushViewController(vc, animated: true)
        
        //        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        //        ac.addAction(UIAlertAction(title: "OK", style: .default))
        //        present(ac, animated: true)
    }
    
    func showMapTypeSelection() {
        // Создаём UIAlertController с вариантами выбора типа карты
        let alert = UIAlertController(title: "Choose Map Type", message: "Select the map type you prefer", preferredStyle: .actionSheet)
        
        // Добавляем действия для разных типов карт
        alert.addAction(UIAlertAction(title: "Standard", style: .default, handler: { _ in
            self.mapView.mapType = .standard
        }))
        
        alert.addAction(UIAlertAction(title: "Satellite", style: .default, handler: { _ in
            self.mapView.mapType = .satellite
        }))
        
        alert.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: { _ in
            self.mapView.mapType = .hybrid
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Показываем UIAlertController
        present(alert, animated: true, completion: nil)
    }
    
    func loadSity() {
        
        DispatchQueue.global().async {
            // Получаем путь к файлу в bundle приложения
            if let url = Bundle.main.url(forResource: "localCountries", withExtension: "json") {
                
                do {
                    // Читаем данные из файла
                    let data = try Data(contentsOf: url)
                    
                    // Декодируем данные в массив объектов типа Capital
                    let decoder = JSONDecoder()
                    let cities = try decoder.decode([Capital].self, from: data)
                    
                  // Печатаем загруженные данные в консоль для проверки
//                    print("Loaded items: \(cities[0].title)") // Выводим первый объект как пример
                    
                    // Переходим на главный поток для обновления UI
                    DispatchQueue.main.async { [weak self] in
                        // Добавляем аннотации на карту
                        self?.mapView.addAnnotations(cities)
                    }
                    
                } catch {
                    // Обработка ошибок
                    print("Error loading or decoding JSON: \(error)")
                }
            }
        }
    }
    
}

