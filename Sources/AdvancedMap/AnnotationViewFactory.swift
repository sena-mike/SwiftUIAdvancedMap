import MapKit

/// Stolen from: https://github.com/darrarski/SwiftUIMKMapView

/// Provides the view associated with the specified annotation object.
public struct AnnotationViewFactory {
  /// - Parameters:
  ///   - register: A closure that registers an annotation view class that the map can create automatically.
  ///   - view: A closure that returns the view associated with the specified annotation object.
  public init(
    register: @escaping (MKMapView) -> Void,
    view: @escaping (MKMapView, MKAnnotation) -> MKAnnotationView?
  ) {
    self.register = register
    self.view = view
  }

  var register: (MKMapView) -> Void
  var view: (MKMapView, MKAnnotation) -> MKAnnotationView?

  func register(in mapView: MKMapView) {
    register(mapView)
  }

  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    view(mapView, annotation)
  }
}

extension AnnotationViewFactory {
  /// An empty factory that does nothing and does not return views.
  public static let empty = Self(register: { _ in }, view: { _, _ in nil })

  /// Combines multiple factories into a single one.
  ///
  /// The combined factory returns first non-`nil` view returned by the provided factories.
  ///
  /// - Parameter factories: Factories to combine.
  /// - Returns: Single, combined factory.
  public static func combine(_ factories: [Self]) -> Self {
    .init(register: { mapView in
      factories.forEach { $0.register(in: mapView) }
    }, view: { mapView, annotation in
      for factory in factories {
        if let view = factory.mapView(mapView, viewFor: annotation) {
          return view
        }
      }
      return nil
    })
  }

  /// Combines multiple factories into one.
  ///
  /// The combined factory returns first non-`nil` view returned by the provided factories.
  ///
  /// - Parameter factories: Factories to combine
  /// - Returns: Single, combined factory.
  public static func combine(_ factories: Self...) -> Self {
    .combine(factories)
  }

  /// Creates a factory that registers and dequeues views of provided class for provided annotation class.
  /// - Parameters:
  ///   - annotationClass: The annotation class (conforming to MKAnnotation).
  ///   - viewClass: The view class (subclass of MKAnnotationView).
  /// - Returns: Factory.
  public static func factory<Annotation, View>(
    for annotationClass: Annotation.Type,
    _ viewClass: View.Type
  ) -> Self
  where Annotation: MKAnnotation,
        View: MKAnnotationView
  {
    let reuseIdentifier = [annotationClass, viewClass]
      .map(String.init(describing:))
      .joined(separator: "___")

    return .init(register: { mapView in
      mapView.register(
        viewClass.self,
        forAnnotationViewWithReuseIdentifier: reuseIdentifier
      )
    }, view: { mapView, annotation in
      guard let annotation = annotation as? Annotation else { return nil }
      let reusableView = mapView.dequeueReusableAnnotationView(
        withIdentifier: reuseIdentifier,
        for: annotation
      )
      return reusableView as? View
    })
  }
}
