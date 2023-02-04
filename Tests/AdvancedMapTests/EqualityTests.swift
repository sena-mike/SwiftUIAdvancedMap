@testable import AdvancedMap
import CoreGraphics
import MapKit
import XCTest

final class EqualityTests: XCTestCase {
  func testDirectEquality() {
    XCTAssertEqual(CLLocationCoordinate2D.newYork.latitude, CLLocationCoordinate2D.newYork.latitude)
    XCTAssertEqual(CLLocationCoordinate2D.newYork, CLLocationCoordinate2D.newYork)
  }

  func testPrecisionIsReasonable() {
    let nullIsland = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    // We only support 7 points past the decimal in precision
    let nullIslandAdjusted = CLLocationCoordinate2D(latitude: 0.0000001, longitude: 0.0000001)

    let distance = CLLocation(latitude: nullIsland.latitude, longitude: nullIsland.longitude)
      .distance(from: CLLocation(latitude: nullIslandAdjusted.latitude, longitude: nullIslandAdjusted.longitude))
    XCTAssert(distance < 0.02) // less than 2 cm accuracy

    XCTAssertEqual(nullIslandAdjusted, CLLocationCoordinate2D(latitude: 0.00000001, longitude: 0.00000001))
  }
}

extension CLLocationCoordinate2D {
  init(north: CLLocationDegrees, west: CLLocationDegrees) {
    self.init(latitude: north, longitude: -west)
  }

  static let newYork = CLLocationCoordinate2D(north: 40.74850, west: 73.98557)
  static let losAngeles = CLLocationCoordinate2D(north: 34.0, west: 118.2)
  static let applePark = CLLocationCoordinate2D(north: 37.33759, west: 122.01423)
}

