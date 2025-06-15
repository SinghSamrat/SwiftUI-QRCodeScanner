//
//  ScannerVC.swift
//  SwiftUI-QRCodeScanner
//
//  Created by Samrat Singh on 15/06/2025.
//

import UIKit
import AVFoundation


protocol ScannerVCDelegate: AnyObject { // Protocol is a blueprint of methods, properties, and other requirements
    func didFind(qrcode: String)
    func didSurface(error: AlertItem)
}

class ScannerVC: UIViewController {
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    weak var scannerDelegate: ScannerVCDelegate!
    
    init(scannerDelegate: ScannerVCDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.scannerDelegate = scannerDelegate
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let previewLayer = previewLayer else {
            scannerDelegate.didSurface(error: AlertContext.invalidDevice)
            return
        }
        
        previewLayer.frame = view.layer.bounds
    }
    
    private func setupCaptureSession() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            scannerDelegate.didSurface(error: AlertContext.invalidDevice)
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            scannerDelegate.didSurface(error: AlertContext.invalidDeviceInput)
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            scannerDelegate.didSurface(error: AlertContext.invalidDeviceInput)
            return
        }
        
        let metaDataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metaDataOutput) {
            captureSession.addOutput(metaDataOutput)
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = [.qr, .microQR]
        } else {
            scannerDelegate.didSurface(error: AlertContext.invalidDeviceInput)
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer!)
        
        captureSession.startRunning()
    }
    
    public func restartCaptureSession() {
        if !(captureSession.isRunning){
            captureSession.startRunning()
        }
    }

}

extension ScannerVC: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection
    ) {
        guard let object = metadataObjects.first else {
            //            scannerDelegate.didSurface(error: AlertContext.invalidDeviceOutput)
            return
        }
        
        if object.type != AVMetadataObject.ObjectType.qr && object.type != AVMetadataObject.ObjectType.microQR {
            return
        }
        
        guard let machineReadableObject = object as? AVMetadataMachineReadableCodeObject else {
            scannerDelegate.didSurface(error: AlertContext.invalidDeviceOutput)
            return
        }
        
        guard let qrcode = machineReadableObject.stringValue else {
            scannerDelegate.didSurface(error: AlertContext.invalidDecode)
            return
        }
        
        captureSession.stopRunning()
        scannerDelegate?.didFind(qrcode: qrcode)
    }
}
