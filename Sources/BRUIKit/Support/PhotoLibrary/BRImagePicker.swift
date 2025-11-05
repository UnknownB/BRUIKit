//
//  BRImagePicker.swift
//  BRUIKit
//
//  Created by BR on 2025/10/23.
//

import BRFoundation
import UIKit
import PhotosUI
import AVFoundation


/// 封裝系統原始 UIImagePicker 透過相機、相簿取得 BRMediaContent
@MainActor
@available(iOS 13.0, *)
public final class BRImagePicker: NSObject {
    
    
    public enum Source {
        case camera
        case photoLibrary
    }
    
    
    public enum PickerError: Error {
        case cameraUnavailable
        case permissionDenied
        case cancelled
        case loadFailed
    }
    
    
    private weak var presentingVC: UIViewController?
    private var continuation: CheckedContinuation<BRMediaContent, Error>?
    
    
    // MARK: - Init
    
    
    public init(presentingViewController: UIViewController) {
        self.presentingVC = presentingViewController
    }
    
    
    // MARK: - Entry
    
    
    public func pick(from source: Source) async throws -> BRMediaContent {
        switch source {
        case .camera:
            try await checkCameraPermission()
            return try await presentCamera()
        case .photoLibrary:
            return try await presentPhotoLibrary()
        }
    }
    
    
    // MARK: - Camera
    
    
    private func presentCamera() async throws -> BRMediaContent {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            throw PickerError.cameraUnavailable
        }
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            presentingVC?.present(picker, animated: true)
        }
    }
    
    
    // MARK: - Photo Library
    
    
    private func presentPhotoLibrary() async throws -> BRMediaContent {
        try await presentPhotoLibraryIOS2()
    }
    
    
    /// 顯示相簿
    /// - Note: iOS 18、26，Release 環境將異常崩潰
    @available(iOS 14.0, *)
    private func presentPhotoLibraryIOS14() async throws -> BRMediaContent {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .any(of: [.images, .livePhotos])
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            presentingVC?.present(picker, animated: true)
        }
    }
    
    
    private func presentPhotoLibraryIOS2() async throws -> BRMediaContent {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            presentingVC?.present(picker, animated: true)
        }
    }
    
    
    // MARK: - Permission
    
    
    private func checkCameraPermission() async throws {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            guard granted else { throw PickerError.permissionDenied }
        default:
            throw PickerError.permissionDenied
        }
    }
    
    
}


// MARK: - Delegates


@available(iOS 13.0, *)
extension BRImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        continuation?.resume(throwing: PickerError.cancelled)
        continuation = nil
    }
    
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage,
              let data = image.jpegData(compressionQuality: 1.0) else {
            continuation?.resume(throwing: PickerError.loadFailed)
            continuation = nil
            return
        }
        continuation?.resume(returning: BRMediaContent(image: image, data: data))
        continuation = nil
    }
    
    
}


@available(iOS 14, *)
extension BRImagePicker: PHPickerViewControllerDelegate {
    
    
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else {
            continuation?.resume(throwing: PickerError.cancelled)
            continuation = nil
            return
        }

        if provider.hasItemConformingToTypeIdentifier("public.image") {
            
            // 在 release 環境會發生異常錯誤而 crash
            provider.loadDataRepresentation(forTypeIdentifier: "public.image") { [weak self] data, error in
                if let error = error {
                    #BRLog(.library, .error, "PHPicker loadDataRepresentation failed: \(error)")
                    return
                }
                guard let self = self, let data = data else {
                    DispatchQueue.main.async {
                        self?.continuation?.resume(throwing: PickerError.loadFailed)
                        self?.continuation = nil
                    }
                    return
                }
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.continuation?.resume(returning: BRMediaContent(image: image, data: data))
                        self.continuation = nil
                    }
                } else {
                    DispatchQueue.main.async {
                        self.continuation?.resume(throwing: PickerError.loadFailed)
                        self.continuation = nil
                    }
                }
            }
        } else {
            continuation?.resume(throwing: PickerError.loadFailed)
            continuation = nil
        }
    }
    
    
}
