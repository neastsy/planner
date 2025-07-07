import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/activity_template_model.dart';

class TemplateProvider with ChangeNotifier {
  final Box<ActivityTemplate> _templatesBox;
  List<ActivityTemplate> _templates = [];

  TemplateProvider(this._templatesBox) {
    _loadTemplates();
  }

  // Dışarıdan erişim için şablon listesinin bir kopyasını döndüren getter
  List<ActivityTemplate> get templates => List.from(_templates);

  // Kutudan şablonları yükleyen özel metot
  void _loadTemplates() {
    _templates = _templatesBox.values.toList();
    // İsteğe bağlı: Şablonları isme göre sıralayabiliriz
    _templates
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    notifyListeners();
  }

  // Yeni bir şablon ekleyen metot
  Future<void> addTemplate(ActivityTemplate template) async {
    // Hive'a eklerken, anahtar olarak template'in id'sini kullanıyoruz.
    await _templatesBox.put(template.id, template);
    _loadTemplates(); // Listeyi yeniden yükle ve dinleyicileri bilgilendir
  }

  // Mevcut bir şablonu güncelleyen metot
  Future<void> updateTemplate(ActivityTemplate template) async {
    // 'put' metodu, anahtar zaten varsa üzerine yazar, yoksa yeni oluşturur.
    await _templatesBox.put(template.id, template);
    _loadTemplates(); // Listeyi yeniden yükle ve dinleyicileri bilgilendir
  }

  // Bir şablonu silen metot
  Future<void> deleteTemplate(String templateId) async {
    await _templatesBox.delete(templateId);
    _loadTemplates(); // Listeyi yeniden yükle ve dinleyicileri bilgilendir
  }
}
