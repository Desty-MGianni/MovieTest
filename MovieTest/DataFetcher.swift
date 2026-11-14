//
//  DataFetcher.swift
//  MovieTest
//
//  Created by Gianni Mucci on 14/11/2026.
//

import Foundation

struct DataFetcher {

    let tmdbBaseURL = APIConfig.shared?.tmdbBaseURL
    let tmdbAPIKey = APIConfig.shared?.tmdbAPIKey

    // renoie un tableau de Title
    //
    // Comme cedtte fonction va effectué des
    // opérations réseau, on la fait exécuté sur un autre thread
    // pour ne pas bloquer le thread principal (UI)
    //
    // "for" est un label d'argument, permettant plus de
    // clarté sur ce qu'attend/suppose la fonction à cet emplacement.
    func fetchTitles(for media: String) async throws -> [Title] {
        // Un exemple d'url:
        // https://api.themoviedgb.org/3/trending/movie/day?api_key=YOUr_API_KEY

        // On fait une null verification sur
        // les deux variables globales
        guard let baseURL = tmdbBaseURL else {
            throw NetworkError.missingConfig
        }
        guard let apiKey = tmdbAPIKey else {
            throw NetworkError.missingConfig
        }

        // On construit l'URL où aller chercher les données.
        // L'initializeur URL renvoient une URL nullable.
        guard
            let fetchTitlesURL = URL(string: baseURL)?
                .appending(path: "3/trending/\(media)/day")
                .appending(queryItems: [
                    URLQueryItem(name: "api_key", value: apiKey)
                ])
        else {
            throw NetworkError.urlBuildFailed
        }

        print(fetchTitlesURL)

        // On gére la requête HTTP et on vérifie la réponse du site

        // Tuples :
        //      - Data: le json que l'on veut de la base de donnée
        //      - urlResponse: un objet contenant les métadonnée de la réponse (200: OK, etc)
        // Renvoie des erreurs (si le serveru crash par exemple),
        // On utilise await pour ne pas bloquer le thread principal
        let (data, urlResponse) = try await URLSession.shared.data(from: fetchTitlesURL)

        // response est récupéré quand le statuscode de la réponse HTTP est de 200.
        // Sinon, on renoie une erreur.
        // "as" est la même chose qu'en C#, avec ? pour gérer les types optionnels
        guard let response = urlResponse as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badURLResponse(
                // NSerror -> NextStepError -> Classe venant d'Objective-C.
                underlyingError: NSError(
                    domain: "DataFetcher",
                    // Opérateur à coalescence nulle (comme C#)
                    code: (urlResponse as? HTTPURLResponse)?.statusCode ?? -1,
                    userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP Response"]))

        }

        // Ici, la réponse est correcte. On décode le json
        let decoder = JSONDecoder()
        // convertit le snake_case renvoyé par le site en camelCase
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        // Rappel: APIObject vient de Title.swift
        var titles = try decoder.decode(APIObject.self, from: data).results

        // On rectifie le chemin d'accès de posterPath
        // avant de renoyer la table.
        Constants.addPosterPath(to: &titles)
        return titles
    }
}
