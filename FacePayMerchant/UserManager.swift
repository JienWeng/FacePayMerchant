//
//  UserManager.swift
//  FacePayMobile
//
//  Created by Lai Jien Weng on 31/07/2025.
//

import SwiftUI

class UserManager: ObservableObject {
    @Published var currentUser: User
    @Published var isSignedIn: Bool = false
    
    private let userDefaults = UserDefaults.standard
    private let userNameKey = "SavedUserName"
    private let icNumberKey = "SavedICNumber"
    private let phoneNumberKey = "SavedPhoneNumber"
    private let businessNameKey = "SavedBusinessName"
    private let emailKey = "SavedEmail"
    
    init() {
        let savedName = userDefaults.string(forKey: userNameKey) ?? "User"
        let savedICNumber = userDefaults.string(forKey: icNumberKey) ?? ""
        let savedPhoneNumber = userDefaults.string(forKey: phoneNumberKey) ?? ""
        let savedBusinessName = userDefaults.string(forKey: businessNameKey) ?? ""
        let savedEmail = userDefaults.string(forKey: emailKey) ?? ""
        self.currentUser = User(name: savedName, faceData: nil, icNumber: savedICNumber, phoneNumber: savedPhoneNumber, businessName: savedBusinessName, email: savedEmail)
    }
    
    func loadUserData() {
        let savedName = userDefaults.string(forKey: userNameKey) ?? "User"
        let savedICNumber = userDefaults.string(forKey: icNumberKey) ?? ""
        let savedPhoneNumber = userDefaults.string(forKey: phoneNumberKey) ?? ""
        let savedBusinessName = userDefaults.string(forKey: businessNameKey) ?? ""
        let savedEmail = userDefaults.string(forKey: emailKey) ?? ""
        currentUser = User(name: savedName, faceData: currentUser.faceData, icNumber: savedICNumber, phoneNumber: savedPhoneNumber, businessName: savedBusinessName, email: savedEmail)
    }
    
    func updateUserName(_ name: String) {
        currentUser = User(name: name, faceData: currentUser.faceData, icNumber: currentUser.icNumber, phoneNumber: currentUser.phoneNumber, businessName: currentUser.businessName, email: currentUser.email)
        userDefaults.set(name, forKey: userNameKey)
    }
    
    func updateUserFromIC(name: String, icNumber: String) {
        currentUser = User(name: name, faceData: currentUser.faceData, icNumber: icNumber, phoneNumber: currentUser.phoneNumber, businessName: currentUser.businessName, email: currentUser.email)
        userDefaults.set(name, forKey: userNameKey)
        userDefaults.set(icNumber, forKey: icNumberKey)
    }
    
    func updatePhoneNumber(_ phoneNumber: String) {
        currentUser = User(name: currentUser.name, faceData: currentUser.faceData, icNumber: currentUser.icNumber, phoneNumber: phoneNumber, businessName: currentUser.businessName, email: currentUser.email)
        userDefaults.set(phoneNumber, forKey: phoneNumberKey)
    }
    
    func updateBusinessName(_ businessName: String) {
        currentUser = User(name: currentUser.name, faceData: currentUser.faceData, icNumber: currentUser.icNumber, phoneNumber: currentUser.phoneNumber, businessName: businessName, email: currentUser.email)
        userDefaults.set(businessName, forKey: businessNameKey)
    }
    
    func updateEmail(_ email: String) {
        currentUser = User(name: currentUser.name, faceData: currentUser.faceData, icNumber: currentUser.icNumber, phoneNumber: currentUser.phoneNumber, businessName: currentUser.businessName, email: email)
        userDefaults.set(email, forKey: emailKey)
    }
    
    func signIn() {
        isSignedIn = true
    }
    
    func signOut() {
        isSignedIn = false
    }
}

struct User {
    let name: String
    var faceData: Data?
    let icNumber: String
    let phoneNumber: String
    let businessName: String
    let email: String
}
