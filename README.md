# 🚀 FacePay – Seamless Face-Based Payment System for MSMEs

"Pay with just your face. No phone. No card. No hassle."

![FacePay Overview](https://raw.githubusercontent.com/xx-3-xx/FacePayMobileApp/refs/heads/main/face-pay-mvp/public/images/facePay.jpg)

A contactless payment system using on-device facial recognition — secure, private, and built for MSMEs.

---

## 🔗 Important Links

- [🛒 FacePay Merchant Web Portal](https://github.com/thanir03/facepay-msme)
- [📱 FacePay Mobile App (Consumer)](https://github.com/xx-3-xx/FacePayMobileApp)

---

## 📌 Problem Statement

Current MSME payment methods are not seamless enough, especially in low-tech and high-traffic environments.

- MSMEs struggle with onboarding to digital payment ecosystems.
- QR and NFC payments require smartphones, apps, stable internet, and customer action.
- Elderly, low-income users, or those with limited digital access are excluded.
- Payment queues and transaction friction reduce efficiency.

---

## 🔥 Why It’s Critical

FacePay solves a pressing need for **secure, touchless, and frictionless payments** by enabling **on-device facial recognition** that is private by design. Built for **MSMEs**, it brings biometric payment tech to businesses of any size.

---

## ⚙️ How It Works

- 🧾 **Merchant Side** 
      - With POS terminal -- face pay api for accepting face pay
      - Without POS terminal -- own tablet/phone for accepting face pay
- 📱 **Consumer Side** – No extra app needed ! Bank integrating face pay in their app 

---

## ✨ Key Features

### 📱 Consumer App

| Feature                    | Description                                          |
|----------------------------|------------------------------------------------------|
| Face Recognition           | Fast, local facial match using MediaPipe + TF.js    |
| 3D Card UI                 | Interactive card design using `framer-motion`       |
| Local Data Storage         | Saves preferences without external calls            |
| Privacy-First Architecture| No facial images leave the device                   |

### 🧾 Merchant Portal

| Feature                    | Description                                          |
|----------------------------|------------------------------------------------------|
| Merchant Onboarding        | Easy registration & setup                           |
| Real-Time Transactions     | View face-auth payments in real-time                |
| Analytics Dashboard        | Track volumes, history, and referral data           |

---

## 💼 Business Model

A **tiered subscription model** to support MSMEs at every growth stage:

| Plan    | Monthly Fee | Free Transaction Volume | Excess Fee |
|---------|-------------|--------------------------|------------|
| Starter | RM39        | RM10,000                 | 2.0%       |
| Growth  | RM99        | RM30,000                 | 2.0%       |
| Pro     | RM299       | RM100,000                | 2.0%       |

> 💳 Flat 2.0% fee for usage beyond quota.

---

## 🛣 Roadmap

- ✅ v1.0 – MVP with local face match & payment interface
- 🔜 v1.1 – Anti-spoofing (liveness detection)
- 🔜 v1.2 – Merchant analytics + real-time insights
- 🔜 v2.0 – Cross-device sync, multi-merchant access
- 🔐 Future – Decentralized identity with blockchain
---

  <img width="1920" height="1080" alt="Green and Black Modern Roadmap Timeline Brainstorm" src="https://github.com/user-attachments/assets/c35096ac-b6a2-4ea3-b031-c680e8e271e7" />
  
---

## 🤝 Referral Program

Refer a friend — you both get **RM150 credit** after setup.

---

## 🏆 Why It’s a Win

- ⚡ Solves Real MSME Pain Points
- 🔐 Inclusive, Fast, and App-Free
- 💸 Built for Malaysia, Scalable Globally
- 🌐 Security First, Privacy Built-In
- 📊 Visionary but Practical

---

## 🚀 Get Started

### 🧾 FacePay Merchant Web Portal

```bash
git clone https://github.com/thanir03/facepay-msme
cd facepay-msme
pnpm install
pnpm dev
# Visit https://localhost:4000
```

### 📱 FacePay Mobile App (Consumer)

```bash
git clone https://github.com/xx-3-xx/FacePayMobileApp
cd FacePayMobileApp
npm install
npm run dev
# Visit https://localhost:3000
```
