import Foundation
import Foundation
import UIKit
import SystemConfiguration.CaptiveNetwork

struct UserData: Codable {
    var vivisWork: Bool
    var gfdokPS: String
    var gdpsjPjg: String
    var poguaKFP: String
    var gpaMFOfa: [String]
    var gciOFm: String?
    var bcpJFs: String
    var GOmblx: String
    var G0pxum: String
    var Fpvbduwm: Bool
    var Fpbjcv: String
    var StwPp: Bool
    var KDhsd: Bool
    var bvoikOGjs: [String: String]?
    var gfpbvjsoM: Int
    var gfdosnb: [String]
    var bpPjfns: String
    var biMpaiuf: Bool
    var oahgoMAOI: Bool

    static func collect() -> UserData {
        let device = UIDevice.current
        let batteryState = device.batteryState
        let batteryLevel = Int(device.batteryLevel * 100)
        let memorySize = ProcessInfo.processInfo.physicalMemory / (1024 * 1024)
        let timeZone = TimeZone.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .long
        
        return UserData(
            vivisWork: checkVPNStatus(),
            gfdokPS: device.name,
            gdpsjPjg: device.model,
            poguaKFP: device.identifierForVendor?.uuidString ?? "",
            gpaMFOfa: getWiFiAddresses(),
            gciOFm: getSimCardInfo(),
            bcpJFs: device.systemVersion,
            GOmblx: Locale.current.languageCode ?? "",
            G0pxum: dateFormatter.string(from: Date()),
            Fpvbduwm: batteryState == .charging || batteryState == .full,
            Fpbjcv: "\(memorySize) MB",
            StwPp: isScreenMirroring(),
            KDhsd: isScreenRecording(),
            bvoikOGjs: getInstalledApps(),
            gfpbvjsoM: batteryLevel,
            gfdosnb: getKeyboardLanguages(),
            bpPjfns: Locale.current.regionCode ?? "",
            biMpaiuf: Locale.current.usesMetricSystem,
            oahgoMAOI: batteryState == .full
        )
    }

    static func getWiFiAddresses() -> [String] {
        var addresses = [String]()

        // Get list of all interfaces on the local machine:
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr!.pointee.ifa_next }
                let interface = ptr!.pointee
                
                // Check for IPv4 or IPv6 interfaces. Skip the loopback interface.
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                    &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        let address = String(cString: hostname)
                        addresses.append(address)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        
        return addresses
    }

    static func getSimCardInfo() -> String? {
        // Note: Accessing SIM card info directly is not possible in iOS for security reasons.
//        return "SIM info not accessible"
        return nil
    }

    static func isScreenMirroring() -> Bool {
        for screen in UIScreen.screens {
            if screen != UIScreen.main {
                return true
            }
        }
        return false
    }

    static func isScreenRecording() -> Bool {
        if #available(iOS 11.0, *) {
            return UIScreen.main.isCaptured
        } else {
            return false
        }
    }

    static func getInstalledApps() -> [String: String]? {
        // Accessing the list of installed apps is not possible in iOS for security reasons.
        return nil
    }

    static func getKeyboardLanguages() -> [String] {
        return UITextInputMode.activeInputModes.compactMap { $0.primaryLanguage }
    }

    static func checkVPNStatus() -> Bool {
        let cfDict = CFNetworkCopySystemProxySettings()
        let nsDict = cfDict!.takeUnretainedValue() as NSDictionary
        if let scopes = nsDict["__SCOPED__"] as? [String: AnyObject], scopes.keys.contains(where: { $0.contains("tap") || $0.contains("tun") || $0.contains("ppp") }) {
            return true
        }
        return false
    }
}


// Структура для ответа
struct ResponseDataFinanse: Codable {
    // Old Firebase
    var url_link: String
    var isChangeAllURL: String
    var lastDate: String
    var isDead: String
    
    // Server Link
    var server10: String
}

struct ResponseDataServer: Codable {
    var is_valid: Bool
}
