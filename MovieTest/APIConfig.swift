//
//  APIConfig.swift
//  MovieTest
//
//  Created by Gianni Mucci on 14/11/2026.
//
import Foundation

// Charge dynamiquement les clés API pour une question de sécurité.
// Une instance sera crée par un source externe (.json)
struct APIConfig: Decodable {
    let tmdbBaseURL: String
    let tmdbAPIKey: String

    // Singleton pattern
    // Si on arrive pas à charger APIConfig, on renvois null
    // pour éviter de faire crash l'app.
    static let shared: APIConfig? = {
        do {
            return try loadConfig()
        } catch {
            print("Failed to load API config: \(error.localizedDescription)")
            return nil
        }
    }()

    // comme en C# pour la visibilité (private static)
    // throws permet à la fonction de renvoyer les erreurs
    // -> = valeur de retour de la fonction.
    private static func loadConfig() throws -> APIConfig {
        // guard est la même chose que if
        // mais il a été pensé pour les retours anticipées.
        guard let url = Bundle.main.url(forResource: "APIConfig", withExtension: "json") else {
            throw APIConfigError.fileNotFound
        }

        do {
            // Essaye de récupérer les données de l'url donnée
            // (ici, le chemin vers APIConfig.json)
            //
            // Si cela réussit, on essaye de décoder le JSON en le "comparant" à la structure APIConfig
            // et on renoie le résultat.
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(APIConfig.self, from: data)
        } catch let error as DecodingError {
            // Si on n'as pas réussi à charger ou décoder le fichier JSON => Erreur
            throw APIConfigError.decodingFailed(underlyingError: error)
        } catch {
            throw APIConfigError.dataLoadingFailed(underlyingError: error)
        }
    }
}
