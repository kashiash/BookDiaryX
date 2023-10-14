## Aktualizacja danych BookDetailView

Dodajmy funkcjonalność aktualizacji do naszej aplikacji do rejestrowania przeczytanych książek. Rozpoczniemy od stworzenia nowego widoku SwiftUI o nazwie `BookDetailView`, który pozwoli nam zobaczyć szczegóły wybranej książki oraz umożliwi aktualizację tych szczegółów, jeśli będzie to konieczne.

```swift
import SwiftUI

struct BookDetailView: View {
    let book: Book
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var isEditing = false
    @State private var title: String = ""
    @State private var author: String = ""
    @State private var publishedYear: Int? = nil
    
    init(book: Book) {
        self.book = book
        self._title = State(initialValue: book.title)
        self._author = State(initialValue: book.author)
        self._publishedYear = State(initialValue: book.publishedYear)
    }
    
    var body: some View {
        NavigationView {
            Form {
                if isEditing {
                    Section(header: Text("Edit Book Details")) {
                        TextField("Title", text: $title)
                        TextField("Author", text: $author)
                        TextField("Published Year", value: $publishedYear, format: .number)
                    }
                } else {
                    Section(header: Text("Book Details")) {
                        Text("Title: \(book.title)")
                        Text("Author: \(book.author)")
                        Text("Published Year: \(book.publishedYear ?? 0)")
                    }
                }
            }
            .navigationTitle("Book Details")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isEditing.toggle()
                    }) {
                        Text(isEditing ? "Done" : "Edit")
                    }
                }
            }
        }
    }
}
```

W tym widoku `BookDetailView` mamy dostęp do właściwości `book`, która jest przekazywana podczas inicjalizacji widoku. Korzystamy również z `@Environment` do uzyskania dostępu do kontekstu modelu (`modelContext`) i do możliwości zamykania wyświetlanego widoku (`dismiss`).

Tworzymy kilka właściwości stanu (`@State`), w tym `isEditing`, który będzie wskazywał, czy widok jest w trybie edycji, oraz właściwości `title`, `author` i `publishedYear`, które będą przechowywać informacje o książce. Te wartości zostaną zainicjowane na podstawie przekazanego obiektu książki.

Następnie w ciele widoku `BookDetailView` dodajemy formularz (`Form`). Jeśli `isEditing` jest ustawione na `true`, wyświetlamy grupę pól tekstowych (`TextField`), w przeciwnym razie wyświetlamy informacje o książce w polach tekstowych (`Text`). Dodajemy także pasek narzędziowy (`toolbar`), który zawiera przycisk do przełączania stanu edycji widoku.

To pozwoli nam na wyświetlanie i aktualizację informacji o książce w naszej aplikacji.

```swift
struct BookDetailView: View {
    let book: Book
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var isEditing = false
    
    @State private var title: String = ""
    @State private var author: String = ""
    @State private var publishedYear: Int? = nil
    
    init(book: Book) {
        self.book = book
        self._title = State.init(initialValue: book.title)
        self._author = State.init(initialValue: book.author)
        self._publishedYear = State.init(initialValue: book.publishedYear)
    }
    
    var body: some View {
        Form {
            if isEditing {
                Group {
                    TextField("Book title", text: $title)
                    TextField("Book author", text: $author)
                    TextField("Published year", value: $publishedYear, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                }
                .textFieldStyle(.roundedBorder)
            } else {
                Text(book.title)
                Text(book.author)
                Text(book.publishedYear.description)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(isEditing ? "Done" : "Edit") {
                    isEditing.toggle()
                }
            }
        }
        .navigationTitle("Book detail")
    }
}
```





Dodajmy teraz funkcjonalność pozwalająca zapisywać dane do bazy:

```swift
struct BookDetailView: View {
    let book: Book
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var isEditing = false
    
    @State private var title: String = ""
    @State private var author: String = ""
    @State private var publishedYear: Int? = nil
    
    init(book: Book) {
        self.book = book
        self._title = State.init(initialValue: book.title)
        self._author = State.init(initialValue: book.author)
        self._publishedYear = State.init(initialValue: book.publishedYear)
    }
    
    var body: some View {
        Form {
            if isEditing {
                Group {
                    TextField("Book title", text: $title)
                    TextField("Book author", text: $author)
                    TextField("Published year", value: $publishedYear, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                }
                .textFieldStyle(.roundedBorder)
                Button("Save") {
                    guard let publishedYear = publishedYear else { return }
                    book.title = title
                    book.author = author
                    book.publishedYear = publishedYear
                    
                    do {
                        try context.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                    dismiss()
                }
            } else {
                Text(book.title)
                Text(book.author)
                Text(book.publishedYear.description)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(isEditing ? "Done" : "Edit") {
                    isEditing.toggle()
                }
            }
        }
        .navigationTitle("Book Detail")
    }
}
```



Będziemy uruchamiać widok szczegółów z widoku `BookCellView`, więc zaktualizujmy ten widok, aby zawierał widok `NavigationLink` i modyfikator `navigationDestination`. Oto, jak możemy to zrobić:

```swift
import SwiftUI

struct BookCellView: View {
    let book: Book
    
    var body: some View {
        NavigationLink(value: book) {
            VStack(alignment: .leading) {
                Text(book.title)
                    .bold()
                HStack {
                    Text("Author: \(book.author)")
                    Spacer()
                    Text("Published on: \(book.publishedYear.description)")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.top, 20)
            }
        }
        .navigationDestination(for: Book.self) { book in
            BookDetailView(book: book)
        }
    }
}
```

Teraz w widoku `BookCellView` mamy `NavigationLink`, który przenosi do widoku szczegółów (`BookDetailView`) po naciśnięciu komórki z informacjami o książce. Zastosowaliśmy także modyfikator `navigationDestination`, aby określić, do którego widoku ma prowadzić link i przekazać odpowiednią książkę jako wartość. Teraz, po zbudowaniu i uruchomieniu aplikacji, powinno działać przejście do widoku szczegółów po kliknięciu w komórkę z książką.





Nasz przycisk "Dodaj nową książkę" pojawia się także w widoku szczegółowym książki. Aby to naprawić, przenieśmy go do paska narzędziowego (`toolbar`) widoku nawigacyjnego na stronie listy książek. Oto, jak możemy to zrobić:

```swift
struct BookListView: View {
    @Environment(\.modelContext) private var context
    @Query private var books: [Book]
    @State private var presentAddNew = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(books) { book in
                    BookCellView(book: book)
                }
                .onDelete(perform: delete(indexSet:))
            }
            .navigationTitle("Reading Logs")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        presentAddNew.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .buttonStyle(.borderedProminent)
                    .sheet(isPresented: $presentAddNew, content: {
                        AddNewBookView()
                    })
                }
            }
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

#Preview {
    BookListView()
        .modelContainer(for: [Book.self])
}
```

