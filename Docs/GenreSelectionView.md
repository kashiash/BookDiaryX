## GenreSelectionView

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

