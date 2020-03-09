//
//  ProfileViewController.swift
//  Firebase-Project
//
//  Created by Lilia Yudina on 3/9/20.
//  Copyright © 2020 Lilia Yudina. All rights reserved.
//

import UIKit
import FirebaseAuth
import Kingfisher

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var imageCountLabel: UILabel!
    
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        return ip
    }()
    
    private var selectedImage: UIImage? {
        didSet {
            imageView.image = selectedImage
        }
    }
    
    private let storageService = StotageService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        updateUI()
        
    }
    
    private func updateUI() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        emailLabel.text = user.email
        nameTextField.text = user.displayName
        imageView.kf.setImage(with: user.photoURL)
        imageCountLabel.text = "You have submitted  images"
        //        user.displayName
        //        user.email
        //        user.phoneNumber
        //        user.photoURL
    }
    
    @IBAction func updatePhotoButtonPressed(_ sender: UIButton) {
        // change the user's display name
        guard let displayName = nameTextField.text,
            !displayName.isEmpty, let selectedImage = selectedImage else {
                print("missing fields")
                return
        }
        
        guard let user = Auth.auth().currentUser else { return }
        
        // resize image before uploading to Firebase
        let resizedImage = UIImage.resizeImage(originalImage: selectedImage, rect: imageView.bounds)
        print("original image size: \(selectedImage.size)")
        print("resized image size: \(resizedImage)")
        
        storageService.uploadPhoto(userId: user.uid, image: resizedImage) { [weak self] (result) in
            // code here to add the photoURL to the user's photoURL property then commit changes
            
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error uploading photo", message: "\(error.localizedDescription)")
                }
            case .success(let url):
                let request = Auth.auth().currentUser?.createProfileChangeRequest()
                request?.displayName = displayName
                request?.photoURL = url
                request?.commitChanges(completion: { [unowned self] (error) in
                    if let error = error {
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Error updating profile", message: "Error changing profile: \(error.localizedDescription)")
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Profile Update", message: "Profile successfully updated.")
                        }
                    }
                    
                })
                
            }
        }
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Choose Photo Option", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: nil)
        let photoLibraryAction = UIAlertAction(title: "Phot Library", style: .default) { alertAction in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated:  true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            alertAction in
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(cameraAction)
        }
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
        
    }
    
}
extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        selectedImage = image
        dismiss(animated: true)
    }
}
