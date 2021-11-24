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

- Principaux avantages: 
    + Architecture adaptée pour séparer la vue de la logique métier par le biais de `ViewModel`.
    + `ViewController` allégés.
    + Tests facilités de la logique métier (Couverture du code par les tests renforcée)
    + Adaptée avec **SwiftUI**
    + Adaptée pour la programmation réactive (**RxSwift, Combine**)
- Inconvénients:
    + Les `ViewModel` deviennent massifs si la séparation des éléments ne sont pas maîtrisés, il est donc difficile de correctement découper ses structures, classes et méthodes afin de respecter le premier principe du SOLID étant le principe de responsabilité unique (SRP: Single Responsibility Principle). La variante **MVVM-C** qui utilise un `Coordinator` s'avère utile pour alléger les vues et gérer la navigation entre vues.
    + Complexe pour des projets de petite taille.
    + Inadaptée pour des projets de très grande taille, il sera préférable de passer à l'architecture **VIPER** ou à la **Clean Architecture**.
    + Maîtrise compliquée pour les débutants (notamment avec **UIKit**)

![MVVM](https://github.com/Kous92/Test-MVVM-Combine-UIKit-iOS/blob/main/MVVM.png)<br>

## <a name="combine"></a>Programmation réactive fonctionnelle avec Combine