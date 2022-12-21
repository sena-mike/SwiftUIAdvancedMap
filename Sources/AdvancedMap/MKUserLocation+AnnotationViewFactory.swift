import MapKit

extension MKUserLocation {

  public override func isEqual(_ object: Any?) -> Bool {
    guard let other = object as? Self else { return false }
#if os(iOS) || os(macOS)
    return isUpdating == other.isUpdating &&
      location == other.location &&
      heading == other.heading &&
      title == other.title &&
      subtitle == other.subtitle
#else
    return isUpdating == other.isUpdating &&
      location == other.location &&
      title == other.title &&
      subtitle == other.subtitle
#endif
  }

  public static let mkUserLocationViewFactory = AnnotationViewFactory.factory(for: MKUserLocation.self, MKUserLocationView.self)
}
