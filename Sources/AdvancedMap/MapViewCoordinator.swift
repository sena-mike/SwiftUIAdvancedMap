import MapKit

public class Coordinator: NSObject, MKMapViewDelegate {
  var advancedMap: AdvancedMap
  var mapView: MKMapView?

  /// I'm using this to avoid updating the map while an animation is in progress. There is
  /// probably a better way to defer updates, perhaps the binding is a bad idea and the
  /// client should just express what they would like to be visible and we handle the rest?
  var isChangingRegion = false

  init(advancedMap: AdvancedMap) {
    self.advancedMap = advancedMap

    super.init()
  }

  // MARK: MKMapViewDelegate

  public func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
    DispatchQueue.main.async {
      self.advancedMap.visibleMapRect = mapView.visibleMapRect
    }
  }

  public func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
    logger.debug("regionWillChangeAnimated")
    isChangingRegion = true
  }

  public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    logger.debug("regionDidChangeAnimated")
    isChangingRegion = false
  }

  public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    advancedMap.annotationViewFactory.mapView(mapView, viewFor: annotation)
  }

  public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    advancedMap.overlayRendererFactory.rendererFor(overlay) ?? .init()
  }

  public func mapView(
      _ mapView: MKMapView,
      annotationView view: MKAnnotationView,
      didChange newState: MKAnnotationView.DragState,
      fromOldState oldState: MKAnnotationView.DragState
  ) {
    guard let annotation = view.annotation else { return }
    advancedMap.annotationDragHandler(annotation, annotation.coordinate, oldState, newState)
  }

  // MARK: - Gesture Recognizer

  func addGestureRecognizer(mapView: MKMapView) {
    self.mapView = mapView
    #if os(macOS)
    let clickGesture = NSClickGestureRecognizer(
      target: self,
      action: #selector(Coordinator.didClickOnMap(gesture:))
    )
    mapView.addGestureRecognizer(clickGesture)
    #else
    let tapGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(Coordinator.didTapOnMap(gesture:))
    )
    mapView.addGestureRecognizer(tapGesture)
    #endif
  }

#if os(macOS)
  @objc func didClickOnMap(gesture: NSClickGestureRecognizer) {
    guard gesture.state == .ended else { return }
    guard let mapView = mapView else {
      fatalError("Missing mapView")
    }
    let coordinate = mapView.convert(gesture.location(in: mapView),
                                     toCoordinateFrom: mapView)
    advancedMap.tapOrClickHandler(coordinate)
  }
#else
  @objc func didTapOnMap(gesture: UITapGestureRecognizer) {
    guard gesture.state == .ended else { return }
    guard let mapView = mapView else {
      fatalError("Missing mapView")
    }
    let coordinate = mapView.convert(gesture.location(in: mapView),
                                     toCoordinateFrom: mapView)
    advancedMap.tapOrClickHandler(coordinate)
  }
#endif
  
}
