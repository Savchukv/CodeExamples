//
//  Device.swift
//
//  Created by Василий Савчук on 07.11.2019.
//  Copyright © 2019
//

public extension UIDevice {

    enum DeviceModelName: String {
        case simulator
        case undefined
        case iPodTouch5
        case iPodTouch6
        case iPhone4
        case iPhone4s
        case iPhone5
        case iPhone5c
        case iPhone5s
        case iPhone6
        case iPhone6Plus
        case iPhone6s
        case iPhone6sPlus
        case iPhone7
        case iPhone7Plus
        case iPhoneSE
        case iPhone8
        case iPhone8Plus
        case iPhoneX
        case iPhoneXS
        case iPhoneXSMax
        case iPhoneXR
        case iPhone11
        case iPhone11Pro
        case iPhone11ProMax
        case iPad2
        case iPad3
        case iPad4
        case iPadAir
        case iPadAir2
        case iPad5
        case iPad6
        case iPadMini
        case iPadMini2
        case iPadMini3
        case iPadMini4
        case iPadPro97Inch
        case iPadPro129Inch
        case iPadPro129Inch2ndGen
        case iPadPro105Inch
        case iPadPro11Inch
        case iPadPro129Inch3rdGen
        case AppleTV
        case AppleTV4K
        case HomePod
    }

    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        switch identifier {
        case "iPod5,1":                                 return DeviceModelName.iPodTouch5.rawValue
        case "iPod7,1":                                 return DeviceModelName.iPodTouch6.rawValue
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return DeviceModelName.iPhone4.rawValue
        case "iPhone4,1":                               return DeviceModelName.iPhone4s.rawValue
        case "iPhone5,1", "iPhone5,2":                  return DeviceModelName.iPhone5.rawValue
        case "iPhone5,3", "iPhone5,4":                  return DeviceModelName.iPhone5c.rawValue
        case "iPhone6,1", "iPhone6,2":                  return DeviceModelName.iPhone5s.rawValue
        case "iPhone7,2":                               return DeviceModelName.iPhone6.rawValue
        case "iPhone7,1":                               return DeviceModelName.iPhone6Plus.rawValue
        case "iPhone8,1":                               return DeviceModelName.iPhone6s.rawValue
        case "iPhone8,2":                               return DeviceModelName.iPhone6sPlus.rawValue
        case "iPhone9,1", "iPhone9,3":                  return DeviceModelName.iPhone7.rawValue
        case "iPhone9,2", "iPhone9,4":                  return DeviceModelName.iPhone7Plus.rawValue
        case "iPhone8,4":                               return DeviceModelName.iPhoneSE.rawValue
        case "iPhone10,1", "iPhone10,4":                return DeviceModelName.iPhone8.rawValue
        case "iPhone10,2", "iPhone10,5":                return DeviceModelName.iPhone8Plus.rawValue
        case "iPhone10,3", "iPhone10,6":                return DeviceModelName.iPhoneX.rawValue
        case "iPhone11,2":                              return DeviceModelName.iPhoneXS.rawValue
        case "iPhone11,4", "iPhone11,6":                return DeviceModelName.iPhoneXSMax.rawValue
        case "iPhone11,8":                              return DeviceModelName.iPhoneXR.rawValue
        case "iPhone12,1":                              return DeviceModelName.iPhone11.rawValue
        case "iPhone12,3":                              return DeviceModelName.iPhone11Pro.rawValue
        case "iPhone12,5":                              return DeviceModelName.iPhone11ProMax.rawValue
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return DeviceModelName.iPad2.rawValue
        case "iPad3,1", "iPad3,2", "iPad3,3":           return DeviceModelName.iPad3.rawValue
        case "iPad3,4", "iPad3,5", "iPad3,6":           return DeviceModelName.iPad4.rawValue
        case "iPad4,1", "iPad4,2", "iPad4,3":           return DeviceModelName.iPadAir.rawValue
        case "iPad5,3", "iPad5,4":                      return DeviceModelName.iPadAir2.rawValue
        case "iPad6,11", "iPad6,12":                    return DeviceModelName.iPad5.rawValue
        case "iPad7,5", "iPad7,6":                      return DeviceModelName.iPad6.rawValue
        case "iPad2,5", "iPad2,6", "iPad2,7":           return DeviceModelName.iPadMini.rawValue
        case "iPad4,4", "iPad4,5", "iPad4,6":           return DeviceModelName.iPadMini2.rawValue
        case "iPad4,7", "iPad4,8", "iPad4,9":           return DeviceModelName.iPadMini3.rawValue
        case "iPad5,1", "iPad5,2":                      return DeviceModelName.iPadMini4.rawValue
        case "iPad6,3", "iPad6,4":                      return DeviceModelName.iPadPro97Inch.rawValue
        case "iPad6,7", "iPad6,8":                      return DeviceModelName.iPadPro129Inch.rawValue
        case "iPad7,1", "iPad7,2":                      return DeviceModelName.iPadPro129Inch2ndGen.rawValue
        case "iPad7,3", "iPad7,4":                      return DeviceModelName.iPadPro105Inch.rawValue
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return DeviceModelName.iPadPro11Inch.rawValue
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return DeviceModelName.iPadPro129Inch3rdGen.rawValue
        case "AppleTV5,3":                              return DeviceModelName.AppleTV.rawValue
        case "AppleTV6,2":                              return DeviceModelName.AppleTV4K.rawValue
        case "AudioAccessory1,1":                       return DeviceModelName.HomePod.rawValue
        case "i386", "x86_64":                          return DeviceModelName.simulator.rawValue
        default:                                        return DeviceModelName.undefined.rawValue
        }
    }
}
