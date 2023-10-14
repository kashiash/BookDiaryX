### Lista notatek w książce

Dodajemy widok do wyświetlania listy naszych notatek `NotesListView`:

```swift
import SwiftUI
import SwiftData

struct NotesListView: View {
    let book: Book

    var body: some View {
        List {
            ForEach(book.notes) { note in

                VStack {
                    Text(note.title)
                        .bold()
                    Text(note.message)

                }
            }
        }
    }
}
```



Dodajmy ten widok jako sekcję do widoku szczegółowego książki.

Zacznij od dodania nowego właściwości stanu (`@State` property) w celu przełączania arkusza do dodawania nowej notatki w widoku `BookDetailView`:

```swift
@State private var showAddNewNote = false
```

Następnie stwórz nową sekcję pod formularzem dla notatek:

```swift
var body: some View {
    Form {
        if isEditing {
            // ...
        } else {
            // ...
        }
        
        Section("Notes") {
            Button("Add new note") {
                showAddNewNote.toggle()
            }
            .sheet(isPresented: $showAddNewNote, content: {
                NavigationStack {
                    AddNewNote(book: book)
                }
            })
        }
    }
}
```

Ponieważ widok dodawania nowej notatki ma tylko dwie pola, byłoby rozsądne, aby zajmował tylko część ekranu, a nie uruchamiał się jako pełny arkusz. Możemy to osiągnąć, korzystając z "presentation detents". Wyłączmy również funkcję przeciągnięcia do zamknięcia arkusza, dzięki czemu użytkownik może zamknąć widok dodawania notatki tylko poprzez naciśnięcie jednego z przycisków w nim dostępnych.

```swift
Section("Notes") {
                Button("Add new note") {
                    showAddNewNote.toggle()
                }
                .sheet(isPresented: $showAddNewNote, content: {
                    NavigationStack {
                        AddNewNote(book: book)
                    }
                    .presentationDetents([.fraction(0.3)])
                    .interactiveDismissDisabled()
                })
                
            }
```





Jesteśmy gotowi, aby wyświetlić wszystkie notatki powiązane z widokiem. Podczas wyświetlania notatek miałoby sens pokazać pusty stan, aby poinformować użytkownika, że nie ma notatek, jeśli jeszcze nie dodał żadnych notatek do książki. W tym celu użyjemy widoku `ContentUnavailable`.

```swift
Section("Notes") {
    Button("Add new note") {
        showAddNewNote.toggle()
    }
    .sheet(isPresented: $showAddNewNote, content: {
        NavigationStack {
            AddNewNote(book: book)
        }
        .presentationDetents([.fraction(0.3)])
        .interactiveDismissDisabled()
    })

    if book.notes.isEmpty {
        ContentUnavailableView("No notes", systemImage: "note")
    } else {
        NotesListView(book: book)
    }
}
```

Zbuduj i uruchom aplikację, aby zobaczyć to w działaniu.



![2023-10-03_12-43-34 (/Users/uta/Desktop/BookDiaryX/Docs/2023-10-03_12-43-34%2520(1).gif)](2023-10-03_12-43-34%20(1).gif)

Teraz mamy możliwość dodawania notatek do książek, ale co jeśli wprowadzimy notatkę przez pomyłkę? Nie byłoby miło móc ją usunąć? Dla tego celu dodajmy funkcję usuwania notatki do listy notatek.

Przejdź z powrotem do widoku `NotesListView` i dodaj zmienną środowiskową (`@Environment(\.modelContext) private var context`) dla dostępu do kontekstu modelu. Następnie dodajmy prywatną funkcję do obsługi operacji usuwania.

```swift
struct NotesListView: View {
    let book: Book
    @Environment(\.modelContext) private var context
    
private func deleteNote(indexSet: IndexSet) {
        indexSet.forEach { index in
            let note = book.notes[index]
            context.delete(note)
            book.notes.remove(at: index)
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    var body: some View {
        // ... reszta widoku
    }
}
```

W powyższym kodzie `deleteNote` jest funkcją, która przyjmuje indeksy notatek do usunięcia (`offsets`) i usuwa odpowiednie notatki z kontekstu modelu. Następnie zapisuje zmiany w kontekście za pomocą `context.save()`. Upewnij się, że obsłużysz ewentualne błędy, które mogą wystąpić podczas zapisywania.

Teraz możemy wywołać tę funkcję w widoku, gdzie użytkownik ma możliwość usuwania notatek, używając `.onDelete(perform: deleteNote)`. Na przykład:

```swift
List {
    ForEach(book.notes, id: \.self) { note in
        // Wyświetl notatkę
    }
    .onDelete(perform: deleteNote)
}
```

W ten sposób użytkownik będzie mógł usuwać notatki z listy, przeciągając w lewo na notatce lub używając przycisku "Edytuj" i naciskając czerwony przycisk "Usuń". Pamiętaj, że operacje usuwania powinny być ostrożnie obsługiwane, aby uniknąć przypadkowego usunięcia ważnych danych.

cały widok:

```swift
import SwiftUI
import SwiftData

struct NotesListView: View {
    let book: Book
    @Environment(\.modelContext) private var context

    var body: some View {
        List {
            ForEach(book.notes) { note in

                VStack {
                    Text(note.title)
                        .bold()
                    Text(note.message)

                }
            }
            .onDelete(perform: deleteNote(indexSet:))
        }
    }

    private func deleteNote(indexSet: IndexSet) {
            indexSet.forEach { index in
                let note = book.notes[index]
                context.delete(note)
                book.notes.remove(at: index)
                do {
                    try context.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
}
```



![2023-10-03_12-49-20 (/Users/uta/Desktop/BookDiaryX/Docs/2023-10-03_12-49-20%2520(1).gif)](2023-10-03_12-49-20%20(1).gif)



Teraz, gdy dodaliśmy właściwość book lub note do widoków, nasza struktura podglądu nie będzie już działać. Co gorsza, nie możemy po prostu utworzyć tymczasowego obiektu Book w podglądzie, ponieważ SwiftData nie będzie wiedział, gdzie go utworzyć – nie ma aktywnego kontenera modelu ani kontekstu wokół.

Aby to naprawić, musimy ręcznie utworzyć kontener modelu, a zrobimy to w bardzo szczególny sposób: ponieważ jest to kod podglądu z danymi przykładowymi, utworzymy kontener w pamięci, aby wszelkie obiekty podglądu, które tworzymy, nie były zapisywane, ale były tylko tymczasowe.

To wymaga czterech kroków:

1. Utworzenie niestandardowego obiektu **ModelConfiguration**, aby określić, że chcemy użyć pamięci podręcznej.
2. Użycie tego obiektu do stworzenia **kontenera modelu**.
3. Utworzenie przykładowego obiektu Destination zawierającego dane próbkowe. Ten obiekt zostanie automatycznie utworzony w kontenerze modelu, który właśnie stworzyliśmy.
4. Przesłanie tego przykładowego obiektu i naszego kontenera modelu do np widoku BookDetailView, a następnie zwrócenie ich wszystkich.

Do tej pory nie musieliśmy robić kroków 1 i 2, ponieważ wszystko to było obsługiwane przez modyfikator modelContainer() w pliku BookDiaryXApp.swift, ale teraz musimy to zrobić ręcznie, abyśmy mogli utworzyć obiekt Book do przekazania do widoku

skonfigurujemy teraz podglad w BookDetailView:

```swift
#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Book.self, configurations: config)
        let example = Book.generateRandomBook()

        return BookDetailView(book: example)
            .modelContainer(container)
    } catch {
        fatalError("Coś się zjebsuło")
    }

}

```





**Ważne: Jeśli próbujesz utworzyć instancję modelu SwiftData i nie istnieje już kontener modelu, twój podgląd może po prostu ulec awarii. Bądź ostrożny!**

