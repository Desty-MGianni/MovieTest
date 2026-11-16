# MovieTest — SwiftUI & SwiftData iOS Application

Movie Test is my first iOS application ever following

It is a feature-rich iOS application built from scratch using **SwiftUI**, **SwiftData**, **Xcode** (iOS 18+) and **neovim**. The app enables users to browse trending and top-rated movies and TV shows, search titles dynamically, stream official YouTube trailers, and save titles locally for offline viewing.

This project was developed following the course _"SwiftUI Course for Beginners – Create an iOS App from Scratch"_ by Carlos (Blossom Build), published on freeCodeCamp.org.

- [Link to the YouTube course](https://www.youtube.com/watch?v=-VC3hIEL7eQ).
- [Link to the original code Repo](https://github.com/BlossomBuild/BlossomMovie/tree/main)

---

## Key Features

- **Embedded YouTube Trailer Player**: Custom `WKWebView` integration via `UIViewRepresentable` (`YouTubePlayer`) that dynamically plays YouTube trailers fetched through the YouTube Data API v3.
- **Detailed Title View**: A comprehensive detail screen (`TitleDetailView`) presenting title posters, names, plot overviews, trailer playback, and action buttons for downloading content.
- **SwiftData Offline Storage**: Persistent offline data management utilizing `@Model`, `@Query`, `@Attribute(.unique)` to eliminate duplicate downloads, and `modelContext` operations for inserting and deleting entries.

---

## Tech Stack & Frameworks

| Technology / Framework            | Purpose in Project                                                                               |
| :-------------------------------- | :----------------------------------------------------------------------------------------------- |
| **Swift & SwiftUI**               | Declarative UI framework and core programming language (iOS 18 / Xcode).                         |
| **SwiftData**                     | Modern Apple framework for offline data persistence, schema modeling, and query management.      |
| **WebKit (`WKWebView`)**          | UI Kit integration (`UIViewRepresentable`) to embed and play YouTube video trailers natively.    |
| **URLSession & Async/Await**      | Asynchronous network requests, concurrency management, and parallel API execution (`async let`). |
| **JSONDecoder & Swift Generics**  | Reusable decoding pipeline converting API responses into strongly typed Swift data structures.   |
| **The Movie Database (TMDB) API** | Data provider for trending, top-rated, upcoming, and search endpoints for movies and TV shows.   |
| **YouTube Data API v3**           | Data provider for querying video IDs for official movie and TV show trailers.                    |

---

## Architecture & Engineering Patterns

### 1. Model-View-ViewModel (MVVM)

The project strictly separates presentation logic from network services and data models:

- **Models**: `Title` (`@Model` class conforming to `Decodable`, `Identifiable`, `Hashable`), `TMDBAPIObject`, and `YouTubeSearchResponse`.
- **View Models**: `@Observable` classes (`ViewModel`, `SearchViewModel`) that track fetch statuses (`FetchStatus`: `.notStarted`, `.fetching`, `.success`, `.failed`) and automatically trigger UI updates.
- **Views**: Declarative SwiftUI views (`HomeView`, `UpcomingView`, `SearchView`, `DownloadView`, `TitleDetailView`, `HorizontalListView`, `VerticalListView`).

### 2. Swift Generics & Parallel Async Fetching

- **Generic Decoder**: `fetchAndDecode<T: Decodable>(url:type:)` centralizes JSON decoding and network response validation (handling HTTP status codes, snake_case key conversions, and custom error mapping).
- **Parallel Requests**: `async let` executes multiple endpoint requests (Trending Movies, Trending TV, Top Rated Movies, Top Rated TV) concurrently rather than sequentially, optimizing application launch speed.

### 3. API Credentials & Singleton Configuration

- **`APIConfig` Singleton**: Loads base URLs and API keys at runtime from an external `APIConfig.json` bundle file using `Bundle.main.url(forResource:withExtension:)`.
- **Error Handling**: Dedicated error enumerations (`APIConfigError`, `NetworkError`) conforming to `Error` and `LocalizedError` provide graceful error recovery without app crashes.

### 4. Custom Styling & DRY Principles

- **Reusable Modifiers**: Custom extensions on `Text` (such as `.ghostButton()` and `.errorMessage()`) eliminate code duplication across view components.
- **Asset Catalog Color Sets**: Custom dark/light mode compatible colors (`ButtonBorder`, `ButtonText`, `Gradients`) defined in `Assets.xcassets`.

---

## Project Structure

```text
MovieTest/
├── App/
│   └── MovieTestApp.swift       # Main App Entry Point & SwiftData Model Container Setup
├── Config/
│   ├── APIConfig.json              # Bundled JSON file holding API credentials & URLs
│   ├── APIConfig.swift             # Decodable singleton parser for API configuration
│   └── Errors.swift                # APIConfigError and NetworkError enum definitions
├── Models/
│   ├── Title.swift                 # SwiftData @Model class for Movie and TV Show titles
│   └── YouTubeSearchResponse.swift # Codable structs for YouTube API video response parsing
├── Network/
│   └── DataFetcher.swift           # Centralized network service (URL construction, generic decoding)
├── ViewModels/
│   ├── ViewModel.swift             # Main view model handling Home & Upcoming screen states
│   └── SearchViewModel.swift       # Dedicated view model handling search & debouncing
├── Views/
│   ├── HomeView.swift              # Main home screen with hero title & horizontal sections
│   ├── UpcomingView.swift          # Vertical list view for upcoming movies
│   ├── SearchView.swift            # 3-column grid search view with movie/TV toggle & search bar
│   ├── DownloadView.swift          # Local downloads list powered by SwiftData @Query
│   ├── TitleDetailView.swift       # Detail screen with YouTube trailer player & save action
│   └── ContentView.swift           # Tab bar containing Home, Upcoming, Search and Downloads
├── Components/
│   ├── HorizontalListView.swift    # Horizontal scrolling poster component
│   ├── VerticalListView.swift      # Vertical poster and title row component
│   └── YouTubePlayer.swift         # UIViewRepresentable wrapper for WKWebView
└── Extensions/
    └── Constants.swift             # Centralized UI string constants, symbol names, and Text extensions
```

---

## Configuration & Setup

### Prerequisites

- Mac running macOS 14+ or macOS 15+
- **Xcode 16+** with iOS 18 SDK installed
- Accounts for The Movie Database (TMDB) and Google Developer Console

### API Credentials Setup

1. Open the Xcode project directory.
2. Create the `APIConfig.json` file inside the `Config/` directory.
3. Configure your API base URLs and API keys inside the JSON bundle resource:

```json
{
  "tmdbBaseURL": "<TMDB_BASE_URL>",
  "tmdbAPIKey": "<YOUR_TMDB_API_KEY>",
  "youtubeBaseURL": "<YOUTUBE_EMBED_BASE_URL>",
  "youtubeAPIKey": "<YOUR_YOUTUBE_API_KEY>",
  "youtubeSearchURL": "<YOUTUBE_SEARCH_API_URL>"
}
```

> **Note**: Storing API keys in `APIConfig.json` decouples credentials from source files. Ensure this JSON file is added to your target bundle resources.

---

## Application Navigation Flow

```text
[ TabView ]
   ├── Home Tab --------> Hero Poster / Horizontal Lists ---> TitleDetailView ---> YouTube Trailer / Download
   ├── Upcoming Tab ----> Vertical Movies List ------------> TitleDetailView ---> YouTube Trailer / Download
   ├── Search Tab ------> Grid Layout (Movie / TV Toggle) --> TitleDetailView ---> YouTube Trailer / Download
   └── Download Tab ----> SwiftData Saved Titles ----------> TitleDetailView ---> Swipe-to-Delete
```

---

## Acknowledgments

- **Course Instructor**: Carlos from Blossom Build
- **Platform**: freeCodeCamp.org
- **Original Inspiration**: Omer (UI Kit implementation)
