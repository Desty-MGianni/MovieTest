//
//  Title.swift
//  MovieTest
//
//  Created by Gianni Mucci on 14/11/2026.
//

import Foundation

// Modèle reflétant la réponse de l'API
struct APIObject: Decodable {
    // le champs est obligatoire, mais
    // on l'initialise à un tableau de Title vide
    // Si la Base de Donnée renoie rien, on ne crash pas.
    var results: [Title] = []
}

// Model permettant de capturer
// les éléments qui nous intéressent
// venant de l'API TheMovieDb

// Cette structure permet de traiter
// Les films ainsi que les Séries.

// Les champs nullable sont pour éviter
// les crashs.

// Decodable et Identifiable sont des Protocols
// (Littéralement la même chose que les interfaces C#)
//      - Decodable: Permet à la structure d'être crée
//          depuis des données externes (mapping)
//      - Identifiable: Oblige la structure à avoir un
//          champ/propriété id pour différencier chaque
//          instances (utiles pour nous dans les Views).
struct Title: Decodable, Identifiable {
    var id: Int?
    var title: String?
    var name: String?
    var overview: String?
    var posterPath: String?

    // Pour faire des tests
    static var previewTitles = [
        Title(
            id: 1, title: "BeetleJuice", name: "BeetleJuice", overview: "A movie about BeetleJuice",
            posterPath: Constants.testTitleURL),
        Title(
            id: 2, title: "Pulp Fiction", name: "Pulp Fiction", overview: "A novie about gangsters",
            posterPath: Constants.testTitleURL2),
        Title(
            id: 3, title: "The Dark Knight", name: "The Dark Knight",
            overview: "A moive about Batman", posterPath: Constants.testTitleURL3),
    ]

}
