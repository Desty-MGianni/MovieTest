//
//  TitleDetailView.swift
//  MovieTest
//
//  Created by Gianni Mucci on 14/11/2026.
//

import SwiftData
import SwiftUI

// Vue pour quand on clique sur un poster
struct TitleDetailView: View {
    // Cette macros permet d'avoir accès à l'action dismiss de
    // la vue actuelle (permettant de revenir en arrière).
    @Environment(\.dismiss) var dismiss
    let title: Title

    // Propriété calculée
    // L'API TMDB utilise name pour les films
    // et title pour les sériestitle
    var titleName: String {
        // Retourne name.
        // si name est null, retourne title
        // si title est null, alors retourne une chaîne vide.
        return (title.name ?? title.title) ?? ""
    }
    // Permet de sauegarder des titre (SwiftData)
    @Environment(\.modelContext) var modelContext

    // Utilisation du pattern MVVM pour
    // afficher la vidéo youtube (trailer)
    let viewModel = ViewModel()
    var body: some View {
        GeometryReader { geo in
            switch viewModel.videoIdStatus {
            case .notStarted:
                EmptyView()
            case .fetching:
                ProgressView()
                    .frame(width: geo.size.width, height: geo.size.height)
            case .success:
                // Ici, ScrollView est utilisé pour
                // les longues descriptions.
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        YouTubePlayer(videoId: viewModel.videoId)
                            // Garde les bonnes proportions.
                            .aspectRatio(1.3, contentMode: .fit)
                        Text(titleName)
                            .bold()
                            .font(.title2)
                            .padding(5)

                        Text(title.overview ?? "")
                            .padding(5)
                        HStack {
                            Spacer()
                            Button {
                                // en mettant titleName et title,
                                // on s'assure que la donnée title est
                                // à un seul endroit, évitant un bordel
                                // dans la base de donnée
                                // (plusieurs fois le même titre)
                                let saveTitle = title
                                saveTitle.title = titleName
                                modelContext.insert(saveTitle)
                                try? modelContext.save()
                                // Une fois la sauvegarde faite,
                                // on retourne en arrière.
                                dismiss()
                            } label: {
                                Text(Constants.downloadString)
                                    .ghostButton()
                            }
                            Spacer()
                        }
                    }
                }
            case .failed(let underlyingError):
                Text(underlyingError.localizedDescription)
                    .errorMessage()
                    .frame(
                        width: geo.size.width,
                        height: geo.size.height)
            }
        }
        // On appelle la logique contenue dans ViewModel
        .task {
            await viewModel.getVideoId(for: titleName)

        }
    }
}

#Preview {
    TitleDetailView(title: Title.previewTitles[0])
}
