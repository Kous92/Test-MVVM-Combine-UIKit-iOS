# iOS (Swift 5): Test MVVM avec Combine et UIKit

L'architecture **MVVM** et la programmation réactive fonctionnelle sont très utlisées dans le développement iOS en entreprise. Ici, voici un exemple où j'implémente l'architecture **MVVM** avec **Combine**, le framework officiel d'Apple, étant l'équivalent du célèbre framework **RxSwift**. Le tout avec UIKit.

## Plan de navigation
- [Architecture MVVM](#mvvm)
- [Programmation réactive fonctionnelle avec Combine](#combine)
- [Exemple](#example)
- [Éléments utilisés avec Combine]()
    + [Actualisation](#update)
    + [Recherche](#search)
    + [Filtrage](#filtering)
    + [Vue détaillée](#details)

## <a name="mvvm"></a>Architecture MVVM

L'architecture MVVM (Model View ViewModel) est un design pattern qui permet de séparer la logique métier et les interactions de l'interface utilisateur (UI). En partant du MVC, la vue et le contrôleur ne font désormais plus qu'un en MVVM. En iOS avec UIKit, les `ViewController` appartiennent à la partie vue (View). De plus, les `ViewController` n'ont plus à gérer la logique métier et n'ont plus de références avec les modèles de données.

La nouveauté étant la vue modèle (ViewModel) est que celle-ci a la responsabilité de gérer la logique métier et de mettre à jour la vue en disposant d'attributs que la vue affichera par le biais du data binding (liaison de données).

Le data binding est un lien entre la vue et la vue modèle, où la vue par le biais des interactions avec l'utilisateur va envoyer un signal à la vue modèle afin d'effectuer une logique métier spécifique. Ce signal va donc permettre la mise à jour des données du modèle et ainsi permettre l'actualisation automatique de la vue. Le data binding en iOS peut se faire par:
- Délégation
- Callbacks (closures)
- Programmation réactive fonctionnelle (**RxSwift, Combine**)

### Avantages et inconvénients du MVVM
- Principaux avantages: 
    + Architecture adaptée pour séparer la vue de la logique métier par le biais de `ViewModel`.
    + `ViewController` allégés.
    + Tests facilités de la logique métier (Couverture du code par les tests renforcée)
    + Adaptée avec **SwiftUI**
    + Adaptée pour la programmation réactive (**RxSwift, Combine**)
- Inconvénients:
    + Les `ViewModel` deviennent massifs si la séparation des éléments ne sont pas maîtrisés, il est donc difficile de correctement découper ses structures, classes et méthodes afin de respecter le premier principe du **SOLID** étant le principe de responsabilité unique (SRP: Single Responsibility Principle). La variante **MVVM-C** qui utilise un `Coordinator` s'avère utile pour alléger les vues et gérer la navigation entre vues.
    + Potentiellement complexe pour des projets de très petite taille.
    + Inadaptée pour des projets de très grande taille, il sera préférable de passer à l'architecture **VIPER** ou à la **Clean Architecture (VIP, MVVM, Clean Swift, ...)**. **MVVM** est donc intégrable dans une **Clean Architecture**.
    + Maîtrise compliquée pour les débutants (notamment avec **UIKit**)

![MVVM](https://github.com/Kous92/Test-MVVM-Combine-UIKit-iOS/blob/main/MVVM.png)<br>

## <a name="combine"></a>Programmation réactive fonctionnelle avec Combine

La programmation réactive est un paradigme de programmation asynchrone, axé sur les flux de données (data streams) et la propagation du changement. Ce modèle est basé sur le pattern de l'observateur où un flux créé des données à différents moments dans le temps, des actions y sont par la suite exécutées de manière ordonnée.

Ces flux sont modélisés par des `Observable` (des `Publishers` avec **Combine**) qui vont émettre des événements qui sont de 3 types:
- Valeur
- Erreur
- Signal de fin (le flux n'a plus de données à envoyer)

Comme dans la programmation événementielle, la programmation réactive utilise aussi des observateurs ou `Observers` (des `Subscribers` avec **Combine**) qui vont s'abonner aux événements émis par les observables, recevoir ainsi les données du flux en temps réel et exécuter les actions en fonction du signal.

Le 3ème élément de la programmation réactive se nomme les sujets (des `Subjects` avec **Combine**) qui sont à la fois observable (`Observable`) et observateurs (`Observer`) qui peuvent donc émettre et recevoir des événements.

On parle de programmation réactive fonctionnelle (on dit aussi **FRP: Functional Reactive Programming**) le fait de combiner des flux de données avec des opérateurs de type fonction pour traiter les données (mise en forme, modification de valeurs, filtrage, association de plusieurs flux en un seul, ...), comme ceux des tableaux avec:
- `map`
- `filter`
- `flatMap`
- `compactMap`
- `reduce`
- Et d'autres...

La programmation réactive fonctionnelle est donc parfaitement adaptée pour le data binding dans l'architecture MVVM avec un observable dans la vue modèle pour émettre les événements reçus notamment asynchrones (appels réseau, actualisation GPS, mise à jour des données du modèle, ...) et un observateur dans la vue qui va s'abonner à l'observable de la vue modèle.

Il faut par contre aussi utiliser des conteneurs qui vont annuler l'abonnement des observateurs (`AnyCancellable` avec **Combine**) et gérer les désallocations mémoires afin d'éviter les fuites de mémoire (**memory leak**).

La programmation réactive fonctionnelle reste l'une des notions les plus complexes à apprendre et à maîtriser (surtout par soi-même en autodidacte), la définition en elle-même de base est complexe à comprendre et à assimiler.
Mais une fois maîtrisée, ce concept devient alors une arme redoutable pour écrire des fonctionnalités asynchrones de façon optimale (chaînage d'appels HTTP, vérification d'un élement par serveur avant validation, ...), d'avoir une interface réactive qui se met à jour automatiquement à la réception d'événements en temps réel depuis le flux de données, de remplacer la délégation (faire passer des données de la vue secondaire à la vue principale, ...), ... **De plus, le fait de savoir utiliser la programmation réactive est également indispensable pour intégrer un projet d'application iOS dans une entreprise, étant l'une des compétences les plus exigées.**

**Combine** nécessite **iOS 13** ou plus pour toute application iOS. L'avantage de **Combine** est au niveau de la performance et de l'optimisation, étant donné que tout est géré par Apple, et qu'Apple peut donc aller au plus profond des éléments du système d'exploitation, chose que les développeurs de frameworks tiers ne peuvent pas faire. La dépendance des frameworks externes y est donc réduite.

Comparé à **RxSwift**, **Combine** reste moins complet en terme d'opérateurs pour des cas spécifiques et avancés. Aussi **Combine** n'est pas suffisamment adaptée pour une utilisation avec **UIKit** notamment pour les liens avec les composants UI, chose qui est plus complète avec **RxSwift**.

## <a name="example"></a>Exemple

Ici, je propose comme exemple une actualisation réactive en temps réel du `TableView` des joueurs du PSG avec l'architecture MVVM. Cette actualisation se fait de plusieurs façons:
1. Au lancement de l'application, par le biais d'un appel HTTP `GET` d'un fichier JSON en ligne. Les données téléchargées y sont donc disposées dans des `ViewModel` dédiées aux `TableViewCell`.
2. Lors de la recherche d'un joueur, le filtrage va s'appliquer automatiquement en fonction du texte saisi et actualiser en temps réel la liste visuelle avec les données filtrées.

<img src="https://github.com/Kous92/Test-MVVM-Combine-UIKit-iOS/blob/main/ReactiveSearch.gif" width="350">

3. En tapant sur le bouton du filtrage, un `ViewController` apparaît pour permettre la sélection d'un filtre afin d'y actualiser la liste de la vue principale parmi les critères possibles: 
    + Gardiens de buts
    + Défenseurs
    + Milieux de terrain
    + Attaquants
    + Joueurs formés au PSG (les titis Parisiens) 🔵🔴
    + Par ordre alphabétique
    + Par numéro dans l'ordre croissant.

<img src="https://github.com/Kous92/Test-MVVM-Combine-UIKit-iOS/blob/main/ReactiveFilters.gif" width="350">

4. En tapant sur une cellule, un `ViewController` apparaît pour y afficher les détails du joueur sélectionné (image, nom, numéro, position, formé ou non au PSG, date de naissance, pays, taille, poids, nombre de matches joués et nombre de buts)

<img src="https://github.com/Kous92/Test-MVVM-Combine-UIKit-iOS/blob/main/ReactiveDetails.gif" width="350">

**ICI C'EST PARIS 🔵🔴**

### Les éléments utilisés avec Combine dans cet exemple

#### 1) <a name="update"></a> L'actualisation réactive

Pour l'actualisation réactive, j'utilise un sujet dans ma vue modèle (ici `PSGPlayersViewModel`). Lorsque l'appli est lancée et qu'elle fait l'appel HTTP depuis un serveur, le sujet va émettre un événement de réussite si le téléchargement est effectué et si la liste des vues modèles des `TableViewCell` est mise à jour. Le sujet de mise à jour `updateResult` est un `PassthroughSubject`. Un sujet a 2 types dans sa déclaration: une valeur et un élément pour les erreurs (`Never` s'il n'y a pas d'erreur à gérer). Ici, c'est le cas s'il y a une erreur, notamment au lancement de l'application lors de l'appel HTTP (aucune connexion internet, erreur 404, décodage JSON en objets,...). La particularité du `PassthroughSubject` est qu'il n'y a pas besoin de donner une valeur initiale à émettre.

```swift
import Combine

final class PSGPlayersViewModel {
    // Les sujets, ceux qui émettent et reçoivent des événements
    var updateResult = PassthroughSubject<Bool, APIError>()
}
```

Lors du téléchargement, si les données sont mise à jour, on utilise la méthode `send(value)` pour émettre un événement.
S'il y a une erreur, on utilise `send(completion: .failure(error)`. Sinon, on envoie la valeur.
```swift
import Combine

final class PSGPlayersViewModel {
    ...
    func getPlayers() {
        apiService.fetchPlayers { [weak self] result in
            switch result {
            case .success(let response):
                self?.playersData = response
                self?.parseData()
            case .failure(let error):
                print(error.rawValue)
                self?.updateResult.send(completion: .failure(error)) // On émet une erreur
            }
        }
    }

    private func parseData() {
        guard let data = playersData, data.players.count > 0 else {
            // Pas de joueurs téléchargés
            updateResult.send(false)
            
            return
        }
        
        data.players.forEach { playersViewModel.append(PSGPlayerCellViewModel(player: $0)) }
        filteredPlayersViewModels = playersViewModel
        updateResult.send(true) // On notifie la vue que les données sont mises à jour afin d'actualiser le TableView
    }
}
```

Au niveau du `ViewController`, on utilise la propriété `updateResult` afin de faire le data binding entre la vue et la vue modèle. Étant donné, que les opérations en réactifs sont asynchrones, on commence avec `receive(on: )` pour préciser dans quel thread on va recevoir la valeur. Les opérations UI ne doivent se faire que dans le thread principal, on va donc mettre en paramètre `RunLoop.main` ou `DispatchQueue.main` (les 2 sont similaires).

Ensuite, l'abonnement pour y traiter les événements se fait avec `sink(completion: , receive: value)`. Dans `completion`, c'est là où on traite 2 situations, soit si le flux s'arrête d'émettre, soit s'il y a une erreur. Dans `receiveValue`, c'est là qu'on peut faire les opérations UI comme actualiser le `TableView`. On stocke ensuite l'abonnement dans une liste d'`AnyCancellable` afin d'éviter les fuites de mémoire.
```swift
final class MainViewController: UIViewController {
    ...
    private var subscriptions = Set<AnyCancellable>()
    private var viewModel = PSGPlayersViewModel()

    private func setBindings() {
        func setUpdateBinding() {
            // La vue reçoit en temps réel l'événement émis par le sujet
            viewModel.updateResult.receive(on: RunLoop.main).sink { completion in
                switch completion {
                case .finished:
                    print("OK: terminé")
                case .failure(let error):
                    // On peut afficher par exemple une alerte pour notifier explicitement d'une erreur
                    print("Erreur reçue: \(error.rawValue)")
                }
            } receiveValue: { [weak self] updated in
                // Les données de la vue modèle sont mise à jour, on actualise la liste
                self?.loadingSpinner.stopAnimating()
                self?.loadingSpinner.isHidden = true
                
                if updated {
                    self?.updateTableView()
                } else {
                    self?.displayNoResult()
                }
            }.store(in: &subscriptions)
        }
        
        setUpdateBinding()
    }
}
```
#### 2) <a name="search"></a> La recherche réactive

Pour la recherche réactive, j'utilise 2 éléments dans ma vue modèle (ici `PSGPlayersViewModel`). Je reprends le sujet d'actualisation `updateResult`, et une propriété `@Published` pour la recherche qui reçoit en temps réel un `String` afin de rechercher le joueur voulu. Cet élément fera office d'observateur qui va s'abonner aux événements de la vue. Il faudra également utiliser un `AnyCancellable` pour gérer l'annulation des abonnements et éviter toute fuite mémoire.

```swift
import Combine

final class PSGPlayersViewModel {
    // Les sujets, ceux qui émettent et reçoivent des événements
    var updateResult = PassthroughSubject<Bool, APIError>()
    @Published var searchQuery = ""

    // Pour la gestion mémoire et l'annulation des abonnements
    private var subscriptions = Set<AnyCancellable>()
}
```

Ici, on définit le data binding avec la vue, où l'observeur `searchQuery` s'abonne aux événements de la vue. La propriété étant un `Publisher<String>`, il faut précéder le nom de la variable avec un `$` pour recevoir les événements. Dans le cadre de la recherche, on va d'abord recevoir dans le thread principal avec `.receive(on: RunLoop.main)`, ignorer les doublons d'événements avec `.removeDuplicates()`. Ensuite, il ne faut pas surcharger le flux du thread principal en temporisant la réception d'événements avec `.debounce(for: .seconds(0.5), scheduler: RunLoop.main)`. La réception de la valeur pour y effectuer l'action se fait avec `sink(receiveValue: )`. On stocke ensuite l'abonnement dans une liste d'`AnyCancellable` afin d'éviter les fuites de mémoire.

```swift
final class PSGPlayersViewModel {
    ...
    private func setBindings() {
        $searchQuery
            .receive(on: RunLoop.main)
            .removeDuplicates()
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] value in
                self?.searchPlayer()
            }.store(in: &subscriptions)
    }
}
```

Dans le `ViewController`, on fait la même chose que dans la vue modèle avec un `Publisher<String>` (`@Published searchQuery`). Dans le traitement de l'abonnement avec `sink(receiveValue: )`, on affecte la valeur recherchée à l'observeur de la vue modèle. La valeur reçue dans la vue modèle va automatiquement déclencher la fonction `searchPlayer()`. Dans la fonction `textDidChange` de `UISearchBarDelegate`, dès lors que le texte de la barre de recherche est modifié, l'action dans le `sink(receiveValue: )` va se déclencher.

```swift
final class MainViewController: UIViewController {
    ...
    @Published private(set) var searchQuery = ""
    private var subscriptions = Set<AnyCancellable>()
    private var viewModel = PSGPlayersViewModel()

    private func setBindings() {
        func setSearchBinding() {
            $searchQuery
                .receive(on: RunLoop.main)
                .removeDuplicates()
                .sink { [weak self] value in
                    print(value)
                    self?.viewModel.searchQuery = value
                }.store(in: &subscriptions)
        }

        func setUpdateBinding() {
            ...
        }
        
        setSearchBinding()
        setUpdateBinding()
    }
}

extension MainViewController: UISearchBarDelegate {
    // C'est ici que lorsqu'on modifie le texte de la barre de recherche. L'abonnement va automatiquement envoyer une nouvelle valeur à l'observeur de la vue modèle.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchQuery = searchText
    }
}
```

Et bien sûr, la fonction `searchPlayer()` émettra depuis le sujet `updateResult` un signal d'actualisation avec `true` s'il y a des données après filtrage, `false` si la liste est vide.
```swift
final class PSGPlayersViewModel {
    ...
    private func searchPlayer() {
        guard !searchQuery.isEmpty else {
            activeFilter = .noFilter
            filteredPlayersViewModels = playersViewModel
            updateResult.send(true)
            
            return
        }
        
        filteredPlayersViewModels = playersViewModel.filter { $0.name.lowercased().contains(searchQuery.lowercased()) }
        
        if filteredPlayersViewModels.count > 0 {
            updateResult.send(true)
        } else {
            updateResult.send(false)
        }
    }
}
```

#### 3) <a name="filtering"></a> Le filtrage réactif

Dans le cadre du filtrage, on utiliserait en temps normal le pattern de la délégation pour recevoir des données dans le sens inverse de `FilterViewController` vers `MainViewController`. Là encore une fois, avec une vue modèle pour le filtrage, on va y effectuer le data binding depuis la vue principale lorsque l'utilisateur tape sur le bouton du filtre. Dans la vue modèle, un `PassthroughSubject` est aussi utilisé, excepté qu'ici on ne traite pas d'erreur vu qu'il y en a pas, on utilise donc `Never`. Lorsque le filtre est sélectionné, on va utiliser la méthode `send(value: )` pour y émettre le filtre sélectionné. De plus, on va récupérer le filtre actuel à l'initialisation.

```swift
final class PSGPlayersFiltersViewModel {
    let selectedFilter = PassthroughSubject<PlayerFilter, Never>()
    var actualFilter: PlayerFilter = .noFilter

    ...
    
    func setFilter(savedFilter: PlayerFilter = .noFilter) {
        actualFilter = savedFilter
        selectedFilter.send(savedFilter)
    }
}
```

Dans `FilterViewController`, lorsqu'une cellule du `TableView` est sélectionnée, un événement sera émis à la vue principale par le biais de `selectedFilters` dans la vue modèle, avec `.send(value: )`

```swift
final class PSGPlayerFiltersViewController: UIViewController {
    let viewModel = PSGPlayersFiltersViewModel()
    ...
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ...
        
        // On garde en mémoire la catégorie séléctionnée
        actualSelectedIndex = selected
        viewModel.actualFilter = viewModel.filters[indexPath.row]
        viewModel.selectedFilter.send(viewModel.filters[indexPath.row])
}
```

Afin que cela ait effet dans la vue principale, les liens se définissent avec une référence vers `FilterViewController` depuis `MainViewController` avec `filterViewController.viewModel`. Pour l'application du filtre, la méthode `.handleEvents(receiveOutput:)` est utilisée (cela remplace la délégation) pour y recevoir les données en sens inverse et effectuer les actions. `sink(value: )` est utilisé par la suite mais il n'y a rien de particulier à faire. On stocke ensuite l'abonnement dans une liste d'`AnyCancellable` afin d'éviter les fuites de mémoire. De plus, on définit un data binding avec la vue modèle pour le filtrage actif, comme pour la recherche, en y modifiant la valeur par le filtre sélectionné dans l'abonnement.

```swift
final class MainViewController: UIViewController {
    ...
    private var subscriptions = Set<AnyCancellable>()
    private var viewModel = PSGPlayersViewModel()

    private func setBindings() {
        func setSearchBinding() {
            ...
        }

        func setUpdateBinding() {
            ...
        }
        
        func setActiveFilterBinding() {
            viewModel.$activeFilter
                .receive(on: RunLoop.main)
                .removeDuplicates()
                .sink { [weak self] value in
                    print(value)
                    self?.viewModel.activeFilter = value
                }.store(in: &subscriptions)
        }

        setSearchBinding()
        setUpdateBinding()
        setActiveFilterBinding()
    }

    @IBAction func filterButton(_ sender: Any) {
        guard let filterViewController = storyboard?.instantiateViewController(withIdentifier: "filtersViewController") as? PSGPlayerFiltersViewController else {
            fatalError("Le ViewController n'est pas détecté dans le Storyboard.")
        }
        
        func setFilterVCBinding() {
            // On garde en mémoire le filtre sélectionné
            filterViewController.viewModel.setFilter(savedFilter: viewModel.activeFilter)
            
            // Ici, on remplace la délégation par un binding par le biais d'un PassthroughSubject
            filterViewController.viewModel.selectedFilter
                .handleEvents(receiveOutput: { [weak self] filter in
                    self?.appliedFilterLabel.text = filter.rawValue
                    self?.viewModel.activeFilter = filter
                }).sink { _ in }
                .store(in: &subscriptions)
        }
        
        setFilterVCBinding()
        filterViewController.modalPresentationStyle = .fullScreen
        self.present(filterViewController, animated: true, completion: nil)
    }
}
```

Ensuite, on fait la même chose qu'avec la recherche, en utilisant un `Publisher<PlayerFilter>` dédié pour le filtre choisi. L'abonnement depuis la vue déclenchant automatiquement la fonction `applyFilter()`, le filtrage s'effectue, la liste mise à jour par l'émission de l'événement depuis le sujet `updateResult`.

```swift
final class PSGPlayersViewModel {
    var updateResult = PassthroughSubject<Bool, APIError>()
    @Published var activeFilter: PlayerFilter = .noFilter
    ...
    private func setBindings() {
        $activeFilter.receive(on: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] value in
                self?.applyFilter()
            }.store(in: &subscriptions)
    }
    ...
    private func applyFilter() {
        switch activeFilter {
        case .noFilter:
            filteredPlayersViewModels = playersViewModel
        case .numberOrder:
            // Tri par numéro dans l'ordre croissant
            filteredPlayersViewModels = playersViewModel.sorted(by: { player1, player2 in
                return player1.number < player2.number
            })
        case .goalkeepers:
            // Les gardiens de but
            filteredPlayersViewModels = playersViewModel.filter { $0.position == "Gardien de but" }
        case .defenders:
            // Les défenseurs
            filteredPlayersViewModels = playersViewModel.filter { $0.position == "Latéral droit" || $0.position == "Défenseur central" || $0.position == "Défenseur" || $0.position == "Latéral gauche" }
        case .midfielders:
            // Les milieux de terrain
            filteredPlayersViewModels = playersViewModel.filter { $0.position == "Milieu" || $0.position == "Milieu offensif" || $0.position == "Milieu défensif" }
        case .forwards:
            // Les attaquants
            filteredPlayersViewModels = playersViewModel.filter { $0.position == "Attaquant" || $0.position == "Avant-centre" }
        case .fromPSGFormation:
            filteredPlayersViewModels = playersViewModel.filter { $0.player.fromPSGformation }
        case .alphabeticalOrder:
            filteredPlayersViewModels = playersViewModel.sorted(by: { player1, player2 in
                return player1.name < player2.name
            })
        }
        
        updateResult.send(true)
    }
}
```

#### 4) <a name="details"></a> La vue détaillée

Pour la vue détaillée qui affiche des détails, le `ViewController` dédié sera lié avec la vue modèle dédié par le biais de variables observeurs dans la vue modèle. Dès lors que l'injection de dépendance sera effectuée, la vue modèle va envoyer un événement à chaque élément visuel pour actualiser la vue.

L'injection de dépendance s'effectue lors de la sélection de la cellule dans la liste avec la méthode `configure(with: viewModel)` par le biais de la vue modèle de la cellule.
```swift
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailsViewController = storyboard?.instantiateViewController(withIdentifier: "detailsViewController") as? PSGPlayerDetailsViewController else {
            fatalError("Le ViewController n'est pas détecté dans le Storyboard.")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        // Injection de dépendance
        detailsViewController.configure(with: PSGPlayerDetailsViewModel(player: viewModel.filteredPlayersViewModels[indexPath.row].player))
        detailsViewController.modalPresentationStyle = .fullScreen
        present(detailsViewController, animated: true, completion: nil)
    }
}
```

Lorsque la vue est chargée, les liens entre les composants UI et la vue modèle s'effectuent.
```swift
final class PSGPlayerDetailsViewController: UIViewController {
    ...
    private var viewModel: PSGPlayerDetailsViewModel!
    private var subscriptions: Set<AnyCancellable> = []
    ...
    override func viewDidLoad() {
        super.viewDidLoad()
        setBindings()
    }

    // Injection de dépendance
    func configure(with viewModel: PSGPlayerDetailsViewModel) {
        self.viewModel = viewModel
    }
}
```

Dans la vue modèle, chaque champ attribué à un texte visuel ou une image est un observeur (avec `@Published`). Ici, on ne modifiera leurs contenus que depuis l'initialiseur lors de l'injection de dépendance, par le biais de la méthode `configure(with: viewModel)` du `ViewController`.
```swift
// MARK: - Vue modèle d'un joueur du PSG (tous les éléments)
final class PSGPlayerDetailsViewModel: PSGPlayerDetails {
    let player: PSGPlayer
    
    @Published private(set) var image: String
    @Published private(set) var number: Int
    @Published private(set) var name: String
    @Published private(set) var position: String
    @Published private(set) var fromPSGformation: Bool
    @Published private(set) var country: String
    @Published private(set) var size: Int
    @Published private(set) var weight: Int
    @Published private(set) var birthDate: String
    @Published private(set) var goals: Int
    @Published private(set) var matches: Int
    
    // Injection de dépendance
    init(player: PSGPlayer) {
        self.player = player
        self.image = player.imageURL
        self.number = player.number
        self.name = player.name
        self.position = player.position
        self.fromPSGformation = player.fromPSGformation
        self.country = player.country
        self.size = player.size
        self.weight = player.weight
        self.birthDate = player.birthDate
        self.goals = player.goals
        self.matches = player.matches
    }
}
```

Ensuite, on définit les data bindings des composants UI avec les champs de la vue modèle. On utilise `$` de l'attribut ciblé suivi de `.receive(on: RunLoop.main)` pour effectuer l'actualisation depuis le thread principal. On utilise ensuite l'opérateur `compactMap` pour la mise en forme du contenu à afficher (`compactMap` lorsqu'il y a des optionnels, `map` sinon). Ensuite, on utilise l'autre méthode d'abonnement pour y effectuer la modification du texte visuel avec `.assign(to: \.text, on: label)`. On stocke ensuite l'abonnement dans une liste d'`AnyCancellable` afin d'éviter les fuites de mémoire.
Concernant l'image, on utilisera `sink(receiveValue: )` pour y actualiser l'image de façon asynchrone avec l'URL récupérée depuis `compactMap`.
```swift
extension PSGPlayerDetailsViewController {
    // L'actualisation de la vue sera automatique.
    private func setBindings() {
        viewModel.$number
            .receive(on: RunLoop.main)
            .compactMap { String($0) }
            .assign(to: \.text, on: playerNumberLabel)
            .store(in: &subscriptions)
        
        viewModel.$name
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .assign(to: \.text, on: playerNameLabel)
            .store(in: &subscriptions)
        
        viewModel.$position
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .assign(to: \.text, on: playerPositionLabel)
            .store(in: &subscriptions)
        
        viewModel.$size
            .receive(on: RunLoop.main)
            .compactMap { "Taille: " + String($0) + " cm" }
            .assign(to: \.text, on: playerSizeLabel)
            .store(in: &subscriptions)
        
        viewModel.$weight
            .receive(on: RunLoop.main)
            .compactMap { "Poids: " + String($0) + " kg" }
            .assign(to: \.text, on: playerWeightLabel)
            .store(in: &subscriptions)
        
        viewModel.$country
            .receive(on: RunLoop.main)
            .compactMap { "Pays: " + $0 }
            .assign(to: \.text, on: playerCountryLabel)
            .store(in: &subscriptions)
        
        viewModel.$birthDate
            .receive(on: RunLoop.main)
            .compactMap { "Date de naissance: " + $0 }
            .assign(to: \.text, on: playerBirthdateLabel)
            .store(in: &subscriptions)
        
        viewModel.$fromPSGformation
            .receive(on: RunLoop.main)
            .compactMap { "Formé au PSG: " + ($0 ? "oui": "non") }
            .assign(to: \.text, on: playerTrainedLabel)
            .store(in: &subscriptions)
        
        viewModel.$matches
            .receive(on: RunLoop.main)
            .compactMap { "Joués: " + String($0) }
            .assign(to: \.text, on: playerPlayedMatchesLabel)
            .store(in: &subscriptions)
        
        viewModel.$goals
            .receive(on: RunLoop.main)
            .compactMap { "Buts: " + String($0) }
            .assign(to: \.text, on: playerGoalsLabel)
            .store(in: &subscriptions)
        
        // L'image va s'actualiser de façon réactive
        viewModel.$image
            .receive(on: RunLoop.main)
            .compactMap{ URL(string: $0) }
            .sink { [weak self] url in
                self?.playerImage.loadImage(fromURL: url)
        }.store(in: &subscriptions)
    }
}
```