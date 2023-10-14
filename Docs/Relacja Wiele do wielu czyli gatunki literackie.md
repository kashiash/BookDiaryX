

## Relacja Wiele do wielu czyli gatunki literackie

Książki są kategoryzowane według gatunków literackich, dlatego byłoby logiczne, aby nasz dziennik książek zawierał klasyfikację gatunkową, która pomoże nam śledzić liczbę przeczytanych książek fabularnych i literatury faktu.

Ponieważ jeden gatunek może mieć wiele książek, a z drugiej strony, jedna książka może być powiązana z wieloma gatunkami literackimi, ta sytuacja oferuje doskonałą okazję do przetestowania, jak SwiftData zarządza relacją wiele do wielu (N:N).

Zaczniemy od dodania nowego modelu do naszego projektu.

```swift
import Foundation
import SwiftData

@Model
final class Genre {
    var name: String
    var books = [Book]()
    
    init(name: String) {
        self.name = name
    }
}
```

Zaktualizujemy także model książki, aby uwzględnić relację między modelami Genre a Book.

Relacja między Book a Genre będzie używać reguły usuwania typu "nullify", co oznacza zerowanie relacji powiązanego modelu do usuniętego modelu. Definiując tę regułę usuwania, zapewniamy, że po usunięciu książki, kategoria gatunku nie zostanie usunięta.

```swift
import Foundation
import SwiftData

@Model
final class Book {
    ...
    
    @Relationship(deleteRule: .nullify, inverse: \Genre.books)
    var genres = [Genre]()
    
    init(title: String, author: String, publishedYear: Int) {
     ...
    }
}
```

Teraz dodamy widok, który pokaże wszystkie gatunki. Użyjemy makra Query do pobrania przechowywanych rekordów dla modelu Genre.

```swift
import SwiftUI
import SwiftData

struct GenreListView: View {
    
    @Query(sort: \Genre.name) private var genres: [Genre]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(genres) { genre in
                    Text(genre.name)
                }
            }
            .navigationTitle("Gatunki Literackie")
        }
    }
}

#Podgląd {
    GenreListView()
}
```

Następnie dodamy ten widok do ContentView. Nasza aplikacja będzie wyświetlać książki i gatunki wewnątrz TabView.

```swift
import SwiftUI

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
                    Text("Gatunki")
                }
        }
    }
}

#Podgląd {
    ContentView()
}
```

Zbuduj i uruchom aplikację.



### Widok do dodawania nowych gatunków `AddNewGenre`

Następnie dodamy widok do tworzenia nowej kategorii gatunkowej. Ten widok będzie prezentowany jako dolny panel (bottom sheet) i będzie zawierać pojedyncze pole tekstowe (TextField), które pozwoli dodać nowy gatunek.

```swift
import SwiftUI
import SwiftData

struct AddNewGenre: View {
    @State private var name: String = ""
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Dodaj nowy gatunek", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .navigationTitle("Dodaj nowy gatunek")
                    .padding(.horizontal)
                
                HStack {
                    Button("Zapisz") {
                        let genre = Genre(name: name)
                        context.insert(genre)
                        do {
                            try context.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Anuluj") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                }
                
                Spacer()
            }
        }
    }
}

#Podgląd {
    AddNewGenre()
}
```

Teraz dodamy punkt uruchomienia dla widoku AddNewGenre. Uruchomimy ten widok z GenreListView, więc dodajmy nowy element paska narzędziowego (ToolBarItem).

```swift
import SwiftUI

struct GenreListView: View {
    @Query(sort: \Genre.name) private var genres: [Genre]
    @State private var isAddNewGenrePresented: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(genres) { genre in
                    Text(genre.name)
                }
            }
            .navigationTitle("Gatunki Literackie")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        presentAddNew.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .buttonStyle(.borderedProminent)
                    .sheet(isPresented: $presentAddNew, content: {
                        AddNewGenre()
                            .presentationDetents([.fraction(0.3)])
                            .interactiveDismissDisabled()
                    })
                }
            }
        }

    }
}

#Podgląd {
    GenreListView()
}
```

Teraz możemy dodać nowe gatunki, a widok AddNewGenre będzie wyświetlany jako dolny panel po naciśnięciu przycisku "Dodaj" na liście gatunków literackich.

### Usuwanie gatunków literackich

Skoro jesteśmy już w GenreListView, dodajmy funkcję usuwania do tego widoku.

Najpierw potrzebujemy dostępu do kontekstu modelu w GenreListView, aby móc wykonać operację usuwania.

```swift
@Environment(\.modelContext) private var context
```

Następnie dodajmy prywatną funkcję, która usunie gatunek z listy.

```swift
private func deleteGenre(atOffsets indexSet: IndexSet) {
    indexSet.forEach { index in
        let genreToDelete = genres[index]
        context.delete(genreToDelete)
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
```

Teraz wywołajmy tę funkcję przy użyciu modyfikatora `onDelete` na widoku `ForEach`.

```swift
List {
    ForEach(genres, id: \.self) { genre in
        Text(genre.name)
    }
    .onDelete(perform: deleteGenre)
}
```

Pamiętaj, że modyfikator `onDelete` przyjmuje domknięcie (closure) jako argument, które jest wywoływane, gdy użytkownik próbuje usunąć element z listy. W naszym przypadku wywołuje funkcję `deleteGenre`, która usuwa odpowiedni gatunek i zapisuje zmiany do kontekstu modelu.

Teraz możesz zbudować i uruchomić projekt, a użytkownicy będą mogli usuwać gatunki z listy.

Teraz, gdy mamy funkcjonalne widoki dla książek i gatunków, nadszedł czas, aby je ze sobą połączyć. Zacznijmy od stworzenia nowego widoku do renderowania kontrolek wyboru gatunku, co pozwoli nam dołączyć ten widok jako podwidok wewnątrz widoku AddNewBookView.

```swift
import SwiftUI
import SwiftData

struct GenreSelectionView: View {
```



Będziemy używać makra Query, aby pobrać wszystkie rekordy z gatunku.

```swift
import SwiftUI
import SwiftData

struct GenreSelectionView: View {
    @Query(sort: \Genre.name) private var genres: [Genre]
```

Musimy także utworzyć zmienną do przechowywania wszystkich wybranych wartości. Tę zmienną również oznaczymy atrybutem Binding, aby stworzyć dwukierunkowe połączenie między właściwością przechowującą dane. Ponieważ jedna książka może należeć do wielu gatunków jednocześnie, utworzymy selectedGenres jako zbiór typu Genre.

```swift
import SwiftUI
import SwiftData

struct GenreSelectionView: View {
    @Query(sort: \Genre.name) private var genres: [Genre]
    @Binding var selectedGenres: Set<Genre>
```

Wyświetlimy gatunki wewnątrz widoku List i obok nazwy gatunku umieścimy pole wyboru, aby pokazać wybór. Dodamy także funkcję onTapGesture, aby wybrać lub odznaczyć dany gatunek.

```swift
import SwiftUI
import SwiftData

struct GenreSelectionView: View {
    @Query(sort: \Genre.name) private var genres: [Genre]
    @Binding var selectedGenres: Set<Genre>
    
    var body: some View {
        List {
            Section("Gatunki Literackie") {
                ForEach(genres) { genre in
                    HStack {
                        Text(genre.name)
                        Spacer()
                        Image(systemName: selectedGenres.contains(genre) ? "checkmark.circle.fill" : "circle.dashed")
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if !selectedGenres.contains(genre) {
                            selectedGenres.insert(genre)
                        } else {
                            selectedGenres.remove(genre)
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}
```

Teraz dodajmy ten widok do AddNewBookView. Zacznijmy od dodania właściwości typu State, aby zapewnić dwukierunkowe powiązanie dla selectedGenres.

```swift
import SwiftUI
import SwiftData

struct AddNewBookView: View {
    ...
    
    @State private var selectedGenres = Set<Genre>()
    
    ...
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                ...
                
                GenreSelectionView(selectedGenres: $selectedGenres)
                
                HStack {
                   ...
                    }
                    .buttonStyle(.bordered)
                    .disabled(!isValid)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Add New Book")
        }
    }
}
```

Powyższy kod tworzy widok GenreSelectionView, który pozwala użytkownikowi wybrać różne gatunki literackie, a następnie dodaje ten widok jako podwidok w AddNewBookView. Widok AddNewBookView zawiera listę wybranych gatunków, które można następnie wykorzystać w logice dodawania nowej książki.





Następnie dodamy widok GenreSelectionView bezpośrednio powyżej przycisków anuluj i zapisz na widoku.

```swift
import SwiftUI
import SwiftData

struct AddNewBookView: View {
    ...
    
    @State private var wybraneGatunki = Set<Genre>()
    
    ...
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                ...
                
                GenreSelectionView(wybraneGatunki: $wybraneGatunki)
                
                HStack {
                   ...
                    }
                    .buttonStyle(.bordered)
                    .disabled(!isValid)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Dodaj Nową Książkę")
        }
    }
}
```

Chcemy również upewnić się, że zapisujemy wybrane gatunki wraz z książką i przypisujemy gatunek do książki, więc zaktualizujmy akcję przycisku „Zapisz”, aby uwzględnić to.

```swift
import SwiftUI
import SwiftData

struct AddNewBookView: View {
    ...
    
    @State private var selectedGenres = Set<Genre>()
    
    ...
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
               ...
                
                GenreSelectionView(selectedGenres: $selectedGenres)
                
                HStack {
                    
                   ...
                    Button("Zapisz") {
                        guard let publishedYear else { return }
                        let book = Book(title: title, author: author, 
                                  publishedYear: publishedYear)

                        book.genres = Array(selectedGenres)
                        selectedGenres.forEach { genre in
                            genre.books.append(book)
                            context.insert(genre)
                        }

                        context.insert(book)
                        
                        ...
                    }
                    ...
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Dodaj Nową Książkę")
        }
    }
}
```

Po zapisaniu gatunku, potrzebujemy sposobu na wyświetlenie go wraz z książką, więc przejdźmy do pracy nad tym.

Otwórzmy `BookDetailView` i dodajmy `HStack` pod szczegółami książki, aby pokazać powiązane z nią gatunki.

```swift
import SwiftUI

struct BookDetailView: View {
    ...
    var body: some View {
        Form {
            if isEditing {
                ...
            } else {
                Text(book.title)
                Text(book.author)
                Text(book.publishedYear.description)

                if !book.genres.isEmpty {
                    HStack {
                        ForEach(book.genres) { genre in
                            Text(genre.name)
                                .font(.caption)
                                .padding(.horizontal)
                                .background(Color.green.opacity(0.3), in: Capsule())
                        }
                    }
                }
            }
            ...
        }
    }
}
```

Po wprowadzeniu tych zmian możesz zbudować i uruchomić projekt.

Mamy możliwość dodawania gatunku do nowej książki, ale co z istniejącymi książkami, które zostały dodane przed tą zmianą? Cóż, dodajmy tę funkcję, aktualizując widok `BookDetailView`.

Zaczniemy od stworzenia właściwości stanu `selectedGenres`, która będzie przechowywać wybrane gatunki.

```swift
import SwiftUI

struct BookDetailView: View {
    ...
    
    @State private var selectedGenres = Set<Genre>()

    init(book: Book) {
        ...
        self._selectedGenres = State(initialValue: Set(book.genres))
    }
    
    var body: some View {
        Form {
            if isEditing {
                Group {
                    TextField("Book title", text: $title)
                    TextField("Book author", text: $author)
                    TextField("Published year", value: $publishedYear, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                    
                    GenreSelectionView(selectedGenres: $selectedGenres)
                        .frame(height: 300)
                }
                .textFieldStyle(.roundedBorder)
                Button("Save") {
                    guard let publishedYear = publishedYear else { return }
                    book.title = title
                    book.author = author
                    book.publishedYear = publishedYear
                    
                    book.genres = []
                    book.genres = Array(selectedGenres)
                    selectedGenres.forEach { genre in
                        if !genre.books.contains(where: { b in
                            b.title == book.title
                        }) {
                            genre.books.append(book)
                        }
                    }
                    ...
                }
            } else {
                Text(book.title)
                Text(book.author)
                Text(book.publishedYear.description)

                if !selectedGenres.isEmpty {
                    HStack {
                        ForEach(Array(selectedGenres), id: \.self) { genre in
                            Text(genre.name)
                                .font(.caption)
                                .padding(.horizontal)
                                .background(Color.green.opacity(0.3), in: Capsule())
                        }
                    }
                }
            }
            ...
        }
    }
}
```

W powyższym kodzie `init`, `selectedGenres` jest inicjowany jako zbiór gatunków przypisanych do książki. Następnie, w zależności od tego, czy edytujemy książkę, czy nie, wyświetlane są odpowiednie widoki. Jeśli edytujemy książkę, dodajemy `GenreSelectionView` do wyboru gatunków i aktualizujemy gatunki wybrane przez użytkownika w `selectedGenres`. Teraz użytkownik będzie mógł edytować gatunki przypisane do już istniejącej książki.



