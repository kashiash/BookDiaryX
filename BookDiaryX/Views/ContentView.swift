//
//  ContentView.swift
//  BookDiary
//
//  Created by Jacek Kosinski U on 20/09/2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    var body: some View {
        TabView {
            BookListView()
                .tabItem {
                    Image(systemName: "books.vertical.fill")
Text("Książki")
                }
            GenreListView()
                .tabItem {
                    Image(systemName: "gear.circle")
                }

        }

    }

}

#Preview {
    ContentView()
}
