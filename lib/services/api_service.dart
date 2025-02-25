import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inventory/services/constant.dart';
import '../models/item.dart';
import '../models/history.dart';

part "repository/auth_repository.dart";
part "repository/items_repository.dart";
part "repository/history_repository.dart";
part "repository/status_repository.dart";

final FlutterSecureStorage Storage = FlutterSecureStorage();

  Future<String?> getToken() async {
    return await Storage.read(key: 'token');
  }

