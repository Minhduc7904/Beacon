import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    super.scene(scene, willConnectTo: session, options: connectionOptions)
    guard let controller = window?.rootViewController as? FlutterViewController else {
      return
    }

    let channel = FlutterMethodChannel(
      name: "beacon/google_maps",
      binaryMessenger: controller.binaryMessenger
    )
    channel.setMethodCallHandler { call, result in
      guard call.method == "open" else {
        result(FlutterMethodNotImplemented)
        return
      }

      guard
        let arguments = call.arguments as? [String: Any],
        let latitude = arguments["latitude"] as? Double,
        let longitude = arguments["longitude"] as? Double
      else {
        result(
          FlutterError(
            code: "INVALID_COORDINATE",
            message: "Missing map coordinate.",
            details: nil
          )
        )
        return
      }

      result(Self.openGoogleMaps(latitude: latitude, longitude: longitude))
    }
  }

  private static func openGoogleMaps(latitude: Double, longitude: Double) -> Bool {
    let coordinate = "\(latitude),\(longitude)"
    let encodedCoordinate = coordinate.addingPercentEncoding(
      withAllowedCharacters: .urlQueryAllowed
    ) ?? coordinate
    let candidates = [
      URL(string: "comgooglemaps://?q=\(encodedCoordinate)&center=\(encodedCoordinate)&zoom=16"),
      URL(string: "https://www.google.com/maps/search/?api=1&query=\(encodedCoordinate)")
    ].compactMap { $0 }

    for url in candidates where UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url)
      return true
    }

    return false
  }
}
