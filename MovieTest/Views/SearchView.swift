//
//  SearchView.swift
//  MovieTest
//
//  Created by Gianni Mucci on 15/11/2026.
//

import SwiftUI

// Cette vue retournera une liste de titre
// provenent d'une recherche.
struct SearchView: View {
    // toggle (booléen) déterminé par l'UI (@State)
    @State private var searchByMovies = true
    @State private var searchText = ""
    private let searchViewModel = SearchViewModel()
    // Track et contrôle l'historique de navigation de l'utilisateur.
    @State private var navigationPath = NavigationPath()

    var body: some View {
        // Nécessaire pour naviguer entre le résultat d'une recherche
        // et la "page de garde" de SearchView
        //
        // On capture l'état (chemins) de la pile
        // dans la variable navigationPath
        NavigationStack(path: $navigationPath) {
            // On utilise ScrollView au cas ou
            // le résultat de la recherche est
            // plus longue que ce que peut afficher
            // le téléphone.
            ScrollView {
                // Si une erreur est présente dans le ViewModel\
                // On affiche le text stylisée.
                // Sinon, on affiche la Vue normale.
                if let error = searchViewModel.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(.rect(cornerRadius: 10))
                }
                // Empile les élément verticalements selon
                // un nombre de colonnes déterminé.
                // Lazy -> charge les éléments seulement quand ils
                // sont nécessaires
                LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
                    ForEach(searchViewModel.searchTitles) { title in
                        AsyncImage(url: URL(string: title.posterPath ?? "")) {
                            image in
                            image
                                // Modifie la taile
                                .resizable()
                                // justqu'à ce que l'image n'est pas coupé
                                .scaledToFit()
                                // arrondit les bords
                                .clipShape(.rect(cornerRadius: 10))
                        } placeholder: {
                            ProgressView()
                        }
                        // Chaque image doit rentrer dans les dimensions
                        // en paramètre
                        .frame(width: 120, height: 200)
                        // Permet de cliquer sur l'image pour
                        // afficher la vue détail
                        .onTapGesture {
                            navigationPath.append(title)
                        }
                    }
                }
            }
            .navigationTitle(
                // Un ternaire comme en C#
                searchByMovies
                    ? Constants.movieSearchString
                    : Constants.tvSearchString
            )
            .toolbar {
                // .topBarTrailing => place l'objet à droite de la barre.
                ToolbarItem(placement: .topBarTrailing) {

                    Button {
                        // quand le bouton sera appuyé,
                        // l'état de la variable passera de
                        // true à false et vice-versa
                        searchByMovies.toggle()

                        // Le programme affiche une liste de ... tendance
                        // si rien n'est tappé par l'utilisateur dans la
                        // barre de recherche.
                        //
                        // la tâches ici permet de changer la liste de posters
                        // des films tendances vers les série tendances
                        Task {
                            // Task permet de lancer une fonction async
                            // dans un endroit qui, normalement, ne supporte
                            // pas await. Dans notre cas un bouton
                            await searchViewModel.getSearchTitle(
                                by: searchByMovies
                                    ? "movie"
                                    : "tv",
                                for: searchText
                            )
                        }

                    } label: {
                        Image(
                            systemName:
                                // Ternaire permettant de changer
                                // l'icone affiché pour le bouton
                                searchByMovies
                                ? Constants.movieIconString
                                : Constants.tvIconString
                        )
                    }

                }
            }
            // $ synchronise ce que l'utilisateur entre comme recherche
            // avec la variable qui suit (searchText)
            //
            // Ici, on peut utiliser .searchable car on à crée un
            // NavigationStack
            .searchable(
                text: $searchText,
                // le comportement par défaut de la barre de recherche à
                // changé par rapport à la vidéo -> placement permet
                // ici de forcer l'affichage de lar barre de recherche.
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: searchByMovies
                    ? Constants.moviePlaceHolderString
                    : Constants.tvPlaceHolderString
            )
            // Cette tâche s'exécutera à chaque fois que la variable
            // serachText sera modifiée.
            //
            // À chaque fois que l'utilisateur tappera quelque chose
            // dans la barre de recherche, un appel vers
            // l'API TheMovieDB sera effectuée.
            .task(id: searchText) {
                // sans cette tempo, une requête est effectée
                // à chaque frappes de l'utilisateur (pas ouf)
                // Je double par rapport au cours pour être surs
                try? await Task.sleep(for: .milliseconds(1000))

                // Cette vérificaton utilisé pour quand l'utilisateur
                // s'arrète en plein milieu de la recherche et puis reprend.
                // (J'ai pas tout compris)
                if Task.isCancelled {
                    return
                }

                // Appel vers l'API TMDB
                await searchViewModel.getSearchTitle(
                    by: searchByMovies ? "movie" : "tv", for: searchText)

            }
            // est liée à opTapGesture() car on a ajouté le titre
            // dans le chemin de navigation.
            .navigationDestination(
                for: Title.self,
                destination: { title in
                    TitleDetailView(title: title)
                }
            )
        }
    }
}

#Preview {
    SearchView()
}
