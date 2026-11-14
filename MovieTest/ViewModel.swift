//
//  ViewModel.swift
//  MovieTest
//
//  Created by Gianni Mucci on 14/11/2026.
//

import Foundation

// @ => macros
// Observable permet de notifier l'UI si
// des données on été modifiées
@Observable
// On ne peut pas utiliser de struct avec @Observable
// On doit donc utiliser une classe.
class ViewModel {
    // Ceci nous permet, selon le status de la récupération
    // de donnée, de changer la vue (UI).
    enum FetchStatus {
        // Affiche rien
        case notStarted
        // Affiche une vue avec une barre de progression
        case fetching
        // Affiche la page "standard"
        case success
        // Affiche une vue pour les erreurs
        case failed(underlyingError: Error)
    }
    // propriété de type FetchStatus
    // ou l'écriture est privée (la lecture est publique)
    // On l'initialize aussi à notStarted.
    private(set) var homeStatus: FetchStatus = .notStarted

    // private n'est pas nécessaire mais comme aucun autre fichier
    // ne va accéder à ce champ, il est de bonne pratique de le faire.
    private let dataFetcher = DataFetcher()

    var trendingMovies: [Title] = []

    // async ici parce que la fonction va faire un appel réseau.
    func getTitles() async {
        homeStatus = .fetching

        do {
            trendingMovies = try await dataFetcher.fetchTitles(for: "movie")
            // Si Fetch à réussi, on change homeStatus
            homeStatus = .success
        } catch {
            print(error)
            homeStatus = .failed(underlyingError: error)
        }
    }
}
