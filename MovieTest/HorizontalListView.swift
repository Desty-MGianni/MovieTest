//
//  HorizontalListView.swift
//  MovieTest
//
//  Created by Gianni Mucci on 14/11/2026.
//

import SwiftUI

struct HorizontalListView: View {
    let header: String
    var titles: [Title]

    // Cette variable est un délégué/event
    // (on veut garder la logique de navigation
    // dans la Vue parente pour éviter let bugs)
    let onSelect: (Title) -> Void

    var body: some View {
        // Alligne la pile sur un coté du téléphone.
        VStack(alignment: .leading) {
            Text(header)
                .font(.title)
            // Vue permettant de scroll
            ScrollView(.horizontal) {
                // Charge les éléments de la pile si
                // nécessaire horizontailement
                LazyHStack {
                    // extrait la valeur et l'index dans la liste
                    ForEach(titles) { title in
                        // Comme dans HomeView. Opérateur à coalescense null
                        // car posterPath renvoie un optionnel
                        AsyncImage(url: URL(string: title.posterPath ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 10))

                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 120, height: 200)
                        .onTapGesture {
                            onSelect(title)
                        }
                    }

                }
            }
        }
        // On ajoute des modifiant sur le VStack
        .frame(height: 250)
        .padding(10)
    }
}

#Preview {
    HorizontalListView(header: Constants.trendingMovieString, titles: Title.previewTitles) {
        title in
        // Avec cela, on indique à la preview de ne rien faire
        // avec le titre ou on à cliquer dessus.
    }
}
