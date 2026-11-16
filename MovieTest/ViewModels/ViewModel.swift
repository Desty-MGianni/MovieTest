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
    // cette classe nous permet, selon le status de la récupération
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
    private(set) var videoIdStatus: FetchStatus = .notStarted
    private(set) var upcomingStatus: FetchStatus = .notStarted

    // private n'est pas nécessaire mais comme aucun autre fichier
    // ne va accéder à ce champ, il est de bonne pratique de le faire.
    private let dataFetcher = DataFetcher()

    var trendingMovies: [Title] = []
    var trendingTVShows: [Title] = []
    var topRatedMovies: [Title] = []
    var topRatedTVShows: [Title] = []

    var upcomingMovies: [Title] = []

    // On initialise en cas de secours si le
    // "randomizer" renvois rien (null)
    var heroTitle = Title.previewTitles[0]
    var videoId = ""

    // Fonction permettant à l'UI de récupérer les titres (MVVM pattern)
    // Async ici parce que la fonction va faire un appel réseau.
    func getTitles() async {
        homeStatus = .fetching

        // Cette application n'as pas besoin de récupérer
        // les infos venant de la base de données à chaque
        // changement d'état de l'application (changer d'onglet par exemple).
        if trendingMovies.isEmpty {
            do {
                // async let permet d'effectuer les 4 requêtes en parallèles
                // avec try await, on attend que chaque requêtes se finissent.
                async let tMovies = dataFetcher.fetchTitles(for: "movie", by: "trending")
                async let tTVShows = dataFetcher.fetchTitles(for: "tv", by: "trending")
                async let tRMovie = dataFetcher.fetchTitles(for: "movie", by: "top_rated")
                async let tRTVShows = dataFetcher.fetchTitles(for: "tv", by: "top_rated")

                // On attend quand même que les 4 requêtes se terminent
                // avant de finir / sortir de la méthode.
                trendingMovies = try await tMovies
                trendingTVShows = try await tTVShows
                topRatedMovies = try await tRMovie
                topRatedTVShows = try await tRTVShows

                // Fait en sorte que le poster affiché dans
                // la homepage est différent à chaque fois.
                // trendingMovies renvois un optionnel, on
                // doit "déballer" la valeur si elle existe
                if let title = trendingMovies.randomElement() {
                    heroTitle = title
                }
                homeStatus = .success
            } catch {
                print(error)
                homeStatus = .failed(underlyingError: error)
            }
        } else {
            homeStatus = .success
        }
    }

    // Cette fonction sera appelé par l'UI pour
    // Récupérer videoId. (MVVM pattern)
    func getVideoId(for title: String) async {
        videoIdStatus = .fetching
        do {
            videoId = try await dataFetcher.fetchVideoId(for: title)
            videoIdStatus = .success
        } catch {
            print(error)
            videoIdStatus = .failed(underlyingError: error)
        }
    }

    func getUpcomingMovies() async {
        upcomingStatus = .fetching

        do {
            // async await toujours pour ne pas bloquer le thread UI
            upcomingMovies = try await dataFetcher.fetchTitles(
                for: "movie", by: "upcoming"
            )
            upcomingStatus = .success
        } catch {
            print(error)
            homeStatus = .failed(underlyingError: error)
        }
    }
}
