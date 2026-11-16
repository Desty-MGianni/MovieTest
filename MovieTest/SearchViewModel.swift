//
//  SearchViewModel.swift
//  MovieTest
//
//  Created by Gianni Mucci on 15/11/2026.
//

import Foundation

// On crée un ViewModel exprès pour la recherche
// pour une meilleure organization.

@Observable
class SearchViewModel {
    // Seulement à l'intérieur de cette classe
    // ces propriétés peuvent ètres changées
    private(set) var errorMessage: String?
    // Iniitaliser cette variable permet de
    // s'évitér de la "déballer" plus tard
    // (vérification de nullité)
    private(set) var searchTitles: [Title] = []

    private let dataFetcher = DataFetcher()

    // media -> Films ou séries
    // title -> ce que l'utilisateur entrera
    //      dans la barre de recherche.
    // async -> Cette fonction va faire un appel réseau.
    func getSearchTitle(by media: String, for title: String) async {
        do {
            errorMessage = nil
            if title.isEmpty {
                // on récupère les objet Title pour le média sélectionné.
                // Si la barre de recherche est vide, on retourne une
                // liste de films / série tendances ("fallback")
                searchTitles = try await dataFetcher.fetchTitles(for: media, by: "trending")
            } else {
                // TODO: Utiliser des enums pour
                // éviter les "trending" et "search" dans
                // les appels à la fonction fetchTitles
                searchTitles = try await dataFetcher.fetchTitles(
                    for: media, by: "search", with: title)
            }
        } catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }
}
