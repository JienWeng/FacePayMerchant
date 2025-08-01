//
//  UserManager.swift
//  FacePayMobile
//
//  Created by Lai Jien Weng on 31/07/2025.
//

import SwiftUI
import Foundation

class UserManager: ObservableObject {
    @Published var currentUser: User
    @Published var isSignedIn: Bool = false
    @Published var transactions: [Transaction] = []
    @Published var dailyRevenue: [DailyRevenue] = []
    
    private let userDefaults = UserDefaults.standard
    private let userNameKey = "SavedUserName"
    private let icNumberKey = "SavedICNumber"
    private let phoneNumberKey = "SavedPhoneNumber"
    private let businessNameKey = "SavedBusinessName"
    private let emailKey = "SavedEmail"
    private let transactionsKey = "SavedTransactions"
    private let dailyRevenueKey = "SavedDailyRevenue"
    
    var todayRevenue: Double {
        let today = Calendar.current.startOfDay(for: Date())
        return transactions.filter { Calendar.current.isDate($0.date, inSameDayAs: today) }
                          .reduce(0) { $0 + $1.amount }
    }
    
    var todayTransactionCount: Int {
        let today = Calendar.current.startOfDay(for: Date())
        return transactions.filter { Calendar.current.isDate($0.date, inSameDayAs: today) }.count
    }
    
    var totalBalance: Double {
        return transactions.reduce(0) { $0 + $1.amount }
    }
    
    var weeklyRevenue: [Double] {
        let calendar = Calendar.current
        let today = Date()
        var weekly: [Double] = Array(repeating: 0, count: 7)
        
        for i in 0..<7 {
            let date = calendar.date(byAdding: .day, value: -6 + i, to: today)!
            let dayRevenue = transactions.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
                                       .reduce(0) { $0 + $1.amount }
            weekly[i] = dayRevenue
        }
        return weekly
    }
    
    init() {
        let savedName = userDefaults.string(forKey: userNameKey) ?? "User"
        let savedICNumber = userDefaults.string(forKey: icNumberKey) ?? ""
        let savedPhoneNumber = userDefaults.string(forKey: phoneNumberKey) ?? ""
        let savedBusinessName = userDefaults.string(forKey: businessNameKey) ?? ""
        let savedEmail = userDefaults.string(forKey: emailKey) ?? ""
        self.currentUser = User(name: savedName, faceData: nil, icNumber: savedICNumber, phoneNumber: savedPhoneNumber, businessName: savedBusinessName, email: savedEmail)
        
        loadTransactions()
        loadSampleDataIfNeeded()
    }
    
    private func loadSampleDataIfNeeded() {
        if transactions.isEmpty {
            // Add some sample transactions for demo
            let sampleTransactions = [
                Transaction(id: UUID().uuidString, customerName: "John Smith", amount: 45.99, date: Date().addingTimeInterval(-3600), status: .completed),
                Transaction(id: UUID().uuidString, customerName: "Sarah Johnson", amount: 128.50, date: Date().addingTimeInterval(-7200), status: .completed),
                Transaction(id: UUID().uuidString, customerName: "Mike Chen", amount: 89.00, date: Date().addingTimeInterval(-86400), status: .completed),
                Transaction(id: UUID().uuidString, customerName: "Emma Wilson", amount: 234.75, date: Date().addingTimeInterval(-172800), status: .completed)
            ]
            transactions = sampleTransactions
            saveTransactions()
        }
    }
    
    func addTransaction(customerName: String, amount: Double) {
        let transaction = Transaction(
            id: UUID().uuidString,
            customerName: customerName,
            amount: amount,
            date: Date(),
            status: .completed
        )
        transactions.insert(transaction, at: 0) // Add to beginning
        saveTransactions()
    }
    
    private func saveTransactions() {
        if let encoded = try? JSONEncoder().encode(transactions) {
            userDefaults.set(encoded, forKey: transactionsKey)
        }
    }
    
    private func loadTransactions() {
        if let data = userDefaults.data(forKey: transactionsKey),
           let decoded = try? JSONDecoder().decode([Transaction].self, from: data) {
            transactions = decoded
        }
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

struct Transaction: Identifiable, Codable {
    let id: String
    let customerName: String
    let amount: Double
    let date: Date
    let status: TransactionStatus
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

enum TransactionStatus: String, Codable {
    case completed = "completed"
    case pending = "pending"
    case failed = "failed"
}

struct DailyRevenue: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let revenue: Double
}
