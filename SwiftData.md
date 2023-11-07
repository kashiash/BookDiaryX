



# Swift Data



na bazie : https://medium.com/better-programming/unveiling-the-data-modeling-principles-of-swiftdata-480c993d2f5c



## Trzy Fakty

Zrozumienie poniższych trzech faktów jest kluczowe dla lepszego zrozumienia zasad modelowania SwiftData oraz dlaczego SwiftData stosuje opisane metody w tym artykule.
SwiftData to framework zbudowany na Core Data
Mimo że Apple rzadko podkreśla związek między SwiftData a Core Data, niezaprzeczalne jest, że framework SwiftData został zbudowany na Core Data. Istnieje kilka korzyści, jakie Core Data przynosi SwiftData:
Format pliku bazy danych jest kompatybilny; istniejące dane można bezpośrednio operować za pomocą nowego frameworka.
Dziedziczy weryfikację stabilności Core Data, znacznie redukując potencjalne problemy.
Mimo że SwiftData opiera się na Core Data, nie oznacza to, że podczas programowania z SwiftData należy używać tych samych zasad, co w przypadku Core Data. Ponieważ SwiftData łączy wiele najnowszych funkcji języka Swift, programiści często muszą używać świeżego podejścia do przeprojektowania logiki przetwarzania danych w wielu sytuacjach.

### SwiftData jest ścisłe związane z językiem Swift i jest prekursorem tego języka.
W ostatnich latach Apple wprowadziło kilka frameworków z przedrostkiem "Swift", takich jak SwiftUI, Swift Charts, SwiftData itp. Ta konwencja nazewnictwa odzwierciedla bliską integrację tych frameworków z językiem Swift. Aby zaimplementować te frameworki, Apple aktywnie promuje rozwój języka Swift, proponując nowe propozycje i stosując częściowo określone funkcje w tych frameworkach.
Te frameworki szeroko przyjmują nowe funkcje Swift, takie jak result builders, property wrapper, makra i dostępy inicjalizacyjne, czyniąc je pionierami i poligonami do testowania nowych funkcji języka.
Niestety, obecnie niemożliwe jest, aby te frameworki były wieloplatformowe i otwarte. Wynika to głównie z faktu, że polegają na własnych interfejsach API w ramach ekosystemu Apple. To utrudnia możliwość promowania języka Swift za pomocą tych doskonałych frameworków na innych platformach.
Ogólnie rzecz biorąc, frameworki takie jak SwiftData są ściśle związane z językiem Swift i odgrywają wiodącą rolę w przyjmowaniu nowych funkcji. Poznanie tych frameworków to również sposób na opanowanie nowych funkcji języka Swift.



Czysta deklaracja modeli danych w postaci kodu jest krokiem naprzód w porównaniu do Core Data, ale nie jest to rewolucja.
Choć SwiftData zaskakuje deweloperów Core Data, stosując podejście oparte wyłącznie na kodzie do deklaracji modeli danych, to już zostało to zastosowane w innych frameworkach i językach. W porównaniu z Core Data, osiągnęło pewien postęp, ale nie może być uznane za kompletną rewolucję.
Mimo to, SwiftData ma swoje unikalne innowacje w implementacji tego konceptu. Wynika to głównie z jej bliskiej integracji z językiem Swift. SwiftData osiąga modelowanie deklaratywne w sposób bardziej zwięzły, wydajny i zgodny z nowoczesnym paradygmatem programowania, tworząc i wykorzystując nowo powstałe funkcje języka.



Analiza Kodu Modelu
W tej sekcji przeanalizujemy kod modelu SwiftData, który opiera się na modelach dostarczonych w szablonie projektu SwiftData w Xcode. Odkryjmy jego tajemniczą zawartość.
```swift
@Model
final class Item {
    var timestamp: Date = Date.now // Domyślna wartość dodana

    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
```

Rola Makra
Jeśli zignorujemy flagę makra @Model, powyższy kod jest dokładnie taki sam jak definicja standardowej klasy Swift. Jednakże, dzięki SwiftData i makrowi @Model, możemy rozszerzyć go, aby stał się modelem danych z kompletnym opisem, opartym na prostym reprezentowaniu, które dostarczamy.
W Xcode, po rozwinięciu makr, będziemy mogli zobaczyć pełny kod po rozwinięciu makra (@_PersistedProperty również może być rozwinięte).





rozwinięte Makro:

```swift
public final class Item {
    // User-defined persistence properties
    public var timestamp: Date = Date.now {
        // Init Accessor, in the process of constructing instances, adds construction capabilities to calculated properties
        @storageRestrictions(accesses: _$backingData, initializes: _timestamp)
        init(initialValue) {
            _$backingData.setValue(forKey: \.timestamp, to: initialValue)
            _timestamp = _SwiftDataNoType()
        }
        get {
            _$observationRegistrar.access(self, keyPath: \.timestamp)
            return self.getValue(forKey: \.timestamp)
        }
        set {
            _$observationRegistrar.withMutation(of: self, keyPath: \.timestamp) {
                self.setValue(forKey: \.timestamp, to: newValue)
            }
        }
    }

    // The underlined version corresponding to timestamp has no practical use yet.
    @Transient
    private var _timestamp: _SwiftDataNoType = .init()
    // User-defined constructor
    public init(timestamp: Date) {
        self.timestamp = timestamp
    }
    // A type used to wrap the corresponding managed object (NSManagedObject) instance without persistence (@Transient)
    @Transient
    private var _$backingData: any SwiftData.BackingData<Item> = Item.createBackingData()
    public var persistentBackingData: any BackingData<Item> {
        get {
            self._$backingData
        }
        set {
            self._$backingData = newValue
        }
    }
    // Provide model metadata for creating Scheme
    public static var schemaMetadata: [Schema.PropertyMetadata] {
        return [
            SwiftData.Schema.PropertyMetadata(name: "timestamp", keypath: \Item.timestamp, defaultValue: Date.now, metadata: nil),
        ]
    }
    // Construct PersistentModel from backingData
    public init(backingData: any BackingData<Item>) {
        _timestamp = _SwiftDataNoType()
        self.persistentBackingData = backingData
    }
    // Observation register required by the Observation protocol
    @Transient
    private let _$observationRegistrar: ObservationRegistrar = Observation.ObservationRegistrar()
    // Empty type, used for the underscore version of the property
    struct _SwiftDataNoType {}
}
// PersistentModel Protocol
extension Item: SwiftData.PersistentModel {}
// Observable Protocol
extension Item: Observation.Observable {}
```





Poniżej zostaną dokładnie opisane szczegóły wygenerowanego kodu.

#### Metadane modelu

W Core Data deweloperzy mogą generować pliki .xcdatamodeld w formacie XML za pomocą edytora modeli danych dostarczanego przez Xcode. Ten plik przechowuje informacje opisujące, które są używane do utworzenia modelu danych (NSManagedObjectModel).





SwiftData integruje powyższe informacje opisowe bezpośrednio do kodu deklaracji za pomocą makra Model.
```swift
public static var schemaMetadata: [Schema.PropertyMetadata] {
    return [
        SwiftData.Schema.PropertyMetadata(name: "timestamp", keypath: \Item.timestamp, defaultValue: Date.now, metadata: nil),
    ]
}
```

Każda klasa, która spełnia protokół PersistentModel, musi dostarczyć właściwość klasy o nazwie schemaMetadata. Ta właściwość zawiera szczegółowe metadane do utworzenia modelu danych, które są generowane poprzez analizę definicji właściwości stałych danego typu.
Nazwa odpowiada atrybutowi Attribute Name modelu danych, keypath to KeyPath odpowiadający właściwości dla danego typu, defaultValue odpowiada domyślnej wartości ustawionej dla właściwości w deklaracji (jeśli nie ma wartości domyślnej, jest nil), a metadata zawiera inne informacje, takie jak opisy relacji, zasady usuwania, oryginalne nazwy itp.

```swift
@Attribute(.unique, originalName: "old_timestamp")
var timestamp: Date = Date.now

static var schemaMetadata: [SwiftData.Schema.PropertyMetadata] {
  return [
    SwiftData.Schema.PropertyMetadata(name: "timestamp", keypath: \Item.timestamp, defaultValue: Date.now, metadata: SwiftData.Schema.Attribute(.unique, originalName: "old_timestamp"))
  ]
}
```



`defaultValue` odpowiada funkcjonalności domyślnej wartości, jaką deweloperzy tworzą dla atrybutów w edytorze modelu Xcode. Ponieważ SwiftData pozwala na deklarowanie właściwości w modelach danych jako bardziej złożonych typów (takich jak enumy, struktury, które spełniają protokół Encoded, itp.), SwiftData mapuje odpowiadający typ przechowywania, używając podanego KeyPath podczas tworzenia modelu. Dodatkowo, każdy PropertyMetadata niekoniecznie odpowiada pojedynczemu polu w SQLite (może tworzyć wiele pól na podstawie typu).

SwiftData będzie bezpośrednio czytać właściwość klasy `schemaMetadata`, aby zakończyć tworzenie Schema, a nawet ModelContainer.

```swift
let schema = Schema([Item.self])
```

Deweloperzy mogą używać nowego interfejsu API `NSManagedObjectModel.makeManagedObjectModel` w Core Data, aby wygenerować odpowiadający `NSManagedObjectModel`, deklarując kod modelu dla SwiftData.

```swift
let model = NSManagedObjectModel.makeManagedObjectModel(for: [Item.self])
```





`BackingData`
Każda instancja `PersistentModel` odpowiada instancji obiektu zarządzanego (NSManagedObject) na poziomie podstawowym, która jest zawinięta w typ o nazwie `_DefaultBackingData` (spełniający protokół `BackingData`).

```swift
@Transient
private var _$backingData: any SwiftData.BackingData<Item> = Item.createBackingData()

public var persistentBackingData: any BackingData<Item> {
    get {
        self._$backingData
    }
    set {
        self._$backingData = newValue
    }
}
```

`createBackingData` to metoda klasy dostarczana przez protokół `PersistentModel`. Tworzy instancję, która spełnia protokół `BackingData`, pobierając informacje z już załadowanego modelu danych, takie jak `_DefaultBackingData<Item>`.

Podczas wywoływania `createBackingData`, SwiftData nie może wyłącznie polegać na `schemaMetadata` dostarczonych przez bieżącą klasę, aby utworzyć instancję. Innymi słowy, `createBackingData` może poprawnie skonstruować instancję `PersistentModel` tylko po utworzeniu instancji `ModelContainer`.

To różni się od Core Data, gdzie instancje można tworzyć wyłącznie na podstawie informacji `NSEntityDescription`, bez konieczności ładowania `NSManagedObjectModel`.

Oto kod używany w SwiftDataKit do pobierania odpowiedniej instancji NSManagedObject z BackingData:

```swift
public extension BackingData {
    // Właściwość obliczeniowa umożliwiająca dostęp do NSManagedObject
    var managedObject: NSManagedObject? {
        guard let object = getMirrorChildValue(of: self, childName: "_managedObject") as? NSManagedObject else {
            return nil
        }
        return object
    }
}

func getMirrorChildValue(of object: Any, childName: String) -> Any? {
    guard let child = Mirror(reflecting: object).children.first(where: { $0.label == childName }) else {
        return nil
    }
    return child.value
}
```

Przez poniższy kod możesz zobaczyć:

```swift
private var _$backingData: any SwiftData.BackingData<Item> = Item.createBackingData()
```

Podczas tworzenia instancji backingData za pomocą `createBackingData` w SwiftData, nie ma potrzeby użycia ModelContext (NSManagedObjectContext). Wewnętrznie używane są następujące metody do tworzenia zarządzanych obiektów:

```swift
let item = Item(entity: Item.entity(), insertInto: nil)
```

To również wyjaśnia, dlaczego w SwiftData, po utworzeniu instancji PersistentModel, musimy ją jawnie zarejestrować (wstawić) do ModelContext.

```swift
let item = Item(timestamp: Date.now)
modelContext.insert(item) // musi zostać wstawiony do pewnego modelContext
```

Ponieważ backingData (_DefaultBackingData) nie ma publicznego konstruktora, nie możemy tworzyć tych danych poprzez instancję zarządzanego obiektu. Inny konstruktor w PersistentModel jest dostarczony dla wewnętrznego użytku w SwiftData, aby przekształcić obiekt zarządzany w PersistentModel.

```swift
public init(backingData: any BackingData<Item>) {
    _timestamp = _SwiftDataNoType()
    self.persistentBackingData = backingData
}
```

### Inicjatory (Init Accessors)

Przeanalizujmy kompletny rozwinięty kod, w którym atrybut `timestamp` zostaje przekształcony w właściwość obliczeniową z konstruktorem za pomocą makra.
```swift
public var timestamp: Date = Date.now {
    @storageRestrictions(accesses: _$backingData, initializes: _timestamp)
    init(initialValue) {
        _$backingData.setValue(forKey: \.timestamp, to: initialValue)
        _timestamp = _SwiftDataNoType()
    }
    get {
        _$observationRegistrar.access(self, keyPath: \.timestamp)
        return self.getValue(forKey: \.timestamp)
    }
    set {
        _$observationRegistrar.withMutation(of: self, keyPath: \.timestamp) {
            self.setValue(forKey: \.timestamp, to: newValue)
        }
    }
}
```
Jak SwiftData buduje bieżącą wartość dla swojej instancji PersistentModel podczas jej tworzenia? Spójrzmy na poniższy kod:
```swift
public init(timestamp: Date) {
    self.timestamp = timestamp
}

let item = Item(timestamp: Date.distantPast)
```
Podczas używania `createBackingData` w SwiftData do utworzenia instancji `Item`, najpierw tworzony jest obiekt `NSManagedObject` z domyślną wartością `Date.now` jako znacznik czasu (przekazywany do schematu przez `schemaMetadata` i zamknięty w `backingData`). Następnie, nowa wartość (z parametru metody konstruktora, `Date.distantPast`) zostanie ustawiona dla właściwości `timestamp` za pomocą inicjatorów inicjalizacji.

Inicjatory (Init Accessors) to nowa funkcja wprowadzona w Swift 5.9. Pozwala ona na uwzględnienie właściwości obliczeniowych w analizie definitywnego inicjalizatora. Pozwala to na bezpośrednie przypisanie wartości do właściwości obliczeniowych w metodach inicjalizacji, które zostaną przekształcone w odpowiadające wartości początkowe dla przechowywanych właściwości.

Znaczenie tego fragmentu kodu jest następujące:

```swift
@storageRestrictions(accesses: _$backingData, initializes: _timestamp)
init(initialValue) {
    _$backingData.setValue(forKey: \.timestamp, to: initialValue)
    _timestamp = _SwiftDataNoType()
}
```

- `accesses: _$backingData` oznacza, że właściwość przechowywania `_$backingData` będzie używana w inicjalizatorze. To oznacza, że `_$backingData` musi być zainicjowany przed wywołaniem tego inicjalizatora, aby zainicjować `timestamp`.

- `initializes: _timestamp` oznacza, że ten inicjalizator będzie inicjować właściwość przechowywania `_timestamp`.

- `initialValue` odpowiada początkowej wartości przekazanej jako argument konstruktora, która w tym przypadku jest `Date.distantPast`.

Inicjatory (Init Accessors) jako nowa funkcja w języku Swift zapewnia bardziej jednolity, precyzyjny, czytelny i elastyczny model inicjalizacji niż Property Wrappers. SwiftData wykorzystuje tę funkcjonalność do przypisywania wartości do właściwości trwałych w czasie fazy konstrukcji, co zmniejsza obciążenie pracy dla programistów i sprawia, że deklaracja kodu modelu jest bardziej zgodna z logiką języka Swift.



### Integracja z frameworkiem obserwacji

W przeciwieństwie do powiązań NSManagedObject z widokami SwiftUI przy użyciu frameworku Combine, PersistentModel w SwiftData przyjmuje nowy framework Obserwacji.

Aby spełnić wymagania frameworku Obserwacji, SwiftData dodał następujący kod do kodu modelu:

```swift
extension Item: Observation.Observable {}

public final class Item {
    // Użytkownicze właściwości trwałe
    public var timestamp: Date = .now {
        ....
        get {
            _$observationRegistrar.access(self, keyPath: \.timestamp)
            return self.getValue(forKey: \.timestamp)
        }
        set {
            _$observationRegistrar.withMutation(of: self, keyPath: \.timestamp) {
                self.setValue(forKey: \.timestamp, to: newValue)
            }
        }
    }

    ....

    // Rejestracja obserwacji wymagana przez protokół Obserwacji
    @Transient
    private let _$observationRegistrar: ObservationRegistrar = Observation.ObservationRegistrar()
}
```

Poprzez użycie `_$observationRegistrar` w metodach `get` i `set` trwałych właściwości, zaimplementowano mechanizm obserwacji na poziomie właściwości, który rejestruje i powiadamia obserwatorów. To podejście może znacząco zmniejszyć niepotrzebne aktualizacje widoku spowodowane zmianami niespokrewnionych właściwości.

Z powyższego opisu rejestracji można wywnioskować, że deweloperzy muszą wywołać jawnie metodę `set` dla właściwości trwałych, aby obserwatorzy otrzymali powiadomienia o zmianach danych (poprzez wywołanie zamknięcia `onChange` w `withObservationTracking`).



### Metody `get` i `set`

Protokół `PersistentModel` definiuje pewne metody `get` i `set`, dostarczając domyślne implementacje. Na przykład:

```swift
public func getValue<Value, OtherModel>(forKey: KeyPath<Self, Value>) -> Value where Value : Decodable, Value : RelationshipCollection, OtherModel == Value.PersistentElement
public func getTransformableValue<Value>(forKey: KeyPath<Self, Value>) -> Value
public func setValue<Value>(forKey: KeyPath<Self, Value>, to newValue: Value) where Value : Encodable
public func setValue<Value>(forKey: KeyPath<Self, Value>, to newValue: Value) where Value : PersistentModel
```

Korzystając z tych metod, programiści mogą odczytywać lub zapisywać określoną właściwość trwałą. Należy zauważyć, że używanie wspomnianych powyżej metod `set` (np. `setValue`) do ustawiania nowej wartości dla właściwości ominie framework Obserwacji, a subskrybenci właściwości nie będą powiadamiani o zmianach właściwości (widoki nie zostaną automatycznie zaktualizowane).

Podobnie, jeśli właściwości trwałe instancji NSManagedObject odpowiadającej PersistentModel zostaną bezpośrednio zmodyfikowane za pomocą SwiftDataKit, nie zostaną wygenerowane żadne powiadomienia.

```swift
item.setValue(forKey: \.timestamp, to: date) // Nie powiadamia subskrybentów timestamp
item.timestamp = date // Powiadamia subskrybentów timestamp
```



Protokół `BackingData` również dostarcza definicji i domyślnych implementacji metod `get` i `set`. Metoda `setValue` dostarczana przez `BackingData` może jedynie modyfikować właściwości odpowiadające `NSManagedObject` na poziomie podstawowym dla `PersistentModel`, podobnie jak modyfikacja instancji zarządzanych obiektów za pomocą `SwiftDataKit`.

Bezpośrednie użycie tej metody spowoduje niezgodność między danymi podstawowymi `NSManagedObject` a danymi modelu `PersistentModel` na powierzchni styku. W związku z tym, przy modyfikacji danych należy być ostrożnym, aby uniknąć takiej niespójności. Właściwszym podejściem jest korzystanie z metod dostarczanych przez `PersistentModel` lub z innych narzędzi zarządzania danymi, które zachowują spójność między różnymi poziomami danych.



Oprócz zapewniania funkcjonalności podobnej do metod `get` i `set` w NSManagedObject, protokół `PersistentModel` przeprowadza również inne operacje za pomocą swoich metod `get` i `set`. Te operacje obejmują mapowanie właściwości `PersistentModel` na wiele właściwości `NSManagedObject` (kiedy właściwość jest złożonym typem), planowanie wątków (aby zapewnić bezpieczeństwo wątkowe) i inne zadania. Działa to na korzyść bardziej zaawansowanych operacji i zachowuje spójność między różnymi poziomami danych w modelu `PersistentModel`.



## Dodatkowe Informacje

Oprócz powyższego omówienia, protokół `PersistentModel` deklaruje kilka innych właściwości:

- `hasChanges`: wskazuje, czy wystąpiły zmiany, podobnie jak właściwość o tej samej nazwie w `NSManagedObject`.
- `isDeleted`: wskazuje, czy został dodany do listy do usunięcia w `ModelContext`, podobnie jak właściwość o tej samej nazwie w `NSManagedObject`.
- `modelContext`: obiekt `ModelContext`, do którego jest zarejestrowany bieżący `PersistentModel`. Jego wartość wynosi `nil` przed rejestracją poprzez `insert`.

W porównaniu z `NSManagedObject`, SwiftData obecnie udostępnia ograniczone API. W miarę ewolucji SwiftData, dla programistów mogą być dostępne więcej funkcji.

## Podsumowanie

Ten artykuł analizuje kod prostego modelu w SwiftData, wyjaśniając jego zasady implementacji, w tym konstrukcję modelu, generowanie instancji `PersistentModel` i mechanizm powiadamiania obserwatorów o zmianach w właściwościach. Proces analizy jest także ważnym sposobem na biegłość w korzystaniu z frameworku.

Podczas procesu analizy kodu nie tylko pogłębiamy nasze zrozumienie frameworku SwiftData, ale także uzyskujemy bardziej intuicyjną wiedzę o wielu nowych funkcjach języka Swift, co sprawia, że wszyscy zyskują.





