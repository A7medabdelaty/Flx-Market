import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flx_market/Core/error_handling/failure.dart';
import 'package:flx_market/Core/services/firebase/base_firestore_service.dart';
import 'package:flx_market/Core/services/firebase/query_filter.dart';

class FirestoreService extends BaseFirestoreService {
  static FirestoreService? _instance;

  FirestoreService._({required FirebaseFirestore firestore}) : super(firestore);

  static FirestoreService get instance {
    _instance ??= FirestoreService._(firestore: FirebaseFirestore.instance);
    return _instance!;
  }

  @override
  Future<void> create(
    String collection,
    String? id,
    Map<String, dynamic> data,
  ) async {
    try {
      final docRef = id != null
          ? firestore.collection(collection).doc(id)
          : firestore.collection(collection).doc();

      await docRef.set({...data, 'id': docRef.id});
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<T?> read<T>(
    String collection,
    String id,
    T Function(Map<String, dynamic>) fromMap,
  ) async {
    try {
      final doc = await firestore.collection(collection).doc(id).get();
      if (!doc.exists) return null;
      return fromMap(doc.data()!);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> update(
    String collection,
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      await firestore.collection(collection).doc(id).update(data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> delete(String collection, String id) async {
    try {
      await firestore.collection(collection).doc(id).delete();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<T>> query<T>(
    String collection,
    T Function(Map<String, dynamic>) fromMap, {
    List<QueryFilter>? filters,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) async {
    try {
      Query query = firestore.collection(collection);

      if (filters != null) {
        for (final filter in filters) {
          switch (filter.operator) {
            case FilterOperator.isEqualTo:
              query = query.where(filter.field, isEqualTo: filter.value);
              break;
            case FilterOperator.isNotEqualTo:
              query = query.where(filter.field, isNotEqualTo: filter.value);
              break;
            case FilterOperator.isLessThan:
              query = query.where(filter.field, isLessThan: filter.value);
              break;
            case FilterOperator.isLessThanOrEqualTo:
              query = query.where(
                filter.field,
                isLessThanOrEqualTo: filter.value,
              );
              break;
            case FilterOperator.isGreaterThan:
              query = query.where(filter.field, isGreaterThan: filter.value);
              break;
            case FilterOperator.isGreaterThanOrEqualTo:
              query = query.where(
                filter.field,
                isGreaterThanOrEqualTo: filter.value,
              );
              break;
            case FilterOperator.arrayContains:
              query = query.where(filter.field, arrayContains: filter.value);
              break;
            case FilterOperator.arrayContainsAny:
              query = query.where(filter.field, arrayContainsAny: filter.value);
              break;
            case FilterOperator.whereIn:
              query = query.where(filter.field, whereIn: filter.value);
              break;
            case FilterOperator.whereNotIn:
              query = query.where(filter.field, whereNotIn: filter.value);
              break;
          }
        }
      }

      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: descending);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs
          .map((doc) => fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> get(String collection, String id) async {
    try {
      return await firestore.collection(collection).doc(id).get();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> getAll(String collection) async {
    try {
      return await firestore.collection(collection).get();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> add(String collection, Map<String, dynamic> data) async {
    try {
      await firestore.collection(collection).add(data);
    } catch (e) {
      throw _handleError(e);
    }
  }
}

ServerFailure _handleError(dynamic error) {
  if (error is FirebaseException) {
    return ServerFailure('Firestore error (${error.code}): ${error.message}');
  }
  return ServerFailure('Firestore operation failed: ${error.toString()}');
}
