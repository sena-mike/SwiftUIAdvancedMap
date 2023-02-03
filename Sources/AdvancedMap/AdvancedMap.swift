import CoreLocation
import MapKit
import SwiftUI

public struct AdvancedMap {

  public typealias DidTapOrClickMapHandler = (CLLocationCoordinate2D) -> Void
  public typealias LongPressMapHandler = DidTapOrClickMapHandler
  #if os(iOS) || os(macOS)
  public typealias AnnotationDragHandler = (
    _ annotation: MKAnnotation,
    _ location: CLLocationCoordinate2D,
    _ oldState: MKAnnotationView.DragState,
    _ newState: MKAnnotationView.DragState
  ) -> Void
  #endif
  public typealias RegionChangingHandler = (_ changing: Bool, _ animated: Bool) -> Void

  @Environment(\.mapConfiguration) var mapConfiguration

  @Binding public var visibleMapRect: MKMapRect?
  #if os(iOS) || os(macOS)
  @Binding public var userTrackingMode: MKUserTrackingMode
  #endif

  public init(
    mapRect: Binding<MKMapRect?>,
    userTrackingMode: Binding<MKUserTrackingMode> = .constant(MKUserTrackingMode.none)
  ) {
    self._visibleMapRect = mapRect
    self._userTrackingMode = userTrackingMode
  }

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
