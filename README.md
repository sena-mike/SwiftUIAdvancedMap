# SwiftUIAdvancedMap

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