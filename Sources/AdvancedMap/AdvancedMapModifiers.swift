import MapKit
import SwiftUI

struct ConfigurationKey: EnvironmentKey {
  static let defaultValue: Configuration? = nil
}

struct EdgeInsetsKey: EnvironmentKey {
  static let defaultValue: XEdgeInsets = .init()
}

struct ShowsUserLocationKey: EnvironmentKey {
  static let defaultValue: Bool = false
}

struct IsZoomEnabledKey: EnvironmentKey {
  static let defaultValue: Bool = true
}

struct IsScrollEnabledKey: EnvironmentKey {
  static let defaultValue: Bool = true
}

struct IsRotationEnabledKey: EnvironmentKey {
  static let defaultValue: Bool = true
}

struct IsPitchEnabledKey: EnvironmentKey {
  static let defaultValue: Bool = true
}

struct ShowsPitchControlKey: EnvironmentKey {
  static let defaultValue: Bool = false
}

struct ShowsZoomControlsKey: EnvironmentKey {
  static let defaultValue: Bool = false
}

struct ShowsCompassKey: EnvironmentKey {
  static let defaultValue: Bool = false
}

struct ShowsScaleKey: EnvironmentKey {
  static let defaultValue: Bool = false
}

struct MapAnnotationsKey: EnvironmentKey {
  static let defaultValue: [MKAnnotation] = []
}

struct MapAnnotationViewFactoryKey: EnvironmentKey {
  static let defaultValue: AnnotationViewFactory? = nil
}

struct MapOverlaysKey: EnvironmentKey {
  static let defaultValue: [MKOverlay] = []
}

struct MapOverlayRendererFactoryKey: EnvironmentKey {
  static let defaultValue: OverlayRendererFactory? = nil
}

struct OnTapOrClickMapGestureKey: EnvironmentKey {
  static let defaultValue: AdvancedMap.DidTapOrClickMapHandler? = nil
}

struct OnLongPressMapGestureKey: EnvironmentKey {
  static let defaultValue: AdvancedMap.LongPressMapHandler? = nil
}

struct OnAnnotationDragGestureKey: EnvironmentKey {
  static let defaultValue: AdvancedMap.AnnotationDragHandler? = nil
}

struct OnMapRegionChangingHandlerKey: EnvironmentKey {
  static let defaultValue: AdvancedMap.RegionChangingHandler? = nil
}

extension EnvironmentValues {
  var mapConfiguration: Configuration? {
    get { self[ConfigurationKey.self] }
    set { self[ConfigurationKey.self] = newValue }
  }

  var edgeInsets: XEdgeInsets {
    get { self[EdgeInsetsKey.self] }
    set { self[EdgeInsetsKey.self] = newValue }
  }
  var showsUserLocation: Bool {
    get { self[ShowsUserLocationKey.self] }
    set { self[ShowsUserLocationKey.self] = newValue }
  }

  var isZoomEnabled: Bool {
    get { self[IsZoomEnabledKey.self] }
    set { self[IsZoomEnabledKey.self] = newValue }
  }

  var isScrollEnabled: Bool {
    get { self[IsScrollEnabledKey.self] }
    set { self[IsScrollEnabledKey.self] = newValue }
  }

  var isRotationEnabled: Bool {
    get { self[IsRotationEnabledKey.self] }
    set { self[IsRotationEnabledKey.self] = newValue }
  }

  var isPitchEnabled: Bool {
    get { self[IsPitchEnabledKey.self] }
    set { self[IsPitchEnabledKey.self] = newValue }
  }

  var showsPitchControl: Bool {
    get { self[ShowsPitchControlKey.self] }
    set { self[ShowsPitchControlKey.self] = newValue }
  }

  var showsZoomControls: Bool {
    get { self[ShowsZoomControlsKey.self] }
    set { self[ShowsZoomControlsKey.self] = newValue }
  }

  var showsCompass: Bool {
    get { self[ShowsCompassKey.self] }
    set { self[ShowsCompassKey.self] = newValue }
  }

  var showsScale: Bool {
    get { self[ShowsScaleKey.self] }
    set { self[ShowsScaleKey.self] = newValue }
  }

  var mapAnnotations: [MKAnnotation] {
    get { self[MapAnnotationsKey.self] }
    set { self[MapAnnotationsKey.self] = newValue }
  }

  var annotationViewFactory: AnnotationViewFactory? {
    get { self[MapAnnotationViewFactoryKey.self] }
    set { self[MapAnnotationViewFactoryKey.self] = newValue }
  }

  var mapOverlays: [MKOverlay] {
    get { self[MapOverlaysKey.self] }
    set { self[MapOverlaysKey.self] = newValue }
  }

  var overlayRendererFactory: OverlayRendererFactory? {
    get { self[MapOverlayRendererFactoryKey.self] }
    set { self[MapOverlayRendererFactoryKey.self] = newValue }
  }

  var onTapOrClickGesture: AdvancedMap.DidTapOrClickMapHandler? {
    get { self[OnTapOrClickMapGestureKey.self] }
    set { self[OnTapOrClickMapGestureKey.self] = newValue }
  }

  var onLongPressMapGesture: AdvancedMap.LongPressMapHandler? {
    get { self[OnLongPressMapGestureKey.self] }
    set { self[OnLongPressMapGestureKey.self] = newValue }
  }

  var onAnnotationDragGesture: AdvancedMap.AnnotationDragHandler? {
    get { self[OnAnnotationDragGestureKey.self] }
    set { self[OnAnnotationDragGestureKey.self] = newValue }
  }

  var mapRegionChangingHandler: AdvancedMap.RegionChangingHandler? {
    get { self[OnMapRegionChangingHandlerKey.self] }
    set { self[OnMapRegionChangingHandlerKey.self] = newValue }
  }
}

extension View {
  public func mapConfiguration(_ configuration: Configuration) -> some View {
    environment(\.mapConfiguration, configuration)
  }

  public func mapEdgeInsets(_ edgeInsets: XEdgeInsets) -> some View {
    environment(\.edgeInsets, edgeInsets)
  }

  public func showsUserLocation(_ showsUserLocation: Bool) -> some View {
    environment(\.showsUserLocation, showsUserLocation)
  }

  public func isZoomEnabled(_ isZoomEnabled: Bool) -> some View {
    environment(\.isZoomEnabled, isZoomEnabled)
  }

  public func isScrollEnabled(_ isScrollEnabled: Bool) -> some View {
    environment(\.isScrollEnabled, isScrollEnabled)
  }

  public func isRotationEnabled(_ isRotationEnabled: Bool) -> some View {
    environment(\.isRotationEnabled, isRotationEnabled)
  }

  public func isPitchEnabled(_ isPitchEnabled: Bool) -> some View {
    environment(\.isPitchEnabled, isPitchEnabled)
  }

#if os(macOS)
  public func showsPitchControl(_ showsPitchControl: Bool) -> some View {
    environment(\.showsPitchControl, showsPitchControl)
  }

  public func showsZoomControls(_ showsZoomControls: Bool) -> some View {
    environment(\.showsZoomControls, showsZoomControls)
  }
#endif

  public func showsCompass(_ showsCompass: Bool) -> some View {
    environment(\.showsCompass, showsCompass)
  }

  public func showsScale(_ showsScale: Bool) -> some View {
    environment(\.showsScale, showsScale)
  }

  public func annotations(
    _ annotations: [MKAnnotation],
    annotationViewFactory: AnnotationViewFactory
  ) -> some View {
    environment(\.mapAnnotations, annotations)
      .environment(\.annotationViewFactory, annotationViewFactory)
  }

  public func overlays(
    _ overlays: [MKOverlay],
    overlayRendererFactory: OverlayRendererFactory
  ) -> some View {
    environment(\.mapOverlays, overlays)
      .environment(\.overlayRendererFactory, overlayRendererFactory)
  }

  #if os(iOS)

  public func onTapMapGesture(
    _ tapOrClickHandler: @escaping AdvancedMap.DidTapOrClickMapHandler
  ) -> some View {
    environment(\.onTapOrClickGesture, tapOrClickHandler)
  }

  #elseif os(macOS)

  public func onClickMapGesture(
    _ tapOrClickHandler: @escaping AdvancedMap.DidTapOrClickMapHandler
  ) -> some View {
    environment(\.onTapOrClickGesture, tapOrClickHandler)
  }

  #endif

  #if os(iOS) || os(macOS)
  public func onTapOrClickMapGesture(
    _ tapOrClickHandler: @escaping AdvancedMap.DidTapOrClickMapHandler
  ) -> some View {
    environment(\.onTapOrClickGesture, tapOrClickHandler)
  }
  #endif

  public func onLongPressMapGesture(
    _ longPressHandler: @escaping AdvancedMap.LongPressMapHandler
  ) -> some View {
    environment(\.onLongPressMapGesture, longPressHandler)
  }

#if os(iOS) || os(macOS)

  public func annotationDragHandler(
    _ annotationDragHandler: @escaping AdvancedMap.AnnotationDragHandler
  ) -> some View {
    environment(\.onAnnotationDragGesture, annotationDragHandler)
  }

#endif

  public func mapRegionChangingHandler(
    _ regionChangingHandler: @escaping AdvancedMap.RegionChangingHandler
  ) -> some View {
    environment(\.mapRegionChangingHandler, regionChangingHandler)
  }
}
