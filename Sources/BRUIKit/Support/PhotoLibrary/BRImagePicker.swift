//
//  BRImagePicker.swift
//  BRUIKit
//
//  Created by BR on 2025/10/23.
//

import UIKit
import PhotosUI
import AVFoundation


public struct BRPickedImage {
    public let image: UIImage
    public let data: Data
    
    public init(image: UIImage, data: Data) {
        self.image = image
        self.data = data
    }
}


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
    private var continuation: CheckedContinuation<BRPickedImage, Error>?
    
    
    // MARK: - Init
    
    
    public init(presentingViewController: UIViewController) {
        self.presentingVC = presentingViewController
    }
    
    
    // MARK: - Entry
    
    
    public func pick(from source: Source) async throws -> BRPickedImage {
        switch source {
        case .camera:
            try await checkCameraPermission()
            return try await presentCamera()
        case .photoLibrary:
            return try await presentPhotoLibrary()
        }
    }
    
    
    // MARK: - Camera
    
    
    private func presentCamera() async throws -> BRPickedImage {
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
    
    
    private func presentPhotoLibrary() async throws -> BRPickedImage {
        if #available(iOS 14, *) {
            var config = PHPickerConfiguration(photoLibrary: .shared())
            config.selectionLimit = 1
            config.filter = .any(of: [.images, .livePhotos])
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = self
            return try await withCheckedThrowingContinuation { continuation in
                self.continuation = continuation
                presentingVC?.present(picker, animated: true)
            }
        } else {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            return try await withCheckedThrowingContinuation { continuation in
                self.continuation = continuation
                presentingVC?.present(picker, animated: true)
            }
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
        continuation?.resume(returning: BRPickedImage(image: image, data: data))
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
            provider.loadDataRepresentation(forTypeIdentifier: "public.image") { [weak self] data, error in
                guard let self = self, let data = data else {
                    DispatchQueue.main.async {
                        self?.continuation?.resume(throwing: PickerError.loadFailed)
                        self?.continuation = nil
                    }
                    return
                }
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.continuation?.resume(returning: BRPickedImage(image: image, data: data))
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
