//
//  PrivacyPolicyView.swift
//  Concert App
//
//  Created by Michael Tempestini on 3/1/26.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Privacy Policy")
                    .font(.largeTitle)
                    .bold()
                
                Text("Last Updated: March 1, 2026")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Divider()
                
                Group {
                    SectionHeader("Your Data Stays On Your Device")
                    Text("""
                    Concert App stores all your concert history, photos, and notes \
                    locally on your iPhone. We do not collect, transmit, or store \
                    any of your data on external servers.
                    """)
                    
                    SectionHeader("No Cloud Sync")
                    Text("""
                    Concert App does not sync data across devices. Your concert history \
                    is stored only on this device. If you get a new device, you can \
                    export your data using the Export or Backup features and manually \
                    transfer it.
                    """)
                    
                    SectionHeader("Photo Access")
                    Text("""
                    The app requests access to your Photo Library only to attach \
                    photos to your concerts. Photos remain in your library - we only \
                    store references to them. You can revoke this permission anytime \
                    in iOS Settings > Privacy & Security > Photos.
                    """)
                    
                    SectionHeader("No Tracking or Analytics")
                    Text("""
                    Concert App does not use any analytics, tracking, or advertising \
                    services. We do not collect information about how you use the app. \
                    We do not track your location, browsing habits, or any other \
                    personal information.
                    """)
                    
                    SectionHeader("Exports and Backups")
                    Text("""
                    When you export or backup your data to PDF or CSV format, files \
                    are created temporarily on your device and saved to your chosen \
                    location (Files app, AirDrop, Email, etc.). You have full control \
                    over where these files go and who has access to them.
                    """)
                    
                    SectionHeader("External Links")
                    Text("""
                    The app may open Safari to search for concert setlists using \
                    Google search. This uses standard web browsing subject to your \
                    browser's privacy settings and Google's privacy policy. We do \
                    not track or collect data from these searches.
                    """)
                    
                    SectionHeader("Data Security")
                    Text("""
                    Your concert data is protected by your device's passcode and \
                    encryption when your device is locked. No data is synchronized \
                    or backed up to external servers by this app. Your data is as \
                    secure as your device.
                    """)
                    
                    SectionHeader("Data Retention")
                    Text("""
                    Your data remains on your device until you delete it. You can \
                    delete individual concerts, or use the "Delete All Data" feature \
                    in Settings to remove all concert data from the app. Deleting \
                    the app from your device will also permanently delete all data.
                    """)
                    
                    SectionHeader("Children's Privacy")
                    Text("""
                    Concert App does not knowingly collect any information from \
                    children. The app is designed for general audiences to track \
                    their personal concert attendance.
                    """)
                    
                    SectionHeader("Changes to This Policy")
                    Text("""
                    We may update this privacy policy from time to time. Any changes \
                    will be reflected in the app with an updated "Last Updated" date. \
                    Continued use of the app after changes constitutes acceptance of \
                    the updated policy.
                    """)
                    
                    SectionHeader("Your Rights")
                    Text("""
                    You have complete control over your data:
                    
                    • Access: View all your data in the app at any time
                    • Export: Use the Export feature to download your data
                    • Delete: Delete individual concerts or all data at once
                    • Privacy: Revoke photo access permissions in iOS Settings
                    """)
                    
                    SectionHeader("Contact")
                    Text("""
                    If you have questions or concerns about privacy, please contact us at:
                    
                    support@concertapp.example.com
                    
                    Note: Replace this email address with your actual support email \
                    before submitting to the App Store.
                    """)
                    .italic()
                }
            }
            .padding()
        }
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SectionHeader: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(.headline)
            .padding(.top, 12)
    }
}

#Preview {
    NavigationStack {
        PrivacyPolicyView()
    }
}
