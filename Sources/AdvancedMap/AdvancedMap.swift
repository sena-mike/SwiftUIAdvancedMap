import CoreLocation
import MapKit
import SwiftUI
import OSLog

#if os(iOS) || os(tvOS)
public typealias XEdgeInsets = UIEdgeInsets
public typealias XViewRepresentableContext = UIViewRepresentableContext
#else
public typealias XEdgeInsets = NSEdgeInsets
public typealias XViewRepresentableContext = NSViewRepresentableContext
#endif

let logger = Logger(subsystem: "com.msena.SwiftUIAdvancedMap", category: "AdvancedMap")

extension XViewRepresentableContext<AdvancedMap> {
  var shouldAnimateChanges: Bool {
    return !transaction.disablesAnimations
  }
}

public struct AdvancedMap {

  public typealias DidTapOrClickMapHandler = (CLLocationCoordinate2D) -> Void
  #if os(iOS) || os(macOS)
  public typealias AnnotationDragHandler = (
    _ annotation: MKAnnotation,
    _ location: CLLocationCoordinate2D,
    _ oldState: MKAnnotationView.DragState,
    _ newState: MKAnnotationView.DragState
  ) -> Void
  #endif
  public typealias RegionChangingHandler = (_ changing: Bool, _ animated: Bool) -> Void

  @Binding public var visibleMapRect: MKMapRect?
  #if os(iOS) || os(macOS)
  @Binding public var userTrackingMode: MKUserTrackingMode
  #endif
  let edgeInsets: XEdgeInsets
  let showsUserLocation: Bool
  let isZoomEnabled: Bool
  let isScrollEnabled: Bool
  let isRotateEnabled: Bool
  let isPitchEnabled: Bool
  #if os(macOS)
  let showsPitchControl: Bool
  let showsZoomControls: Bool
  #endif
  let showsCompass: Bool
  let showsScale: Bool
  let annotations: [MKAnnotation]
  let annotationViewFactory: AnnotationViewFactory
  let overlays: [MKOverlay]
  let overlayRendererFactory: OverlayRendererFactory
  let tapOrClickHandler: DidTapOrClickMapHandler?

  #if os(iOS) || os(macOS)
  var annotationDragHandler: AnnotationDragHandler
  #endif
  var regionChangingHandler: RegionChangingHandler

  #if os(iOS)
  public init(
    mapRect: Binding<MKMapRect?>,
    userTrackingMode: Binding<MKUserTrackingMode> = .constant(MKUserTrackingMode.none),
    edgeInsets: XEdgeInsets = .init(),
    showsUserLocation: Bool = false,
    isZoomEnabled: Bool = true,
    isScrollEnabled: Bool = true,
    isRotateEnabled: Bool = true,
    isPitchEnabled: Bool = true,
    showsCompass: Bool = false,
    showsScale: Bool = false,
    annotations: [MKAnnotation] = [],
    annotationViewFactory: AnnotationViewFactory = .empty,
    overlays: [MKOverlay] = [],
    overlayRendererFactory: OverlayRendererFactory = .empty,
    annotationDragHandler: @escaping AnnotationDragHandler = { _, _, _, _ in },
    regionChangingHandler: @escaping RegionChangingHandler = { _, _ in }
  ) {
    self._visibleMapRect = mapRect
    self._userTrackingMode = userTrackingMode
    self.edgeInsets = edgeInsets
    self.showsUserLocation = showsUserLocation
    self.isZoomEnabled = isZoomEnabled
    self.isScrollEnabled = isScrollEnabled
    self.isRotateEnabled = isRotateEnabled
    self.isPitchEnabled = isPitchEnabled
    self.showsCompass = showsCompass
    self.showsScale = showsScale
    self.annotations = annotations
    self.annotationViewFactory = annotationViewFactory
    self.overlays = overlays
    self.overlayRendererFactory = overlayRendererFactory
    self.tapOrClickHandler = nil
    self.annotationDragHandler = annotationDragHandler
    self.regionChangingHandler = regionChangingHandler
  }
  public init(
    mapRect: Binding<MKMapRect?>,
    userTrackingMode: Binding<MKUserTrackingMode> = .constant(MKUserTrackingMode.none),
    edgeInsets: XEdgeInsets = .init(),
    showsUserLocation: Bool = false,
    isZoomEnabled: Bool = true,
    isScrollEnabled: Bool = true,
    isRotateEnabled: Bool = true,
    isPitchEnabled: Bool = true,
    showsCompass: Bool = false,
    showsScale: Bool = false,
    annotations: [MKAnnotation] = [],
    annotationViewFactory: AnnotationViewFactory = .empty,
    overlays: [MKOverlay] = [],
    overlayRendererFactory: OverlayRendererFactory = .empty,
    tapOrClickHandler: @escaping DidTapOrClickMapHandler = { _ in },
    annotationDragHandler: @escaping AnnotationDragHandler = { _, _, _, _ in },
    regionChangingHandler: @escaping RegionChangingHandler = { _, _ in }
  ) {
    self._visibleMapRect = mapRect
    self._userTrackingMode = userTrackingMode
    self.edgeInsets = edgeInsets
    self.showsUserLocation = showsUserLocation
    self.isZoomEnabled = isZoomEnabled
    self.isScrollEnabled = isScrollEnabled
    self.isRotateEnabled = isRotateEnabled
    self.isPitchEnabled = isPitchEnabled
    self.showsCompass = showsCompass
    self.showsScale = showsScale
    self.annotations = annotations
    self.annotationViewFactory = annotationViewFactory
    self.overlays = overlays
    self.overlayRendererFactory = overlayRendererFactory
    self.tapOrClickHandler = tapOrClickHandler
    self.annotationDragHandler = annotationDragHandler
    self.regionChangingHandler = regionChangingHandler
  }
  #elseif os(macOS)
  public init(
    mapRect: Binding<MKMapRect?>,
    userTrackingMode: Binding<MKUserTrackingMode> = .constant(MKUserTrackingMode.none),
    edgeInsets: XEdgeInsets = .init(),
    showsUserLocation: Bool = false,
    isZoomEnabled: Bool = true,
    isScrollEnabled: Bool = true,
    isRotateEnabled: Bool = true,
    isPitchEnabled: Bool = true,
    showsPitchControl: Bool = false,
    showsZoomControls: Bool = false,
    showsCompass: Bool = false,
    showsScale: Bool = false,
    annotations: [MKAnnotation] = [],
    annotationViewFactory: AnnotationViewFactory = .empty,
    overlays: [MKOverlay] = [],
    overlayRendererFactory: OverlayRendererFactory = .empty,
    annotationDragHandler: @escaping AnnotationDragHandler = { _, _, _, _ in },
    regionChangingHandler: @escaping RegionChangingHandler = { _, _ in }
  ) {
    self._visibleMapRect = mapRect
    self._userTrackingMode = userTrackingMode
    self.edgeInsets = edgeInsets
    self.showsUserLocation = showsUserLocation
    self.isZoomEnabled = isZoomEnabled
    self.isScrollEnabled = isScrollEnabled
    self.isRotateEnabled = isRotateEnabled
    self.isPitchEnabled = isPitchEnabled
    self.showsPitchControl = showsPitchControl
    self.showsZoomControls = showsZoomControls
    self.showsCompass = showsCompass
    self.showsScale = showsScale
    self.annotations = annotations
    self.annotationViewFactory = annotationViewFactory
    self.overlays = overlays
    self.overlayRendererFactory = overlayRendererFactory
    self.tapOrClickHandler = nil
    self.annotationDragHandler = annotationDragHandler
    self.regionChangingHandler = regionChangingHandler
  }
  public init(
    mapRect: Binding<MKMapRect?>,
    userTrackingMode: Binding<MKUserTrackingMode> = .constant(MKUserTrackingMode.none),
    edgeInsets: XEdgeInsets = .init(),
    showsUserLocation: Bool = false,
    isZoomEnabled: Bool = true,
    isScrollEnabled: Bool = true,
    isRotateEnabled: Bool = true,
    isPitchEnabled: Bool = true,
    showsPitchControl: Bool = false,
    showsZoomControls: Bool = false,
    showsCompass: Bool = false,
    showsScale: Bool = false,
    annotations: [MKAnnotation] = [],
    annotationViewFactory: AnnotationViewFactory = .empty,
    overlays: [MKOverlay] = [],
    overlayRendererFactory: OverlayRendererFactory = .empty,
    tapOrClickHandler: @escaping DidTapOrClickMapHandler = { _ in },
    annotationDragHandler: @escaping AnnotationDragHandler = { _, _, _, _ in },
    regionChangingHandler: @escaping RegionChangingHandler = { _, _ in }
  ) {
    self._visibleMapRect = mapRect
    self._userTrackingMode = userTrackingMode
    self.edgeInsets = edgeInsets
    self.showsUserLocation = showsUserLocation
    self.isZoomEnabled = isZoomEnabled
    self.isScrollEnabled = isScrollEnabled
    self.isRotateEnabled = isRotateEnabled
    self.isPitchEnabled = isPitchEnabled
    self.showsPitchControl = showsPitchControl
    self.showsZoomControls = showsZoomControls
    self.showsCompass = showsCompass
    self.showsScale = showsScale
    self.annotations = annotations
    self.annotationViewFactory = annotationViewFactory
    self.overlays = overlays
    self.overlayRendererFactory = overlayRendererFactory
    self.tapOrClickHandler = tapOrClickHandler
    self.annotationDragHandler = annotationDragHandler
    self.regionChangingHandler = regionChangingHandler
  }
  #elseif os(tvOS)
  public init(
    mapRect: Binding<MKMapRect?>,
    edgeInsets: XEdgeInsets = .init(),
    showsUserLocation: Bool = false,
    isZoomEnabled: Bool = true,
    isScrollEnabled: Bool = true,
    isRotateEnabled: Bool = true,
    isPitchEnabled: Bool = true,
    showsPitchControl: Bool = false,
    showsZoomControls: Bool = false,
    showsCompass: Bool = false,
    showsScale: Bool = false,
    annotations: [MKAnnotation] = [],
    annotationViewFactory: AnnotationViewFactory = .empty,
    overlays: [MKOverlay] = [],
    overlayRendererFactory: OverlayRendererFactory = .empty,
    regionChangingHandler: @escaping RegionChangingHandler = { _, _ in }
  ) {
    self._visibleMapRect = mapRect
    self.edgeInsets = edgeInsets
    self.showsUserLocation = showsUserLocation
    self.isZoomEnabled = isZoomEnabled
    self.isScrollEnabled = isScrollEnabled
    self.isRotateEnabled = isRotateEnabled
    self.isPitchEnabled = isPitchEnabled
    self.showsCompass = showsCompass
    self.showsScale = showsScale
    self.annotations = annotations
    self.annotationViewFactory = annotationViewFactory
    self.overlays = overlays
    self.tapOrClickHandler = nil
    self.overlayRendererFactory = overlayRendererFactory
    self.regionChangingHandler = regionChangingHandler
  }
  public init(
    mapRect: Binding<MKMapRect?>,
    edgeInsets: XEdgeInsets = .init(),
    showsUserLocation: Bool = false,
    isZoomEnabled: Bool = true,
    isScrollEnabled: Bool = true,
    isRotateEnabled: Bool = true,
    isPitchEnabled: Bool = true,
    showsPitchControl: Bool = false,
    showsZoomControls: Bool = false,
    showsCompass: Bool = false,
    showsScale: Bool = false,
    annotations: [MKAnnotation] = [],
    annotationViewFactory: AnnotationViewFactory = .empty,
    overlays: [MKOverlay] = [],
    overlayRendererFactory: OverlayRendererFactory = .empty,
    tapOrClickHandler: @escaping DidTapOrClickMapHandler = { _ in },
    regionChangingHandler: @escaping RegionChangingHandler = { _, _ in }
  ) {
    self._visibleMapRect = mapRect
    self.edgeInsets = edgeInsets
    self.showsUserLocation = showsUserLocation
    self.isZoomEnabled = isZoomEnabled
    self.isScrollEnabled = isScrollEnabled
    self.isRotateEnabled = isRotateEnabled
    self.isPitchEnabled = isPitchEnabled
    self.showsCompass = showsCompass
    self.showsScale = showsScale
    self.annotations = annotations
    self.annotationViewFactory = annotationViewFactory
    self.overlays = overlays
    self.overlayRendererFactory = overlayRendererFactory
    self.tapOrClickHandler = tapOrClickHandler
    self.regionChangingHandler = regionChangingHandler
  }
  #endif

  public func makeCoordinator() -> Coordinator {
    return Coordinator(advancedMap: self)
  }

  func update(_ mapView: MKMapView, context: Context) {
    if let visibleMapRect, !context.coordinator.isChangingRegion {
      mapView.setVisibleMapRect(visibleMapRect, edgePadding: edgeInsets, animated: context.shouldAnimateChanges)
    }
    // Commmon
    mapView.showsUserLocation = showsUserLocation
    mapView.isZoomEnabled = isZoomEnabled
    mapView.isScrollEnabled = isScrollEnabled

    // iOS or macOS
    #if os(iOS) || os(macOS)
    mapView.isRotateEnabled = isRotateEnabled
    mapView.isPitchEnabled = isPitchEnabled
    mapView.showsCompass = showsCompass
    if mapView.userTrackingMode != userTrackingMode {
      mapView.setUserTrackingMode(userTrackingMode, animated: context.shouldAnimateChanges)
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

#if os(macOS)
extension AdvancedMap: NSViewRepresentable {
  public func makeNSView(context: NSViewRepresentableContext<AdvancedMap>) -> MKMapView {
    logger.debug("Creating MKMapView")
    let newMapView = MKMapView()

    newMapView.delegate = context.coordinator
    if tapOrClickHandler != nil {
      context.coordinator.addGestureRecognizer(mapView: newMapView)
    }
    annotationViewFactory.register(in: newMapView)

    return newMapView
  }

  public func updateNSView(_ mapView: MKMapView, context: NSViewRepresentableContext<AdvancedMap>) {
    update(mapView, context: context)
  }
}
#endif

#if os(iOS) || os(tvOS)
extension AdvancedMap: UIViewRepresentable {

  public func makeUIView(context: UIViewRepresentableContext<AdvancedMap>) -> MKMapView {
    logger.debug("Creating MKMapView")
    let newMapView = MKMapView()

    newMapView.delegate = context.coordinator
    if tapOrClickHandler != nil {
      context.coordinator.addGestureRecognizer(mapView: newMapView)
    }
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
