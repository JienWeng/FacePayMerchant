//
//  DashboardView.swift
//  FacePayMerchant
//
//  Created by Lai Jien Weng on 01/08/2025.
//

import SwiftUI
import AVFoundation
import Vision

enum PaymentState {
    case ready
    case enteringAmount
    case scanningCustomer
    case confirmingPayment
    case processing
    case completed
}

struct DashboardView: View {
    @ObservedObject var userManager: UserManager
    @State private var paymentState: PaymentState = .ready
    @State private var paymentAmount: String = ""
    @State private var recognizedCustomer: String = ""
    @State private var showingTransactions = false
    @State private var showingWithdrawals = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                if paymentState == .ready {
                    // Main dashboard view with new layout
                    VStack(spacing: 0) {
                        // Top row - Financial cards only
                        VStack(spacing: 20) {
                            // Business header
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(userManager.currentUser.businessName.isEmpty ? "FacePay Merchant" : userManager.currentUser.businessName)
                                        .font(.system(size: 32, weight: .bold, design: .default))
                                        .foregroundColor(.black)
                                    
                                    Text("Today • \(getCurrentDate())")
                                        .font(.system(size: 16, weight: .medium, design: .default))
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                // Sign out button
                                Button(action: {
                                    userManager.signOut()
                                }) {
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            // Top financial cards row
                            HStack(spacing: 16) {
                                FinancialCard(
                                    title: "Current Balance",
                                    value: "$\(String(format: "%.2f", userManager.availableBalance))",
                                    subtitle: "Available",
                                    color: .primaryYellow,
                                    icon: "dollarsign.circle.fill"
                                )
                                
                                FinancialCard(
                                    title: "Today's Revenue",
                                    value: "$\(String(format: "%.0f", userManager.todayRevenue))",
                                    subtitle: "\(userManager.todayTransactionCount) transactions",
                                    color: .primaryYellow,
                                    icon: "chart.line.uptrend.xyaxis"
                                )
                                
                                FinancialCard(
                                    title: "Weekly Growth",
                                    value: "+12.5%",
                                    subtitle: "vs last week",
                                    color: .primaryYellow,
                                    icon: "arrow.up.right.circle.fill"
                                )
                                
                                FinancialCard(
                                    title: "Avg Transaction",
                                    value: "$\(String(format: "%.0f", userManager.totalBalance / max(Double(userManager.transactions.count), 1)))",
                                    subtitle: "per payment",
                                    color: .primaryYellow,
                                    icon: "creditcard.circle.fill"
                                )
                            }
                        }
                        .padding(.horizontal, 40)
                        .padding(.top, 30)
                        
                        Spacer().frame(height: 40)
                        
                        // Bottom section - Chart on left, Actions on right
                        HStack(alignment: .top, spacing: 40) {
                            // Left side
                            VStack(alignment: .leading, spacing: 20) {
                                Text("Weekly Revenue")
                                    .font(.system(size: 20, weight: .bold, design: .default))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                WeeklyChart(data: userManager.weeklyRevenue)
                                    .frame(height: 240)
                                    .frame(maxWidth: .infinity)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 255)
                            .padding(24)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white)
                                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                            
                            // Right side - Action buttons
                            VStack(spacing: 20) {
                                // Large action buttons
                                Button(action: { showingTransactions = true }) {
                                    HStack(spacing: 16) {
                                        Image(systemName: "list.bullet.rectangle")
                                            .font(.system(size: 24, weight: .bold))
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Transactions")
                                                .font(.system(size: 18, weight: .bold, design: .default))
                                            Text("\(userManager.transactions.count) payments")
                                                .font(.system(size: 14, weight: .medium, design: .default))
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.gray)
                                    }
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 80)
                                    .padding(.horizontal, 24)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.white)
                                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.black, lineWidth: 2)
                                    )
                                }
                                
                                Button(action: { showingWithdrawals = true }) {
                                    HStack(spacing: 16) {
                                        Image(systemName: "banknote")
                                            .font(.system(size: 24, weight: .bold))
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Settlement")
                                                .font(.system(size: 18, weight: .bold, design: .default))
                                            Text("Withdraw earnings")
                                                .font(.system(size: 14, weight: .medium, design: .default))
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.gray)
                                    }
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 80)
                                    .padding(.horizontal, 24)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.white)
                                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.black, lineWidth: 2)
                                    )
                                }
                                
                                // Large pay button
                                Button(action: {
                                    paymentState = .enteringAmount
                                }) {
                                    HStack(spacing: 16) {
                                        Image(systemName: "dollarsign.circle.fill")
                                            .font(.system(size: 32, weight: .bold))
                                        Text("Pay")
                                            .font(.system(size: 24, weight: .bold, design: .default))
                                    }
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 100)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.primaryYellow)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.black, lineWidth: 3)
                                    )
                                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 40)
                    }
                } else {
                    // Payment flow states
                    Group {
                        switch paymentState {
                        case .enteringAmount:
                            AmountEntryView(amount: $paymentAmount) {
                                paymentState = .scanningCustomer
                            }
                        case .scanningCustomer:
                            RealCustomerFaceScanView(
                                amount: paymentAmount,
                                onCustomerRecognized: { customer in
                                    recognizedCustomer = customer
                                    paymentState = .confirmingPayment
                                },
                                onCancel: {
                                    resetPayment()
                                }
                            )
                        case .confirmingPayment:
                            PaymentConfirmationView(
                                amount: paymentAmount,
                                customer: recognizedCustomer,
                                onConfirm: {
                                    // Add transaction to user manager
                                    if let amount = Double(paymentAmount) {
                                        userManager.addTransaction(customerName: recognizedCustomer, amount: amount)
                                    }
                                    paymentState = .processing
                                },
                                onCancel: {
                                    resetPayment()
                                }
                            )
                        case .processing:
                            ProcessingPaymentView {
                                paymentState = .completed
                            }
                        case .completed:
                            PaymentCompletedView {
                                resetPayment()
                            }
                        default:
                            EmptyView()
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingTransactions) {
            TransactionListView(userManager: userManager)
        }
        .sheet(isPresented: $showingWithdrawals) {
            SettlementView(userManager: userManager)
        }
    }
    
    private func resetPayment() {
        paymentState = .ready
        paymentAmount = ""
        recognizedCustomer = ""
    }
    
    private func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: Date())
    }
}

// MARK: - Supporting Views

struct FinancialCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium, design: .default))
                        .foregroundColor(.gray)
                    
                    Text(value)
                        .font(.system(size: 28, weight: .bold, design: .default))
                        .foregroundColor(.black)
                    
                    Text(subtitle)
                        .font(.system(size: 14, weight: .medium, design: .default))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: icon)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(color)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.black, lineWidth: 2)
        )
    }
}

struct WeeklyChart: View {
    let data: [Double]
    private let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    var body: some View {
        let maxValue = data.max() ?? 1
        
        HStack(alignment: .bottom, spacing: 12) {
            ForEach(0..<data.count, id: \.self) { index in
                VStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.primaryYellow)
                        .frame(width: 40, height: CGFloat((data[index] / maxValue) * 120))
                        .animation(.easeInOut(duration: 0.8).delay(Double(index) * 0.1), value: data[index])
                    
                    Text(days[index])
                        .font(.system(size: 16, weight: .medium, design: .default))
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(16)
    }
}

// MARK: - Payment Flow Views

struct AmountEntryView: View {
    @Binding var amount: String
    let onNext: () -> Void
    @FocusState private var isAmountFocused: Bool
    
    var body: some View {
        VStack(spacing: 80) {
            VStack(spacing: 20) {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("$")
                        .font(.system(size: 48, weight: .bold, design: .default))
                        .foregroundColor(.primaryYellow)

                    TextField("0", text: $amount)
                        .font(.system(size: 64, weight: .bold, design: .default))
                        .foregroundColor(.black)
                        .keyboardType(.decimalPad)
                        .focused($isAmountFocused)
                        .multilineTextAlignment(.leading)
                        .frame(minWidth: 100)
                }
                .fixedSize() // 👈 Key to keep the HStack as small as needed
                .frame(maxWidth: .infinity, alignment: .center) // 👈 Center the whole unit

                Rectangle()
                    .fill(Color.primaryYellow)
                    .frame(height: 4)
                    .frame(maxWidth: 400)
            }
            .padding()


            
            // Action buttons
            HStack(spacing: 30) {
                Button(action: {
                    amount = ""
                }) {
                    Text("Clear")
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .foregroundColor(.gray)
                        .frame(width: 120, height: 60)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.gray.opacity(0.1))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                        )
                }
                
                Button(action: onNext) {
                    HStack(spacing: 12) {
                        Text("Continue")
                            .font(.system(size: 20, weight: .bold, design: .default))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 18, weight: .bold))
                    }
                    .foregroundColor(.black)
                    .frame(width: 180, height: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(isValidAmount ? Color.primaryYellow : Color.gray.opacity(0.3))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.black, lineWidth: 3)
                    )
                }
                .disabled(!isValidAmount)
            }
        }
        .onAppear {
            isAmountFocused = true
        }
    }
    
    private var isValidAmount: Bool {
        guard let value = Double(amount), value > 0 else { return false }
        return true
    }
}

struct RealCustomerFaceScanView: View {
    let amount: String
    let onCustomerRecognized: (String) -> Void
    let onCancel: () -> Void
    
    @StateObject private var faceDataManager = FaceDataManager()
    @State private var isScanning = true
    @State private var progress: Double = 0.0
    @State private var statusMessage = "Position customer's face in the circle"
    @State private var authenticationResult: AuthResult?
    @State private var showResult = false
    @State private var livenessDetected = false
    @State private var faceQuality: Float = 0.0
    
    enum AuthResult {
        case success
        case failed
        case noFaceRegistered
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // Camera view
            RealCustomerFaceAuthController(
                isScanning: $isScanning,
                progress: $progress,
                statusMessage: $statusMessage,
                authenticationResult: $authenticationResult,
                showResult: $showResult,
                livenessDetected: $livenessDetected,
                faceQuality: $faceQuality,
                faceDataManager: faceDataManager,
                onCustomerRecognized: onCustomerRecognized
            )
            .ignoresSafeArea()
            
            // UI overlay
            VStack {
                // Top info
                VStack(spacing: 16) {
                    HStack {
                        Button(action: onCancel) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 4) {
                            Text("Customer Face Scan")
                                .font(.system(size: 24, weight: .bold, design: .default))
                                .foregroundColor(.white)
                            
                            Text("Amount: $\(amount)")
                                .font(.system(size: 20, weight: .bold, design: .default))
                                .foregroundColor(.primaryYellow)
                        }
                        
                        Spacer()
                        
                        // Balance space
                        Color.clear.frame(width: 32, height: 32)
                    }
                }
                .padding(.top, 60)
                .padding(.horizontal, 40)
                
                Spacer()
                
                // Face circle overlay - same as FaceRegistrationView
                ZStack {
                    // Progress circle
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            livenessDetected ? Color.green : Color.primaryYellow,
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 280, height: 280)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 0.3), value: progress)

                    // Center icon
                    Image(systemName: "faceid")
                        .font(.system(size: 40, weight: .semibold))
                        .foregroundColor(getIconColor())
                        .scaleEffect(showResult ? 1.2 : 1.0)
                        .animation(.spring(response: 0.5, dampingFraction: 0.6), value: showResult)
                    
                    // Quality indicator
                    if faceQuality > 0 {
                        Circle()
                            .fill(Color.green.opacity(Double(faceQuality)))
                            .frame(width: 20, height: 20)
                            .offset(y: -140)
                    }
                }
                
                Spacer()
                
                // Status message
                VStack(spacing: 20) {
                    Text(statusMessage)
                        .font(.system(size: 18, weight: .medium, design: .default))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    // Success checkmark
                    if showResult && authenticationResult == .success {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)
                            .scaleEffect(showResult ? 1.0 : 0.5)
                            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: showResult)
                    }
                }
                .padding(.bottom, 80)
            }
        }
    }
    
    private func getIconColor() -> Color {
        if authenticationResult == .success {
            return .green
        } else if authenticationResult == .failed {
            return .red
        } else {
            return .white
        }
    }
}

struct RealCustomerFaceAuthController: UIViewControllerRepresentable {
    @Binding var isScanning: Bool
    @Binding var progress: Double
    @Binding var statusMessage: String
    @Binding var authenticationResult: RealCustomerFaceScanView.AuthResult?
    @Binding var showResult: Bool
    @Binding var livenessDetected: Bool
    @Binding var faceQuality: Float
    let faceDataManager: FaceDataManager
    let onCustomerRecognized: (String) -> Void
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = RealCustomerFaceAuthViewController()
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if let controller = uiViewController as? RealCustomerFaceAuthViewController {
            controller.isScanning = isScanning
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, CustomerFaceAuthDelegate {
        let parent: RealCustomerFaceAuthController
        private var scanStartTime: Date?
        private let scanDuration: TimeInterval = 2.5
        private var scanningFace: VNFaceObservation?
        
        init(_ parent: RealCustomerFaceAuthController) {
            self.parent = parent
        }
        
        func didDetectCustomerFace(_ observation: VNFaceObservation) {
            DispatchQueue.main.async {
                // Start scan timer
                if self.parent.isScanning && self.scanStartTime == nil {
                    self.scanStartTime = Date()
                    self.scanningFace = observation
                    self.parent.statusMessage = "Scanning customer face..."
                    self.parent.livenessDetected = true
                }
                
                // Update face quality
                self.parent.faceQuality = Float.random(in: 0.8...1.0)
                
                // Update progress
                if let startTime = self.scanStartTime {
                    let elapsed = Date().timeIntervalSince(startTime)
                    let progress = min(elapsed / self.scanDuration, 1.0)
                    self.parent.progress = progress
                    
                    // Complete scan
                    if progress >= 1.0 {
                        self.completeScan(observation)
                    }
                }
            }
        }
        
        func didLoseCustomerFace() {
            DispatchQueue.main.async {
                if self.parent.isScanning && !self.parent.showResult {
                    self.resetScan()
                    self.parent.statusMessage = "Position customer's face in the circle"
                    self.parent.livenessDetected = false
                    self.parent.faceQuality = 0.0
                }
            }
        }
        
        private func completeScan(_ observation: VNFaceObservation) {
            // For demo purposes, simulate customer recognition
            let existingCustomers = ["Low Liana", "Jien Weng", "Liang Ke Ying", "Thanirmalai"]
            
            // 80% chance of being a recognized customer, 20% new customer
            let customerName: String
            if Double.random(in: 0...1) < 0.8 {
                customerName = existingCustomers.randomElement() ?? "John Doe"
            } else {
                customerName = "Customer \(Int.random(in: 1000...9999))"
            }
            
            parent.authenticationResult = .success
            parent.statusMessage = "Customer recognized: \(customerName)"
            parent.showResult = true
            parent.isScanning = false
            
            // Haptic feedback
            let successFeedback = UINotificationFeedbackGenerator()
            successFeedback.notificationOccurred(.success)
            
            // Complete after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.parent.onCustomerRecognized(customerName)
            }
            
            scanStartTime = nil
            scanningFace = nil
        }
        
        private func resetScan() {
            scanStartTime = nil
            parent.progress = 0.0
            scanningFace = nil
        }
    }
}

protocol CustomerFaceAuthDelegate: AnyObject {
    func didDetectCustomerFace(_ observation: VNFaceObservation)
    func didLoseCustomerFace()
}

class RealCustomerFaceAuthViewController: UIViewController {
    weak var delegate: CustomerFaceAuthDelegate?
    var isScanning: Bool = true
    
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private let videoDataOutputQueue = DispatchQueue(label: "CustomerVideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updatePreviewLayerFrame()
    }
    
    private func updatePreviewLayerFrame() {
        if let previewLayer = previewLayer {
            previewLayer.frame = view.bounds
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if captureSession?.isRunning == false {
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.captureSession?.startRunning()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.updatePreviewLayerFrame()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession?.isRunning == true {
            captureSession?.stopRunning()
        }
    }
    
    private func setupCamera() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            configureCameraSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.configureCameraSession()
                    }
                }
            }
        case .denied, .restricted:
            print("Camera access denied or restricted")
        @unknown default:
            print("Unknown camera authorization status")
        }
    }
    
    private func configureCameraSession() {
        #if targetEnvironment(simulator)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let backgroundLayer = CALayer()
            backgroundLayer.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.3).cgColor
            backgroundLayer.frame = self.view.bounds
            self.view.layer.insertSublayer(backgroundLayer, at: 0)
            
            let label = UILabel()
            label.text = "Customer Camera Preview\n(Simulator Mode)"
            label.textAlignment = .center
            label.numberOfLines = 0
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            label.frame = self.view.bounds
            self.view.addSubview(label)
        }
        return
        #endif
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("Unable to access front camera")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: frontCamera)
            
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
            
            videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
            videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
            
            if captureSession.canAddOutput(videoDataOutput) {
                captureSession.addOutput(videoDataOutput)
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                self.previewLayer?.videoGravity = .resizeAspectFill
                self.previewLayer?.connection?.videoOrientation = self.getVideoOrientation()
                self.previewLayer?.frame = self.view.bounds
                
                self.view.layer.insertSublayer(self.previewLayer!, at: 0)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.updatePreviewLayerFrame()
                }
            }
            
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.captureSession?.startRunning()
            }
            
        } catch {
            print("Error setting up customer camera: \(error)")
        }
    }
    
    private func getVideoOrientation() -> AVCaptureVideoOrientation {
        switch UIDevice.current.orientation {
        case .portrait:
            return .portrait
        case .landscapeLeft:
            return .landscapeRight
        case .landscapeRight:
            return .landscapeLeft
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default:
            return .portrait
        }
    }
}

extension RealCustomerFaceAuthViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard isScanning else { return }
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let faceDetectionRequest = VNDetectFaceLandmarksRequest { [weak self] request, error in
            guard let observations = request.results as? [VNFaceObservation], !observations.isEmpty else {
                DispatchQueue.main.async {
                    self?.delegate?.didLoseCustomerFace()
                }
                return
            }
            
            let faceObservation = observations[0]
            DispatchQueue.main.async {
                self?.delegate?.didDetectCustomerFace(faceObservation)
            }
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .leftMirrored, options: [:])
        
        try? imageRequestHandler.perform([faceDetectionRequest])
    }
}

struct TransactionListView: View {
    @ObservedObject var userManager: UserManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Transactions")
                        .font(.system(size: 28, weight: .bold, design: .default))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 20)
                
                // Transaction list
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(userManager.transactions) { transaction in
                            TransactionRow(transaction: transaction)
                        }
                    }
                    .padding(.horizontal, 30)
                }
            }
            .background(Color.white)
        }
    }
}

struct SettlementView: View {
    @ObservedObject var userManager: UserManager
    @Environment(\.dismiss) private var dismiss
    @State private var withdrawalAmount: String = ""
    @State private var showingWithdrawal = false
    @State private var withdrawalMethod: WithdrawalMethod = .bankTransfer
    @State private var isProcessing = false
    
    enum WithdrawalMethod: String, CaseIterable {
        case bankTransfer = "Bank Transfer"
        case touchNGo = "Touch 'n Go"
        
        var icon: String {
            switch self {
            case .bankTransfer: return "building.columns"
            case .touchNGo: return "wallet.bifold.fill"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Header
                HStack {
                    Text("Settlement")
                        .font(.system(size: 28, weight: .bold, design: .default))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
                
                if !showingWithdrawal {
                    // Settlement overview
                    VStack(spacing: 24) {
                        FinancialCard(
                            title: "Available Balance",
                            value: "$\(String(format: "%.2f", userManager.availableBalance))",
                            subtitle: "Ready for withdrawal",
                            color: .primaryYellow,
                            icon: "dollarsign.circle.fill"
                        )
                        
                        HStack(spacing: 20) {
                            FinancialCard(
                                title: "This Month",
                                value: "$\(String(format: "%.2f", userManager.availableBalance * 0.3))",
                                subtitle: "Earned",
                                color: .primaryYellow,
                                icon: "chart.line.uptrend.xyaxis"
                            )
                            
                            FinancialCard(
                                title: "Last Settlement",
                                value: "$0.00",
                                subtitle: "Never withdrawn",
                                color: .primaryYellow,
                                icon: "arrow.down.circle.fill"
                            )
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                    
                    // Withdraw button
                    Button(action: {
                        showingWithdrawal = true
                    }) {
                        HStack(spacing: 16) {
                            Image(systemName: "banknote.fill")
                                .font(.system(size: 24, weight: .bold))
                            Text("Request Settlement")
                                .font(.system(size: 20, weight: .bold, design: .default))
                        }
                        .foregroundColor(.black)
                        .frame(width: 280, height: 60)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.primaryYellow)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.black, lineWidth: 3)
                        )
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    }
                    .padding(.bottom, 60)
                } else {
                    // Withdrawal form
                    VStack(spacing: 30) {
                        Text("Withdrawal Details")
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .foregroundColor(.black)
                        
                        // Amount input
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Withdrawal Amount")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.gray)
                            
                            HStack {
                                Text("$")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.primaryYellow)
                                
                                TextField("0.00", text: $withdrawalAmount)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.black)
                                    .keyboardType(.decimalPad)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.1))
                            )
                            
                            Text("Available: $\(String(format: "%.2f", userManager.availableBalance))")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                        }
                        
                        // Withdrawal method
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Withdrawal Method")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.gray)
                            
                            VStack(spacing: 12) {
                                ForEach(WithdrawalMethod.allCases, id: \.self) { method in
                                    Button(action: {
                                        withdrawalMethod = method
                                    }) {
                                        HStack {
                                            Image(systemName: method.icon)
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(withdrawalMethod == method ? .primaryYellow : .gray)
                                            
                                            Text(method.rawValue)
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(.black)
                                            
                                            Spacer()
                                            
                                            Image(systemName: withdrawalMethod == method ? "checkmark.circle.fill" : "circle")
                                                .font(.system(size: 20))
                                                .foregroundColor(withdrawalMethod == method ? .primaryYellow : .gray)
                                        }
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(withdrawalMethod == method ? Color.primaryYellow.opacity(0.1) : Color.white)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(withdrawalMethod == method ? Color.primaryYellow : Color.gray.opacity(0.3), lineWidth: 2)
                                                )
                                        )
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                        
                        // Action buttons
                        HStack(spacing: 20) {
                            Button(action: {
                                showingWithdrawal = false
                                withdrawalAmount = ""
                            }) {
                                Text("Cancel")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.gray)
                                    .frame(width: 120, height: 50)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.gray.opacity(0.1))
                                    )
                            }
                            
                            Button(action: {
                                processWithdrawal()
                            }) {
                                HStack {
                                    if isProcessing {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                            .scaleEffect(0.8)
                                    }
                                    Text(isProcessing ? "Processing..." : "Confirm Withdrawal")
                                        .font(.system(size: 18, weight: .bold))
                                }
                                .foregroundColor(.black)
                                .frame(width: 200, height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(isValidWithdrawal ? Color.primaryYellow : Color.gray.opacity(0.3))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.black, lineWidth: 2)
                                )
                            }
                            .disabled(!isValidWithdrawal || isProcessing)
                        }
                        .padding(.bottom, 40)
                    }
                    .padding(.horizontal, 30)
                }
            }
            .background(Color.white)
        }
    }
    
    private var isValidWithdrawal: Bool {
        guard let amount = Double(withdrawalAmount) else { return false }
        return amount > 0 && amount <= userManager.availableBalance
    }
    
    private func processWithdrawal() {
        isProcessing = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Actually deduct the withdrawal amount from balance
            if let amount = Double(withdrawalAmount) {
                userManager.processWithdrawal(amount: amount)
            }
            
            isProcessing = false
            showingWithdrawal = false
            withdrawalAmount = ""
        }
    }
}

struct TransactionRow: View {
    let transaction: Transaction
    @State private var showingDetails = false
    
    var body: some View {
        Button(action: {
            showingDetails = true
        }) {
            HStack(spacing: 16) {
                // Customer avatar
                Circle()
                    .fill(Color.primaryYellow.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text(String(transaction.customerName.prefix(1)))
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .foregroundColor(.primaryYellow)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(transaction.customerName)
                        .font(.system(size: 16, weight: .bold, design: .default))
                        .foregroundColor(.black)
                    
                    Text(formatDate(transaction.date))
                        .font(.system(size: 14, weight: .medium, design: .default))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    Text("$\(String(format: "%.2f", transaction.amount))")
                        .font(.system(size: 18, weight: .bold, design: .default))
                        .foregroundColor(.black)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.black, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetails) {
            TransactionDetailView(transaction: transaction)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

struct TransactionDetailView: View {
    let transaction: Transaction
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Header
                HStack {
                    Text("Transaction Details")
                        .font(.system(size: 28, weight: .bold, design: .default))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
                
                // Transaction info
                VStack(spacing: 24) {
                    // Customer info
                    VStack(spacing: 16) {
                        Circle()
                            .fill(Color.primaryYellow.opacity(0.2))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Text(String(transaction.customerName.prefix(1)))
                                    .font(.system(size: 32, weight: .bold, design: .default))
                                    .foregroundColor(.primaryYellow)
                            )
                        
                        Text(transaction.customerName)
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .foregroundColor(.black)
                    }
                    
                    // Transaction amount
                    VStack(spacing: 8) {
                        Text("Amount")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                        
                        Text("$\(String(format: "%.2f", transaction.amount))")
                            .font(.system(size: 48, weight: .bold, design: .default))
                            .foregroundColor(.black)
                    }
                    
                    // Transaction details
                    VStack(spacing: 16) {
                        DetailRow(title: "Transaction ID", value: String(transaction.id.prefix(8).uppercased()))
                        DetailRow(title: "Date", value: formatFullDate(transaction.date))
                        DetailRow(title: "Time", value: formatTime(transaction.date))
                        DetailRow(title: "Payment Method", value: "Face Recognition")
                        DetailRow(title: "Status", value: "Completed")
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.black, lineWidth: 2)
                    )
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
            .background(Color.white)
        }
    }
    
    private func formatFullDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)
        }
    }
}

struct PaymentConfirmationView: View {
    let amount: String
    let customer: String
    let onConfirm: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        VStack(spacing: 60) {
            VStack(spacing: 30) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 100, weight: .bold))
                    .foregroundColor(.primaryYellow)
                
                VStack(spacing: 16) {
                    Text("Customer Identified")
                        .font(.system(size: 36, weight: .bold, design: .default))
                        .foregroundColor(.black)
                    
                    Text(customer)
                        .font(.system(size: 28, weight: .bold, design: .default))
                        .foregroundColor(.black)
                }
                
                VStack(spacing: 8) {
                    Text("Payment Amount")
                        .font(.system(size: 18, weight: .medium, design: .default))
                        .foregroundColor(.gray)
                    
                    Text("$\(amount)")
                        .font(.system(size: 48, weight: .bold, design: .default))
                        .foregroundColor(.primaryYellow)
                }
            }
            
            VStack(spacing: 20) {
                Text("Customer: Please confirm this payment")
                    .font(.system(size: 20, weight: .medium, design: .default))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 40) {
                    Button(action: onCancel) {
                        HStack(spacing: 12) {
                            Image(systemName: "xmark")
                                .font(.system(size: 20, weight: .bold))
                            Text("Cancel")
                                .font(.system(size: 20, weight: .bold, design: .default))
                        }
                        .foregroundColor(.red)
                        .frame(width: 160, height: 70)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.red.opacity(0.1))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.red, lineWidth: 3)
                        )
                    }
                    
                    Button(action: onConfirm) {
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 20, weight: .bold))
                            Text("Confirm")
                                .font(.system(size: 20, weight: .bold, design: .default))
                        }
                        .foregroundColor(.black)
                        .frame(width: 160, height: 70)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.primaryYellow)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.black, lineWidth: 3)
                        )
                    }
                }
            }
        }
    }
}

struct ProcessingPaymentView: View {
    let onComplete: () -> Void
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        VStack(spacing: 50) {
            Image(systemName: "creditcard.fill")
                .font(.system(size: 100, weight: .bold))
                .foregroundColor(.primaryYellow)
                .rotationEffect(.degrees(rotationAngle))
                .animation(.linear(duration: 1.5).repeatForever(autoreverses: false), value: rotationAngle)
            
            VStack(spacing: 20) {
                Text("Processing Payment")
                    .font(.system(size: 36, weight: .bold, design: .default))
                    .foregroundColor(.black)
                
                Text("Please wait...")
                    .font(.system(size: 20, weight: .medium, design: .default))
                    .foregroundColor(.gray)
                
                // Progress dots
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(Color.primaryYellow)
                            .frame(width: 12, height: 12)
                            .scaleEffect(rotationAngle > Double(index * 120) ? 1.0 : 0.5)
                            .animation(.easeInOut(duration: 0.6).repeatForever(), value: rotationAngle)
                    }
                }
            }
        }
        .onAppear {
            rotationAngle = 360
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                onComplete()
            }
        }
    }
}

struct PaymentCompletedView: View {
    let onNewPayment: () -> Void
    @State private var showCheckmark = false
    
    var body: some View {
        VStack(spacing: 60) {
            VStack(spacing: 30) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 120, weight: .bold))
                    .foregroundColor(.green)
                    .scaleEffect(showCheckmark ? 1.0 : 0.3)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showCheckmark)
                
                VStack(spacing: 20) {
                    Text("Payment Successful!")
                        .font(.system(size: 40, weight: .bold, design: .default))
                        .foregroundColor(.black)
                    
                    Text("Transaction completed successfully")
                        .font(.system(size: 20, weight: .medium, design: .default))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
            }
            
            Button(action: onNewPayment) {
                HStack(spacing: 16) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24, weight: .bold))
                    Text("New Payment")
                        .font(.system(size: 24, weight: .bold, design: .default))
                }
                .foregroundColor(.black)
                .frame(width: 220, height: 70)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.primaryYellow)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.black, lineWidth: 3)
                )
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            }
        }
        .onAppear {
            showCheckmark = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                onNewPayment()
            }
        }
    }
}

#Preview(traits: .landscapeLeft) {
    DashboardView(userManager: UserManager())
}
