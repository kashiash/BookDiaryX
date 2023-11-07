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
        .onAppear {
            guard let urlApp = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).last else { return }

            let url = urlApp.appendingPathComponent("default.store")
            if FileManager.default.fileExists(atPath: url.path) {
                print("DataStore znajduje się pod adresem \(url.absoluteString)")
            }
        }

    }

}

#Preview {
    ContentView()
}
