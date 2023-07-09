[Deprecated]

This project was started before iOS 17's SwiftUI for MapKit which mostly obviates the need for this library. I will likely not be making further changes to this project. For more information see [this wwdc video](https://developer.apple.com/videos/play/wwdc2023/10043/).



# SwiftUIAdvancedMap

[![Swift](https://github.com/sena-mike/SwiftUIAdvancedMap/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/sena-mike/SwiftUIAdvancedMap/actions/workflows/swift.yml)

A wrapper around MKMapView with more functionality than Map.

| Points and Overlays  | Camera  | Styling |
|:----------|:----------|:----------|
| ![Points Screenshot](/Resources/pointsAndOverlays.png) | ![Camera Control](/Resources/lincoln.png) | ![Sat Screenshot](/Resources/la-sat.png) |  



| Feature  | `AdvancedMap`  | `MapKit.Map`  |
|:----------|:----------|:----------|
| Tap/Long Press Gestures with Map coordinates passed into the Handlers. | ✅ | ❌ |
| Annotations with Drag and Drop support | ✅ <br> (UIKit Annotation Views) | ✅ <br>(SwiftUI Annotation Views) |
| Overlays | ✅ <br> (UIKit Overlay Views) | ❌ |
| Specify EdgeInsets for UI overlays | ✅ | ❌ |
| Display User Location | ✅ <br>(via `AnnoatationViewFactory`) | ✅ <br>(as an initialization parameter) |
| Region State Changing Handler, a callback that informs when a map change Animation in progress. | ✅ | ❌ |
| Binding to Optional map region so map is initially positioned around country bounding box. | ✅ | ❌ |
| `MKMapCamera` support | ✅ | ❌ |


### Tap or Click Gesture with Coordinate on Map.

```swift
struct TappableMap: View {
  var body: some View {
    // `.constant(nil)` uses MKMapView's behavior of starting the map over the phone's current country. 
    // Still scrollable by default.
    AdvancedMap(mapRect: .constant(nil))
      .onTapOrClickMapGesture { coordinate in
        print("Tapped map at: \(coordinate)")
      }
  }
}
```

### Rendering Annotations

```swift
struct TappableMap: View {

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
      .onTapOrClickMapGesture { coordinate in
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotations.append(annotation)
      }
  }
}
```

Inspired by, and sometimes stealing from, the following projects:
* https://github.com/pauljohanneskraft/Map
* https://github.com/darrarski/SwiftUIMKMapView
* https://github.com/sgade/swiftui-mapview
