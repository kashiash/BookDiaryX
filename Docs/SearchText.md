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

### Wyszkiwanie i filtrowanie w `GenreListView`

Makro `Query` odgrywa kluczową rolę w ekosystemie SwiftData, przede wszystkim pełniąc funkcję kamienia węgielnego w procesie pozyskiwania i przetwarzania danych. Dotychczas ograniczyliśmy się do podstawowych scenariuszy korzystania z tego makra do dostępu do książek z magazynu trwałego, ale nasze użycie było dotąd ograniczone. Zanurzmy się głębiej w możliwości makra `Query`.

Do zbadania makra `Query` użyjemy widoku `GenreListView`. Zauważ, że makro `Query`, które stosujemy dla gatunku (Genre), pobiera dane posortowane według nazwy.

```swift
@Query(sort: \Genre.name) private var genres: [Genre]
```

Jednak makro `Query` nie wymaga tego parametru i może działać także bez niego.
```swift
@Query private var genres: [Genre]
```

Skorzystajmy z pierwszej przeciążonej wersji, która przyjmuje jako parametr `FetchDescriptor`. `FetchDescriptor` to typ opisujący kryteria, porządek sortowania oraz wszelkie dodatkowe konfiguracje do użycia podczas operacji pobierania danych.
`FetchDescriptor` przyjmuje jako parametr predykat, który jest warunkiem logicznym używanym do testowania zestawu wartości wejściowych podczas wyszukiwania lub filtrowania.
W naszym przypadku będziemy filtrować gatunki za pomocą słowa kluczowego "fiction".
```swift
let fetchDescriptor = FetchDescriptor(predicate: "genre == 'fiction'")
```

W naszym przypadku będziemy filtrować gatunki za pomocą słowa kluczowego "fiction". Oto kod z uwzględnieniem tych instrukcji:

```swift
@Query(
    FetchDescriptor<Genre>(predicate: #Predicate {
        $0.name.localizedStandardContains(
            "fiction"
        )
    })
)
private var genres: [Genre]
```

Zbuduj i uruchom, aby zobaczyć widok `GenreListView` przefiltrowany za pomocą słowa kluczowego "fiction".

To tłumaczenie jest wykonywane na poziomie bazy danych, podobnie jak w przypadku wykonania zapytania SQL z warunkiem `WHERE CONTAINS`.

```swift
@Query(
    FetchDescriptor<Genre>(predicate: #Predicate {
        $0.name.localizedStandardContains(
            "fiction"
        )
    },
    animation: .bouncy)
)
```

Oprócz `FetchDescriptor`, makro `Query` może również przyjmować parametry `filter`, `sort`, `order` i `animation`. Teraz wypróbujemy je.

Rozpoczniemy od parametru `filter`, który posłuży do filtrowania wyników za pomocą predykatu.

```swift
@Query(filter: #Predicate<Genre> { $0.name.localizedStandardContains("sci") })
private var genres: [Genre]
```

Możemy sortować wyniki na poziomie zapytania do bazy danych, przekazując parametr `sort`, możemy również ustawić kolejność sortowania w przód/lub wstecz za pomocą parametru `order`.

```swift
@Query(sort: \Genre.name, order: .reverse)
private var genres: [Genre]
```

Możemy połączyć filtrowanie oraz sortowanie w jednym zapytaniu. Będziemy filtrować wyniki według słowa kluczowego "fic" i sortować gatunki według nazwy w odwrotnej kolejności.

```swift
@Query(filter: #Predicate<Genre> {
        $0.name.localizedStandardContains("fic")},
       sort: \Genre.name,
       order: .reverse)
private var genres: [Genre]
```

Teraz, gdy posiadamy nieco więcej informacji na temat makra Query, użyjmy go do budowy funkcjonalności dynamicznego sortowania. Dotychczas widzieliśmy przykłady filtrowania i sortowania statycznych danych, ale możemy to wszystko robić także dynamicznie. Musimy tylko trochę zmodyfikować nasz kod.

Mając na uwadze, że FetchDescriptor może przyjmować jako parametr SortDescriptor, możemy wykorzystać tę wiedzę, aby stworzyć dynamiczny mechanizm sortowania. Na początek wprowadźmy nowe wyliczenie, GenreSortOrder, jako nasz pierwszy krok.

```swift
enum GenreSortOrder: String, Identifiable, CaseIterable {
    case forward
    case reverse
    
    var id: Self { return self }
    
    var title: String {
        switch self {
        case .forward:
            return "Przód"
        case .reverse:
            return "Tył"
        }
    }
    
    var sortOption: SortDescriptor<Genre> {
        switch self {
        case .forward:
            return SortDescriptor(\Genre.name, order: .forward)
        case .reverse:
            return SortDescriptor(\Genre.name, order: .reverse)
        }
    }
}
```

W tym przypadku wyliczenie GenreSortOrder zawiera dwa przypadki: forward (przód) i reverse (tył). Każdy przypadek ma swoje wartości składowe: id, którym jest sam siebie, oraz tytuł, który zmienia się w zależności od przypadku. Dodatkowo, mamy właściwość sortOption, która zwraca odpowiedni SortDescriptor na podstawie wybranego przypadku sortowania. Teraz możemy użyć tego wyliczenia do dynamicznego ustalania kolejności sortowania w naszym zapytaniu Query.

Następnie, przeprowadzimy refaktoryzację widoku `GenreListView`, tworząc podwidok dla kodu odpowiedzialnego za pobieranie gatunków z magazynu danych. Ten podwidok będzie przyjmować `sortOrder` jako parametr inicjalizacyjny, a nasze dynamiczne zapytanie Query będzie oparte na wybranej kolejności sortowania.

```swift
struct GenreListSubview: View {
    @Query private var genres: [Genre]
    @Environment(\.modelContext) private var context
    
    init(sortOrder: GenreSortOrder = .forward) {
        _genres = Query(FetchDescriptor<Genre>(sortBy: [sortOrder.sortOption]), animation: .snappy)
    }
    
    var body: some View {
        List {
            ForEach(genres) { genre in
                NavigationLink(destination: GenreDetailView(genre: genre)) {
                    Text(genre.name)
                }
            }
            .onDelete(perform: deleteGenre)
        }
    }
    
    private func deleteGenre(at offsets: IndexSet) {
        offsets.forEach { index in
            let genreToDelete = genres[index]
            context.delete(genreToDelete)
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
```

Ostatnim, ale nie najmniej ważnym krokiem będzie dodanie przycisku w pasku narzędziowym, który pozwoli nam sortować naszą listę gatunków w kolejności rosnącej i malejącej.

```swift
import SwiftUI
import SwiftData

struct GenreListView: View {
    @State private var presentAddNew = false
    @State private var sortOption: GenreSortOrder = .forward
    
    var body: some View {
        NavigationStack {
            GenreListSubview(sortOrder: sortOption)
                .navigationTitle("Gatunki Literackie")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            presentAddNew.toggle()
                        }) {
                            Image(systemName: "plus")
                        }
                        .sheet(isPresented: $presentAddNew) {
                            // Implementuj widok do dodawania nowego gatunku literackiego
                            // np. AddGenreView()
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            sortOption = sortOption == .forward ? .reverse : .forward
                        }) {
                            Image(systemName: "arrow.up.arrow.down")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
        }
    }
}
```

