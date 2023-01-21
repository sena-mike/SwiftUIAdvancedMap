import MapKit

public class Coordinator: NSObject, MKMapViewDelegate {
  var advancedMap: AdvancedMap
  var mapView: MKMapView?

  /// I'm using this to avoid updating the map while an animation is in progress. There is
  /// probably a better way to defer updates, perhaps the binding is a bad idea and the
  /// client should just express what they would like to be visible and we handle the rest?
  var isChangingRegion = false

  var isFirstRender = true

  init(advancedMap: AdvancedMap) {
    self.advancedMap = advancedMap

    super.init()
  }

  private func updateVisibleBinding() {
    advancedMap.visibleMapRect = mapView?.visibleMapRect
  }

  // MARK: MKMapViewDelegate

  public func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.updateVisibleBinding()
    }
  }

  public func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
    isChangingRegion = true
    advancedMap.regionChangingHandler(true, animated)
  }

  public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    isChangingRegion = false
    advancedMap.regionChangingHandler(false, animated)
    
    if isFirstRender {
      updateVisibleBinding()
    }
    isFirstRender = false
  }

  #if os(iOS) || os(macOS)
  public func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
    DispatchQueue.main.async {
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

  func addTapOrClickGestureRecognizer(mapView: MKMapView) {
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

  func addLongTapOrClickGestureRecognizer(mapView: MKMapView) {
    #if os(macOS)
    let longPress = NSPressGestureRecognizer(
      target: self,
      action: #selector(Coordinator.didLongPressOnMap(gesture:))
    )
    mapView.addGestureRecognizer(longPress)
    #else
    let longTap = UILongPressGestureRecognizer(
      target: self,
      action: #selector(Coordinator.didLongPressOnMap(gesture:))
    )
    longTap.delegate = self
    mapView.addGestureRecognizer(longTap)
    #endif
  }
}

#if os(macOS)
extension Coordinator: NSGestureRecognizerDelegate {
  @objc func didClickOnMap(gesture: NSClickGestureRecognizer) {
    didTapOrClickOnMap(gesture: gesture)
  }

  @objc func didLongPressOnMap(gesture: NSPressGestureRecognizer) {
    didLongTapOrClickOnMap(gesture: gesture)
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

  @objc func didLongPressOnMap(gesture: UILongPressGestureRecognizer) {
    didLongTapOrClickOnMap(gesture: gesture)
  }

  @objc public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    shouldGestureRecognizerBegin(gesture: gestureRecognizer)
  }

  @objc public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    // Without this a long tap/click gesture will only work on every other attempt.
    if gestureRecognizer is UILongPressGestureRecognizer {
      return true
    }

    return false
  }
}
#endif

extension Coordinator {
  func didTapOrClickOnMap(gesture: XTapOrClickGestureRecognizer) {
    guard gesture.state == .ended else { return }
    guard let mapView = mapView else {
      fatalError("Missing mapView")
    }
    let coordinate = mapView.convert(gesture.location(in: mapView),
                                     toCoordinateFrom: mapView)
    advancedMap.tapOrClickHandler?(coordinate)
  }

  func didLongTapOrClickOnMap(gesture: XLongTapOrClickGestureRecognizer) {
    print("long gesture state: \(String(describing: gesture.state))")
    guard gesture.state == .began else { return }
    guard let mapView = mapView else {
      fatalError("Missing mapView")
    }
    let coordinate = mapView.convert(gesture.location(in: mapView),
                                     toCoordinateFrom: mapView)
    advancedMap.longPressHandler?(coordinate)
  }

  func shouldGestureRecognizerBegin(gesture: XTapOrClickGestureRecognizer) -> Bool {
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
