import MapKit

/// Stolen from: https://github.com/darrarski/SwiftUIMKMapView

/// Returns renderer object to use when drawing the specified overlay.
public struct OverlayRendererFactory {
  /// - Parameter renderer: A closure that returns optional render for provided overlay.
  public init(renderer: @escaping (MKOverlay) -> MKOverlayRenderer?) {
    self.renderer = renderer
  }

  var renderer: (MKOverlay) -> MKOverlayRenderer?

  func rendererFor(_ overlay: MKOverlay) -> MKOverlayRenderer? {
    renderer(overlay)
  }
}

extension OverlayRendererFactory {
  /// An empty factory that does not return renderer.
  public static let empty = Self(renderer: { _ in nil })

  /// Combines multiple factories into a single one.
  ///
  /// The combined factory returns first non-`nil` renderer returned by the provided factories.
  ///
  /// - Parameter factories: Factories to combine.
  /// - Returns: Single, combined factory.
  public static func combine(_ factories: [Self]) -> Self {
    .init { overlay in
      for factory in factories {
        if let renderer = factory.rendererFor(overlay) {
          return renderer
        }
      }
      return nil
    }
  }

  /// Combines multiple factories into a single one.
  ///
  /// The combined factory returns first non-`nil` renderer returned by the provided factories.
  ///
  /// - Parameter factories: Factories to combine.
  /// - Returns: Single, combined factory.
  public static func combine(_ factories: Self...) -> Self {
    .combine(factories)
  }

  /// Creates a factory that uses provided closure to create renderer for overlay of the provided class.
  /// - Parameters:
  ///   - overlayClass: A class of the overlay.
  ///   - renderer: A closure that returns renderer for the provided overlay.
  /// - Returns: Factory.
  public static func factory<Overlay>(
    for overlayClass: Overlay.Type,
    _ renderer: @escaping (Overlay) -> MKOverlayRenderer
  ) -> Self
  where Overlay: MKOverlay
  {
    return .init { overlay in
      guard let overlay = overlay as? Overlay else { return nil }
      return renderer(overlay)
    }
  }
}
