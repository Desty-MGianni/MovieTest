//
//  YouTubePlayer.swift
//  MovieTest
//
//  Created by Gianni Mucci on 14/11/2026.
//

import SwiftUI
import WebKit

// On utilise le protocol UIViewRepresentable
struct YouTubePlayer: UIViewRepresentable {
    let webView = WKWebView()
    let videoId: String
    let youtubeBaseURL = APIConfig.shared?.youtubeBaseURL

    // les functions suivantes  viennent du protocol.
    // On doit les implémentées nous même.
    func makeUIView(context: Context) -> some UIView {
        webView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        // Si ytBaseURL n'est pas null
        // on convertit le string en URL
        guard let baseURLString = youtubeBaseURL,
            let baseURL = URL(string: baseURLString)
        else { return }

        let fullURL = baseURL.appending(path: videoId)

        // Obligatoire pour satisfaire YouTube
        // On à besoin d'un champ "Referer" valide pour que
        // YouTube ne renvoie pas d'erreur.
        // On récupère l'indentifiant de lot (bundle identifier)
        // car c'est plus robute.
        guard let bundleId = Bundle.main.bundleIdentifier else { return }
        let refererURL = "https://" + bundleId
        var request = URLRequest(url: fullURL)
        request.setValue(refererURL, forHTTPHeaderField: "Referer")

        // On lance le navigateur web
        webView.load(request)
    }
}
