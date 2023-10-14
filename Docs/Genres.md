

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





