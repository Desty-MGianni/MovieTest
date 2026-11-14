//
//  Errors.swift
//  MovieTest
//
//  Created by Gianni Mucci on 14/11/2026.
//

import Foundation

// On crée notre propre type d'erreur
// On hérite/combine les protocols Error et LocalizedError
//
// Error: lance des erreur dans les fonctions
// LocalizedError: Logs et message d'erreur plus user-friendly
//
// Comme en C#, il y a le principe de inner error/exception
// que l'on peut re-lancer.
// Ici, on utilise les inner Exceptiosn car la source de l'erreur peut être
// différente. Par exemple:
//      - Si le fichier est corompu
//      - Si on n'as pas les permissions pour lire le fichier
//      - ...

enum APIConfigError: Error, LocalizedError {
    case fileNotFound
    case dataLoadingFailed(underlyingError: Error)
    case decodingFailed(underlyingError: Error)

    // En swift, ? -> optionnel
    // (la même chose que C# à part le nom qui change)
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "API configuration file not found."
        case .dataLoadingFailed(underlyingError: let error):
            return "Failed to load data from API configuration file: \(error.localizedDescription)."
        case .decodingFailed(underlyingError: let error):
            return "Failed to decode API configuration: \(error.localizedDescription)."
        }
    }
}

enum NetworkError: Error, LocalizedError {
    case badURLResponse(underlyingError: Error)
    case missingConfig
    case urlBuildFailed

    var errorDescription: String? {
        switch self {
        case .badURLResponse(underlyingError: let error):
            return "Failed to parse URL response: \(error.localizedDescription)."
        case .missingConfig:
            return "Missing API configuration."
        case .urlBuildFailed:
            return "Failed to build URL."
        }

    }
}
