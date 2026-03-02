//
//  FestivalListView.swift
//  Concert App
//
//  Created by Michael Tempestini on 3/1/26.
//

import SwiftUI
import CoreData

// Grouped festival data structure
struct GroupedFestival: Identifiable {
    let id = UUID()
    let festivalName: String
    let concerts: [Concert]
    let attendanceCount: Int
    let totalUniqueArtists: Int
}

struct FestivalListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Concert.date, ascending: false)],
        predicate: NSPredicate(format: "concertType == %@", "festival"),
        animation: .default)
    private var festivals: FetchedResults<Concert>
    
    @State private var searchText = ""
    
    // Normalize festival name for grouping
    func normalizeFestivalName(_ name: String) -> String {
        var normalized = name.lowercased()
        
        // Remove common festival-related words
        let wordsToRemove = ["festival", "fest", "music", "the", "&", "and"]
        for word in wordsToRemove {
            normalized = normalized.replacingOccurrences(of: word, with: "")
        }
        
        // Remove spaces, punctuation, and special characters
        normalized = normalized.components(separatedBy: CharacterSet.alphanumerics.inverted).joined()
        
        return normalized.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // Check if two festival names are similar enough to group
    func areSimilarFestivalNames(_ name1: String, _ name2: String) -> Bool {
        let norm1 = normalizeFestivalName(name1)
        let norm2 = normalizeFestivalName(name2)
        
        // Exact match after normalization
        if norm1 == norm2 { return true }
        
        // One contains the other (for "Riot Fest" vs "Riot Fest Music Festival")
        if norm1.contains(norm2) || norm2.contains(norm1) {
            // Only match if they're reasonably close in length
            let lengthRatio = Double(min(norm1.count, norm2.count)) / Double(max(norm1.count, norm2.count))
            if lengthRatio > 0.6 { return true }
        }
        
        return false
    }
    
    // Group festivals by similar names
    var groupedFestivals: [GroupedFestival] {
        var groups: [String: [Concert]] = [:]
        var nameMapping: [String: String] = [:] // Maps normalized name to display name
        
        for festival in festivals {
            let festivalName = festival.wrappedFestivalName
            guard !festivalName.isEmpty else { continue }
            
            let normalized = normalizeFestivalName(festivalName)
            
            // Check if this festival belongs to an existing group
            var foundGroup = false
            for (existingNormalized, existingDisplayName) in nameMapping {
                if areSimilarFestivalNames(normalized, existingNormalized) {
                    groups[existingDisplayName, default: []].append(festival)
                    foundGroup = true
                    break
                }
            }
            
            // If no existing group found, create new one
            if !foundGroup {
                nameMapping[normalized] = festivalName
                groups[festivalName, default: []].append(festival)
            }
        }
        
        // Convert to GroupedFestival objects
        return groups.map { name, concerts in
            // Calculate total unique artists across all concerts
            var allArtists = Set<String>()
            for concert in concerts {
                for artist in concert.artistsArray {
                    let artistName = artist.wrappedName.trimmingCharacters(in: .whitespaces)
                    if !artistName.isEmpty {
                        allArtists.insert(artistName)
                    }
                }
            }
            
            return GroupedFestival(
                festivalName: name,
                concerts: concerts.sorted { $0.wrappedDate > $1.wrappedDate },
                attendanceCount: concerts.count,
                totalUniqueArtists: allArtists.count
            )
        }
        .sorted { $0.attendanceCount > $1.attendanceCount }
    }
    
    // Filter grouped festivals based on search
    var filteredGroupedFestivals: [GroupedFestival] {
        if searchText.isEmpty {
            return groupedFestivals
        }
        
        return groupedFestivals.filter { group in
            // Search by festival name
            if group.festivalName.localizedCaseInsensitiveContains(searchText) {
                return true
            }
            
            // Search by year
            for concert in group.concerts {
                let calendar = Calendar.current
                let year = calendar.component(.year, from: concert.wrappedDate)
                if String(year).contains(searchText) {
                    return true
                }
            }
            
            // Search by artist name
            for concert in group.concerts {
                for artist in concert.artistsArray {
                    if artist.wrappedName.localizedCaseInsensitiveContains(searchText) {
                        return true
                    }
                }
            }
            
            // Search by city
            for concert in group.concerts {
                if concert.wrappedCity.localizedCaseInsensitiveContains(searchText) {
                    return true
                }
            }
            
            return false
        }
    }
    
    var body: some View {
        List {
            ForEach(filteredGroupedFestivals) { group in
                NavigationLink(destination: FestivalHistoryView(festivalGroup: group)) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(group.festivalName)
                            .font(.headline)
                        
                        Text("Attended \(group.attendanceCount) time\(group.attendanceCount == 1 ? "" : "s")")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Festivals")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $searchText, prompt: "Search festivals, years, or artists")
        .overlay {
            if filteredGroupedFestivals.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: searchText.isEmpty ? "tent.fill" : "magnifyingglass")
                        .font(.system(size: 60))
                        .foregroundStyle(.secondary)
                    
                    Text(searchText.isEmpty ? "No Festivals" : "No Results")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(searchText.isEmpty ? "Add festival concerts to see them here" : "Try a different search term")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding()
            }
        }
    }
}

#Preview {
    NavigationStack {
        FestivalListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
