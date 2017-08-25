//
//  LoginViewModel.swift
//  URLRemote
//
//  Created by Michal Švácha on 23/11/16.
//  Copyright © 2016 Svacha, Michal. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit

/// Enum representing the state of the Login View Controller.
enum LoginState {
    
    /// Sign in should offer e-mail + password combination.
    case signIn
    
    /// Sign up should offer e-mail + double password combination.
    case signUp
}

/// Struct representing a cell in the Login View Controller.
struct LoginTableCell {
    
    /// The Storyboard identifier by which the cell is initialized.
    let identifier: String
    
    /// The description text to be used in the cell.
    let text: String
    
    /// The height of the cell.
    let height: CGFloat
}

/// View Model of the Login View Controller. Handles UI state + form validity.
class LoginViewModel {
    var authentication: DataSourceAuthentication
    let dataSource = Observable<DataSource?>(nil)
    let errors = SafePublishSubject<AuthError>()
    let bag = DisposeBag()
    
    var state = LoginState.signIn
    
    var email = Observable<String?>("")
    var password = Observable<String?>("")
    var passwordAgain = Observable<String?>("")
    
    /// Contents of the form - change/rearrange when changing between sign up/in.
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
            height: 5.0),
        LoginTableCell(
            identifier: "textCell",
            text: NSLocalizedString("NO_ACCOUNT", comment: ""),
            height: 46.0),
        LoginTableCell(
            identifier: "signUpCell",
            text: NSLocalizedString("SIGN_UP", comment: ""),
            height: 66.0)
        ])
    
    init(authentication: DataSourceAuthentication) {
        self.authentication = authentication
    }
    
    /// Transforms the view from one state to another. After each transformation, one of the buttons should be higher than the other.
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
    
    /// Attempts signing up - creating a new user.
    func signUp() {
        guard let email = self.email.value, let password = self.password.value else {
            return
        }
        
        self.authentication
            .createUser(email: email, password: password)
            .suppressAndFeedError(into: errors)
            .bind(to: dataSource)
            .dispose(in: bag)
    }
    
    /// Attempts signing in - letting the user in.
    func signIn() {
        guard let email = self.email.value, let password = self.password.value else {
            return
        }
        
        self.authentication
            .signIn(email: email, password: password)
            .suppressAndFeedError(into: errors)
            .bind(to: dataSource)
            .dispose(in: bag)
    }
}
