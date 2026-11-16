//
//  YouTubeSearchResponse.swift
//  MovieTest
//
//  Created by Gianni Mucci on 14/11/2026.
//
import Foundation

// Chaque élément des structs et optionnels
// au cas ou il n'y a pas de réponse de google.
// Le nom des structs est modifiable.
//
// IL FAUT ABSOLUMENT QUE LES
// NOMS DES CHAMPS CORRESPONDENT À LA DONNÉE
// RENVOYÉ PAR LE JSON DE L'API

/*
    pour cette requête dans l'api google:
    https://www.googleapis.com/youtube/v3/search?q=Havoc%20trailer&key=YOUR_KEY

    La réponse est la suivante :
    {
      "kind": "youtube#searchListResponse",
      "etag": "tFx7oWrOUDpxlMSYXhHzOcXa4So",
      "nextPageToken": "CAUQAA",
      "regionCode": "BE",
      "pageInfo": {
        "totalResults": 1000000,
        "resultsPerPage": 5
      },
      "items": [
        {
          "kind": "youtube#searchResult",
          "etag": "jmwKzd8bjgsFLtyd2sFHBes7E7w",
          "id": {
            "kind": "youtube#video",
            "videoId": "6txjTWLoSc8"
          }
        },
        {
          "kind": "youtube#searchResult",
          "etag": "cWRKwr5qwDWYmAiH_oSmoyflv7A",
          "id": {
            "kind": "youtube#video",
            "videoId": "uf5UcDDASIM"
          }
        },
        {
          "kind": "youtube#searchResult",
          "etag": "elk_jKGNpgRYVSpM-Od_9-wLhQM",
          "id": {
            "kind": "youtube#video",
            "videoId": "HAQfDRvrU0s"
          }
        },
        {
          "kind": "youtube#searchResult",
          "etag": "kOdkAtzycY6NUYK4_wmk8vhvOcY",
          "id": {
            "kind": "youtube#video",
            "videoId": "R05icJEHOnM"
          }
        },
        {
          "kind": "youtube#searchResult",
          "etag": "T-iZJHNPKKBW5xV5ugJBPC0x_Hg",
          "id": {
            "kind": "youtube#video",
            "videoId": "1E4dLMAKmdo"
          }
        }
      ]
    }
*/

struct YouTubeSearchResponse: Codable {
    let items: [ItemProperties]?
}

struct ItemProperties: Codable {
    let id: IdProperties?
}

struct IdProperties: Codable {
    let videoId: String?
}
