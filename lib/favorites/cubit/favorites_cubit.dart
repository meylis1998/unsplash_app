import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:models/models.dart';

class FavoritesCubit extends Cubit<List<Item>> {
  final Box<String> _box;

  static List<Item> _loadFrom(Box<String> box) {
    return box.values
        .map((jsonStr) {
          final decoded = jsonDecode(jsonStr);

          if (decoded is Map<String, dynamic>) {
            return Item.fromJson(decoded);
          }

          return null;
        })
        .whereType<Item>()
        .toList();
  }

  FavoritesCubit(Box<String> box) : _box = box, super(_loadFrom(box));

  void toggle(Item item) {
    final key = item.id;

    if (_box.containsKey(key)) {
      _box.delete(key);
    } else {
      _box.put(key, jsonEncode(item.toJson()));
    }

    emit(_loadFrom(_box));
  }
}
