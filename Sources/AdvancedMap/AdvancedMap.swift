import CoreLocation
import MapKit
import SwiftUI

public enum MapVisibility {
  case region(MKCoordinateRegion)
  case centerCoordinate(CLLocationCoordinate2D)
  case visibleMapRect(MKMapRect)
  case annotations([MKAnnotation])
  case camera(MKMapCamera)
}

public struct AdvancedMap {

  public typealias DidTapOrClickMapHandler = (CLLocationCoordinate2D) -> Void
  public typealias LongPressMapHandler = DidTapOrClickMapHandler
  public typealias RegionChangingHandler = (_ changing: Bool, _ animated: Bool) -> Void

#if os(iOS) || os(macOS)
  public typealias AnnotationDragHandler = (
    _ annotation: MKAnnotation,
    _ location: CLLocationCoordinate2D,
    _ oldState: MKAnnotationView.DragState,
    _ newState: MKAnnotationView.DragState
  ) -> Void
  #endif

  @Environment(\.mapConfiguration) var mapConfiguration

  /// Use `mapVisibility` to control what is currently visible on the map. Set values to this binding to change the map
  /// programmatically, when the user pans around, zooms or tilts the map the binding is written to by the Map.
  ///
  /// Currently there is no way to fetch a different kind of `MapVisibility` value from the map, the map will only write in the same
  /// case of the enum it received. However, if `nil` is passed initially the map **will** begin writing out the `.centerCoordinate`
  /// case as the user moves the map.
  @Binding public var mapVisibility: MapVisibility?

  #if os(iOS) || os(macOS)
  @Binding public var userTrackingMode: MKUserTrackingMode
  #endif

  @Environment(\.edgeInsets) var edgeInsets
  @Environment(\.showsUserLocation) var showsUserLocation
  @Environment(\.isZoomEnabled) var isZoomEnabled
  @Environment(\.isScrollEnabled) var isScrollEnabled
  @Environment(\.isRotationEnabled) var isRotationEnabled
  @Environment(\.isPitchEnabled) var isPitchEnabled
  #if os(macOS)
  @Environment(\.showsPitchControl) var showsPitchControl
  @Environment(\.showsZoomControls) var showsZoomControls
  #endif
  @Environment(\.showsCompass) var showsCompass
  @Environment(\.showsScale) var showsScale
  @Environment(\.mapAnnotations) var annotations
  @Environment(\.annotationViewFactory) var annotationViewFactory
  @Environment(\.mapOverlays) var overlays
  @Environment(\.overlayRendererFactory) var overlayRendererFactory
  @Environment(\.onTapOrClickGesture) var tapOrClickHandler
  @Environment(\.onLongPressMapGesture) var longPressHandler
  #if os(iOS) || os(macOS)
  @Environment(\.onAnnotationDragGesture) var annotationDragHandler
  #endif
  @Environment(\.mapRegionChangingHandler) var regionChangingHandler
}

extension AdvancedMap {
  #if os(tvOS)
  public init(mapVisibility: Binding<MapVisibility?>) {
    self._mapVisibility = mapVisibility
  }
  #else
  public init(
    mapVisibility: Binding<MapVisibility?>,
    userTrackingMode: Binding<MKUserTrackingMode> = .constant(MKUserTrackingMode.none)
  ) {
    self._mapVisibility = mapVisibility
    self._userTrackingMode = userTrackingMode
  }
  #endif
}
