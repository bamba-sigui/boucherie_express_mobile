import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../../../products/data/models/product_model.dart';
import '../../../products/domain/entities/product.dart';

abstract class FavoritesRemoteDataSource {
  Future<List<ProductModel>> getFavorites();
  Future<bool> isFavorite(String productId);
  Future<void> toggleFavorite(Product product);
}

@LazySingleton(as: FavoritesRemoteDataSource)
class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  FavoritesRemoteDataSourceImpl(this.firestore, this.auth);

  String? get _userId => auth.currentUser?.uid;

  @override
  Future<List<ProductModel>> getFavorites() async {
    if (_userId == null) return [];

    final snapshot = await firestore
        .collection('users')
        .doc(_userId)
        .collection('favorites')
        .get();

    return snapshot.docs
        .map((doc) => ProductModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  @override
  Future<bool> isFavorite(String productId) async {
    if (_userId == null) return false;

    final doc = await firestore
        .collection('users')
        .doc(_userId)
        .collection('favorites')
        .doc(productId)
        .get();

    return doc.exists;
  }

  @override
  Future<void> toggleFavorite(Product product) async {
    if (_userId == null) return;

    final docRef = firestore
        .collection('users')
        .doc(_userId)
        .collection('favorites')
        .doc(product.id);

    final doc = await docRef.get();
    if (doc.exists) {
      await docRef.delete();
    } else {
      await docRef.set(
        (product as ProductModel).toJson(),
      ); // Assuming it's already a model or we cast it
    }
  }
}
