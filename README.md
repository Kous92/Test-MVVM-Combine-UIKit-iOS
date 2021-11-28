# iOS (Swift 5): Test MVVM avec Combine et UIKit

L'architecture **MVVM** et la programmation réactive fonctionnelle sont très utlisées dans le développement iOS en entreprise. Ici, voici un exemple où j'implémente l'architecture **MVVM** avec **Combine**, le framework officiel d'Apple, étant l'équivalent du célèbre framework **RxSwift**. Le tout avec UIKit.

## Plan de navigation
- [Architecture MVVM](#mvvm)
- [Programmation réactive fonctionnelle avec Combine](#combine)
- [Exemple](#example)

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

Il faut par contre aussi utiliser des conteneurs qui vont annuler l'abonnement des observateurs (`Cancellable` avec **Combine**) et gérer les désallocations mémoires afin d'éviter les fuites de mémoire (**memory leak**).

La programmation réactive fonctionnelle reste l'une des notions les plus complexes à apprendre et à maîtriser (surtout par soi-même en autodidacte), la définition en elle-même de base est complexe à comprendre et à assimiler.
Mais une fois maîtrisée, ce concept devient alors une arme redoutable pour écrire des fonctionnalités asynchrones de façon optimale (chaînage d'appels HTTP, vérification d'un élement par serveur avant validation, ...), d'avoir une interface réactive qui se met à jour automatiquement à la réception d'événements en temps réel depuis le flux de données, de remplacer la délégation (faire passer des données de la vue secondaire à la vue principale, ...), ... **De plus, le fait de savoir utiliser la programmation réactive est également indispensable pour intégrer un projet d'application iOS dans une entreprise, étant l'une des compétences les plus exigées.**

**Combine** nécessite **iOS 13** ou plus pour toute application iOS. L'avantage de **Combine** est au niveau de la performance et de l'optimisation, étant donné que tout est géré par Apple, et qu'Apple peut donc aller au plus profond des éléments du système d'exploitation, chose que les développeurs de frameworks tiers ne peuvent pas faire. La dépendance des frameworks externes y est donc réduite.

Comparé à **RxSwift**, **Combine** reste moins complet en terme d'opérateurs pour des cas spécifiques et avancés. Aussi **Combine** n'est pas suffisamment adaptée pour une utilisation avec **UIKit** notamment pour les liens avec les composants UI, chose qui est plus complète avec **RxSwift**.

## <a name="example"></a>Exemple

Ici, je propose comme exemple une actualisation réactive en temps réel du `TableView` des joueurs du PSG avec l'architecture MVVM. Cette actualisation se fait de plusieurs façons:
1. Au lancement de l'application, par le biais d'un appel HTTP `GET` d'un fichier JSON en ligne. Les données téléchargées y sont donc disposées dans des `ViewModel` dédiées aux `TableViewCell`.
2. Lors de la recherche d'un joueur, le filtrage va s'appliquer automatiquement en fonction du texte saisi et actualiser en temps réel la liste visuelle avec les données filtrées.

![Recherche réactive](https://github.com/Kous92/Test-MVVM-Combine-UIKit-iOS/blob/main/ReactiveSearch.gif)

3. En tapant sur le bouton du filtrage, un `ViewController` apparaît pour permettre la sélection d'un filtre afin d'y actualiser la liste de la vue principale parmi les critères possibles: 
    + Gardiens de buts
    + Défenseurs
    + Milieux de terrain
    + Attaquants
    + Joueurs formés au PSG (les titis Parisiens) 🔵🔴
    + Par ordre alphabétique
    + Par numéro dans l'ordre croissant.

![Filtrage réactif](https://github.com/Kous92/Test-MVVM-Combine-UIKit-iOS/blob/main/ReactiveFilters.gif)