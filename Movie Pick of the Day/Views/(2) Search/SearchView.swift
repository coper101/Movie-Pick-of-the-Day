//
//  SearchView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 7/1/23.
//

import SwiftUI

enum SearchContent {
    case noInternet
    case noResults
    case searching
    case hasResults
    case none
}

struct SearchView: View {
    // MARK: - Props
    @EnvironmentObject private var appViewModel: AppViewModel
    @Environment(\.dimensions) var dimensions: Dimensions
    
    @State private var searchText: String = ""
    
    let searchBarHeight: CGFloat = 79
    
    private var searchContent: Binding<SearchContent> {
        .init(
            get: {
                if !appViewModel.hasInternetConnection {
                    return .noInternet
                } else if appViewModel.isSearching {
                    return .searching
                } else if
                    !appViewModel.isSearching &&
                    appViewModel.hasSearched &&
                    appViewModel.searchedMovies.isEmpty {
                    return .noResults
                } else if
                    !appViewModel.isSearching &&
                    !appViewModel.searchedMovies.isEmpty {
                    return .hasResults
                } else {
                    return .none
                }
            },
            set: { _ in}
        )
    }
    
    // MARK: - UI
    var body: some View {
        ZStack(alignment: .top) {
            
            // MARK: Layer 1 - Top Bar
            StatusBarBackgroundView()
                .zIndex(2)
            
            TopBarView(title: "Search")
                .zIndex(1)
                .padding(.top, dimensions.insets.top)
            
            // MARK: Layer 2 - Results
            Group {
                switch searchContent.wrappedValue {
                case .searching:
                    SearchingView()
                    
                case .hasResults:
                    ResultMoviesView(movies: appViewModel.searchedMovies)
                    
                case .noResults:
                    ResultNoneView()
                        .fillMaxSize(alignment: .center)
                        .opacity(0.5)
                        .padding(.top, 50)
                    
                case .noInternet:
                    ResultNoInternetConnectionView()
                        .fillMaxSize(alignment: .center)
                        .opacity(0.5)
                        .padding(.top, 50)
                    
                case .none:
                    EmptyView()
                }
            }
            .padding(.bottom, dimensions.insets.bottom + searchBarHeight + 63 + 28)
            .zIndex(0)
                
            // MARK: Layer 3 - Search
            VStack(spacing: 0) {
                
                Spacer()
                
                SearchBarView(
                    text: $searchText,
                    placeholder: "Search Movie",
                    onCommit: commitAction
                )
                .padding(.horizontal, 24)
                .padding(.bottom, dimensions.insets.bottom + searchBarHeight + 13)
                
            } //: VStack
            .zIndex(1)
            
        } //: ZStack
        .background(Colors.background.color)
        .ignoresSafeArea(.container, edges: .top)
    }
    
    // MARK: - Actions
    func commitAction() {
        withAnimation {
            appViewModel.didTapSearchOnCommitMovie(searchText) { hasError in
                if hasError {
                    self.searchText.removeAll()
                }
            }
        }
    }
}

// MARK: - Preview
struct SearchView_Previews: PreviewProvider {
    static var noResultsModel: AppViewModel {
        let model = TestData.appViewModel
        model.searchedMovies = []
        return model
    }
    
    static var noInternectConnectionModel: AppViewModel {
        let model = TestData.appViewModel
        model.hasInternetConnection = false
        return model
    }
    
    static var previews: some View {
        SearchView()
            .previewLayout(.sizeThatFits)
            .environmentObject(noResultsModel)
            .environmentObject(ImageCacheRepository())
            .previewDisplayName("No Results")
        
        SearchView()
            .previewLayout(.sizeThatFits)
            .environmentObject(noInternectConnectionModel)
            .environmentObject(ImageCacheRepository())
            .previewDisplayName("No Internet Connection")
        
        SearchView()
            .previewLayout(.sizeThatFits)
            .environmentObject(TestData.appViewModel)
            .environmentObject(ImageCacheRepository())
            .previewDisplayName("Results")
    }
}
