//
//  AppSettings.swift
//  Concert App
//
//  Created by Michael Tempestini on 3/1/26.
//

import SwiftUI

@MainActor
class AppSettings: ObservableObject {
    static let shared = AppSettings()
    
    private let colorSchemeKey = "appColorScheme"
    
    @Published var colorSchemeOption: ColorSchemeOption {
        didSet {
            UserDefaults.standard.set(colorSchemeOption.rawValue, forKey: colorSchemeKey)
        }
    }
    
    private init() {
        // Load saved preference, default to system if none exists
        if let savedValue = UserDefaults.standard.string(forKey: colorSchemeKey),
           let option = ColorSchemeOption(rawValue: savedValue) {
            self.colorSchemeOption = option
        } else {
            self.colorSchemeOption = .system
        }
    }
}
