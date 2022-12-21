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

  @State var region: MKMapRect? = .buschGardens
  @State var overlays: [MKOverlay] = [MKOverlay]()
  @State var annotations: [MKPointAnnotation] = [MKPointAnnotation]()

  func updateOverlays() {
    if annotations.count >= 3 {
      let coordinates = annotations.map(\.coordinate)
      overlays = [MKPolygon(coordinates: coordinates, count: coordinates.count)]
    }
  }

  var map: some View {
  #if os(iOS)
    AdvancedMap(
      mapRect: $region,
      showsUserLocation: true,
      isZoomEnabled: true,
      isScrollEnabled: true,
      isRotateEnabled: true,
      isPitchEnabled: true,
      showsCompass: true,
      showsScale: true,
      annotations: annotations,
      annotationViewFactory: .combine(
        MKUserLocation.mkUserLocationViewFactory,
        MKPointAnnotation.annotationViewFactory
      ),
      overlays: overlays,
      overlayRendererFactory: .factory(for: MKPolygon.self) { polygon in
        let renderer = MKPolygonRenderer(polygon: polygon)
        renderer.strokeColor = .red
        renderer.lineWidth = 4
        renderer.fillColor = .red.withAlphaComponent(0.3)
        return renderer
      },
      tapOrClickHandler: { location in
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotations.append(annotation)
        updateOverlays()
      },
      annotationDragHandler: { annotation, location, oldState, newState in
        guard let index = annotations.firstIndex(where: { pointAnnotation in
          pointAnnotation === annotation
        }) else { return }
        annotations[index].coordinate = location
        updateOverlays()
      }
    )
  #elseif os(macOS)
    AdvancedMap(
      mapRect: $region,
      showsUserLocation: true,
      isZoomEnabled: true,
      isScrollEnabled: true,
      isRotateEnabled: true,
      isPitchEnabled: true,
      showsPitchControl: true,
      showsZoomControls: true,
      showsCompass: true,
      showsScale: true,
      annotations: annotations,
      annotationViewFactory: .combine(
        MKUserLocation.mkUserLocationViewFactory,
        MKPointAnnotation.annotationViewFactory
      ),
      overlays: overlays,
      overlayRendererFactory: .factory(for: MKPolygon.self) { polygon in
        let renderer = MKPolygonRenderer(polygon: polygon)
        renderer.strokeColor = .red
        renderer.lineWidth = 4
        renderer.fillColor = .red.withAlphaComponent(0.3)
        return renderer
      },
      tapOrClickHandler: { location in
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotations.append(annotation)
        updateOverlays()
      },
      annotationDragHandler: { annotation, location, oldState, newState in
        guard let index = annotations.firstIndex(where: { pointAnnotation in
          pointAnnotation === annotation
        }) else { return }
        annotations[index].coordinate = location
        updateOverlays()
      }
    )
#elseif os(tvOS)
    AdvancedMap(
      mapRect: $region,
      showsUserLocation: true,
      isZoomEnabled: true,
      isScrollEnabled: true,
      isRotateEnabled: true,
      isPitchEnabled: true,
      showsPitchControl: true,
      showsZoomControls: true,
      showsCompass: true,
      annotations: annotations,
      annotationViewFactory: .combine(
        MKUserLocation.mkUserLocationViewFactory,
        MKPointAnnotation.annotationViewFactory
      ),
      overlays: overlays,
      overlayRendererFactory: .factory(for: MKPolygon.self) { polygon in
        let renderer = MKPolygonRenderer(polygon: polygon)
        renderer.strokeColor = .red
        renderer.lineWidth = 4
        renderer.fillColor = .red.withAlphaComponent(0.3)
        return renderer
      },
      tapOrClickHandler: { location in
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotations.append(annotation)
        updateOverlays()
      }
    )
#endif
  }

  var body: some View {
    ZStack {
      map
        .ignoresSafeArea()
        .onAppear {
          CLLocationManager().requestWhenInUseAuthorization()
        }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
