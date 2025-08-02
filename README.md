
# 🚀 FacePay – Seamless Face-Based Payment System for MSMEs

"Pay with just your face. No phone. No card. No hassle."

![FacePay Overview](https://raw.githubusercontent.com/xx-3-xx/FacePayMobileApp/refs/heads/main/face-pay-mvp/public/images/facePay.jpg)

A contactless payment system using on-device facial recognition — secure, private, and built for MSMEs.

---

## 🔗 Important Links

- [🛒 FacePay Merchant App](https://github.com/JienWeng/FacePayMerchant/)
- [📱 FacePay Pitch Deck](https://github.com/JienWeng/FacePayMerchant/blob/main/Payhack2025-FacePay_pitchkey.pdf)

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
- 📱 **Consumer Side** 
      – No extra app needed ! Bank integrating face pay in their app 

---

## ✨ Key Features

### 📱 Merchant App
| Feature                        | Description                                                  |
| ------------------------------ | ------------------------------------------------------------ |
| 🔐 Secure Facial Recognition   | Fast, on-device or cloud-based face matching with encryption |
| 📶 Offline-First Mode          | Queue transactions offline and sync when back online         |
| 👀 Liveness Detection          | Anti-spoofing: blink, nod, or gesture validation             |
| 🧭 Location-Aware Matching     | Prioritizes nearby customers in crowded areas                |
| 🔁 Merchant Confirmation Layer | Ensures correct face selection before payment                |
| 🛡️ PDPA-Compliant             | Encrypted embeddings, no raw face images stored              |
| 🔄 Fallback Methods            | PIN, phone number, or OTP fallback if face scan fails        |
| 🧓 Inclusive UX                | Designed for elderly, disabled, and non-smartphone users     |

## 💬 Frequently Asked Questions (FAQs)
Q: What if a customer’s face changes?
A: FacePay allows re-registration and uses fallback options like PIN or phone number.

Q: Can FacePay work offline?
A: Yes. Transactions are queued locally and synced when internet is restored.

Q: Is this secure?
A: Yes. We use encrypted embeddings, liveness checks, and PDPA-compliant practices.

Q: What if multiple users are nearby?
A: The system highlights multiple faces; the merchant confirms the correct one before proceeding.

## 💼 Business Model
![FacePay Business Model](https://github.com/JienWeng/FacePayMerchant/raw/main/business-model.png)
---

## 🛣 Roadmap

- ✅ Bank pilot partnership (DuitNow or digital banks)
- ✅ Add web-based registration portal for face linking
- 🔄 Loyalty system via face (returning customer tracking)
- 🏦 Integration with financial assistance for MSMEs
- 🔧 POS hardware partner pilot (e.g., StoreHub, Qashier)


## 🏆 Why It’s a Win

- ⚡ Solves Real MSME Pain Points
- 🔐 Inclusive, Fast, and App-Free
- 💸 Built for Malaysia, Scalable Globally
- 🌐 Security First, Privacy Built-In
- 📊 Visionary but Practical

---

## Business Flow

### 🧾 Solution: FacePay
A dual-platform facial recognition payment system:

### 🧾 Merchant Side

#### 1. **Soft POS** *(Budget-Friendly Option)*  
Merchants install the **FacePay** app on any Android phone or tablet.

**Steps:**
- 💰 Enter transaction amount  
- 📷 Point camera at customer  
- 🧠 System recognizes customer → deducts from **linked DuitNow account**  
- ✅ Merchant confirms → transaction completes

---

#### 2. **POS Terminal Integration**  
FacePay API is **embedded into existing smart POS terminals**.

- Merchants use it just like a regular POS — but with **face scanning instead of cards or QR**.

---

### 🙋‍♂️ Consumer Side

- **No extra app required**
- Users activate FacePay by registering their face:
  - During bank card sign-up  
  - Or via their **bank’s app** or the **FacePay portal**
- Linked directly to their **DuitNow or bank account**

