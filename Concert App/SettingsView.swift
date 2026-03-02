//
//  SettingsView.swift
//  Concert App
//
//  Created by Michael Tempestini on 2/26/26.
//

import SwiftUI
import CoreData
import UniformTypeIdentifiers

struct SettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Concert.date, ascending: false)],
        animation: .default)
    private var concerts: FetchedResults<Concert>
    
    @State private var showingExportOptions = false
    @State private var showingShareSheet = false
    @State private var showingDocumentPicker = false
    @State private var shareItem: ShareItem?
    @State private var backupFiles: [URL] = []
    @State private var showingBackupSuccess = false
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var showingDeleteSuccessAlert = false
    @State private var showingFirstDeleteConfirmation = false
    @State private var showingSecondDeleteConfirmation = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Data") {
                    Button {
                        if concerts.isEmpty {
                            errorMessage = "No concerts to export"
                            showingError = true
                        } else {
                            showingExportOptions = true
                        }
                    } label: {
                        Label("Export Concert Data", systemImage: "square.and.arrow.up")
                    }
                    .actionSheet(isPresented: $showingExportOptions) {
                        ActionSheet(
                            title: Text("Choose Export Format"),
                            buttons: [
                                .default(Text("PDF")) {
                                    exportData(format: "pdf")
                                },
                                .default(Text("CSV")) {
                                    exportData(format: "csv")
                                },
                                .cancel()
                            ]
                        )
                    }
                    
                    Button {
                        if concerts.isEmpty {
                            errorMessage = "No concerts to backup"
                            showingError = true
                        } else {
                            backupToFiles()
                        }
                    } label: {
                        Label("Backup to Files", systemImage: "folder")
                    }
                }
                
                Section("Developer & Testing") {
                    NavigationLink {
                        DiagnosticView()
                    } label: {
                        Label("Diagnostics & Data Tools", systemImage: "wrench.and.screwdriver")
                    }
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0")
                            .foregroundStyle(.secondary)
                    }
                    
                    NavigationLink {
                        PrivacyPolicyView()
                    } label: {
                        HStack {
                            Text("Privacy Policy")
                            Spacer()
                        }
                    }
                    
                    if let supportEmail = "support@concertapp.example.com".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                       let mailURL = URL(string: "mailto:\(supportEmail)") {
                        Button {
                            UIApplication.shared.open(mailURL)
                        } label: {
                            HStack {
                                Text("Contact Support")
                                Spacer()
                                Image(systemName: "envelope")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .foregroundStyle(.primary)
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        showingFirstDeleteConfirmation = true
                    } label: {
                        Label("Delete All Data", systemImage: "trash")
                    }
                    .confirmationDialog(
                        "Delete All Data",
                        isPresented: $showingFirstDeleteConfirmation,
                        titleVisibility: .visible
                    ) {
                        Button("Cancel", role: .cancel) {
                            // Dismiss
                        }
                        Button("Delete", role: .destructive) {
                            showingSecondDeleteConfirmation = true
                        }
                    } message: {
                        Text("Are you sure you want to delete all data? This cannot be undone")
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingShareSheet) {
                if let shareItem = shareItem {
                    ShareSheet(items: [shareItem.url])
                }
            }
            .sheet(isPresented: $showingDocumentPicker) {
                DocumentPicker(files: backupFiles, onComplete: { success in
                    if success {
                        showingBackupSuccess = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            showingBackupSuccess = false
                        }
                    } else {
                        errorMessage = "Save failed. Please try again."
                        showingError = true
                    }
                })
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
            .alert("Success", isPresented: $showingDeleteSuccessAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("All data deleted successfully")
            }
            .alert(
                "Last Chance",
                isPresented: $showingSecondDeleteConfirmation
            ) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    deleteAllData()
                }
            } message: {
                Text("Last chance, are you positive?")
            }
            .overlay {
                if showingBackupSuccess {
                    VStack {
                        Spacer()
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                            Text("Backup saved to Files")
                                .fontWeight(.medium)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .padding(.bottom, 100)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.spring(), value: showingBackupSuccess)
        }
    }
    
    // MARK: - Export Functions
    
    func exportData(format: String) {
        let concertArray = Array(concerts)
        
        if format == "pdf" {
            guard let pdfData = ConcertExportManager.generatePDF(concerts: concertArray) else {
                errorMessage = "Failed to generate PDF"
                showingError = true
                return
            }
            
            let fileName = ConcertExportManager.getFileName(format: "pdf")
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
            
            do {
                try pdfData.write(to: tempURL)
                shareItem = ShareItem(url: tempURL)
                showingShareSheet = true
                
                // Clean up temp file after a delay (after share sheet dismisses)
                DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
                    try? FileManager.default.removeItem(at: tempURL)
                }
            } catch {
                errorMessage = "Failed to save PDF: \(error.localizedDescription)"
                showingError = true
            }
        } else if format == "csv" {
            let csvString = ConcertExportManager.generateCSV(concerts: concertArray)
            let fileName = ConcertExportManager.getFileName(format: "csv")
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
            
            do {
                try csvString.write(to: tempURL, atomically: true, encoding: .utf8)
                shareItem = ShareItem(url: tempURL)
                showingShareSheet = true
                
                // Clean up temp file after a delay (after share sheet dismisses)
                DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
                    try? FileManager.default.removeItem(at: tempURL)
                }
            } catch {
                errorMessage = "Failed to save CSV: \(error.localizedDescription)"
                showingError = true
            }
        }
    }
    
    func backupToFiles() {
        let concertArray = Array(concerts)
        
        // Generate PDF
        guard let pdfData = ConcertExportManager.generatePDF(concerts: concertArray) else {
            errorMessage = "Failed to generate PDF"
            showingError = true
            return
        }
        
        let pdfFileName = ConcertExportManager.getFileName(format: "pdf")
        let pdfURL = FileManager.default.temporaryDirectory.appendingPathComponent(pdfFileName)
        
        // Generate CSV
        let csvString = ConcertExportManager.generateCSV(concerts: concertArray)
        let csvFileName = ConcertExportManager.getFileName(format: "csv")
        let csvURL = FileManager.default.temporaryDirectory.appendingPathComponent(csvFileName)
        
        do {
            try pdfData.write(to: pdfURL)
            try csvString.write(to: csvURL, atomically: true, encoding: .utf8)
            
            backupFiles = [pdfURL, csvURL]
            showingDocumentPicker = true
            
            // Clean up temp files after a delay (after document picker dismisses)
            DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
                try? FileManager.default.removeItem(at: pdfURL)
                try? FileManager.default.removeItem(at: csvURL)
            }
        } catch {
            errorMessage = "Failed to create backup files: \(error.localizedDescription)"
            showingError = true
        }
    }
    
    // MARK: - Delete Function
    
    private func deleteAllData() {
        do {
            try PersistenceController.shared.clearAllData()
            
            // Provide haptic feedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            // Show success alert
            showingDeleteSuccessAlert = true
            
            print("✅ All data deleted successfully by user")
            
        } catch {
            errorMessage = "Failed to delete data: \(error.localizedDescription)"
            showingError = true
            
            print("❌ Error deleting data: \(error)")
        }
    }
}

// MARK: - Helper Structs

struct ShareItem: Identifiable {
    let id = UUID()
    let url: URL
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct DocumentPicker: UIViewControllerRepresentable {
    let files: [URL]
    let onComplete: (Bool) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onComplete: onComplete)
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forExporting: files, asCopy: true)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let onComplete: (Bool) -> Void
        
        init(onComplete: @escaping (Bool) -> Void) {
            self.onComplete = onComplete
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            onComplete(true)
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            onComplete(false)
        }
    }
}

#Preview {
    SettingsView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
