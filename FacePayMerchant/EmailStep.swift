//
//  EmailStep.swift
//  FacePayMerchant
//
//  Created by Lai Jien Weng on 01/08/2025.
//

import SwiftUI

struct EmailStep: View {
    let onNext: () -> Void
    @State private var email: String = ""
    @FocusState private var isEmailFocused: Bool
    @StateObject private var userManager = UserManager()
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 40) {
                // Left side - Content
                VStack(spacing: 30) {
                    Spacer()
                    
                    // Icon
                    Image(systemName: "envelope.fill")
                        .font(.system(size: 60, weight: .black))
                        .foregroundColor(.primaryYellow)
                    
                    // Title and description  
                    VStack(spacing: 16) {
                        Text("Email Address")
                            .font(.system(size: 28, weight: .bold, design: .default))
                            .foregroundColor(.black)
                        
                        if !userManager.currentUser.name.isEmpty {
                            Text("Hi \(userManager.currentUser.name)! Please enter your email address")
                                .font(.system(size: 16, weight: .medium, design: .default))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        } else {
                            Text("Please enter your email address")
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
                    
                    // Email input
                    VStack(spacing: 8) {
                        TextField("", text: $email)
                            .placeholder(when: email.isEmpty) {
                                Text("Email address")
                                    .font(.system(size: 18, weight: .medium, design: .default))
                                    .foregroundColor(.gray.opacity(0.6))
                            }
                            .font(.system(size: 18, weight: .semibold, design: .default))
                            .foregroundColor(.black)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .focused($isEmailFocused)
                            .textContentType(.emailAddress)
                        
                        Rectangle()
                            .fill(isEmailFocused ? Color.primaryYellow : Color.gray.opacity(0.3))
                            .frame(height: 2)
                            .animation(.easeInOut(duration: 0.2), value: isEmailFocused)
                    }
                    
                    // Continue button
                    Button(action: {
                        // Save the email and proceed
                        userManager.updateEmail(email)
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
                                .fill(email.isValidEmail ? Color.primaryYellow : Color.gray.opacity(0.3))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.black, lineWidth: 3)
                        )
                    }
                    .disabled(!email.isValidEmail)
                    
                    Spacer()
                }
                .frame(width: geometry.size.width * 0.4)
                
                Spacer()
            }
            .padding(.horizontal, 40)
        }
        .onTapGesture {
            isEmailFocused = false
        }
        .onAppear {
            // Load existing user data when view appears
            userManager.loadUserData()
        }
    }
}

extension String {
    var isValidEmail: Bool {
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
}

#Preview {
    EmailStep(onNext: {})
}
