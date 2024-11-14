//
//  Capital.swift
//  Project-16
//
//  Created by Serhii Prysiazhnyi on 14.11.2024.
//

import MapKit
import UIKit

// Capital теперь является классом, так как MKAnnotation требует класса
class Capital: NSObject, MKAnnotation, Decodable {
    
    var id: Int
    var title: String?
    var info: String
    var coordinate: CLLocationCoordinate2D

    // Инициализатор для класса
    init(id: Int, title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.id = id
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
    
    // Структура для координат, которая соответствует Decodable
    struct Coordinate: Decodable {
        var latitude: Double
        var longitude: Double
        
        enum CodingKeys: String, CodingKey {
            case latitude
            case longitude
        }
        
        // Инициализатор для преобразования в CLLocationCoordinate2D
        func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    // Для декодирования
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        info = try container.decode(String.self, forKey: .info)
        
        // Декодируем координаты
        let coordinateData = try container.decode(Coordinate.self, forKey: .coordinate)
        coordinate = coordinateData.toCLLocationCoordinate2D()  // Преобразуем в CLLocationCoordinate2D
    }
    
    // CodingKeys для декодирования
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case coordinate
        case info
    }
}

