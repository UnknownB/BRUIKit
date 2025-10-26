//
//  BRPhotoLibrary.swift
//  BRUIKit
//
//  Created by BR on 2025/10/22.
//

import UIKit
import Photos
import PhotosUI


extension BRPhotoLibrary {
    enum PhotoLibraryError: Error {
        case noAssetsToDelete
    }
}


public enum BRPhotoLibrary {
    
    
    public static var status: PHAuthorizationStatus {
        if #available(iOS 14, *) {
            return PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            return PHPhotoLibrary.authorizationStatus()
        }
    }

        
    public static func requestAuthorization(completion: @escaping @Sendable (PHAuthorizationStatus, Error?) -> Void) {
        PHPhotoLibrary.shared().performChanges {
        } completionHandler: { [self] success, error in
            completion(status, error)
        }
    }
    
    
    public static func requestAuthorization() throws {
        try PHPhotoLibrary.shared().performChangesAndWait {
        }
    }

    
    public static func saveVideoToLibrary(_ fileURL: URL, completion: @escaping @Sendable (Bool, Error?) -> Void) {
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
        } completionHandler: { success, error in
            completion(success, error)
        }
    }
    
    
    public static func saveVideoToLibrary(_ fileURL: URL) throws {
        try PHPhotoLibrary.shared().performChangesAndWait {
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
        }
    }

    
    public static func savePhotoToLibrary(_ image: UIImage, completion: @escaping @Sendable (Bool, Error?) -> Void) {
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        } completionHandler: { success, error in
            completion(success, error)
        }
    }
    
    
    public static func savePhotoToLibrary(_ image: UIImage) throws {
        try PHPhotoLibrary.shared().performChangesAndWait {
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }
    }
    
    
    public static func deleteLatestAsset(with mediaType: PHAssetMediaType, completion: @escaping @Sendable (Bool, Error?) -> Void) {
        PHPhotoLibrary.shared().performChanges { [self] in
            if let lastAsset = fetchLatestAsset(with: mediaType) {
                PHAssetChangeRequest.deleteAssets([lastAsset] as NSFastEnumeration)
            }
        } completionHandler: { success, error in
            completion(success, error)
        }
    }
    
    
    public static func deleteLatestAsset(with mediaType: PHAssetMediaType) throws {
        if let lastAsset = fetchLatestAsset(with: mediaType) {
            try PHPhotoLibrary.shared().performChangesAndWait {
                PHAssetChangeRequest.deleteAssets([lastAsset] as NSFastEnumeration)
            }
        } else {
            throw PhotoLibraryError.noAssetsToDelete
        }
    }
    
    
    public static func fetchLatestAsset(with mediaType: PHAssetMediaType) -> PHAsset? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        return fetchResult.firstObject
    }
    
    
    /// 從 iOS 14 開始，當使用者選擇有限開放相簿時，可透過此 API 供使用者選擇授權檔案
    @available(iOS 14, *)
    public static func showLimitedLibraryPicker(from viewController: UIViewController) {
       PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: viewController)
    }

    
}
