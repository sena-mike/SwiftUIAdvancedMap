import MapKit

extension MKMapRect: Equatable {
  public static func == (lhs: MKMapRect, rhs: MKMapRect) -> Bool {
    return lhs.origin == rhs.origin && lhs.size == rhs.size
  }

}

extension MKMapPoint: Equatable {
  public static func == (lhs: MKMapPoint, rhs: MKMapPoint) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
  }
}

extension MKMapSize: Equatable {
  public static func == (lhs: MKMapSize, rhs: MKMapSize) -> Bool {
    return lhs.width == rhs.width
  }
}

extension CLLocationCoordinate2D: Equatable {
  public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.longitude == rhs.longitude
    && lhs.latitude == rhs.latitude
  }
}
