//
//  Global.swift
//  Signature
//
//  Created by Thanh-Tam Le on 9/23/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import CoreLocation

class Global {
    
    static let colorHome = UIColor(0x3498DB)
    static let colorMain = UIColor(0x206AA7)
    static let colorSecond = UIColor(0x33B476)
    static let colorSelected = UIColor(0x434F5D)
    static let colorBg = UIColor(0xF9F9F9)
    static let colorSeparator = UIColor(0xE6E7E8)
    static let colorStatus = UIColor(0x333333)
    static let colorGray = UIColor(0xAEB5B8)
    static let colorHeader = UIColor(0xF1F5F8)
    static let colorLogin = UIColor(0xE74C3C)
    static let colorNewUser = UIColor(0x2ECC71)
    static let colorNavBar = UIColor(0x444444)
    static let imageSize = CGSize(width: 1024, height: 768)
    
    static var SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static var SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    
    static let mapKey = "AIzaSyD36MbPUKUSVcgc9RBmHzuIyQJSWqyiqRQ"
    static let apiKey = "AIzaSyD36MbPUKUSVcgc9RBmHzuIyQJSWqyiqRQ"
    
    static let serverKey = "key=AIzaSyA8l622rz_n2xCDLwZm7P--ydkYZryY3zo"
    
}


struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    
    static let IS_IPHONE  = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_IPAD    = UIDevice.current.userInterfaceIdiom == .pad
}


