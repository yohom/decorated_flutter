import 'dart:convert';

import 'package:flutter/services.dart';

class CityRegion {
  const CityRegion({
    required this.code,
    required this.name,
    this.children = const [],
  });

  factory CityRegion.fromJson(Map<String, dynamic> json) {
    return CityRegion(
      code: json['code'] as String,
      name: json['name'] as String,
      children: [
        for (final child in json['children'] as List<dynamic>? ?? const [])
          CityRegion.fromJson(child as Map<String, dynamic>),
      ],
    );
  }

  static List<CityRegion> listFromJsonString(String source) {
    final json = jsonDecode(source) as List<dynamic>;
    return [
      for (final item in json)
        CityRegion.fromJson(item as Map<String, dynamic>),
    ];
  }

  final String code;
  final String name;
  final List<CityRegion> children;

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      if (children.isNotEmpty)
        'children': [for (final child in children) child.toJson()],
    };
  }

  @override
  String toString() => 'CityRegion(code: $code, name: $name)';
}

class CityPickerResult {
  const CityPickerResult({
    required this.province,
    required this.city,
    required this.area,
  });

  final CityRegion province;
  final CityRegion city;
  final CityRegion area;

  List<CityRegion> get regions => [province, city, area];

  List<String> get codes => [province.code, city.code, area.code];

  List<String> get names => [province.name, city.name, area.name];

  String get address => names.join(' ');

  Map<String, dynamic> toJson() {
    return {
      'province': province.toJson(),
      'city': city.toJson(),
      'area': area.toJson(),
    };
  }

  @override
  String toString() => 'CityPickerResult(${codes.join('/')}: $address)';
}

class CityPickerData {
  CityPickerData._();

  static const assetPath =
      'packages/decorated_flutter/assets/city_picker/china_regions.json';

  static Future<List<CityRegion>>? _cache;

  static Future<List<CityRegion>> load({
    AssetBundle? bundle,
    String path = assetPath,
    bool forceReload = false,
  }) {
    if (bundle != null || path != assetPath) {
      return _load(bundle ?? rootBundle, path);
    }

    if (forceReload || _cache == null) {
      _cache = _load(rootBundle, path);
    }
    return _cache!;
  }

  static Future<List<CityRegion>> _load(AssetBundle bundle, String path) async {
    final source = await bundle.loadString(path);
    return CityRegion.listFromJsonString(source);
  }
}
