//
//  ContentView.swift
//  SwiftUI-QRCodeScanner
//
//  Created by Samrat Singh on 15/06/2025.
//

import SwiftUI

struct QRCodeScannerView: View {
    @StateObject var viewModel = QRCodeScannerViewModel()
    @State private var scannerVCRef: ScannerVC?
    
    var body: some View {
        NavigationView {
            VStack {
                ScannerView(scannedQRCode: $viewModel.scannedCode,
                            alertItem: $viewModel.alertItem,
                            scannerVCRef: $scannerVCRef,
                )
                    .frame(width: .infinity, height: 300)
                
                Spacer().frame(height: 80)
                
                ScannedQRCodeView(scanResult: viewModel.statusText,
                                  statusColor: viewModel.statusColor)
                
                Spacer().frame(height: 80)
                
                Button() {
                    viewModel.scannedCode = ""
                    scannerVCRef?.restartCaptureSession()
                } label: {
                    Label("Scan Again", systemImage: "arrow.clockwise")
                }
            }
            .navigationTitle(Text("QRCode Scanner"))
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(title: Text(alertItem.title),
                      message: Text(alertItem.message),
                      dismissButton: alertItem.dismissButton)
            }
        }
    }
}

struct ScannedQRCodeView: View {
    var scanResult: String
    var statusColor: Color
    var body: some View {
        Label("Scanned QR Code:", systemImage: "qrcode.viewfinder")
            .font(.title)
        
        Link(scanResult, destination: URL(string: scanResult) ?? URL(string: "https://www.google.com")!)
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(statusColor)
            .padding(.top, 5)
    }
}

#Preview {
    QRCodeScannerView()
}
