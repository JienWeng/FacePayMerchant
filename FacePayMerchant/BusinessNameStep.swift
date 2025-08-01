//
//  BusinessNameStep.swift
//  FacePayMerchant
//
//  Created by Lai Jien Weng on 01/08/2025.
//

import SwiftUI

struct BusinessNameStep: View {
    let onNext: () -> Void
    @State private var businessName: String = ""
    @FocusState private var isBusinessNameFocused: Bool
    @StateObject private var userManager = UserManager()
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 40) {
                // Left side - Content
                VStack(spacing: 30) {
                    Spacer()
                    
                    // Icon
                    Image(systemName: "building.2.fill")
                        .font(.system(size: 60, weight: .black))
                        .foregroundColor(.primaryYellow)
                    
                    // Title and description  
                    VStack(spacing: 16) {
                        Text("Business Name")
                            .font(.system(size: 28, weight: .bold, design: .default))
                            .foregroundColor(.black)
                        
                        if !userManager.currentUser.name.isEmpty {
                            Text("Hi \(userManager.currentUser.name)! Please enter your business name")
                                .font(.system(size: 16, weight: .medium, design: .default))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        } else {
                            Text("Please enter your business name")
                                .font(.system(size: 16, weight: .medium, design: .default))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                    }
                    
                    Spacer()
                }
                .frame(width: geometry.size.width * 0.4)
                
                // Right side - Input and Action
                VStack(spacing: 40) {
                    Spacer()
                    
                    // Business name input
                    VStack(spacing: 8) {
                        TextField("", text: $businessName)
                            .placeholder(when: businessName.isEmpty) {
                                Text("Business name")
                                    .font(.system(size: 18, weight: .medium, design: .default))
                                    .foregroundColor(.gray.opacity(0.6))
                            }
                            .font(.system(size: 18, weight: .semibold, design: .default))
                            .foregroundColor(.black)
                            .focused($isBusinessNameFocused)
                            .textContentType(.organizationName)
                        
                        Rectangle()
                            .fill(isBusinessNameFocused ? Color.primaryYellow : Color.gray.opacity(0.3))
                            .frame(height: 2)
                            .animation(.easeInOut(duration: 0.2), value: isBusinessNameFocused)
                    }
                    
                    // Continue button
                    Button(action: {
                        // Save the business name and proceed
                        userManager.updateBusinessName(businessName)
                        onNext()
                    }) {
                        HStack {
                            Text("Continue")
                                .font(.system(size: 18, weight: .bold, design: .default))
                                .foregroundColor(.black)
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .black))
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(businessName.isValidBusinessName ? Color.primaryYellow : Color.gray.opacity(0.3))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.black, lineWidth: 3)
                        )
                    }
                    .disabled(!businessName.isValidBusinessName)
                    
                    Spacer()
                }
                .frame(width: geometry.size.width * 0.4)
                
                Spacer()
            }
            .padding(.horizontal, 40)
        }
        .onTapGesture {
            isBusinessNameFocused = false
        }
        .onAppear {
            // Load existing user data when view appears
            userManager.loadUserData()
        }
    }
}

extension String {
    var isValidBusinessName: Bool {
        return !self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && self.count >= 2
    }
}

#Preview {
    BusinessNameStep(onNext: {})
}
