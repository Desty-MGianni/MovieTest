//
//  HorizontalListView.swift
//  MovieTest
//
//  Created by Gianni Mucci on 14/11/2026.
//

import SwiftUI

struct HorizontalListView: View {
    let header : String
    var titles = [Constants.testTitleURL, Constants.testTitleURL2, Constants.testTitleURL3]
    
    var body: some View {
        // Alligne la pile sur un coté du téléphone.
        VStack(alignment: .leading){
            Text(header)
                .font(.title)
            // Vue permettant de scroll
            ScrollView(.horizontal){
                // Charge les éléments de la pile si nécessaire horizontailement
                LazyHStack{
                    // extrait la valeur et l'index dans la liste
                    ForEach(titles, id: \.self) {title in
                        // Comme dans HomeView
                        AsyncImage(url: URL(string: title)){image in
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                        }placeholder: {
                            ProgressView()
                        }
                        .frame(width: 120, height: 200)
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
    HorizontalListView(header: Constants.trendingMovieString)
}
