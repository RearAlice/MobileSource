import UIKit

class BatteryInfo: ObservableObject {
    @Published var batteryLevel: Float = UIDevice.current.batteryLevel

    init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateBatteryLevel),
            name: UIDevice.batteryLevelDidChangeNotification,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func updateBatteryLevel() {
        DispatchQueue.main.async {
            self.batteryLevel = UIDevice.current.batteryLevel
        }
    }
}
