//
//  StorageService.swift
//  Firebase-Project
//
//  Created by Lilia Yudina on 3/9/20.
//  Copyright © 2020 Lilia Yudina. All rights reserved.
//

import Foundation
import FirebaseStorage

class StotageService {

    private let storageRef = Storage.storage().reference()
    
    public func uploadPhoto(userId: String? = nil, itemId: String? = nil, image: UIImage, completion: @escaping (Result<URL, Error>) -> ()) {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return
        }
 
        var photoReference: StorageReference!
        
        if let userId = userId {
            photoReference = storageRef.child("UserProfilePhotos/\(userId).jpg")
        } else if let itemId = itemId {
            photoReference = storageRef.child("ItemsPhotos/\(itemId).jpg")
        }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg" 
        
        let _ = photoReference.putData(imageData, metadata: metadata) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
            } else if let _ = metadata {
                photoReference.downloadURL { (url, error) in
                    if let error = error {
                        completion(.failure(error))
                    } else if let url = url {
                        completion(.success(url))
                    }
                }
            }
        }
}
}
