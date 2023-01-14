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
      logger.debug("didChange didChangeVisibleRegion: \(String(describing: mapView.visibleMapRect))")
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

  #if os(iOS) || os(macOS)
  public func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
    DispatchQueue.main.async {
      logger.debug("didChange userTrackingMode: \(String(describing: mode)), animated: \(animated)")
      self.advancedMap.userTrackingMode = mode
    }
  }
  #endif

  public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    advancedMap.annotationViewFactory.mapView(mapView, viewFor: annotation)
  }

  public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    advancedMap.overlayRendererFactory.rendererFor(overlay) ?? .init()
  }

  #if os(iOS) || os(macOS)
  public func mapView(
      _ mapView: MKMapView,
      annotationView view: MKAnnotationView,
      didChange newState: MKAnnotationView.DragState,
      fromOldState oldState: MKAnnotationView.DragState
  ) {
    guard let annotation = view.annotation else { return }
    advancedMap.annotationDragHandler(annotation, annotation.coordinate, oldState, newState)
  }
  #endif

  // MARK: - Gesture Recognizer

  func addGestureRecognizer(mapView: MKMapView) {
    self.mapView = mapView
    #if os(macOS)
    let clickGesture = NSClickGestureRecognizer(
      target: self,
      action: #selector(Coordinator.didClickOnMap(gesture:))
    )
    clickGesture.delegate = self
    mapView.addGestureRecognizer(clickGesture)
    #else
    let tapGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(Coordinator.didTapOnMap(gesture:))
    )
    tapGesture.delegate = self
    mapView.addGestureRecognizer(tapGesture)
    #endif
  }
}

#if os(macOS)
extension Coordinator: NSGestureRecognizerDelegate {
  @objc func didClickOnMap(gesture: NSClickGestureRecognizer) {
    didTapOrClickOnMap(gesture: gesture)
  }

  @objc public func gestureRecognizerShouldBegin(_ gestureRecognizer: NSGestureRecognizer) -> Bool {
    shouldGestureRecognizerBegin(gesture: gestureRecognizer)
  }
}
#else
extension Coordinator: UIGestureRecognizerDelegate {
  @objc func didTapOnMap(gesture: UITapGestureRecognizer) {
    didTapOrClickOnMap(gesture: gesture)
  }

  @objc public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    shouldGestureRecognizerBegin(gesture: gestureRecognizer)
  }
}
#endif

extension Coordinator {
  func didTapOrClickOnMap(gesture: XGestureRecognizer) {
    guard gesture.state == .ended else { return }
    guard let mapView = mapView else {
      fatalError("Missing mapView")
    }
    let coordinate = mapView.convert(gesture.location(in: mapView),
                                     toCoordinateFrom: mapView)
    logger.debug("Did tap or click on map at: \(String(describing: coordinate), privacy: .private)")
    advancedMap.tapOrClickHandler?(coordinate)
  }

  func shouldGestureRecognizerBegin(gesture: XGestureRecognizer) -> Bool {
    guard let mapView = mapView else { return false }
    for view in mapView.subviews {
      #if os(macOS)
      if view is MKZoomControl || view is MKPitchControl {
        let location = gesture.location(in: view)
        let isInBounds = view.bounds.contains(location)
        return !isInBounds
      }
      #endif
    }
    return true
  }
}
