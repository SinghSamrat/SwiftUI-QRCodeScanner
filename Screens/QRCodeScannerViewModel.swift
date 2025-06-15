//
//  QRCodeScannerViewModel.swift
//  SwiftUI-QRCodeScanner
//
//  Created by Samrat Singh on 15/06/2025.
//

import SwiftUI

class QRCodeScannerViewModel: ObservableObject {
    @Published var scannedCode: String = ""
    @Published var alertItem: AlertItem?
    @Published var isScanning: Bool = false
    
    var statusText: String {
        scannedCode.isEmpty ? "Not yet scanned" : scannedCode
    }
    
    var statusColor: Color {
        scannedCode.isEmpty ? .red : .green
    }
}
