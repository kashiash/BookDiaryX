//
//  ContentView.swift
//  BookDiary
//
//  Created by Jacek Kosinski U on 20/09/2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var presentAddNew = false
    var body: some View {
        VStack{
            BookListView()
            .sheet(isPresented: $presentAddNew, content: {
                AddNewBookView()
            })
        }

    }

}

#Preview {
    ContentView()
}
