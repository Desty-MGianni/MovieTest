//
//  Title.swift
//  MovieTest
//
//  Created by Gianni Mucci on 14/11/2026.
//

// On a remplacé Foundation par SwiftData car
// on n'utilisait aucun éléments.

// SwiftData permet de gérer des donnée hors lignes
// Le but est de sauvegarder et supprimer des titres dans
// l'onglet Download.
import SwiftData

// Modèle reflétant la réponse de l'API
// Le nom à été changé car on travaille
// avec 2 API (TMDB et YouTube)
struct TMDBAPIObject: Decodable {
    // le champs est obligatoire, mais
    // on l'initialise à un tableau de Title vide
    // Si la Base de Donnée renoie rien, on ne crash pas.
    var results: [Title] = []
}

// Model permettant de capturer
// les éléments qui nous intéressent
// venant de l'API TheMovieDb

// Cette élément permet de traiter
// Les films ainsi que les Séries.

// Les champs nullable sont pour éviter
// les crashs.

// Decodable, Identifiable et Hashable sont des Protocols
// (Littéralement la même chose que les interfaces C#)
//      - Decodable: Permet à la structure d'être crée
//          depuis des données externes (mapping)
//      - Identifiable: Oblige la structure à avoir un
//          champ/propriété id pour différencier chaque
//          instances (utiles pour nous dans les Views).
//      - Hashable: Permet de savoir si 2 objet sont
//          identiques. Obligatoire quand on utilise
//          des chemins de navigation.
//
// On a changé Title de struct vers class
// pour pouvoir utilisé l'attribut @Model,
// permettant de convertir la classe en stored model
//
@Model
class Title: Decodable, Identifiable, Hashable {
    // Cette macros permet que chaque titre enregistré
    // dans SwiftData possède un identifiant unique.
    // Si deux titre on le même Id, il ne sera pas possible
    // d'enregistrer, empéchant les doublons.
    @Attribute(.unique) var id: Int?
    var title: String?
    var name: String?
    var overview: String?
    var posterPath: String?

    // La même chose qu'constructeur en C#
    init(
        id: Int? = nil, title: String? = nil, name: String? = nil, overview: String? = nil,
        posterPath: String? = nil
    ) {
        self.id = id
        self.title = title
        self.name = name
        self.overview = overview
        self.posterPath = posterPath
    }

    // Cette énumération est nécessaire pour matcher
    // les champs de cette classe avec les propriétés
    // venants des résonses json
    enum CodingKeys: CodingKey {
        case id
        case title
        case name
        case overview
        case posterPath
    }

    // Donne à SwiftData comment crée le modèle depuis notre
    // fonction de décodage des réponses json.
    // "required" permet aussi au classe dérivées de pouvoir être décodées
    // de la même manière.
    required init(from decoder: any Decoder) throws {
        // Crée un container qui nous permet d'accéder aux donnée json
        // en utilisant les clé définie dans l'enum
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // On peut essayer de décoder et initialisé nos champs (ou propriétés)
        // tous les champs sont nullable (optionnel) car le server tmdb peut
        // ne rien renvoyer. decodeIfPresent est une manière plus safe
        // de procéder au décodage.
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        overview = try container.decodeIfPresent(String.self, forKey: .overview)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
    }
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
