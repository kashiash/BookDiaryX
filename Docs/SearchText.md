### Wyszukiwanie danych `SearchText`



Postępy w naszej aplikacji są obecnie bardzo obiecujące, ale brakuje nam kluczowej funkcji, a mianowicie możliwości wyszukiwania książek na naszej liście czytelniczej. Ta konkretna funkcja jest istotna z kilku powodów:

Wygoda dla użytkownika: Możliwość wyszukiwania książek na liście czytelniczej to kluczowy element wygody dla użytkownika. W miarę jak lista czytelnicza rośnie, użytkownicy mogą mieć coraz większe trudności z ręcznym znalezieniem konkretnej książki, zwłaszcza jeśli lista jest długa. Funkcja wyszukiwania upraszcza ten proces, pozwalając użytkownikom szybko odnaleźć poszukiwaną książkę.

Efektywność: Bez funkcji wyszukiwania użytkownicy mogą być zmuszeni przewijać całą listę czytelniczą, aby znaleźć książkę. To może być czasochłonne i frustrujące, zwłaszcza gdy lista jest długa. Funkcja wyszukiwania znacznie poprawia efektywność aplikacji, oszczędzając użytkownikom czas i wysiłek.

Udoskonalone doświadczenie użytkownika: Funkcja wyszukiwania stanowi fundamentalny element usprawnienia ogólnego doświadczenia użytkownika. Użytkownicy są bardziej skłonni korzystać z aplikacji, która oferuje im funkcje ułatwiające codzienne życie i sprawiające, że korzystanie z aplikacji jest przyjemniejsze.

Okej, więc zaczniemy od dodania funkcji wyszukiwania do naszej listy książek (`BookListView`). Na początek utworzymy właściwość stanu (`@State`), która będzie wiązać tekst wyszukiwania z polem wyszukiwania.

```swift
import SwiftUI
import SwiftData

struct BookListView: View {
    ...
    
    @State private var searchTerm: String = ""
```

Następnie stworzymy nową właściwość obliczeniową o nazwie "filteredBooks". Ta właściwość będzie zawierać kolekcję książek na podstawie podanego terminu wyszukiwania. Gdy termin wyszukiwania jest pusty, właściwość ta zwróci wszystkie pobrane książki. Natomiast gdy termin wyszukiwania jest określony, przeprowadzi wyszukiwanie, porównując tytuły książek i zwróci odpowiednie pozycje.

```swift
import SwiftUI
import SwiftData

struct BookListView: View {
    ...
    
    @State private var searchTerm: String = ""
    var filteredBooks: [Book] {
        guard searchTerm.isEmpty == false else { return books }
        return books.filter { $0.title.localizedCaseInsensitiveContains(searchTerm) }
    }
```

Do pola wyszukiwania skorzystamy z modyfikatora `searchable`. Modyfikator `searchable` dodaje interfejs wyszukiwania do twojej aplikacji, stosując jeden z modyfikatorów widoku do wyszukiwania, takich jak `searchable(text:placement:prompt:)`, do `NavigationSplitView` lub `NavigationStack`, lub do widoku wewnątrz jednego z tych widoków. Wtedy pole wyszukiwania pojawi się w pasku narzędzi.

Oto jak możemy użyć modyfikatora `searchable`:

```swift
import SwiftUI
import SwiftData

struct BookListView: View {
    ...
    
    @State private var searchTerm: String = ""
    
    var body: some View {
        NavigationView {
            List(filteredBooks, id: \.id) { book in
                // Wyświetlanie pojedynczej książki na liście
            }
            .searchable(text: $searchTerm, placement: .navigationBarDrawer(displayMode: .always), prompt: "Wyszukaj książki")
            .navigationTitle("Lista Książek")
        }
    }
}
```

W powyższym kodzie `searchable` jest stosowany do naszej listy `filteredBooks` wraz z wiązaniem tekstu do zmiennej stanu `searchTerm`. Wyszukiwarka pojawi się jako pole tekstowe w pasku nawigacyjnym, umożliwiając użytkownikowi szybkie i łatwe wyszukiwanie książek na podstawie ich tytułów. Pamiętaj, że możesz dostosować umiejscowienie i komunikat pomocniczy według własnych preferencji.

```swift
import SwiftUI
import SwiftData

struct BookListView: View {
    ...
    
    var body: some View {
        NavigationStack {
            List {
              ForEach(filteredBooks) { book in
               ...
            }
            .searchable(text: $searchTerm, prompt: "Search book title")

```

