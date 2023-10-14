

## Dopisywanie nowej ksiązki AddNewBookView

Dodajmy widok do dodawania nowej książki do naszego dziennika czytelnictwa.
Zaczniemy od importu SwiftData.

```swift
import SwiftUI
import SwiftData

struct AddNewBookView: View {
    var body: some View {
        Text("Witaj, DevTechie!")
    }
}

#Podgląd {
    AddNewBookView()
}
```

Oto reszta interfejsu użytkownika (UI), która pozwala na dodawanie nowej książki do naszej listy czytanych książek. Ten kod zawiera pola do wprowadzenia tytułu, autora i roku publikacji, a także przyciski "Anuluj" i "Zapisz" do zarządzania operacjami.

```swift
import SwiftUI
import SwiftData

struct AddNewBookView: View {
    
    @State private var title: String = ""
    @State private var author: String = ""
    @State private var publishedYear: Int?
    
    var body: some View {
        NavigationStack {
            VStack(
                alignment: .leading
            ) {
                Text(
                    "Tytuł książki:"
                )
                TextField(
                    "Wprowadź tytuł",
                    text: $title
                )
                .textFieldStyle(
                    .roundedBorder
                )
                
                Text(
                    "Autor:"
                )
                TextField(
                    "Wprowadź autora książki",
                    text: $author
                )
                .textFieldStyle(
                    .roundedBorder
                )
                
                Text(
                    "Rok publikacji:"
                )
                TextField(
                    "Wprowadź rok publikacji",
                    value: $publishedYear,
                    format: .number
                )
                .textFieldStyle(
                    .roundedBorder
                )
                .keyboardType(
                    .numberPad
                )
                
                HStack {
                    
                    Button(
                        "Anuluj",
                        role: .destructive
                    ) {
                        // Tu możesz dodać kod obsługujący anulowanie operacji
                    }
                    .buttonStyle(
                        .bordered
                    )
                    
                    Spacer()
                    
                    Button(
                        "Zapisz"
                    ) {
                        // Tu możesz dodać kod obsługujący zapisywanie nowej książki
                    }
                    .buttonStyle(
                        .bordered
                    )
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle(
                "Dodaj Nową Książkę"
            )
        }
    }
}

#Preview {
    AddNewBookView()
}
```

Ten kod definiuje widok (`View`), który pozwala użytkownikowi wprowadzić informacje o nowej książce, takie jak tytuł, autor i rok publikacji. Wprowadzone dane są przechowywane w zmiennych stanu (`@State`), a przyciski "Anuluj" i "Zapisz" pozwalają na zarządzanie operacjami anulowania i zapisywania nowej książki. Widok ten jest dodatkowo umieszczony w nawigacyjnym stosie (`NavigationStack`) i ma tytuł "Dodaj Nową Książkę".



Mamy już przygotowany interfejs użytkownika (UI), więc teraz dodajmy część związana z SwiftData, która pomoże nam zapisać wprowadzone informacje. Ponieważ przekazujemy kontener modeli za pomocą App, możemy uzyskać dostęp do obiektu środowiskowego (`@Environment`) w celu uzyskania dostępu do kontekstu modelu.

```swift
@Environment(\.modelContext) private var context
```

Dodajmy to do naszego widoku `AddNewBookView` (upewnij się, że zaimportowano SwiftData). Musimy również dodać sposób na zamknięcie tego widoku, ponieważ zostanie on prezentowany jako arkusz. Skorzystajmy z funkcji dismiss z obiektu środowiskowego (`@Environment`), aby zamknąć ten widok.

```swift
@Environment(\.dismiss) private var dismiss
```

Dodajmy to również do pliku (upewnij się, że jest zaimportowany SwiftUI i SwiftData). Chcemy upewnić się, że wszystkie informacje związane z książką zostały wprowadzone przez użytkownika, zanim włączymy przycisk "Zapisz". Dlatego napiszemy prostą właściwość obliczeniową do sprawdzania poprawności formularza wprowadzania.

```swift
import SwiftUI
import SwiftData

struct AddNewBookView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var author: String = ""
    @State private var publishedYear: Int?
    
    private var isFormValid: Bool {
        // Tutaj możesz dodać kod sprawdzający poprawność wprowadzonych danych
        // Zwróć true, jeśli dane są poprawne, w przeciwnym razie false
        return true // Zmień to na właściwą logikę
    }
    
    // ...
}
```

To jest początkowy kod, który pozwala na dostęp do kontekstu modelu (`context`) i funkcji zamknięcia widoku (`dismiss`). Właściwość `isFormValid` jest obecnie zawsze ustawiona na `true`. Musisz dostosować tę właściwość, aby uwzględniała warunki poprawności formularza wprowadzania danych, na przykład sprawdzając, czy wszystkie pola są wypełnione.



Chcemy upewnić się, że użytkownik wprowadzi wszystkie informacje dotyczące książki, zanim włączymy przycisk "Zapisz", dlatego napiszemy prosty obliczany atrybut, aby sprawdzić poprawność tego formularza wprowadzania.

```swift
private var isValid: Bool {
    !title.isEmpty && !author.isEmpty && publishedYear != nil
}
```

Dodamy ten obliczany atrybut pod właściwościami stanu.

Następnie wywołamy funkcję dismiss w bloku akcji przycisku "Cancel", aby zamknąć ten widok.

```swift
Button(
    "Cancel",
    role: .destructive
) {
    dismiss()
}
.buttonStyle(
    .bordered
)
```

Dodajmy funkcjonalność zapisywania do przycisku "Save".

```swift
Button(
    "Save"
) {
    guard let publishedYear = publishedYear else { return }
    let book = Book(title: title, author: author, publishedYear: publishedYear)
    
    context.insert(book)
    
    do {
        try context.save()
    } catch {
        print(error.localizedDescription)
    }
    
    dismiss()
}
.buttonStyle(
    .bordered
)
.disabled(!isValid)
```

Ten kod sprawdza, czy wszystkie wymagane pola są wypełnione, a także tworzy i zapisuje nową książkę w bazie danych, gdy użytkownik naciśnie przycisk "Save".

Udało nam się zapisać książkę, ale w tym momencie nie mamy sposobu, aby zobaczyć wszystkie zapisane książki, i to jest kolejne wyzwanie, które podejmiemy.