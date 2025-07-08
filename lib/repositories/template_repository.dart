// lib/repositories/template_repository.dart (YENİ DOSYA)

import 'package:hive_flutter/hive_flutter.dart';
import '../models/activity_template_model.dart';

class TemplateRepository {
  final Box<ActivityTemplate> _templatesBox;
  TemplateRepository(this._templatesBox);

  // Tüm şablonları yükle
  List<ActivityTemplate> loadTemplates() {
    return _templatesBox.values.toList();
  }

  // Yeni bir şablon ekle
  Future<void> addTemplate(ActivityTemplate template) async {
    await _templatesBox.put(template.id, template);
  }

  // Mevcut bir şablonu güncelle
  Future<void> updateTemplate(ActivityTemplate template) async {
    await _templatesBox.put(template.id, template);
  }

  // Bir şablonu sil
  Future<void> deleteTemplate(String templateId) async {
    await _templatesBox.delete(templateId);
  }
}
