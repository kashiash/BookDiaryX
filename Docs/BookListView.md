## Lista książek BookListView

Jak dotąd udało nam się dodać książki do bazy danych przy użyciu SwiftData. Kontynuujmy budowę naszej aplikacji i dodajmy możliwość pobierania zapisanych książek z przechowywanej bazy danych. Zacznijmy od stworzenia widoku do wyświetlania listy książek.

```swift
import SwiftUI
import SwiftData

struct BookListView: View {
    @Query private var books: [Book]

    var body: some View {
        NavigationView {
            List {
                ForEach(books) { book in
                    Text(book.title)
                }
            }
            .navigationBarTitle("Lista Książek")
        }
    }
}
```

Następnie zaktualizuj plik zawartości (przykładowo plik `ContentView.swift`), aby zawierał nowo utworzony widok `BookListView`.

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        BookListView() // Dodajemy widok BookListView jako treść głównego widoku.
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
```

W powyższym kodzie mamy widok `BookListView`, który używa `@Query`, aby pobrać listę książek z bazy danych i wyświetlić je w formie listy. Następnie w widoku `ContentView`, który jest głównym widokiem naszej aplikacji, dodajemy `BookListView` jako jego treść. Teraz `BookListView` będzie wyświetlane jako część aplikacji.





```swift
import SwiftUI

struct ContentView: View {
    @State private var presentAddNew = false
    var body: some View {
        VStack {
            BookListView()
            
            Button("Add new book") {
                presentAddNew.toggle()
            }
            .sheet(isPresented: $presentAddNew, content: {
                AddNewBookView()
            })
        }
    }
}

#Preview {
    ContentView()
}
```



Nasza lista książek wyświetla tylko nazwę książki, ale nie wyświetla innych informacji, więc ulepszmy komórkę listy, aby wyświetlać więcej informacji.
Stworzymy nowy widok o nazwie BookCellView, aby wyświetlać informacje o książce.

```swift
import SwiftUI

struct BookCellView: View {
    let book: Book
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(book.title)
                .bold()
            HStack {
                Text("Autor: \(book.author)")
                Spacer()
                Text("Opublikowano: \(book.publishedYear.description)")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .padding(.top, 20)
        }
    }
}
```

Zaktualizujmy teraz widok `BookListView`, aby uwzględniał ten nowo utworzony widok.

```swift
struct BookListView: View {
    @Query private var books: [Book]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(books) { book in
                    BookCellView(book: book)
                }
            }
            .navigationTitle("Dziennik Czytania")
        }
    }
}
```

Teraz lista książek będzie wyświetlać więcej informacji o każdej książce dzięki widokowi `BookCellView`.



Teraz mamy aplikację, która może trwale przechowywać dane za pomocą **SwiftData**, a także możemy przeglądać wszystkie zapisane rekordy między uruchomieniami aplikacji, więc teraz zbudujemy funkcjonalność usuwania rekordów, abyśmy mogli usunąć rekord ze magazynu danych.

Zacznijmy od przekazania do widoku kontekstu modelu za pomocą obiektu **Environment**, dzięki czemu będziemy mogli pracować nad kontekstem, aby usunąć rekord i zapisać zmiany z powrotem w trwałym sklepie.

```swift
import SwiftUI
import SwiftData

struct BookListView: View {
    @Environment(\.modelContext) private var context
    
    @Query private var books: [Book]
```

Najpierw dodamy prywatną funkcję do widoku, która będzie wykonywać operację usuwania.

```swift
private func delete(indexSet: IndexSet) {
    indexSet.forEach { index in
        let book = books[index]
        context.delete(book)
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
```

Teraz przekażmy tę funkcję jako parametr do modyfikatora **onDelete** dla widoku **ForEach**.

```swift
import SwiftUI
import SwiftData

struct BookListView: View {
    @Environment(\.modelContext) private var context
    
    @Query private var books: [Book]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(books) { book in
                    BookCellView(book: book)
                }
                .onDelete(perform: delete(indexSet:))
            }
            .navigationTitle("Dziennik Czytania")
        }
    }
    
    private func delete(indexSet: IndexSet) {
        indexSet.forEach { index in
            let book = books[index]
            context.delete(book)
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Podgląd {
    BookListView()
        .modelContainer(for: [Book.self])
}

```

Zbuduj i uruchom aplikację na symulatorze, aby dodać nowy rekord do naszego dziennika czytania. Teraz możemy przeciągnąć, aby usunąć rekord z listy.