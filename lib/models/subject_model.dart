import 'package:flutter/material.dart';

class SubjectModel {
  final int id;
  final int classId;
  final String name;
  final String? nameMarathi;
  final String? nameHindi;
  final String? icon;
  final String? pdfAsset;
  final String? colorHex;

  const SubjectModel({
    required this.id,
    required this.classId,
    required this.name,
    this.nameMarathi,
    this.nameHindi,
    this.icon,
    this.pdfAsset,
    this.colorHex,
  });

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      id:           map['id']           as int,
      classId:      map['class_id']     as int,
      name:         map['name']         as String,
      nameMarathi:  map['name_marathi'] as String?,
      nameHindi:    map['name_hindi']   as String?,
      icon:         map['icon']         as String?,
      pdfAsset:     map['pdf_asset']    as String?,
      colorHex:     map['color_hex']    as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'id':           id,
    'class_id':     classId,
    'name':         name,
    'name_marathi': nameMarathi,
    'name_hindi':   nameHindi,
    'icon':         icon,
    'pdf_asset':    pdfAsset,
    'color_hex':    colorHex,
  };

  // Display name based on language
  String displayName(String lang) {
    if (lang == 'mr' && nameMarathi != null) return nameMarathi!;
    if (lang == 'hi' && nameHindi   != null) return nameHindi!;
    return name;
  }

  // Convert hex to Color
  Color get color {
    if (colorHex == null) return const Color(0xFFFF7A1A);
    final hex = colorHex!.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  String toString() => 'SubjectModel(id: $id, name: $name)';
}
