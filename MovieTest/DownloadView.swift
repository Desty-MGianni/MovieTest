//
//  TitleDetailView.swift
//  MovieTest
//
//  Created by Gianni Mucci on 16/11/2026.
//

import SwiftData
import SwiftUI

struct DownloadView: View {
    // Cette macros indique à Swift de récupérer touts les titres
    // enregistrés et de les triés par titre (alphabétique)
    //
    // Mets aussi la liste à jour automatiquement
    // quand la base de donnée est modifiée.
    @Query(sort: \Title.title) var savedTitles: [Title]

    var body: some View {
        NavigationStack {
            if savedTitles.isEmpty {
                Text("No Downloads")
                    .padding()
                    .font(.title3)
                    .bold()
            } else {
                // On réutilise notre vue de liste verticale
                // pour afficher les titres enregistrées.
                VerticalListView(titles: savedTitles, canDelete: true)
            }
        }
    }
}

#Preview {
}
