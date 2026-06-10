enum Priority {
  basse,
  moyenne,
  haute,
  urgente;

  String get label {
    switch (this) {
      case Priority.basse: return 'Basse';
      case Priority.moyenne: return 'Moyenne';
      case Priority.haute: return 'Haute';
      case Priority.urgente: return 'Urgente';
    }
  }
}

enum Status {
  aFaire,
  enCours,
  terminee;

  String get label {
    switch (this) {
      case Status.aFaire: return 'À faire';
      case Status.enCours: return 'En cours';
      case Status.terminee: return 'Terminée';
    }
  }
}