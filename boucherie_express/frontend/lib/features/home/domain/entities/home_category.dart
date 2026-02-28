import 'package:equatable/equatable.dart';

/// Représente une catégorie de produits sur l'écran d'accueil.
class HomeCategory extends Equatable {
  final String id;
  final String name;
  final String icon;

  const HomeCategory({required this.id, required this.name, this.icon = ''});

  @override
  List<Object?> get props => [id, name, icon];
}
