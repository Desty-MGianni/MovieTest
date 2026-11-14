//
//  HomeView.swift
//  MovieTest
//
//  Created by Gianni Mucci on 14/11/2026.
//

import SwiftUI

struct HomeView: View {

    var body: some View {
        // Lors du chargement de l'image, cet objet permettra
        // de ne pas avoir le texte suivant l'image de "remonter".
        GeometryReader { geo in
            ScrollView(.vertical) {
                // Empilement vertical (lazy load)
                LazyVStack {
                    // Charge une image depuis internet (Async)
                    AsyncImage(url: URL(string: Constants.testTitleURL)) {
                        image in
                        image
                            .resizable()
                            .scaledToFit()
                            // Ajoute le dégradé (de transparent à la couleur du fond d'écran,
                            // dépendament de si on active le darkmode ou non)
                            // démarrant du haut vers bas de l'image
                            // (à 80 % de l'image, on commence le gradient).
                            // .gradient est défini dans les assets.
                            .overlay {
                                LinearGradient(
                                    stops: [
                                        Gradient.Stop(color: .clear, location: 0.8),
                                        Gradient.Stop(color: .gradient, location: 1),
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            }
                    }  // Si l'image ne se charge pas on utilise une vue spéciale (ProgressView)
                    placeholder: {
                        ProgressView()
                    }
                    // modifiant de AsyncImage avec les infos de GeometryReader
                    .frame(width: geo.size.width, height: geo.size.height * 0.85)

                    // Empilement horizontale
                    HStack {
                        Button {
                        } label: {
                            Text(Constants.playString).ghostButton()
                        }
                        Button {
                        } label: {
                            Text(Constants.downloadString).ghostButton()
                        }
                    }

                    HorizontalListView(header: Constants.trendingMovieString)
                    HorizontalListView(header: Constants.trendingTVString)
                    HorizontalListView(header: Constants.topRatedMovieString)
                    HorizontalListView(header: Constants.topRatedTVString)
                }
            }
        }
    }
}
#Preview {
    HomeView()
}
