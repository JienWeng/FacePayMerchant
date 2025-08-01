//
//  DashboardView.swift
//  FacePayMerchant
//
//  Created by Lai Jien Weng on 01/08/2025.
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject var userManager: UserManager
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack {
                    Color.white
                        .ignoresSafeArea()
                    
                    // Main content optimized for landscape iPad
                    HStack(spacing: 0) {
                        // Left side - Business Info Panel
                        VStack(alignment: .leading, spacing: 30) {
                            // Header
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Welcome back,")
                                    .font(.system(size: 20, weight: .medium, design: .default))
                                    .foregroundColor(.gray)
                                
                                Text(userManager.currentUser.name)
                                    .font(.system(size: 36, weight: .bold, design: .default))
                                    .foregroundColor(.black)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.8)
                            }
                            .padding(.top, 20)
                            
                            // Business Info Cards
                            VStack(spacing: 20) {
                                // Business Name Card
                                BusinessInfoCard(
                                    icon: "building.2.fill",
                                    title: "Business Name",
                                    value: userManager.currentUser.businessName.isEmpty ? "Not Set" : userManager.currentUser.businessName
                                )
                                
                                // Email Card
                                BusinessInfoCard(
                                    icon: "envelope.fill",
                                    title: "Email",
                                    value: userManager.currentUser.email.isEmpty ? "Not Set" : userManager.currentUser.email
                                )
                                
                                // Phone Number Card
                                BusinessInfoCard(
                                    icon: "phone.fill",
                                    title: "Phone Number",
                                    value: userManager.currentUser.phoneNumber.isEmpty ? "Not Set" : userManager.currentUser.phoneNumber
                                )
                            }
                            
                            Spacer()
                            
                            // Logout Button
                            Button(action: {
                                userManager.signOut()
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .font(.system(size: 18, weight: .bold))
                                    Text("Sign Out")
                                        .font(.system(size: 18, weight: .bold, design: .default))
                                }
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(15)
                            }
                            .padding(.bottom, 30)
                        }
                        .frame(width: geometry.size.width * 0.4)
                        .padding(.horizontal, 30)
                        .background(Color.gray.opacity(0.05))
                        
                        // Right side - Main Content Area
                        VStack(spacing: 30) {
                            // Quick Stats Row
                            HStack(spacing: 20) {
                                StatCard(
                                    icon: "creditcard.fill",
                                    title: "Today's Transactions",
                                    value: "0",
                                    color: .primaryYellow
                                )
                                
                                StatCard(
                                    icon: "dollarsign.circle.fill",
                                    title: "Today's Revenue",
                                    value: "$0.00",
                                    color: .green
                                )
                                
                                StatCard(
                                    icon: "person.2.fill",
                                    title: "Active Customers",
                                    value: "0",
                                    color: .blue
                                )
                            }
                            
                            // Merchant Tools Section
                            VStack(alignment: .leading, spacing: 20) {
                                Text("Merchant Tools")
                                    .font(.system(size: 28, weight: .bold, design: .default))
                                    .foregroundColor(.black)
                                
                                LazyVGrid(columns: [
                                    GridItem(.flexible(), spacing: 20),
                                    GridItem(.flexible(), spacing: 20)
                                ], spacing: 20) {
                                    // Payment Terminal
                                    MerchantToolCard(
                                        icon: "terminal.fill",
                                        title: "Payment Terminal",
                                        subtitle: "Process face payments",
                                        isComingSoon: true
                                    )
                                    
                                    // Transaction History
                                    MerchantToolCard(
                                        icon: "list.bullet.rectangle.fill",
                                        title: "Transaction History",
                                        subtitle: "View payment records",
                                        isComingSoon: true
                                    )
                                    
                                    // Analytics
                                    MerchantToolCard(
                                        icon: "chart.bar.fill",
                                        title: "Analytics",
                                        subtitle: "Business insights",
                                        isComingSoon: true
                                    )
                                    
                                    // Settings
                                    MerchantToolCard(
                                        icon: "gearshape.fill",
                                        title: "Settings",
                                        subtitle: "Configure your account",
                                        isComingSoon: true
                                    )
                                }
                            }
                            
                            Spacer()
                        }
                        .frame(width: geometry.size.width * 0.6)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 30)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Supporting Views

struct BusinessInfoCard: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primaryYellow)
                .frame(width: 40, height: 40)
                .background(Circle().fill(Color.primaryYellow.opacity(0.1)))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .medium, design: .default))
                    .foregroundColor(.gray)
                
                Text(value)
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .foregroundColor(.black)
                
                Text(title)
                    .font(.system(size: 12, weight: .medium, design: .default))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct MerchantToolCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let isComingSoon: Bool
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(isComingSoon ? .gray : .primaryYellow)
            
            VStack(spacing: 6) {
                Text(title)
                    .font(.system(size: 18, weight: .bold, design: .default))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                Text(subtitle)
                    .font(.system(size: 14, weight: .medium, design: .default))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                
                if isComingSoon {
                    Text("Coming Soon")
                        .font(.system(size: 12, weight: .bold, design: .default))
                        .foregroundColor(.primaryYellow)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color.primaryYellow.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.top, 4)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 140)
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        .opacity(isComingSoon ? 0.7 : 1.0)
    }
}

#Preview(traits: .landscapeLeft) {
    DashboardView(userManager: UserManager())
}
