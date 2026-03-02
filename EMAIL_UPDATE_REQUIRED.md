# ⚠️ ACTION REQUIRED BEFORE APP STORE SUBMISSION

## Update These Email Addresses

You need to replace the placeholder email addresses with your actual support email in **2 locations**:

---

### 1. PrivacyPolicyView.swift (Line ~123)

**Current code:**
```swift
support@concertapp.example.com
```

**Replace with your actual email:**
```swift
yourname@yourdomain.com
```

**Full section:**
```swift
SectionHeader("Contact")
Text("""
If you have questions or concerns about privacy, please contact us at:

yourname@yourdomain.com
""")
```

---

### 2. SettingsView.swift (Line ~106)

**Current code:**
```swift
if let supportEmail = "support@concertapp.example.com".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
```

**Replace with your actual email:**
```swift
if let supportEmail = "yourname@yourdomain.com".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
```

---

## ✅ After Updating:

1. Build and run the app
2. Go to Settings → Privacy Policy
3. Scroll to bottom and verify your email is shown
4. Go to Settings → Contact Support
5. Tap it and verify Mail app opens with your email

---

## 🎯 What Email Should I Use?

### Options:

**Personal Email:**
- ✅ Gmail, iCloud Mail, etc.
- ✅ Free and easy
- ⚠️ May get spam if app becomes popular

**Professional Email:**
- ✅ yourname@yourdomain.com
- ✅ Looks more professional
- ⚠️ Requires domain registration

**Apple Hide My Email:**
- ✅ Privacy-focused
- ✅ Can disable later if needed
- ⚠️ Requires Apple iCloud+ subscription

**Recommendation:** Use whatever email you check regularly and don't mind users contacting!

---

## 📋 Quick Checklist:

- [ ] Updated email in PrivacyPolicyView.swift
- [ ] Updated email in SettingsView.swift
- [ ] Tested Privacy Policy view shows correct email
- [ ] Tested Contact Support opens Mail app correctly
- [ ] Email address is one you actually monitor

---

## 🚨 Important Notes:

1. **This email will be visible to users** in your Privacy Policy
2. **Apple may contact you at this email** for app review questions
3. **Users will contact you here** for support requests
4. **Must be a valid, working email** for App Store approval
5. **Can't use @example.com** - Apple will reject it

---

After updating these 2 email addresses, you're ready for App Store submission! 🎉
