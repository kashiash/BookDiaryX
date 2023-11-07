Zmiany są nieuniknione, zobaczmy więc, jak SwiftData sobie z nimi radzi. Nasza aplikacja wygląda dobrze, ale brakuje jej okładek książek, więc dodajmy je.



## Zmiany w modelu

Zaczniemy od dodania nowej właściwości do modelu książki. Ponieważ mamy do czynienia z obrazami, będziemy je przechowywać jako dane binarne (`Data`).

```swift
import Foundation
import SwiftData

@Model
final class Book {
    var title: String
    var author: String
    var publishedYear: Int
    
    var cover: Data?
}
```

Ta właściwość jest oznaczona jako opcjonalna (`Optional`), ponieważ dodajemy nową cechę do istniejącej aplikacji, a wcześniej zapisane dane nie powinny być dotknięte tą zmianą, o ile nowa właściwość jest opcjonalna lub ma domyślną wartość.



Obrazy są duże, i nie jest dobrym pomysłem przechowywać je bezpośrednio w bazie danych (ze względu na problemy z wydajnością). Możemy zdecydować się na przechowywanie jedynie odwołania do obrazu, a rzeczywiste dane obrazu mogą być umieszczone gdzieś indziej na dysku. Nie musimy tego robić ręcznie, możemy skorzystać z makra `Attribute` w SwiftData i zdefiniować konfigurację schematu, aby przechowywać binarne dane obrazu na zewnątrz.

Zaktualizujmy nasz model, aby uwzględnić makro `Attribute`:

```swift
import Foundation
import SwiftData

@Model
final class Book {
    ...
    
    @Attribute(.externalStorage)
    var cover: Data?
}
```

Po tej zmianie jesteśmy gotowi do przechowywania okładek książek.

Zaktualizujmy widok `AddNewBookView`, aby umożliwić użytkownikom wybór okładek książek z ich biblioteki zdjęć. Najpierw zaimportuj moduł `PhotosUI`. Następnie dodajmy dwie nowe właściwości stanu (`@State`): jedną do powiązania z wyborem zdjęcia (`selectedCover`) i drugą do przechowywania danych wybranego obrazu (`selectedCoverData`).

```swift
import SwiftUI
import SwiftData
import PhotosUI

struct AddNewBookView: View {
    @State private var selectedCover: PhotosPickerItem?
    @State private var selectedCoverData: Data?
    
    var body: some View {
        // Tutaj umieść kod UI dla wybierania zdjęć
    }
}
```

## Wybór zdjęc w `AddNewBookView`

Teraz możemy przejść do dodania interfejsu użytkownika, który umożliwi wybór zdjęć.

```swift
import SwiftUI
import SwiftData
import PhotosUI

struct AddNewBookView: View {
    ...
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Book title:")
                ...
                
                HStack {
                    PhotosPicker(
                        selection: $selectedCover,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        Label("Add Cover", systemImage: "book.closed")
                    }
                    .padding(.vertical)
                    
                    Spacer()
                    
                    if let selectedCoverData {

                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    }
                }
                
                Text("Published:")
...
```

Przed wyświetleniem wybranego obrazka, pobierzmy jego dane binarne i przypiszmy je do zmiennej `selectedCoverData`. Operacja ta jest asynchroniczna, więc użyjmy modyfikatora `task` do pobrania danych z wybranego zdjęcia.

```swift
struct AddNewBookView: View {
    ...
            .navigationTitle("Add New Book")
            .task(id: selectedCover) {
                if let data = try? await selectedCover?.loadTransferable(type: Data.self) {
                    selectedCoverData = data
                }
            }
        }
    }
}
```

W powyższym kodzie używamy funkcji `loadTransferable` z `PhotosPickerItem` w modyfikatorze `task`. Ta funkcja pozwala nam na przekształcenie danych z wybranego obrazka na typ `Data`. Następnie używamy tego `Data`, aby utworzyć obiekt `UIImage`, który jest wyświetlany na ekranie. Pamiętaj, że ta operacja jest asynchroniczna, więc używamy modyfikatora `await` do oczekiwania na zakończenie operacji i pobranie danych z wybranego zdjęcia.

#### Wyświetlenie wybranego zdjęcia

Teraz jak mamy juz wybieranie zdjecia, to dodajmy kod ktory je wyswietli na widoku:

```swift
struct AddNewBookView: View {
    ...
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                ...
                
                HStack {
                    PhotosPicker(
                        selection: $selectedCover,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        Label("Add Cover", systemImage: "book.closed")
                    }
                    .padding(.vertical)
                    
                    Spacer()
                    
                    if let selectedCoverData, 
                        let image = UIImage(
                        data: selectedCoverData) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .clipShape(.rect(cornerRadius: 10))
                            .frame(width: 100, height: 100)
                            
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    }
                }
                ...
            .navigationTitle("Add New Book")
            .task(id: selectedCover) {
                if let data = try? await selectedCover?.loadTransferable(type: Data.self) {
                    selectedCoverData = data
                }
            }
        }
    }
}
```

Budujemy i uruchamiamy

#### Zapisywanie zdjecia do bazy/storage

Teraz dodajemy kod ktory zapisze nam wybrane zdjecie do kontekstu i dalej do bazy danych

```swift
                    Button("Save") {
                        guard let publishedYear else { return }
                        let book = Book(title:title, author: author, publishedYear: publishedYear)

                        book.genres = Array(selectedGenres)

                        if let selectedCoverData {
                            book.cover = selectedCoverData
                        }
                        
                        selectedGenres.forEach{ genre in
                            genre.books.append(book)
                            context.insert(genre)
                        }
                        context.insert(book)
                        do {
                            try context.save()
                        } catch {
                            print (error.localizedDescription)
                        }
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .disabled(!isValid)
```



### Wyświetlanie zdjecia okładki na liście książek

Nasza aplikacja rozwija się całkiem dobrze. Dodaliśmy funkcję zapisywania okładek książek, ale nadal musimy zaimplementować metodę weryfikującą, czy okładkę można pobrać z dysku. Skupmy się na dodaniu zapisanej okładki do widoku listy książek (`BookListView`) i wyświetleniu jej obok odpowiednich książek.
Ponieważ większość logiki związanej z wyświetlaniem należy do widoku komórki książki (`BookCellView`), zaktualizujemy go, aby zawierał pobrany obraz z magazynu trwałego.

```swift
struct BookCellView: View {
    let book: Book
    
    var body: some View {
        NavigationLink(destination: BookDetailView(book: book)) {
            HStack(alignment: .top) {
                if let cover = book.cover, let image = UIImage(data: cover) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .clipShape(Rectangle())
                        .cornerRadius(5)
                        .frame(height: 100)
                }
                VStack(alignment: .leading) {
                    Text(book.title)
                        .bold()
                    Group {
                        Text("Autor: \(book.author)")
                        Text("Opublikowano: \(book.publishedYear.description)")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
            }
        }
    }
}
```

Zbuduj i uruchom aplikację.

![2023-11-07_22-37-58 (1)](2023-11-07_22-37-58%20(1).gif)

### Wyświetlanie zdjęcia na oknie edycji książki `BookDetailView`

Okej, teraz dodamy okładkę książki do widoku `BookDetailView` w trybie przeglądania. Poniżej znajdziesz aktualizowany kod widoku, który obejmuje również okładkę książki.

```swift
import SwiftUI

struct BookDetailView: View {
    @State private var isEditing = false
    var book: Book
    
    init(book: Book) {
        self.book = book
    }
    
    var body: some View {
        Form {
            if isEditing {
                // Implement editing mode if needed
            } else {
                Section(header: Text("Book Details")) {
                    Text("Title: \(book.title)")
                    Text("Author: \(book.author)")
                    Text("Published Year: \(book.publishedYear.description)")
                    if !book.genres.isEmpty {
                        Text("Genres: \(book.genres.joined(separator: ", "))")
                    }
                    if let cover = book.cover, let image = UIImage(data: cover) {
                        HStack {
                            Text("Book Cover")
                            Spacer()
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .clipShape(Rectangle())
                                .cornerRadius(5)
                                .frame(height: 100)
                        }
                    }
                }
            }
            
            // Add more sections as needed
            
        }
        .navigationBarTitle(Text(book.title), displayMode: .inline)
    }
}
```

W powyższym kodzie dodaliśmy sekcję `"Book Details"` do widoku `Form`, która zawiera informacje o książce, w tym okładkę, jeśli jest dostępna. Pamiętaj, że możesz dostosować ten widok według własnych potrzeb, dodając lub usuwając sekcje oraz modyfikując wygląd i układ elementów. Po wprowadzeniu tych zmian, zbuduj i uruchom aplikację, aby zobaczyć okładkę książki w widoku szczegółów książki.



### Obsługa dodawania obrazu do istniejącego wpisu książki w `BookDetailView`.

Zaczniemy od importu PhotosUI wraz z SwiftData.

```swift
import SwiftUI
import SwiftData
import PhotosUI

struct BookDetailView: View {
```
Dodajmy również właściwości stanu dla wyboru okładki książki, podobnie jak w widoku AddNewBookView.
```swift
import SwiftUI
import SwiftData
import PhotosUI

struct BookDetailView: View {
    ...
    
    @State private var selectedCover: PhotosPickerItem?
    @State private var selectedCoverData: Data?
```
Następnie dodamy HStack, aby pokazać picker zdjęć, dzięki któremu użytkownik może wybrać okładkę książki.

```swift
import SwiftUI
import SwiftData
import PhotosUI

struct BookDetailView: View {
    let book: Book
    
    ...
    
    var body: some View {
        Form {
            if isEditing {
                Group {
                    TextField("Book title", text: $title)
                    TextField("Book author", text: $author)
                    TextField("Published year", value: $publishedYear, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                    
                    HStack {
                        PhotosPicker(
                            selection: $selectedCover,
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
                            Label("Add Cover", systemImage: "book.closed")
                        }
                        .padding(.vertical)
                        
                        Spacer()
                        
                        if let selectedCoverData,
                            let image = UIImage(
                            data: selectedCoverData) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .clipShape(.rect(cornerRadius: 10))
                                .frame(width: 100, height: 100)
                                
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        }
                    }
                    
                    GenreSelectionView(selectedGenres: $selectedGenres)
                        .frame(height: 300)
...
```

Dodajmy blok zadania (`task`), aby przetworzyć element `photoPickerItem` do bloku danych, dzięki któremu będziemy mogli go przechować za pomocą SwiftData.

pod Form {...} podpinamy kod: 

```swift
        .task(id: selectedCover) {
            if let data = try? await selectedCover?.loadTransferable(type: Data.self) {
                selectedCoverData = data
            }
        }
```

całośc powinna wyglądac mniej wiecej tak:

```swift
import SwiftUI
import SwiftData
import PhotosUI

struct BookDetailView: View {
    @State private var isEditing = false
    @State private var selectedCover: PhotosPickerItem?
    @State private var selectedCoverData: Data?
    var book: Book
    
    init(book: Book) {
        self.book = book
    }
    
    var body: some View {
        Form {
            Section(header: Text("Szczegóły książki")) {
                Text("Tytuł: \(book.title)")
                Text("Autor: \(book.author)")
                Text("Rok wydania: \(book.publishedYear.description)")
                if !book.genres.isEmpty {
                    Text("Gatunki: \(book.genres.joined(separator: ", "))")
                }
                
                HStack {
                    Text("Okładka książki")
                    Spacer()
                    if selectedCoverData != nil {
                        Image(uiImage: UIImage(data: selectedCoverData!)!)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Rectangle())
                            .cornerRadius(5)
                            .frame(height: 100)
                    } else if let cover = book.cover, let image = UIImage(data: cover) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Rectangle())
                            .cornerRadius(5)
                            .frame(height: 100)
                    }
                }
                
                Button(action: {
                    // Pokaż picker zdjęć, aby wybrać okładkę książki
                    PhotosPicker.showPicker { result in
                        switch result {
                        case .success(let selectedImage):
                            self.selectedCover = selectedImage
                            Task {
                                if let data = try? await selectedImage.loadTransferable(type: Data.self) {
                                    self.selectedCoverData = data
                                }
                            }
                        case .failure(let error):
                            print("Błąd podczas wybierania obrazu: \(error)")
                        }
                    }
                }) {
                    Text("Wybierz okładkę książki")
                        .foregroundColor(.blue)
                }
            }
        }
        .navigationBarTitle(Text("Szczegóły książki"), displayMode: .inline)
    }
}
```

Zaktualizujmy akcję zapisywania (`save action`), aby uwzględnić okładkę książki. Oto jak możesz zrobić to w kodzie:

```swift
Button("Zapisz") {
    // Inne operacje zapisywania książki...
    
    if let selectedCoverData = selectedCoverData {
        book.cover = selectedCoverData
    }
    
    // Inne operacje zapisywania książki...
}
```

W powyższym kodzie, jeśli istnieją dane dla wybranej okładki (`selectedCoverData`), zostaną one przypisane do właściwości `cover` obiektu `book`. Następnie możesz kontynuować zapisywanie reszty danych książki. Po wprowadzeniu tej zmiany, możesz zbudować i uruchomić aplikację.



Aktualizujemy przepływ edycji, aby uwzględnić okładkę książki, jeśli już istnieje, a jeśli nie, to pokażemy domyślny obrazek systemowy.

```swift
import SwiftUI
import SwiftData
import PhotosUI

struct BookDetailView: View {
    // ...
    
    var body: some View {
        Form {
            if isEditing {
                Group {
                    TextField("Tytuł książki", text: $title)
                    TextField("Autor książki", text: $author)
                    TextField("Rok wydania", value: $publishedYear, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                    
                    HStack {
                        PhotosPicker(
                            selection: $selectedCover,
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
                            Label("Dodaj okładkę", systemImage: "book.closed")
                        }
                        .padding(.vertical)
                        
                        Spacer()
                        
                        if let selectedCoverData,
                            let image = UIImage(data: selectedCoverData) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .clipShape(Rectangle())
                                .cornerRadius(10)
                                .frame(width: 100, height: 100)
                                
                        } else if let cover = book.cover, let image = UIImage(data: cover) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .clipShape(Rectangle())
                                .cornerRadius(5)
                                .frame(height: 100)
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        }
                    }
                    
                    GenreSelectionView(selectedGenres: $selectedGenres)
                        .frame(height: 300)
                    
                    // Pozostała część widoku edycji...
                }
            } else {
                // Widok szczegółów w trybie przeglądania...
            }
        }
        // Pozostała część widoku...
    }
}
```

W powyższym kodzie, jeśli okładka została wybrana, zostanie wyświetlona jako obrazek. Jeśli okładka nie istnieje, ale obraz jest przechowywany w obiekcie `book.cover`, zostanie on również wyświetlony. Jeśli obie te opcje zawiodą, zostanie wyświetlony domyślny obrazek systemowy.



Ostatnia aktualizacja dotyczy zmiany etykiety w PhotoPicker w zależności od tego, czy książka już ma okładkę, czy nie. Oto jak możesz zaktualizować kod:

```swift
PhotosPicker(
    selection: $selectedCover,
    matching: .images,
    photoLibrary: .shared()
) {
    Label(book.cover == nil ? "Add Cover" : "Update Cover", systemImage: "book.closed")
}
.padding(.vertical)
```



SwiftData domyślnie używa SQLite do przechowywania danych, a nazwą domyślną pliku jest "default.store". Możemy sprawdzić lokalizację tego pliku danych, odpytując katalog `applicationSupportDirectory`. Oto jak możemy wydrukować lokalizację pliku danych w widoku `ContentView`:

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
           // Inne widoki w tablicy
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
```

Uruchomienie aplikacji teraz spowoduje wydrukowanie lokalizacji w konsoli, na przykład:

```
DataStore znajduje się pod adresem file:.../Library/Developer/CoreSimulator/Devices/<<path>>/default.store
```

Możemy użyć aplikacji takiej jak SQLiteBrowser (https://sqlitebrowser.org/), aby sprawdzić schemat i dane w pliku "default.store".
