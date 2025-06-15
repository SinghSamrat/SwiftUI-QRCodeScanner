//
//  ScannerView.swift
//  SwiftUI-QRCodeScanner
//
//  Created by Samrat Singh on 15/06/2025.
//

import Foundation
import SwiftUI

struct ScannerView: UIViewControllerRepresentable {
    @Binding var scannedQRCode: String
    @Binding var alertItem: AlertItem?
    @Binding var scannerVCRef: ScannerVC?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ScannerView>) -> UIViewController {
        let scannerVC = ScannerVC(scannerDelegate: context.coordinator)
        scannerVCRef = scannerVC
        return scannerVC
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<ScannerView>) {}
    
    class Coordinator: NSObject, ScannerVCDelegate {
        private let scannerView: ScannerView
        
        init(scannerView: ScannerView) {
            self.scannerView = scannerView
        }
        
        func didFind(qrcode: String) {
            scannerView.scannedQRCode = qrcode
        }
        
        func didSurface(error: AlertItem) {
            scannerView.alertItem = error
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(scannerView: ScannerView(scannedQRCode: $scannedQRCode, alertItem: $alertItem, scannerVCRef: $scannerVCRef))
    }
}
