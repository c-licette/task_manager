# Gestionnaire de Tâches Avancé

Application de gestion de tâches desktop construite avec Flutter, suivant une architecture hexagonale.

## Fonctionnalités

- **Projets** : création, suppression, organisation des tâches par projet
- **Aujourd'hui** : tâches dont la date d'échéance est aujourd'hui
- **Cette semaine** : tâches de la semaine en cours
- **CRUD complet** : créer, lire, modifier, supprimer des tâches avec confirmation
- **Priorités** : basse, moyenne, haute, urgente (indicateur visuel coloré)
- **Statuts** : à faire, en cours, terminée (clic pour cycler)
- **Thème clair/sombre** : bascule depuis les paramètres ou Ctrl+D, persisté
- **Recherche** : Ctrl+F pour filtrer les tâches par titre ou description
- **Persistance** : toutes les données sauvegardées localement via shared_preferences

## Raccourcis clavier

| Raccourci | Action |
|-----------|--------|
| Ctrl+N | Nouvelle tâche |
| Ctrl+F | Ouvrir/fermer la recherche |
| Ctrl+D | Basculer thème clair/sombre |

## Architecture
lib/
├── core/           # Enums (Priority, Status)
├── domain/         # Entités Freezed, interfaces repositories
├── application/    # Providers Riverpod
├── infrastructure/ # Implémentations repositories (SharedPreferences)
└── presentation/   # Pages, widgets, router

## Stack technique

- **Flutter** 3.x — framework desktop
- **Riverpod** 3.x — state management
- **auto_route** — navigation déclarative
- **Freezed** — entités immuables et sérialisables
- **shared_preferences** — persistance locale
- **window_manager** — gestion fenêtre desktop
- **mockito** — tests unitaires

## Lancer le projet

```bash
flutter pub get
dart run build_runner build
flutter run -d windows
```

## Tests

```bash
flutter test --reporter expanded
```

## CI/CD

GitHub Actions lance automatiquement les tests et le build Windows à chaque push sur `main`.