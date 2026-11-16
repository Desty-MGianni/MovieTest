//
//  VerticalListView.swift
//  MovieTest
//
//  Created by Gianni Mucci on 15/11/2026.
//

import SwiftData
import SwiftUI

struct VerticalListView: View {
    var titles: [Title]

    // Propriété permettant de différencier
    // depuis où cette vue à été "appelée"
    // (il ne faut pas avoir le swipe pour supprimer
    // en venant de upcomingView)
    var canDelete: Bool
    @Environment(\.modelContext) var modelContext
    var body: some View {
        List(titles) { title in
            // NavigationLink permet de définir où l'utilisateur va aller
            // et comment le lien est affiché.
            // Ici, on veut que le lien soit l'entièreté de l'élément
            // (image + texte)
            //
            // NavigationLink à l'avantage d'être plus pratique à utiliser
            // que NavigationPath, mais elle possèdent des inconvénients:
            //      - Il évalue prématurément la vue de destination, même
            //          lorsq'un objet ou un bouton n'est pas déclenché.
            //          -> Des chutes de performances peuvent arriver.
            //      - Ne fonctionne qu'avec une intéraction de l'utilisateur.
            //          Cela signifie que l'on ne peut pas l'utiliser après
            //          avoir chargé des données, gérer des deep links où
            //          des notifications Push.
            //          -> Pas de navigation asynchrone ou de control via
            //              programmation.
            //
            NavigationLink {
                TitleDetailView(title: title)

            } label: {
                AsyncImage(url: URL(string: title.posterPath ?? "")) { image in
                    HStack {
                        image
                            .resizable()
                            .scaledToFit()
                            .clipShape(.rect(cornerRadius: 10))
                            .padding(5)

                        // Même logique que dans TitleDetailView
                        //
                        // Pour que le résultat reste uniforme,
                        // le texte est dans ma même portée que l'image.
                        Text((title.name ?? title.title) ?? "")
                            .font(.system(size: 15))
                            .bold()
                    }
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 150)
            }
            // Permet à l'utilisateur de glisser de la droite vers la gauche
            // pour supprimer un titre enregistré
            .swipeActions(edge: .trailing) {
                // on affiche le bouton seulement si
                // l'utilisateur "vient" depuis DownloadView
                if canDelete {
                    Button {
                        modelContext.delete(title)
                        try? modelContext.save()
                    } label: {
                        Image(systemName: "trash")
                            .tint(.red)
                    }
                }
            }

        }
    }
}

#Preview {
    VerticalListView(titles: Title.previewTitles, canDelete: true)
}
