import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

     GMSServices.provideAPIKey("AIzaSyDg9rz2YvhKlP6WZ6Ptj6-tjfci1NiVRtY")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
