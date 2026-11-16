//
//  MovieTestApp.swift
//  MovieTest
//
//  Created by Gianni Mucci on 14/11/2026.
//

// Projet crée avec ce cours :
// https://www.youtube.com/watch?v=-VC3hIEL7eQ

import SwiftData
import SwiftUI

@main
struct MovieTestApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // Crée un container permetter de stocker
        // et gérer des objets Title
        //      - Sauvegarder
        //      - Chargement
        //      - Sync avec la BDD
        .modelContainer(for: Title.self)
    }
}
