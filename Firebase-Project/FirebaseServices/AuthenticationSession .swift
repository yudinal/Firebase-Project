//
//  AuthenticationSession .swift
//  Firebase-Project
//
//  Created by Lilia Yudina on 3/6/20.
//  Copyright © 2020 Lilia Yudina. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthenticationSession {
    
    public func createNewUser(username: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> ()) {
        Auth.auth().createUser(withEmail: username, password: password) { (authDataResult, error) in
            if let error = error {
                completion(.failure(error))
            } else if let authDataResult = authDataResult {
                completion(.success(authDataResult))
            }
        }
    }
    
    public func signinExistingUser(userName: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> ()) {
        Auth.auth().signIn(withEmail: userName, password: password) { (authDataResult, error) in
            if let error = error {
                completion(.failure(error))
            } else if let authDataResult = authDataResult {
                completion(.success(authDataResult))
            }
        }
    }
}
