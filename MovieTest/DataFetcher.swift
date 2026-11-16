//
//  DataFetcher.swift
//  MovieTest
//
//  Created by Gianni Mucci on 14/11/2026.
//

import Foundation

// Un exemple d'url pour les films:
// https://api.themoviedgb.org/3/trending/movie/day?api_key=YOUR_API_KEY

// Un exemple d'url pour les mieux noté
// https://api.themoviedb.org/3/movie/top_rated?api_key=YOUR_API_KEY

// Un exemple d'url pour les fils qui arrivent
// https://api.themoviedb.org/3/movie/upcoming?api_key=YOUR_API_KEY

// Un exemple d'url pour une requête de recherche:
// https://api.themoviedb.org/3/search/movie?api_key=YOUR_API_KEY&query=PulpFiction

struct DataFetcher {

    let tmdbBaseURL = APIConfig.shared?.tmdbBaseURL
    let tmdbAPIKey = APIConfig.shared?.tmdbAPIKey
    let youtubeSearchURL = APIConfig.shared?.youtubeSearchURL
    let youtubeAPIKey = APIConfig.shared?.youtubeAPIKey

    // renoie un tableau de Title
    //
    // Comme cedtte fonction va effectué des
    // opérations réseau, on la fait exécuté sur un autre thread
    // pour ne pas bloquer le thread principal (UI)
    //
    // "for", "by type" et "with" sont des labels d'argument
    // permettant plus de clarté sur ce qu'attend/suppose
    // la fonction à cet emplacement.
    //
    // "with title" sert pour la recherche de film/série (searchView)
    func fetchTitles(for media: String, by type: String, with title: String? = nil) async throws
        -> [Title]
    {

        // On construit l'URL où aller chercher les données.
        // L'initializeur URL renvoient une URL nullable.
        // On à crée une fonction d'aide car le chemin selon
        // le type d'infos est différent.
        let fetchTitlesURL = try buildURL(media: media, type: type, searchPhrase: title)
        guard let fetchTitlesURL = fetchTitlesURL else {
            throw NetworkError.urlBuildFailed
        }

        // Appelle la fonction générique de décodage de la répoonse (json)
        // avec comme patron le type TMDBAPIObject
        // on capture seulement les résultats dans la variable titles.
        var titles = try await fetchAndDecode(url: fetchTitlesURL, type: TMDBAPIObject.self).results
        // On rectifie le chemin d'accès de posterPath
        // avant de renoyer la table.
        Constants.addPosterPath(to: &titles)
        return titles
    }

    // requête réseau, donc on utilise async
    func fetchVideoId(for title: String) async throws -> String {
        // on vérifie si on a des valeurs pour la clé
        // et l'url de base pour l'api youtube.
        guard let baseSearchURL = youtubeSearchURL else {
            throw NetworkError.missingConfig
        }
        guard let searchAPIKey = youtubeAPIKey else {
            throw NetworkError.missingConfig
        }

        // On concatène le string avec les valeurs contenue
        // dans chaque élément de l'énumération (pas les "clés")
        let trailerSearch =
            title + YoutubeURLStrings.space.rawValue + YoutubeURLStrings.trailer.rawValue

        // On construit l'url complète pour récupéré la vidéo youtube.
        // si le résultat est null, on lance une erreur.
        //
        // QueryItem est une abstraction qui gère
        // la bonne syntaxe pour les requêtes.
        //
        // le type URL possède la fonction appending qui
        // permet d'ajouter une liste de requêtes à la fin de l'url.
        guard
            let fetchVideoURL = URL(string: baseSearchURL)?.appending(queryItems: [
                URLQueryItem(name: YoutubeURLStrings.queryShorten.rawValue, value: trailerSearch),
                URLQueryItem(name: YoutubeURLStrings.key.rawValue, value: searchAPIKey),
            ])
        else {
            throw NetworkError.urlBuildFailed
        }

        // Appelle la fonction générique de décodage de la répoonse (json)
        // avec comme patron le type YoutubeSarchResponse.
        //
        // On récupère seulement l'id de la vidéo
        // ou une chaîne vide si cela échoue.
        //
        // La réponse de google est très imbriqué (items,first.id.video).
        //
        // ATTENTION: Dans ce code, on part du principe que la première entrée
        // dans la liste retourné par google est la bonne vidéo.
        return try await fetchAndDecode(
            url: fetchVideoURL, type: YouTubeSearchResponse.self
        ).items?.first?.id?.videoId ?? ""
    }

    // Fonction d'aide générique permettant de récupérer
    // la réponse json des API.
    // Elle va être utilisé par DataFetcher et YouTubeSearchResonnse.
    // Ici, T doit hérité de Decodable (la même chose que where en C#)
    func fetchAndDecode<T: Decodable>(url: URL, type: T.Type) async throws -> T {
        // On gére la requête HTTP et on vérifie la réponse du site
        // Tuples :
        //      - Data: le json que l'on veut de la base de donnée
        //      - urlResponse: un objet contenant les métadonnée
        //          de la réponse (200: OK, etc)
        // Renvoie des erreurs (si le serveru crash par exemple),
        // On utilise await pour ne pas bloquer le thread principal
        let (data, urlResponse) = try await URLSession.shared.data(from: url)

        // response est récupéré quand le statuscode
        // de la réponse HTTP est de 200.
        // Sinon, on renoie une erreur.
        //
        // "as" est la même chose qu'en C#, avec ?
        // pour gérer les types optionnels
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
        // convertit le snake_case utilisé dans les réponses json en camelCase
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        // Ici, on essaye de renvoyé le type T
        // en décodant les données venant de l'url
        return try decoder.decode(type, from: data)
    }

    // Fonction d'aide pour construire l'URL vers TMDB
    // searchPhrase est optionnel et à une valeur par défault,
    // il peut donc être omis à l'appel (comme C#)
    private func buildURL(media: String, type: String, searchPhrase: String? = nil) throws -> URL? {
        // On fait une null verification sur
        // les deux variables globales
        guard let baseURL = tmdbBaseURL else {
            throw NetworkError.missingConfig
        }
        guard let apiKey = tmdbAPIKey else {
            throw NetworkError.missingConfig
        }

        // map selon le type la bonne structure URL
        // voir les exemples en haut du fichier.
        var path: String
        if type == "trending" {
            path = "3/\(type)/\(media)/day"
        } else if type == "top_rated" || type == "upcoming" {
            path = "3/\(media)/\(type)"
        } else if type == "search" {
            path = "3/\(type)/\(media)"
        } else {
            throw NetworkError.urlBuildFailed
        }

        // Variable contenant la suite pour générer l'URL complète
        var urlQueryItems = [
            // on ajoute la clé dans la liste d'objet de requêtes
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        // Si on a une recherche, on l'ajoute dans
        // la liste des objets de requêtes.
        if let searchPhrase {
            urlQueryItems.append(
                URLQueryItem(
                    name: "query",
                    value: searchPhrase)
            )
        }

        guard
            let url = URL(string: baseURL)?
                .appending(path: path)
                .appending(queryItems: urlQueryItems)
        else {
            throw NetworkError.urlBuildFailed
        }

        return url
    }
}
