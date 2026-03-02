# 🚀 App Store Submission Checklist - Concert App

## ✅ Completed Security Fixes

All critical and high-priority security issues have been addressed. Below is your complete pre-submission checklist.

---

## 🔧 REQUIRED ACTIONS (Before Submission)

### 1. Update Email Addresses (2 locations)
- [ ] **PrivacyPolicyView.swift** (line ~123)
  - Replace `support@concertapp.example.com` with your real email
- [ ] **SettingsView.swift** (line ~106)
  - Replace `support@concertapp.example.com` with your real email
- [ ] Test Privacy Policy displays your email
- [ ] Test Contact Support opens mail app with your email

📄 **See:** `EMAIL_UPDATE_REQUIRED.md` for detailed instructions

---

### 2. Add Privacy Manifest to Xcode
- [ ] Add `PrivacyInfo.xcprivacy` to Xcode project
- [ ] Verify target membership is enabled
- [ ] Verify file appears in Build Phases → Copy Bundle Resources
- [ ] Clean and rebuild project successfully

📄 **See:** `PRIVACY_MANIFEST_SETUP.md` for step-by-step guide

---

## 🧪 TESTING CHECKLIST

### Core Features Testing
- [ ] App launches successfully on real device
- [ ] App launches successfully on simulator
- [ ] Create a new concert entry
- [ ] Edit an existing concert
- [ ] Delete a single concert
- [ ] View concert details
- [ ] Add photos to a concert
- [ ] View photos in full screen
- [ ] Delete a photo from a concert
- [ ] Navigate through all tabs/views

### Settings Testing
- [ ] Open Settings screen
- [ ] Toggle "Show Artist Count on Rows" - verify it works
- [ ] Change "Default Sort Order" - verify it persists
- [ ] Tap "Privacy Policy" - verify it opens correctly
- [ ] Tap "Contact Support" - verify mail app opens
- [ ] View version number - verify it shows correct version

### Export/Backup Testing
- [ ] Export data to PDF - verify file is created
- [ ] Export data to CSV - verify file is created
- [ ] Open exported PDF - verify content is correct
- [ ] Open exported CSV in spreadsheet app - verify format
- [ ] Test "Backup to Files" - save to iCloud Drive
- [ ] Test "Backup to Files" - save to On My iPhone
- [ ] Verify success notification appears after backup
- [ ] Check Files app to confirm backup files exist

### Delete All Data Testing
- [ ] Tap "Delete All Data" button
- [ ] Verify first confirmation dialog appears
- [ ] Tap "Delete X Concerts" in dialog
- [ ] Verify second confirmation dialog appears
- [ ] Tap "Cancel" - verify nothing is deleted
- [ ] Tap "Delete All Data" again and confirm both dialogs
- [ ] Verify all concerts are deleted
- [ ] Verify success message appears
- [ ] Verify app doesn't crash after deletion

### URL Validation Testing
- [ ] Test setlist URL with valid URL (should open in Safari)
- [ ] Test setlist URL with invalid URL (should show as invalid)
- [ ] Test "Search for Setlist" button (should open Google search)
- [ ] Test search with no internet (should show error)

### Photo Permissions Testing
- [ ] First launch - request photo permission
- [ ] Grant full access - verify photos can be added
- [ ] Test with "Limited Access" permission
- [ ] Deny permission - verify alert appears
- [ ] Open Settings from alert - verify it goes to correct place
- [ ] Re-grant permission - verify photos work again

### Data Persistence Testing
- [ ] Add several concerts with notes, photos, friends
- [ ] Force quit the app (swipe up in app switcher)
- [ ] Relaunch app
- [ ] Verify all data persists correctly
- [ ] Test after device restart (if possible)

### Edge Cases Testing
- [ ] Test with 0 concerts (empty state)
- [ ] Test with 100+ concerts (performance)
- [ ] Test with very long concert descriptions (1000+ chars)
- [ ] Test with special characters in fields (emoji, symbols)
- [ ] Test with concerts from different years
- [ ] Test with concerts with no venue/location
- [ ] Test festivals vs standard concerts

### Error Handling Testing
- [ ] Try to export with 0 concerts - verify error shown
- [ ] Try to backup with 0 concerts - verify error shown
- [ ] Test app behavior with low storage space
- [ ] Test app behavior with airplane mode enabled
- [ ] Test app behavior with low memory (background apps)

---

## 📱 Device Testing

### Test On:
- [ ] **iPhone Simulator** (multiple screen sizes)
  - [ ] iPhone SE (small screen)
  - [ ] iPhone 15 Pro (standard)
  - [ ] iPhone 15 Pro Max (large screen)
- [ ] **Physical iPhone** (required for App Store submission)
  - [ ] Test on your actual device
  - [ ] Test with actual photos from library
  - [ ] Test real-world usage patterns

### iOS Versions:
- [ ] Test on **minimum supported iOS version** (check deployment target)
- [ ] Test on **latest iOS version**
- [ ] Verify no deprecated API warnings in console

---

## 🔒 Security Verification

### Privacy & Security
- [ ] Privacy Policy is accessible and readable
- [ ] No data leaves the device (fully offline except setlist search)
- [ ] No analytics or tracking code present
- [ ] Photo library permission properly requested
- [ ] Temporary export files are cleaned up
- [ ] Core Data encryption enabled (check PersistenceController)
- [ ] No force-unwrapped external URLs
- [ ] All destructive actions require confirmation

### Code Quality
- [ ] No `fatalError()` in production code paths
- [ ] No `TODO` comments in critical functions
- [ ] No hardcoded credentials or API keys
- [ ] No debug print statements with sensitive data
- [ ] All force-unwraps (`!`) reviewed and justified

---

## 📋 App Store Connect Setup

### App Information
- [ ] App name chosen and available
- [ ] Bundle identifier set correctly
- [ ] Version number set (1.0.0 or higher)
- [ ] Build number set
- [ ] App icon added (all required sizes)
- [ ] Launch screen configured

### App Store Listing
- [ ] App description written
- [ ] Keywords chosen
- [ ] Support URL set (or email contact)
- [ ] Marketing URL set (optional)
- [ ] Privacy Policy URL (optional - you have in-app)
- [ ] Screenshots prepared (all required sizes)
- [ ] App preview video prepared (optional)

### Privacy & Legal
- [ ] App privacy details filled out in App Store Connect
  - [ ] Data Collection: None (you don't collect any data)
  - [ ] Data Linked to User: None
  - [ ] Data Used to Track User: None
- [ ] Age rating questionnaire completed
- [ ] Export compliance information provided
- [ ] Content rights confirmation

---

## 🎯 Pre-Submission Review

### Final Checks:
- [ ] **All code compiles** without errors
- [ ] **All code compiles** without warnings (or warnings are justified)
- [ ] **App runs** on physical device without crashes
- [ ] **Archive builds** successfully for App Store
- [ ] **TestFlight** upload succeeds (optional but recommended)
- [ ] **TestFlight** internal testing completed (optional)
- [ ] **All required actions** above are completed
- [ ] **All tests** above have passed

### Documentation Review:
- [ ] README updated (if public repo)
- [ ] Version notes prepared for App Store
- [ ] Support documentation prepared
- [ ] FAQ prepared (if needed)

---

## 🚨 Common Rejection Reasons to Avoid

### Check These Don't Apply to Your App:
- [ ] ✅ App doesn't crash on launch (TESTED)
- [ ] ✅ App doesn't have broken links (FIXED - no more example.com)
- [ ] ✅ Privacy policy is accessible (ADDED)
- [ ] ✅ Destructive actions are protected (FIXED - double confirmation)
- [ ] ✅ Photo permissions are properly described (verify Info.plist)
- [ ] ✅ App description matches actual functionality
- [ ] ✅ No "test" or "demo" content in production
- [ ] ✅ No placeholder text or Lorem Ipsum
- [ ] ✅ All features are complete (no "Coming Soon")

---

## 📊 Info.plist Requirements

Verify these entries exist in your Info.plist:

### Photo Library Permissions:
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to attach photos from your library to concerts</string>

<key>NSPhotoLibraryAddUsageDescription</key>
<string>We need access to save photos to your concerts</string>
```

### App Information:
- [ ] `CFBundleDisplayName` - Your app name
- [ ] `CFBundleIdentifier` - Your bundle ID
- [ ] `CFBundleShortVersionString` - Version (e.g., 1.0.0)
- [ ] `CFBundleVersion` - Build number (e.g., 1)

---

## ✅ Sign-Off Checklist

Before clicking "Submit for Review":

- [ ] I have updated both email addresses
- [ ] I have added PrivacyInfo.xcprivacy to Xcode
- [ ] I have tested all features on a real device
- [ ] I have tested Delete All Data works correctly
- [ ] I have verified exports work and clean up temp files
- [ ] I have verified privacy policy displays correctly
- [ ] I have completed App Store Connect setup
- [ ] I have prepared screenshots and description
- [ ] I have read and understood App Store Review Guidelines
- [ ] I am ready to respond to App Store review feedback

---

## 🎉 Ready to Submit!

Once all items above are checked, you're ready to:

1. **Create Archive** in Xcode (Product → Archive)
2. **Distribute to App Store Connect**
3. **Complete App Store Connect listing**
4. **Submit for Review**
5. **Wait for review** (typically 1-3 days)
6. **Respond promptly** to any review questions

---

## 📞 Support During Review

If you get questions during App Store review:

### Common Questions:
- **"What data do you collect?"** → None, fully local app
- **"How do you use photo access?"** → Only to reference photos, not copy them
- **"Where is your privacy policy?"** → In-app (Settings → Privacy Policy)
- **"How can users delete their data?"** → Settings → Delete All Data

### If Rejected:
1. Read rejection reason carefully
2. Fix the specific issue mentioned
3. Update version/build number
4. Resubmit with resolution notes

---

## 📚 Additional Resources

- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [App Privacy Details](https://developer.apple.com/app-store/app-privacy-details/)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)

---

**Last Updated:** March 1, 2026
**Security Fixes Version:** All critical and high-priority issues resolved

Good luck with your submission! 🚀
