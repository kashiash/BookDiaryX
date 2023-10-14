## Widok do dopisywania notatek `AddNewNote`

Po przygotowaniu modeli i ustanowieniu relacji między nimi, możemy zacząć rozwijać nasze widoki. Zaczynamy od utworzenia `AddNewNote` do ktorego przekażemy obiekt Book jako parametr wejściowy i zadeklarujemy 2 zmienne do ktorych beda wpisywane dane:

```swift
import SwiftUI
import SwiftData

struct AddNewNote: View {
      let book: Book
    
    @State private var title: String = ""
    @State private var message: String = ""
  
    var body: some View {
        Text("Hello !")
    }
}
```



dodajemy informacje o kontekscie i zmienną do sterowania formularzem

```swift
struct AddNewNote: View {
    let book: Book
    
    @State private var title: String = ""
    @State private var message: String = ""
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
```



dodajemy przyciski Save i Close



```swift
struct AddNewNote: View {
    let book: Book
    
    @State private var title: String = ""
    @State private var message: String = ""
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            TextField("Note title", text: $title)
            TextField("Note", text: $message)
        }
        .navigationTitle("Add new note")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Close") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    let note = Note(title: title, message: message)
                    note.book = book
                    context.insert(note)
                    
                    do {
                        try context.save()
                        book.notes.append(note)
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                    dismiss()
                }
            }
        }
    }
}
```

###