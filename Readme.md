# SwiftData pierwsze kroki



## Wstęp

Apple przedstawiło SwiftData na WWDC 23. Podobnie jak SwiftUI, SwiftData stosuje podejście deklaratywne. SwiftData ułatwia zapisywanie i przechowywanie danych, pozwalając nam modelować i zarządzać danymi za pomocą deklaratywnego kodu, eliminując potrzebę korzystania z plików projektowania schematu modelu (dostępne od wielu lat na IOS CoreData) i wprowadzając kwerendy i filtrowanie danych wyłącznie w kodzie Swift.

SwiftData został zaprojektowany do współpracy zarówno z UIKit, jak i SwiftUI, i doskonale integruje się z SwiftUI. SwiftData jest oparty na Core Data, ale wprowadza nowoczesne podejście do przechowywania danych, dostarczając natywne interfejsy API napisane w języku Swift.

SwiftData wykorzystuje makra do generowania kodu. Makra są kolejną  ciekawą funkcją wprowadzoną na WWDC 23 i służą do generowania szybkiego, wydajnego i bezpiecznego kodu.

SwiftData automatycznie buduje schemat przy użyciu naszych modeli i skutecznie mapuje ich pola do magazynu danych. Obiekty zarządzane przez SwiftData są pobierane z bazy danych w razie potrzeby i automatycznie zapisywane w odpowiednim momencie, bez dodatkowej pracy z naszej strony.

Aby lepiej zrozumieć to zagadnienie, pracujmy nad aplikacją obsługiwaną przez SwiftData.
Będziemy tworzyć aplikację do logowania czytanych książek. Ta aplikacja będzie śledzić wszystkie przeczytane przez nas książki. Aplikacja ta będzie także miała sekcję na notatki do każdej książki, dzięki czemu będziemy mogli zapamiętać ważne aspekty książki za pomocą zapisanych notatek.



[Model Books](Docs/model book.md)

​	[AddNewBook](Docs/ [AddNewBookView.md] )

​	[BookListView](Docs/BookListView.md)

​	[BookDetailView](Docs/BookDetailView.md)

[Notatki - relacja 1:N](Docs/Notes.md)

​	[Add new note ](Docs/AddNewNote.md)

​	[Notes List View](Docs/NotesListView.md)

[Gatunki literackie - relacja M-N](Docs/genres.md)

​	[GenreListView](Docs/GenreListView.md)

​	[AddNewGenreView](Docs/addNewGenreView.md)

​	[Wybieranie gatunków listeracjich](Docs\GenreSelectionView.md)

​	[Edycja gatunków  w BookDetailView](Docs/ModyfikacjeBookDetailView.md)





plan do rozbudowy:

w notatkach mozemy robic zdjęcia 

jak przechowywac zdjecia mamy tu:

https://www.youtube.com/watch?v=y3LofRLPUM8

https://www.hackingwithswift.com/quick-start/swiftdata/how-to-store-swiftdata-attributes-in-an-external-file

https://www.youtube.com/playlist?list=PLvUWi5tdh92wZ5_iDMcBpenwTgFNan9T7

pobieranie obrazkow i zdjęć:

https://www.youtube.com/watch?v=yMC16EZHwZU

https://www.youtube.com/playlist?list=PLBn01m5Vbs4DNdXMfXKpY7WS0S5CAg7NI

