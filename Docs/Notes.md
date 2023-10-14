##  Notatki Relacje z innymi danymi



Nasz dziennik czytelniczy zawiera spis książek, które dotąd przeczytaliśmy, ale co jeśli chcemy zapamiętać rzeczy, które nam się podobają w książce, na przykład ważne cytaty itp.? Możemy rozwiązać ten problem, dodając możliwość robienia notatek na poziomie książki, dzięki czemu każdy rekord książki będzie miał miejsce na dodawanie notatek o niej.
W tym przypadku łączymy ze sobą dwa rekordy (Książka i Notatka) za pomocą wspólnego ogniwa. To połączenie nazywa się relacją między rekordami. Istnieją różne rodzaje relacji między rekordami.
**Relacja jeden do jeden (1:1):** W relacji jeden do jeden, każdy rekord po jednej stronie relacji jest powiązany dokładnie z jednym rekordem po drugiej stronie, i vice versa. Na przykład możemy mieć rekord "`Osoba`" z relacją jeden do jeden z rekordem "`Paszport`", gdzie każda osoba ma tylko jeden paszport.
**Relacja jeden do wielu (1:N):** W relacji jeden do wielu, każdy rekord po jednej stronie relacji może być powiązany z wieloma rekordami po drugiej stronie, ale każdy rekord po drugiej stronie jest powiązany tylko z jednym rekordem po pierwszej stronie. Na przykład możemy mieć rekord "Dział" z relacją jeden do wielu z rekordem "`Pracownik`", gdzie każdy dział może mieć wielu pracowników, ale każdy pracownik należy tylko do jednego działu.
**Relacja wiele do jeden (N:1):** To jest odwrotność relacji jeden do wielu. Każdy rekord po jednej stronie jest powiązany z jednym rekordem po drugiej stronie, ale każdy rekord po drugiej stronie może być powiązany z wieloma rekordami po pierwszej stronie. Korzystając z tego samego przykładu "`Dział`" i "`Pracownik`", oznaczałoby to, że każdy pracownik należy do jednego działu, ale wiele pracowników może należeć do tego samego działu.
**Relacja wiele do wielu (N:N):** W relacji wiele do wielu, wiele rekordów po jednej stronie może być powiązanych z wieloma rekordami po drugiej stronie. Na przykład możemy mieć rekord "`Student`", rekord "`Kurs`" i rekord "`Rejestracja`", aby reprezentować relację wiele do wielu między studentami a kursami, gdzie każda rejestracja łączy studenta z kursem.
W naszym przypadku relacja jest jednostronna, gdzie jedna książka będzie zawierać wiele notatek.
Zacznijmy od stworzenia nowego modelu dla notatki do książki. Będziemy nazywać tę klasę "`Notatka`".

```swift
import Foundation
import SwiftData

@Model
final class Note {
    var title: String
    var message: String
    var book: Book?
    
    init(title: String, message: String, book: Book? = nil) {
        self.title = title
        self.message = message
        self.book = book
    }
}
```



Aby powiązac ten rekord z książka musimy w modelu Book dodać informację o relacji:

```swift
import Foundation
import SwiftData

@Model
final class Book {
    var title: String
    var author: String
    var publishedYear: Int
    
    @Relationship(deleteRule: .cascade, inverse: \Note.book)
    var notes = [Note]()
    
    init(title: String, author: String, publishedYear: Int) {
        self.title = title
        self.author = author
        self.publishedYear = publishedYear
    }
}
```



Zauważ, że ustawiamy `deleteRule` dla tej relacji jako `cascade`, co oznacza, że po usunięciu tej książki wszelkie powiązane modele również zostaną usunięte. Inne reguły usuwania obejmują:

- `noAction`: Reguła, która nie wprowadza zmian w powiązanych modelach.
- `nullify`: Reguła, która ustawia na `null` referencję do powiązanego modelu.
- `deny`: Reguła, która uniemożliwia usunięcie modelu, ponieważ zawiera jedno lub więcej odniesień do innych modeli.
- `cascade`: Reguła, która usuwa wszelkie powiązane modele.

Opcja `inverse` tworzy połączenie między modelem książki a właściwością `book` notatki.

