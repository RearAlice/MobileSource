import SwiftUI
import UIKit
import CoreTelephony


class BatteryInfo: ObservableObject {
    @Published var batteryLevel: Float = UIDevice.current.batteryLevel
    @Published var systemVersion: String = UIDevice.current.systemVersion
    @Published var systembuildName: String = UIDevice.current.systemName
    @Published var model : String = UIDevice.current.localizedModel
    @Published var identifierForVendor: String = UIDevice.current.identifierForVendor!.uuidString
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
    let telephonyInfo = CTTelephonyNetworkInfo()
    let phoneNumber = "0120277535" // 電話番号を指定
    var body: some View {
        VStack {

                List {
                    Section{
                        //Text("OS: \(batteryInfo.systembuildName)")
                        Text("\(batteryInfo.systembuildName) \(batteryInfo.systemVersion)")
                        //Text("モデル: \(batteryInfo.model)")
                        
                    }
                header: {
                    Text("システム")
                }
                footer: {
                    Text("最新バージョンの iOS／iPadOS ソフトウェアにアップグレードすると、最新の機能やセキュリティアップデートを利用できるほか、バグも修正されます。デバイスまたは国／地域によっては、利用できない機能もあります。バッテリーとシステムのパフォーマンスは、ネットワークの状況や個々の使用条件など、さまざまな要因に左右されるため、実際の結果は異なる場合があります。")
                }
                    
                    Section{
                        Button(action: {
                                        openSettings()
                                    }) {
                                        Text("Open Settings")
                                    }
                    }
                header: {
                    Text("設定アプリ")
                }
                footer: {
                    Text("iOS、iPadOSの設定はこちらから。")
                }
                    
                        Section{
                            Text("\(batteryInfo.identifierForVendor)")
                            
                        }
                    header: {
                        Text("UUID")
                    }
                    
                    
                    
                    //                Section{
                    //                    Text(currentCarrierName)
                    //                }
                    //            header: {
                    //                Text("通信キャリア")
                    //            }
                    
                    Section{
                        //Text(" \(Int(batteryInfo.batteryLevel * 100))%")
                        Text(isCharging ? "充電中" : "充電していません")
                    }
                header: {
                    Text("充電状況")
                }
                    
                    Section{
                        Text(" \(Int(batteryInfo.batteryLevel * 100))%")
                        //Text(isCharging ? "充電中" : "充電していません")
                    }
                header: {
                    Text("バッテリー残量")
                }
                footer: {
                    Text("バッテリー駆動時間と充電サイクルは使用方法および設定によって異なります。iPhoneのバッテリーの修理またはリサイクルは、AppleまたはAppleの正規サービスプロバイダのみが行う必要があります。")
                }
                    Section{
                        Button(action: {
                                        guard let phoneURL = URL(string: "tel://\(phoneNumber)") else { return }
                                        UIApplication.shared.open(phoneURL)
                                    }) {
                                        Text("Appleサポートに連絡")
                                    }
                    }
                header: {
                    Text("Apple Care")
                }
                footer: {
                    Text("Apple アドバイザー (サポート担当スペシャリスト) と直接話がしたい場合は、Apple サポートまでお電話ください。")
                }
                    
                    
                .listStyle(.automatic)
            }
            

            .navigationTitle("診断結果")
        }
        
        var isCharging: Bool {
            UIDevice.current.batteryState == .charging || UIDevice.current.batteryState == .full
        }
        var currentCarrierName: String {
            if let carrier = telephonyInfo.subscriberCellularProvider {
                return carrier.carrierName ?? "お使いのデバイスは、Wifiモデルかご契約されているキャリア契約は見つかりませんでした。"
            }
            return "不明"
        }
    }
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
