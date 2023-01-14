import CoreLocation
import MapKit
import SwiftUI

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

  let configuration: Configuration?
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
}

// MARK: - Initializers

extension AdvancedMap {
#if os(iOS)
  public init(
    configuration: Configuration? = nil,
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
    self.configuration = configuration
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
    configuration: Configuration? = nil,
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
    self.configuration = configuration
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
    configuration: Configuration? = nil,
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
    self.configuration = configuration
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
    configuration: Configuration? = nil,
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
    self.configuration = configuration
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
    configuration: Configuration? = nil,
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
    self.configuration = configuration
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
    configuration: Configuration? = nil,
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
    self.configuration = configuration
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
}
