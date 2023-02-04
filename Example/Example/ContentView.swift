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
  @State var mapVisibility: MapVisibility? = nil
  @State var overlays: [MKOverlay] = [MKOverlay]()
  @State var annotations: [MKPointAnnotation] = [MKPointAnnotation]()
#if os(iOS) || os(macOS)
  @State var userTrackingMode: MKUserTrackingMode = .follow
#endif

  var body: some View {
    NavigationStack {
      ZStack {
        AdvancedMap(mapVisibility: $mapVisibility)
          .mapConfiguration(configuration)
          .annotations(annotations, annotationViewFactory: annotationViewFacotry())
          .overlays(overlays, overlayRendererFactory: overlayRendererFactory())
          .onLongPressMapGesture(tapOrClickHandler)
          #if !os(tvOS)
          .annotationDragHandler(annotationDragHandler)
          #endif
          .ignoresSafeArea()
          .onAppear {
            CLLocationManager().requestWhenInUseAuthorization()
            #if !os(tvOS)
            CLLocationManager().startUpdatingLocation()
            #endif
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
        ToolbarItem {
          Button("New York Center") {
            mapVisibility = .centerCoordinate(.newYork)
          }
        }
        ToolbarItem {
          Button("Los Angeles Region (Animated)") {
            withAnimation {
              mapVisibility = .region(
                MKCoordinateRegion(
                  center: .losAngeles,
                  latitudinalMeters: .oneHundredKm,
                  longitudinalMeters: .oneHundredKm
                )
              )
            }
          }
        }
        ToolbarItem {
          Button("Show Annotations") {
            mapVisibility = .annotations(self.annotations)
          }
        }
        ToolbarItem {
          Button("Lincoln Memorial") {
            mapVisibility = .camera(MKMapCamera(lookingAtCenter: CLLocationCoordinate2D(north: 38.88919130, west: 77.05026405), fromDistance: 110, pitch: 60, heading: 249))
          }
        }
        ToolbarItem {
          Button("Apple Park Point Region (Animated)") {
            withAnimation {
              mapVisibility = .visibleMapRect(
                MKMapRect(
                  origin: MKMapPoint(.applePark),
                  size: MKMapSize(
                    width: MKMapPointsPerMeterAtLatitude(CLLocationCoordinate2D.applePark.latitude) * 800,
                    height: MKMapPointsPerMeterAtLatitude(CLLocationCoordinate2D.applePark.latitude) * 1000
                  )
                )
              )
            }
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

  #if !os(tvOS)
  func annotationDragHandler(
    annotation: MKAnnotation,
    location: CLLocationCoordinate2D,
    oldState: MKAnnotationView.DragState,
    newState: MKAnnotationView.DragState
  ) {
    guard let index = annotations.firstIndex(where: { pointAnnotation in
      pointAnnotation === annotation
    }) else { return }
    annotations[index].coordinate = location
    updateOverlays()
  }
  #endif
}

// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}


extension CLLocationCoordinate2D {
  init(north: CLLocationDegrees, west: CLLocationDegrees) {
    self.init(latitude: north, longitude: -west)
  }

  static let newYork = CLLocationCoordinate2D(north: 40.74850, west: 73.98557)
  static let losAngeles = CLLocationCoordinate2D(north: 34.0, west: 118.2)
  static let applePark = CLLocationCoordinate2D(north: 37.33759, west: 122.01423)
}

extension CLLocationDistance {
  static let oneHundredKm = 100_000.0
}
