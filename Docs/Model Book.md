

## Model Book

Rozpoczniemy od modelu danych. Nasz model będzie nosił nazwę "Book".

```swift
import Foundation

final class Book {
    var title: String
    var author: String
    var publishedYear: Int
    
    init(title: String, author: String, publishedYear: Int) {
        self.title = title
        self.author = author
        self.publishedYear = publishedYear
    }
}
```





Aby przekształcić ten model w model SwiftData, wystarczy zaimportować SwiftData.

```swift
import Foundation
import SwiftData
```

Następnie ozdobimy klasę makrem @Model.

```swift
import Foundation
import SwiftData

@Model
final class Book {
    var title: String
    var author: String
    var publishedYear: Int
    
    init(title: String, author: String, publishedYear: Int) {
        self.title = title
        self.author = author
        self.publishedYear = publishedYear
    }
}
```

*(Przy okazji podpowiedz do Xcode: Wybierz nazwe klasy, prawy klawisz myszy i Refactor-> Generate MemberWise Initializer. )*



To makro Model przekształca klasę Swift w przechowywany model zarządzany przez SwiftData. (**Kodu ponizej nie musisz przepisywać !!!**)

```swift
@Model
final class Book {
    internal init(title: String, author: String, publishedYear: Int) {
        self.title = title
        self.author = author
        self.publishedYear = publishedYear
    }
    
    var title: String
    var author: String
    var publishedYear: Int
  // wszystko ponziej jest wygenerowane dzieki makru @Model
@Transient
private var _$backingData: any SwiftData.BackingData<Book> = Book.createBackingData()

public var persistentBackingData: any SwiftData.BackingData<Book> {
    get {
        _$backingData
    }
    set {
        _$backingData = newValue
    }
}

static var schemaMetadata: [SwiftData.Schema.PropertyMetadata] {
  return [
    SwiftData.Schema.PropertyMetadata(name: "title", keypath: \Book.title, defaultValue: nil, metadata: nil),
    SwiftData.Schema.PropertyMetadata(name: "author", keypath: \Book.author, defaultValue: nil, metadata: nil),
    SwiftData.Schema.PropertyMetadata(name: "publishedYear", keypath: \Book.publishedYear, defaultValue: nil, metadata: nil)
  ]
}

init(backingData: any SwiftData.BackingData<Book>) {
  _title = _SwiftDataNoType()
  _author = _SwiftDataNoType()
  _publishedYear = _SwiftDataNoType()
  self.persistentBackingData = backingData
}

@Transient
private let _$observationRegistrar = Observation.ObservationRegistrar()

struct _SwiftDataNoType {
}
```



 Nie potrzebujemy żadnych dodatkowych plików ani narzędzi do zarządzania modelem danych ani warstwą trwałości. Dodatkowo SwiftData może automatycznie wywnioskować wiele relacji, korzystając z deklaracji, takich jak @Attribute(.unique), aby opisać ograniczenia dla naszych modeli danych.

W przypadku Core Data musimy zainicjować kontener trwałości, aby uzyskać kontekst modelu, ale w przypadku SwiftData otrzymujemy go za darmo, o ile tworzymy i przekazujemy obiekt ModelContainer. ModelContainer to obiekt zarządzający schematem aplikacji i konfiguracją przechowywania modelu.

W naszym przypadku przekażemy ten kontener z poziomu struktury App.

```swift
import SwiftUI
import SwiftData

@main
struct ReadingLogDraftApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Book.self])
        }
    }
}
```

