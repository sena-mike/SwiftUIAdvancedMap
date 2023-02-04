import AdvancedMap
import MapKit
import SwiftUI

struct TappableMapWithAnnotations: View {

  static let annotationViewFactory = AnnotationViewFactory(
    register: { mapView in
      mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: String(describing: MKPointAnnotation.self))
    },
    view: { mapView, annotation in
      mapView.dequeueReusableAnnotationView(withIdentifier: String(describing: MKPointAnnotation.self), for: annotation)
    }
  )

  @State var mapVisibility: MapVisibility?
  @State var annotations: [MKPointAnnotation] = [MKPointAnnotation]()

  var body: some View {
    AdvancedMap(mapVisibility: $mapVisibility)
      .annotations(annotations, annotationViewFactory: Self.annotationViewFactory)
    #if !os(tvOS)
      .onTapOrClickMapGesture { coordinate in
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotations.append(annotation)
      }
    #endif
  }
}

struct TappableMap: View {
  var body: some View {
    // Uses MKMapView's behavior of starting the map over the
    // phone's current country. Still scrollable by default.
    AdvancedMap(mapVisibility: .constant(nil))
      #if !os(tvOS)
      .onTapOrClickMapGesture { coordinate in
        print("Tapped map at: \(coordinate)")
      }
      #endif
  }
}

struct READMESampleMap_Previews: PreviewProvider {
  static var previews: some View {
    TappableMap()
  }
}
