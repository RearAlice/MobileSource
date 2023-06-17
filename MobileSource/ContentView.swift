import SwiftUI
import UIKit

class BatteryInfo: ObservableObject {
    @Published var batteryLevel: Float = UIDevice.current.batteryLevel
    @Published var systemVersion: String = UIDevice.current.systemVersion
    @Published var systembuildName: String = UIDevice.current.systemName
    @Published var model: String = UIDevice.current.model
    @Published var buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""

    init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateBatteryLevel),
            name: UIDevice.batteryLevelDidChangeNotification,
            object: nil
        )
        updateBatteryLevel() // 初期値を設定するために呼び出す
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func updateBatteryLevel() {
        DispatchQueue.main.async {
            let currentLevel = UIDevice.current.batteryLevel
            if currentLevel >= 0.0 && currentLevel <= 1.0 {
                self.batteryLevel = currentLevel
            }
        }
    }
}

struct ContentView: View {
    @ObservedObject var batteryInfo = BatteryInfo()

    var body: some View {
        
        VStack {
            List {
                Section{
                    Text("OS: \(batteryInfo.systembuildName)")
                    Text("バージョン: \(batteryInfo.systemVersion)")
                    Text("モデル: \(batteryInfo.model)")
                }
            header: {
                Text("システム")
            }
            footer: {
                Text("最新バージョンの iOS／iPadOS ソフトウェアにアップグレードすると、最新の機能やセキュリティアップデートを利用できるほか、バグも修正されます。デバイスまたは国／地域によっては、利用できない機能もあります。バッテリーとシステムのパフォーマンスは、ネットワークの状況や個々の使用条件など、さまざまな要因に左右されるため、実際の結果は異なる場合があります。")
            }
                Section{
                    Text(" \(Int(batteryInfo.batteryLevel * 100))%")
                }
            header: {
                Text("バッテリー状況")
            }
            footer: {
                Text("バッテリー駆動時間と充電サイクルは使用方法および設定によって異なります。iPhoneのバッテリーの修理またはリサイクルは、AppleまたはAppleの正規サービスプロバイダのみが行う必要があります。")
            }
            }
            .listStyle(.grouped)

            .navigationTitle("診断結果")
        }
    }
}


struct BatteryApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
