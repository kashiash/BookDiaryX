## Przechowywanie danych binarnych

Zmiany są nieuniknione, więc zobaczmy, jak SwiftData radzi sobie z nimi. Nasza aplikacja wygląda dobrze, ale brakuje jej okładek książek, więc dodajmy je.

Zaczniemy od dodania nowej właściwości do modelu książki. Ponieważ mamy do czynienia z obrazami, będziemy przechowywać je jako dane binarne.



```swift

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

Ta właściwość jest oznaczona jako opcjonalna, ponieważ dodajemy nowy atrybut do istniejącej aplikacji, i wcześniej zapisane dane nie powinny być dotknięte tą zmianą, o ile dodajemy nową właściwość jako opcjonalną lub z domyślną wartością.

Obrazy są duże, i nie jest dobrym pomysłem przechowywanie ich bezpośrednio w magazynie danych (ze względu na problemy z wydajnością). Możemy zdecydować się przechowywać jedynie referencję do obrazu, a rzeczywiste dane obrazu mogą być umieszczone gdzieś indziej na dysku. Nie musimy tego robić ręcznie, możemy skorzystać z makra Attribute w SwiftData i zdefiniować konfigurację schematu do przechowywania danych binarnych obrazu na zewnątrz.

Zaktualizujmy model, aby zawierał makro Attribute:

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



Najpierw zaimportuj moduł `PhotosUI`.

```swift
import SwiftUI
import SwiftData
import PhotosUI
```

Następnie dodaj dwie nowe właściwości stanu (`@State`) - jedną do powiązania z wyborem zdjęć (`selectedCover`) i drugą do przechowywania danych wybranego obrazka (`selectedCoverData`).

```swift
@State private var selectedCover: PhotosPickerItem?
@State private var selectedCoverData: Data?
```

Teraz dodaj interfejs użytkownika do wyboru zdjęć w sekcji `body` widoku.

```swift
var body: some View {
    NavigationStack {
        VStack(alignment: .leading) {
            Text("Tytuł książki:")
            // ... Pozostałe elementy interfejsu użytkownika ...
            
            HStack {
                PhotosPicker(
                    selection: $selectedCover,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Label("Dodaj Okładkę", systemImage: "book.closed")
                }
                .padding(.vertical)
                
                Spacer()
                
                if let selectedCoverData = selectedCoverData,
                   let image = UIImage(data: selectedCoverData) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                }
            }
            
            Text("Rok Wydania:")
            // ... Pozostałe elementy interfejsu użytkownika ...
        }
        .padding()
        .navigationTitle("Dodaj Nową Książkę")
        // ... Pozostałe modyfikatory widoku ...
    }
}
```

W powyższym kodzie `PhotosPicker` jest używany do wyboru zdjęcia. W zależności od wyboru użytkownika, wybrany obraz jest wyświetlany lub ikona "photo", jeśli żadne zdjęcie nie zostało jeszcze wybrane. Pamiętaj, że `selectedCoverData` musi być zainicjowane w odpowiednim momencie (np. po wybraniu zdjęcia) przed wyświetleniem obrazka.



Przed wyświetleniem wybranego obrazka, pobierzmy jego dane binarne i przypiszmy je do zmiennej `selectedCoverData`. Operacja ta jest asynchroniczna, więc użyjmy modyfikatora `task` do pobrania danych z wybranego zdjęcia.

```swift
import SwiftUI
import SwiftData
import PhotosUI

struct AddNewBookView: View {
    @State private var title = ""
    @State private var author = ""
    @State private var publishedYear = ""
    @State private var selectedCover: PhotosPickerItem?
    @State private var selectedCoverData: Data?
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                // Pozostałe elementy interfejsu użytkownika...
                
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
                    
                    if let selectedCoverData = selectedCoverData,
                       let image = UIImage(data: selectedCoverData) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Rectangle().cornerRadius(10))
                            .frame(width: 100, height: 100)
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    }
                }
                
                // Pozostałe elementy interfejsu użytkownika...
            }
            .padding()
            .navigationTitle("Dodaj nową książkę")
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