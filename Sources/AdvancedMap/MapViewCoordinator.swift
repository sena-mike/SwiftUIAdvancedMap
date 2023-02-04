import MapKit

public class Coordinator: NSObject, MKMapViewDelegate {
  var advancedMap: AdvancedMap
  var mapView: MKMapView?

  /// I'm using this to avoid updating the map while an animation is in progress. There is
  /// probably a better way to defer updates, perhaps the binding is a bad idea and the
  /// client should just express what they would like to be visible and we handle the rest?
  var isChangingRegion = false

  var isFirstRender = true

  var tapOrClickGesture: XTapOrClickGestureRecognizer?
  var longPressGesture: XLongTapOrClickGestureRecognizer?

  init(advancedMap: AdvancedMap) {
    self.advancedMap = advancedMap

    super.init()
  }

  private func updateVisibleBinding() {
    guard let mapView else { return }
    switch advancedMap.mapVisibility {
    case .none:
      // If clients initially provide `nil` for `mapVisibility` this will write a
      // `MapVisibility.centerCoordinate` to the binding.
      advancedMap.mapVisibility = .centerCoordinate(mapView.centerCoordinate)
    case .region:
      advancedMap.mapVisibility = .region(mapView.region)
    case .centerCoordinate:
      advancedMap.mapVisibility = .centerCoordinate(mapView.centerCoordinate)
    case .visibleMapRect:
      advancedMap.mapVisibility = .visibleMapRect(mapView.visibleMapRect)
    case .annotations:
      // We don't write back to the binding
      break
    case .camera:
      advancedMap.mapVisibility = .camera(mapView.camera)
    }
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
    advancedMap.regionChangingHandler?(true, animated)
  }

  public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    isChangingRegion = false
    advancedMap.regionChangingHandler?(false, animated)
    
    if isFirstRender {
      DispatchQueue.main.async { [weak self] in
        guard let self else { return }
        self.updateVisibleBinding()
      }
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
    advancedMap.annotationViewFactory?.mapView(mapView, viewFor: annotation)
  }

  public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    advancedMap.overlayRendererFactory?.rendererFor(overlay) ?? .init()
  }

  #if os(iOS) || os(macOS)
  public func mapView(
      _ mapView: MKMapView,
      annotationView view: MKAnnotationView,
      didChange newState: MKAnnotationView.DragState,
      fromOldState oldState: MKAnnotationView.DragState
  ) {
    guard let annotation = view.annotation else { return }
    advancedMap.annotationDragHandler?(annotation, annotation.coordinate, oldState, newState)
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
    tapOrClickGesture = clickGesture
    #else
    let tapGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(Coordinator.didTapOnMap(gesture:))
    )
    tapGesture.delegate = self
    mapView.addGestureRecognizer(tapGesture)
    tapOrClickGesture = tapGesture
    #endif
  }

  func addLongTapOrClickGestureRecognizer(mapView: MKMapView) {
    #if os(macOS)
    let longPress = NSPressGestureRecognizer(
      target: self,
      action: #selector(Coordinator.didLongPressOnMap(gesture:))
    )
    mapView.addGestureRecognizer(longPress)
    longPressGesture = longPress
    #else
    let longTap = UILongPressGestureRecognizer(
      target: self,
      action: #selector(Coordinator.didLongPressOnMap(gesture:))
    )
    longTap.delegate = self
    mapView.addGestureRecognizer(longTap)
    longPressGesture = longTap
    #endif
  }
}

#if os(macOS)
extension Coordinator: NSGestureRecognizerDelegate {
  @objc func didClickOnMap(gesture: NSClickGestureRecognizer) {
    didTapOrClickOnMap(gesture: gesture)
  }

  @objc func didLongPressOnMap(gesture: NSPressGestureRecognizer) {
    didLongPress(gesture: gesture)
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
    didLongPress(gesture: gesture)
  }

  @objc public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    shouldGestureRecognizerBegin(gesture: gestureRecognizer)
  }

  @objc public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    // Without this a long tap/click gesture will only work on every other attempt.
    if gestureRecognizer is UILongPressGestureRecognizer {
      return true
    }

    return true
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
    logger.info("didTapOrClickOnMap, calling tapOrClickHandler")
    advancedMap.tapOrClickHandler?(coordinate)
  }

  func didLongPress(gesture: XLongTapOrClickGestureRecognizer) {
    print("long gesture state: \(String(describing: gesture.state))")
    guard gesture.state == .began else { return }
    guard let mapView = mapView else {
      fatalError("Missing mapView")
    }
    let coordinate = mapView.convert(gesture.location(in: mapView),
                                     toCoordinateFrom: mapView)
    logger.info("didLongPress, calling longPressHandler")
    advancedMap.longPressHandler?(coordinate)
  }

  func shouldGestureRecognizerBegin(gesture: XGestureRecognizer) -> Bool {
    logger.debug("""
    shouldGestureRecognizerBegin,
    isOurTap, \(gesture == self.tapOrClickGesture, privacy: .public),
    isOurLongPress, \(gesture == self.longPressGesture, privacy: .public)
    """)

    guard let mapView = mapView else { return false }
    for view in mapView.allDescendantSubViews {
      let location = gesture.location(in: view)
      let isInBounds = view.bounds.contains(location)
      guard isInBounds else { continue }
      logger.debug("gesture started on subview: \(view)")
      if view is MKAnnotationView, isInBounds {
        logger.debug("\(type(of: gesture)) shouldBegin on \(type(of: view)): \(!isInBounds)")
        return !isInBounds
      }
      #if os(macOS)
      if (view is MKZoomControl || view is MKPitchControl || view is MKCompassButton), isInBounds {
        logger.debug("\(gesture.className) shouldBegin on \(type(of: view)): \(!isInBounds)")
        return !isInBounds
      }
      #endif
    }
    logger.debug("\(type(of: gesture)) shouldBegin: true")
    mapView.deselectAnnotation(mapView.selectedAnnotations.first, animated: true)
    return true
  }
}


extension XLegacyView {
  var allDescendantSubViews: [XLegacyView] {
    var allSubviews = subviews
    allSubviews.forEach { allSubviews.append(contentsOf: $0.allDescendantSubViews) }
    return allSubviews
  }
}
