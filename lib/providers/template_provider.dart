import 'package:flutter/foundation.dart';
import '../models/activity_template_model.dart';
import '../repositories/template_repository.dart'; // YENİ: Repository'yi import et

class TemplateProvider with ChangeNotifier {
  // GÜNCELLENDİ: Artık doğrudan Hive kutusuna değil, Repository'ye bağımlıyız.
  final TemplateRepository _templateRepository;
  List<ActivityTemplate> _templates = [];

  TemplateProvider(this._templateRepository) {
    _loadTemplates();
  }

  List<ActivityTemplate> get templates => List.from(_templates);

  // GÜNCELLENDİ: Yükleme işlemi Repository üzerinden yapılıyor.
  void _loadTemplates() {
    _templates = _templateRepository.loadTemplates();
    _sortTemplates(); // Sıralama işlemini ayrı bir metoda taşıdık.
    // notifyListeners() burada gereksiz çünkü constructor'da çağrılıyor.
  }

  // YENİ: Sıralama mantığını ayrı bir metoda taşıdık.
  void _sortTemplates() {
    _templates
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  // GÜNCELLENDİ: Daha verimli ekleme metodu.
  Future<void> addTemplate(ActivityTemplate template) async {
    // 1. Repository aracılığıyla Hive'a kaydet.
    await _templateRepository.addTemplate(template);
    // 2. Bellekteki listeye ekle.
    _templates.add(template);
    // 3. Listeyi yeniden sırala.
    _sortTemplates();
    // 4. Dinleyicileri bilgilendir.
    notifyListeners();
  }

  // GÜNCELLENDİ: Daha verimli güncelleme metodu.
  Future<void> updateTemplate(ActivityTemplate template) async {
    // 1. Repository aracılığıyla Hive'ı güncelle.
    await _templateRepository.updateTemplate(template);
    // 2. Bellekteki listede ilgili şablonu bul ve değiştir.
    final index = _templates.indexWhere((t) => t.id == template.id);
    if (index != -1) {
      _templates[index] = template;
      // 3. Listeyi yeniden sırala (isim değişmiş olabilir).
      _sortTemplates();
      // 4. Dinleyicileri bilgilendir.
      notifyListeners();
    }
  }

  // GÜNCELLENDİ: Daha verimli silme metodu.
  Future<void> deleteTemplate(String templateId) async {
    // 1. Repository aracılığıyla Hive'dan sil.
    await _templateRepository.deleteTemplate(templateId);
    // 2. Bellekteki listeden kaldır.
    _templates.removeWhere((t) => t.id == templateId);
    // Sıralama bozulmaz, yeniden sıralamaya gerek yok.
    // 3. Dinleyicileri bilgilendir.
    notifyListeners();
  }
}
