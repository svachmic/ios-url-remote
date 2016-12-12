//
//  LoginViewModel.swift
//  URLRemote
//
//  Created by Michal Švácha on 23/11/16.
//  Copyright © 2016 Svacha, Michal. All rights reserved.
//

import Foundation
import Bond
import FirebaseAuth

///
enum LoginState {
    case signIn
    case signUp
}

///
struct LoginTableCell {
    let identifier: String
    let text: String
    let height: CGFloat
}

///
class LoginViewModel {
    var state = LoginState.signIn
    
    var email = Observable<String?>("")
    var password = Observable<String?>("")
    var passwordAgain = Observable<String?>("")
    
    let contents = MutableObservableArray<LoginTableCell>([
        LoginTableCell(
            identifier: "headerCell",
            text: "",
            height: 20.0),
        LoginTableCell(
            identifier: "emailCell",
            text: NSLocalizedString("EMAIL", comment: ""),
            height: 78.0),
        LoginTableCell(
            identifier: "passwordCell",
            text: NSLocalizedString("PASSWORD", comment: ""),
            height: 72.0),
        LoginTableCell(
            identifier: "signInCell",
            text: NSLocalizedString("SIGN_IN", comment: ""),
            height: 66.0),
        LoginTableCell(
            identifier: "googleCell",
            text: "",
            height: 80.0),
        LoginTableCell(
            identifier: "textCell",
            text: NSLocalizedString("NO_ACCOUNT", comment: ""),
            height: 46.0),
        LoginTableCell(
            identifier: "signUpCell",
            text: NSLocalizedString("SIGN_UP", comment: ""),
            height: 66.0)
        ])
    
    ///
    func transform() {
        if self.state == .signIn {
            self.contents.insert(LoginTableCell(
                identifier: "passwordAgainCell",
                text: NSLocalizedString("PASSWORD_AGAIN", comment: ""),
                height: 78.0), at: 3)
            self.contents.moveItem(from: 4, to: 7)
            self.contents.moveItem(from: 6, to: 4)
            self.contents.remove(at: 6)
            
            self.contents.insert(LoginTableCell(
                identifier: "textCell",
                text: NSLocalizedString("YES_ACCOUNT", comment: ""),
                height: 46.0), at: 6)
            self.state = .signUp
        } else {
            self.contents.remove(at: 3)
            self.contents.moveItem(from: 3, to: 6)
            self.contents.moveItem(from: 5, to: 3)
            
            self.contents.remove(at: 5)
            self.contents.insert(LoginTableCell(
                identifier: "textCell",
                text: NSLocalizedString("NO_ACCOUNT", comment: ""),
                height: 46.0), at: 5)
            self.state = .signIn
        }
    }
    
    func signUp() {
        // TODO: validate fields
        
        guard let auth = FIRAuth.auth() else {
            return
        }
        
        guard let email = self.email.value, let password = self.password.value else {
            return
        }
        
        auth.createUser(withEmail: email, password: password) { user, error in
            if error == nil {
                self.signIn()
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FAILED_SIGN_UP"), object: error)
            }
        }
    }
    
    func signIn() {
        // TODO: validate fields
        
        guard let auth = FIRAuth.auth() else {
            return
        }
        
        guard let email = self.email.value, let password = self.password.value else {
            return
        }
        
        auth.signIn(withEmail: email, password: password) { user, error in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FAILED_SIGN_IN"), object: error)
        }
    }
}