import AdvancedMap
import MapKit
import SwiftUI

extension MKMapRect {
  static let buschGardens = MKMapRect(
    origin: MKMapPoint(
      x: 77063948.43628144,
      y: 104261566.7753939
    ),
    size: MKMapSize(
      width: 5973.566551163793,
      height: 6648.14294731617
    )
  )
}


extension MKPointAnnotation {

  public override func isEqual(_ object: Any?) -> Bool {
    guard let other = object as? Self else { return false }
    return coordinate == other.coordinate && title == other.title && subtitle == other.subtitle
  }

  static let annotationViewFactory = AnnotationViewFactory(register: { mapView in
    mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: String(describing: MKPointAnnotation.self))
  }, view: { mapView, annotation in
    let view = mapView.dequeueReusableAnnotationView(withIdentifier: String(describing: MKPointAnnotation.self), for: annotation)
#if os(iOS) || os(macOS)
    (view as? MKMarkerAnnotationView)?.isDraggable = true
#endif
    return view
  })
}

struct ContentView: View {

  enum ConfigurationStyle: String, CaseIterable {
    case standard, hybrid, sattelite
  }

  @State var selectedStyle: ConfigurationStyle = .standard
  var configuration: Configuration {
    switch selectedStyle {
    case .standard: return .standard(.default, .realistic, .includingAll, false)
    case .hybrid: return .hybrid(.realistic, .includingAll, false)
    case .sattelite: return .imagery(.realistic)
    }
  }
  @State var region: MKMapRect? = nil
  @State var overlays: [MKOverlay] = [MKOverlay]()
  @State var annotations: [MKPointAnnotation] = [MKPointAnnotation]()
#if os(iOS) || os(macOS)
  @State var userTrackingMode: MKUserTrackingMode = .follow
#endif

  var body: some View {
    NavigationStack {
      ZStack {
        AdvancedMap(mapRect: $region)
          .mapConfiguration(configuration)
          .annotations(annotations, annotationViewFactory: annotationViewFacotry())
          .overlays(overlays, overlayRendererFactory: overlayRendererFactory())
          .onLongPressMapGesture(tapOrClickHandler)
          .annotationDragHandler(annotationDragHandler)
          .ignoresSafeArea()
          .onAppear {
            CLLocationManager().requestWhenInUseAuthorization()
            CLLocationManager().startUpdatingLocation()
          }
      }
      .toolbar {
        ToolbarItem {
          Picker(selection: $selectedStyle) {
            ForEach(ConfigurationStyle.allCases, id: \.self) { style in
              Text(style.rawValue.localizedCapitalized)
            }
          } label: {
            Text("Select a style")
          }
        }
      }
    }
  }

  func updateOverlays() {
    if annotations.count >= 3 {
      let coordinates = annotations.map(\.coordinate)
      overlays = [MKPolygon(coordinates: coordinates, count: coordinates.count)]
    }
  }

  func annotationViewFacotry() -> AnnotationViewFactory {
    .combine(
      MKUserLocation.mkUserLocationViewFactory,
      MKPointAnnotation.annotationViewFactory
    )
  }

  func overlayRendererFactory() -> OverlayRendererFactory {
    .factory(for: MKPolygon.self) { polygon in
      let renderer = MKPolygonRenderer(polygon: polygon)
      renderer.strokeColor = .red
      renderer.lineWidth = 4
      renderer.fillColor = .red.withAlphaComponent(0.3)
      return renderer
    }
  }

  func tapOrClickHandler(location: CLLocationCoordinate2D) {
    let annotation = MKPointAnnotation()
    annotation.coordinate = location
    annotation.title = "A"
    annotations.append(annotation)
    updateOverlays()
  }

  func annotationDragHandler(
    annotation: MKAnnotation,
    location: CLLocationCoordinate2D,
    oldState: MKAnnotationView.DragState,
    newState: MKAnnotationView.DragState) {
      guard let index = annotations.firstIndex(where: { pointAnnotation in
        pointAnnotation === annotation
      }) else { return }
      annotations[index].coordinate = location
      updateOverlays()
    }
}

// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}


