import MapKit
import SwiftUI

extension AdvancedMap: XViewRepresentable {

  public func makeUIView(context: XViewRepresentableContext<AdvancedMap>) -> MKMapView {
    _makeView(context: context)
  }

  public func makeNSView(context: Context) -> MKMapView {
    _makeView(context: context)
  }

  func _makeView(context: XViewRepresentableContext<AdvancedMap>) -> MKMapView {
    logger.debug("Creating MKMapView")
    // Without providing a non-zero frame the user tracking mode is reset to `none`
    // in the delegate after setting on the map.
    // https://stackoverflow.com/questions/61262404/mkmapview-usertrackingmode-reset-in-swiftui
    let newMapView = MKMapView(frame: .init(x: 0, y: 0, width: 1, height: 1))

    context.coordinator.mapView = newMapView
    newMapView.delegate = context.coordinator
    if tapOrClickHandler != nil {
      context.coordinator.addTapOrClickGestureRecognizer(mapView: newMapView)
    }

    if longPressHandler != nil {
      context.coordinator.addLongTapOrClickGestureRecognizer(mapView: newMapView)
    }

    annotationViewFactory?.register(in: newMapView)
    return newMapView
  }

  public func updateNSView(
    _ mapView: MKMapView,
    context: XViewRepresentableContext<AdvancedMap>
  ) {
    update(mapView, context: context)
  }

  public func updateUIView(
    _ mapView: MKMapView,
    context: XViewRepresentableContext<AdvancedMap>
  ) {
    update(mapView, context: context)
  }

  public func makeCoordinator() -> Coordinator {
    return Coordinator(advancedMap: self)
  }

  func update(_ mapView: MKMapView, context: Context) {
    if let visibleMapRect,
        !context.coordinator.isChangingRegion,
        mapView.visibleMapRect != visibleMapRect,
        userTrackingMode == .none {
      mapView.setVisibleMapRect(visibleMapRect, edgePadding: edgeInsets, animated: context.shouldAnimateChanges)
    }
    switch mapConfiguration {
    case let .standard(emphasisStyle, elevationStyle, pointOfInterestFilter, showsTraffic):
      let style = MKStandardMapConfiguration(elevationStyle: elevationStyle, emphasisStyle: emphasisStyle)
      style.pointOfInterestFilter = pointOfInterestFilter
      style.showsTraffic = showsTraffic
      mapView.preferredConfiguration = style
    case let .hybrid(elevationStyle, pointOfInterestFilter, showsTraffic):
      let style = MKHybridMapConfiguration(elevationStyle: elevationStyle)
      style.pointOfInterestFilter = pointOfInterestFilter
      style.showsTraffic = showsTraffic
      mapView.preferredConfiguration = style
    case let .imagery(elevationStyle):
      let style = MKImageryMapConfiguration(elevationStyle: elevationStyle)
      mapView.preferredConfiguration = style
    case .none:
      break
    }

    // Commmon
    mapView.showsUserLocation = showsUserLocation
    mapView.isZoomEnabled = isZoomEnabled
    mapView.isScrollEnabled = isScrollEnabled

    // iOS or macOS
    #if os(iOS) || os(macOS)
    mapView.isRotateEnabled = isRotationEnabled
    mapView.isPitchEnabled = isPitchEnabled
    mapView.showsCompass = showsCompass
    if mapView.userTrackingMode != userTrackingMode {
      mapView.setUserTrackingMode(userTrackingMode, animated: false)
    }
    #endif

    // iOS or tvOS
    #if os(iOS) || os(tvOS)
    // Setting this to `true` crashes on macOS.. as of Xcode 14.1
    mapView.showsScale = showsScale
    #endif

    // macOS Only
    #if os(macOS)
    mapView.showsPitchControl = showsPitchControl
    mapView.showsZoomControls = showsZoomControls
    #endif

    mapView.annotations.forEach { annotation in
      if !annotations.contains(where: { $0.isEqual(annotation) }) {
        mapView.removeAnnotation(annotation)
      }
    }
    annotations.forEach { annotation in
      if !mapView.annotations.contains(where: { $0.isEqual(annotation) }) {
        mapView.addAnnotation(annotation)
      }
    }

    mapView.overlays.forEach { overlay in
      if !overlays.contains(where: { $0.isEqual(overlay) }) {
        mapView.removeOverlay(overlay)
      }
    }
    overlays.forEach { overlay in
      if !mapView.overlays.contains(where: { $0.isEqual(overlay) }) {
        mapView.addOverlay(overlay)
      }
    }
  }
}
