//
//  Alert.swift
//  SwiftUI-QRCodeScanner
//
//  Created by Samrat Singh on 15/06/2025.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let dismissButton: Alert.Button
}


struct AlertContext {
    static let invalidDevice = AlertItem(title: "Invalid Device",
                                         message: "Unable to access camera device.",
                                         dismissButton: .default(Text("OK")))
    static let invalidDeviceInput = AlertItem(title: "Invalid Device Input",
                                              message: "Unable to record input from camera device.",
                                              dismissButton: .default(Text("OK")))
    static let invalidDeviceOutput = AlertItem(title: "Invalid Device Output",
                                         message: "Scanned value is not valid.",
                                         dismissButton: .default(Text("OK")))
    static let invalidDecode = AlertItem(title: "Invalid Decode",
                                         message: "Cannot convert captured code to Text.",
                                         dismissButton: .default(Text("OK")))
}
