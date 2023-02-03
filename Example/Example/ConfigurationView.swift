import AdvancedMap
import MapKit
import SwiftUI


/// This example demonstrates changing the map's configuration at runtime.
struct ConfigurationView: View {

  enum ConfigurationStyle: String, CaseIterable {
    case standard, hybrid, satellite
  }

  @State var selectedStyle: ConfigurationStyle = .standard
  var configuration: Configuration {
    switch selectedStyle {
    case .standard: return .standard(.default, .realistic, .includingAll, false)
    case .hybrid: return .hybrid(.realistic, .includingAll, false)
    case .satellite: return .imagery(.realistic)
    }
  }
  @State var region: MKMapRect? = nil

  var body: some View {
    NavigationStack {
      ZStack {
        AdvancedMap(mapRect: $region)
          .mapConfiguration(configuration)
          .ignoresSafeArea()
          .onAppear {
            CLLocationManager().requestWhenInUseAuthorization()
            CLLocationManager().startUpdatingLocation()
          }
      }
      .toolbar {
        ToolbarItem(placement: .principal) {
          Picker(selection: $selectedStyle) {
            ForEach(ConfigurationStyle.allCases, id: \.self) { style in
              Text(style.rawValue.localizedCapitalized)
            }
          } label: {
            Text("Select a style")
          }.pickerStyle(.segmented)
        }
      }
      #if os(iOS)
      .navigationBarTitleDisplayMode(.inline)
      .toolbarBackground(.visible, for: .navigationBar)
      #endif
    }
  }
}
struct ConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationView()
    }
}
