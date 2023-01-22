# SwiftUIAdvancedMap

[![Swift](https://github.com/sena-mike/SwiftUIAdvancedMap/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/sena-mike/SwiftUIAdvancedMap/actions/workflows/swift.yml)

A wrapper around MKMapView with more functionality than Map.

![A screenshot of SwiftUIAdvancedMap in action](/Resources/screenshot.png)

| Feature  | `AdvancedMap`  | `MapKit.Map`  |
|:----------|:----------|:----------|
| Tap Gesture with Map coordinates passed into the Handler. | ✅ | ❌ |
| Annotations | ✅ <br> (UIKit Annotation Views) | ✅ <br>(SwiftUI Annotation Views) |
| Drag and Drop Annotations | ✅ | ❌ |
| Overlays | ✅ <br> (UIKit Overlay Views) | ❌ |
| Specify EdgeInsets for UI overlays | ✅ | ❌ |
| Display User Location | ✅ <br>(via `AnnoatationViewFactory`) | ✅ <br>(as an initialization parameter) |
| User Tracking Mode | ❌ | ✅ |
| Region State Changing Handler<br> (Animation in progress) | ✅ | ❌ |
| Animate Changes Control | ✅ | ❌ |
| Binding to Optional map region so map is initially positioned around country bounding box. | ✅ | ❌ |


### Tap or Click Gesture with Coordinate on Map.

```swift
struct TappableMap: View {
  
  @State var rect: MKMapRect? = nil

  var body: some View {
    AdvancedMap(mapRect: $rect) { coordinate in
      print("Tapped on map at: \(coordinate)")
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
  
  @State var rect: MKMapRect? = nil
  @State var annotations: [MKPointAnnotation] = [MKPointAnnotation]()

  var body: some View {
    AdvancedMap(
      mapRect: $rect,
      annotations: annotations,
      annotationViewFactory: TappableMap.annotationViewFactory
    ) { coordinate in
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
