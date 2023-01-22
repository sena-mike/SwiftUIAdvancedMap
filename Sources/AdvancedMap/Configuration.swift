import MapKit

public enum Configuration: Hashable {
  case standard(
    _ emphasisStyle: MKStandardMapConfiguration.EmphasisStyle,
    _ elevationStyle: MKMapConfiguration.ElevationStyle,
    _ pointOfInterestFilter: MKPointOfInterestFilter,
    _ showsTraffic: Bool
  )
  case hybrid(
    _ elevationStyle: MKMapConfiguration.ElevationStyle,
    _ pointOfInterestFilter: MKPointOfInterestFilter,
    _ showsTraffic: Bool
  )
  case imagery(
    _ elevationStyle: MKMapConfiguration.ElevationStyle
  )
}
