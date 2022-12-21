import CoreLocation
import MapKit
import SwiftUI
import OSLog

#if os(iOS) || os(tvOS)
public typealias XEdgeInsets = UIEdgeInsets
#else
public typealias XEdgeInsets = NSEdgeInsets
#endif

let logger = Logger(subsystem: "com.msena.SwiftUIAdvancedMap", category: "AdvancedMap")

public struct AdvancedMap {

  public typealias DidTapOrClickMapHandler = (CLLocationCoordinate2D) -> Void
  public typealias AnnotationDragHandler = (
    _ annotation: MKAnnotation,
    _ location: CLLocationCoordinate2D,
    _ oldState: MKAnnotationView.DragState,
    _ newState: MKAnnotationView.DragState
  ) -> Void
  public typealias RegionStateChangingHandler = (_ changing: Bool, _ animated: Bool) -> Void

  @Binding public var visibleMapRect: MKMapRect?
  let edgeInsets: XEdgeInsets
  let animateChanges: Bool
  let showsUserLocation: Bool
  let annotations: [MKAnnotation]
  let annotationViewFactory: AnnotationViewFactory
  let overlays: [MKOverlay]
  let overlayRendererFactory: OverlayRendererFactory

  var tapOrClickHandler: DidTapOrClickMapHandler
  var annotationDragHandler: AnnotationDragHandler
  var regionStateChangingHandler: RegionStateChangingHandler

  public init(
    mapRect: Binding<MKMapRect?>,
    edgeInsets: XEdgeInsets = .init(),
    animateChanges: Bool = false,
    showsUserLocation: Bool = false,
    annotations: [MKAnnotation] = [],
    annotationViewFactory: AnnotationViewFactory = .empty,
    overlays: [MKOverlay] = [],
    overlayRendererFactory: OverlayRendererFactory = .empty,
    tapOrClickHandler: @escaping DidTapOrClickMapHandler = { _ in },
    annotationDragHandler: @escaping AnnotationDragHandler = { _, _, _, _ in },
    regionStateChangingHandler: @escaping RegionStateChangingHandler = { _, _ in }
  ) {
    self._visibleMapRect = mapRect
    self.edgeInsets = edgeInsets
    self.animateChanges = animateChanges
    self.showsUserLocation = showsUserLocation
    self.annotations = annotations
    self.annotationViewFactory = annotationViewFactory
    self.overlays = overlays
    self.overlayRendererFactory = overlayRendererFactory
    self.tapOrClickHandler = tapOrClickHandler
    self.annotationDragHandler = annotationDragHandler
    self.regionStateChangingHandler = regionStateChangingHandler
  }

  public func makeCoordinator() -> Coordinator {
    return Coordinator(advancedMap: self)
  }

  func update(_ mapView: MKMapView, context: Context) {

    if let visibleMapRect, !context.coordinator.isChangingRegion {
      mapView.setVisibleMapRect(visibleMapRect, edgePadding: edgeInsets, animated: animateChanges)
    }

    mapView.showsUserLocation = showsUserLocation

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

#if os(macOS)
extension AdvancedMap: NSViewRepresentable {
  public func makeNSView(context: NSViewRepresentableContext<AdvancedMap>) -> MKMapView {
    logger.debug("Creating MKMapView")
    let newMapView = MKMapView()

    newMapView.delegate = context.coordinator
    context.coordinator.addGestureRecognizer(mapView: newMapView)
    annotationViewFactory.register(in: newMapView)

    return newMapView
  }

  public func updateNSView(_ mapView: MKMapView, context: NSViewRepresentableContext<AdvancedMap>) {
    update(mapView, context: context)
  }
}
#endif

#if os(iOS)
extension AdvancedMap: UIViewRepresentable {

  public func makeUIView(context: UIViewRepresentableContext<AdvancedMap>) -> MKMapView {
    logger.debug("Creating MKMapView")
    let newMapView = MKMapView()

    newMapView.delegate = context.coordinator
    context.coordinator.addGestureRecognizer(mapView: newMapView)
    annotationViewFactory.register(in: newMapView)

    return newMapView
  }

  public func updateUIView(
    _ mapView: MKMapView,
    context: UIViewRepresentableContext<AdvancedMap>
  ) {
    update(mapView, context: context)
  }
}
#endif
