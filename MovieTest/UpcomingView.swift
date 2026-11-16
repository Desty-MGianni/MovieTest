//
//  VerticalListView.swift
//  MovieTest
//
//  Created by Gianni Mucci on 15/11/2026.
//

import SwiftUI

struct UpcomingView: View {
    let viewModel = ViewModel()
    var body: some View {
        // Deuxième manière d'indiquer au programme ou se trouve
        // l'utilisateur dans l'arborescense interne:
        // NavigationLink avec NavigationStack
        //
        // NavigationLink est défini dans la vue enfant:
        // VerticalListView.
        //
        // GeometryReader est utilisé pour
        // affiché la ProgressView en plein milieu

        NavigationStack {
            GeometryReader { geo in
                switch viewModel.upcomingStatus {
                case .notStarted:
                    EmptyView()
                case .fetching:
                    ProgressView()
                        .frame(width: geo.size.width, height: geo.size.height)
                case .success:
                    VerticalListView(
                        titles: viewModel.upcomingMovies,
                        canDelete: false
                    )
                case .failed(let underlyingError):
                    Text(underlyingError.localizedDescription)
                        .errorMessage()
                        .frame(
                            width: geo.size.width,
                            height: geo.size.height)
                }
            }
            // Permet de récupérer les données lors du
            // chargement de la vue.
            .task {
                await viewModel.getUpcomingMovies()
            }
        }
    }
}

#Preview {
    UpcomingView()
}
