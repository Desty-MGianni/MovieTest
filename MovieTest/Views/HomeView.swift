//
//  HomeView.swift
//  MovieTest
//
//  Created by Gianni Mucci on 14/11/2026.
//

import SwiftData
import SwiftUI

struct HomeView: View {
    // cet objet permettra de contrôle l'UI
    let viewModel = ViewModel()
    // le symbole @ signifie 2 chose :
    //      - Un attribut
    //      - Une macro
    //
    // L'attribut State permet à l'UI de change
    // la valeur de cette variable.
    //
    // Il existe plusieurs manière de "dire" à l'application
    // ou se siture l'utilisateur dans l'arboressence interne du programme.
    //
    // Dans cette vue, on utilise NavigationPath et NavigationStack.
    //
    // NavigationPath permet de gérér ou l'utilisateur
    // se situe dans l'application
    @State private var titleDetailPath = NavigationPath()
    // Cette macros permet d'attrapper notre connection à SwiftData
    // Avec cela, on peut insérer, supprimer et enregistré des donnée
    // depuis l'UI (cette vue)
    @Environment(\.modelContext) var modelContext

    var body: some View {
        // Empile les View les unes sur les autres
        // (même principe que / dans une URL mais pour les vues)
        // Ici, on empile la vue détail sut la HomeView
        // $ indique à SwiftUI quelles Vues on à visité
        NavigationStack(path: $titleDetailPath) {
            // Lors du chargement de l'image, cet objet permettra
            // de ne pas avoir le texte suivant l'image de "remonter".
            GeometryReader { geo in
                ScrollView(.vertical) {
                    switch viewModel.homeStatus {
                    case .notStarted:
                        EmptyView()
                    case .fetching:
                        ProgressView()
                            .frame(width: geo.size.width, height: geo.size.height)
                    case .success:

                        LazyVStack {
                            // Charge une image depuis le ViewModel (retourné aléatoirement)
                            AsyncImage(url: URL(string: viewModel.heroTitle.posterPath ?? "")) {
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
                                    titleDetailPath.append(viewModel.heroTitle)
                                } label: {
                                    Text(Constants.playString).ghostButton()
                                }.padding(.horizontal, 10)
                                Button {
                                    // insère le titre dans le
                                    // context SwiftData
                                    modelContext.insert(viewModel.heroTitle)
                                    try? modelContext.save()
                                } label: {
                                    Text(Constants.downloadString).ghostButton()
                                }.padding(.horizontal, 10)
                            }

                            HorizontalListView(
                                header: Constants.trendingMovieString,
                                titles: viewModel.trendingMovies
                            ) { title in
                                // On ajoute au chemin de navigation
                                // les 4 listes horizontales
                                titleDetailPath.append(title)
                            }
                            HorizontalListView(
                                header: Constants.trendingTVString,
                                titles: viewModel.trendingTVShows
                            ) { title in
                                // On ajoute au chemin de navigation
                                // les 4 listes horizontales
                                titleDetailPath.append(title)
                            }

                            HorizontalListView(
                                header: Constants.topRatedMovieString,
                                titles: viewModel.topRatedMovies
                            ) { title in
                                // On ajoute au chemin de navigation
                                // les 4 listes horizontales
                                titleDetailPath.append(title)
                            }

                            HorizontalListView(
                                header: Constants.topRatedTVString,
                                titles: viewModel.topRatedTVShows
                            ) { title in
                                // On ajoute au chemin de navigation
                                // les 4 listes horizontales
                                titleDetailPath.append(title)
                            }

                        }
                    case .failed(let error):
                        Text(error.localizedDescription)
                            .errorMessage()
                            .frame(
                                width: geo.size.width,
                                height: geo.size.height)

                    }
                    // Empilement vertical (lazy load)
                }
            }.task {
                await viewModel.getTitles()
            }
            // Quand on push un titre dans la pile de navigation,
            // On affiche la TitleDetailView avec le bon titre.
            // Il est de bonne pratique d'avoir ce modifiant
            // aussi proche que possible de NavigationStack
            .navigationDestination(for: Title.self) { title in
                TitleDetailView(title: title)

            }
        }
    }
}
#Preview {
    HomeView()
}
