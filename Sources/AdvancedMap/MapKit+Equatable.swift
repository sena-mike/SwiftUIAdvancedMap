import MapKit

extension MKMapRect: Equatable {
  public static func == (lhs: MKMapRect, rhs: MKMapRect) -> Bool {
    return lhs.origin == rhs.origin && lhs.size == rhs.size
  }
}

extension MKMapPoint: Equatable {
  public static func == (lhs: MKMapPoint, rhs: MKMapPoint) -> Bool {
    return (lhs.x ==~ rhs.x) && (lhs.y ==~ rhs.y)
  }
}

extension MKMapSize: Equatable {
  public static func == (lhs: MKMapSize, rhs: MKMapSize) -> Bool {
    return lhs.width ==~ rhs.width
  }
}

extension CLLocationCoordinate2D: Equatable {
  public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return (lhs.latitude ==~ rhs.latitude) && (lhs.longitude ==~ rhs.longitude)
  }
}

extension MKCoordinateRegion: Equatable {
  public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
    lhs.center == rhs.center && lhs.span == rhs.span
  }
}

extension MKCoordinateSpan: Equatable {
  public static func == (lhs: MKCoordinateSpan, rhs: MKCoordinateSpan) -> Bool {
    lhs.latitudeDelta == rhs.latitudeDelta && rhs.longitudeDelta == rhs.longitudeDelta
  }
}


extension CLLocationDistance {
  static let oneHundredKm = 100_000.0
  static let mapEqualityPrecision = 1e-7
}

infix operator ==~ : AssignmentPrecedence
public func ==~ (left: Double, right: Double) -> Bool
{
  return fabs(left.distance(to: right)) <= .mapEqualityPrecision
}
