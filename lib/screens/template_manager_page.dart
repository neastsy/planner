import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/activity_template_model.dart';
import '../providers/template_provider.dart';
import '../widgets/add_edit_template_sheet.dart';

class TemplateManagerPage extends StatelessWidget {
  const TemplateManagerPage({super.key});

  void _showAddEditSheet(BuildContext context,
      {ActivityTemplate? template}) async {
    final result = await showModalBottomSheet<ActivityTemplate>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddEditTemplateSheet(templateToEdit: template),
    );

    if (result != null && context.mounted) {
      final provider = Provider.of<TemplateProvider>(context, listen: false);
      if (template != null) {
        provider.updateTemplate(result);
      } else {
        provider.addTemplate(result);
      }
    }
  }

  Widget _getNotificationIconForTemplate(
      ActivityTemplate template, BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    IconData icon;
    Color color;

    switch (template.notificationMinutesBefore) {
      case null:
        icon = Icons.notifications_off_outlined;
        color = Colors.grey;
        break;
      case 0:
        icon = Icons.notifications_active;
        color = Colors.blue;
        break;
      case 5:
        icon = Icons.notifications;
        color = isDarkMode ? Colors.amber.shade300 : Colors.amber.shade700;
        break;
      case 15:
        icon = Icons.notification_add_outlined;
        color = isDarkMode ? Colors.orange.shade300 : Colors.orange.shade700;
        break;
      default:
        icon = Icons.notifications_none;
        color = Colors.grey;
    }
    return Icon(icon, color: color);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.templateManagerTitle), // Yeni metin
      ),
      body: Consumer<TemplateProvider>(
        builder: (context, provider, child) {
          if (provider.templates.isEmpty) {
            return Center(
              child: Padding(
                // Metne yatayda boşluk veriyoruz.
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  l10n.noTemplates,
                  // YENİ: Metni kendi içinde ortalıyoruz.
                  textAlign: TextAlign.center,
                  // İsteğe bağlı: Metni biraz daha belirgin hale getirelim.
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        height:
                            1.5, // Satır yüksekliğini artırarak okunabilirliği iyileştir.
                      ),
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: provider.templates.length,
            itemBuilder: (context, index) {
              final template = provider.templates[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Container(width: 10, color: template.color),
                  title: Text(template.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(l10n.durationLabel(
                      template.durationInMinutes.toString())), // Yeni metin
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // YENİ: Bildirim durumu ikonu
                      IconButton(
                        icon:
                            _getNotificationIconForTemplate(template, context),
                        onPressed: null, // Tıklanabilir değil
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () =>
                            _showAddEditSheet(context, template: template),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          // YENİ: Silme onayı diyaloğu
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title:
                                  Text(l10n.deleteTemplateTitle), // Yeni metin
                              content: Text(l10n.deleteTemplateContent(
                                  template.name)), // Yeni metin
                              actions: <Widget>[
                                TextButton(
                                  child: Text(l10n.cancel),
                                  onPressed: () => Navigator.of(ctx).pop(),
                                ),
                                TextButton(
                                  child: Text(l10n.delete,
                                      style: const TextStyle(
                                          color: Colors.redAccent)),
                                  onPressed: () {
                                    provider.deleteTemplate(template.id);
                                    Navigator.of(ctx).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditSheet(context),
        tooltip: l10n.addTemplate,
        child: const Icon(Icons.add),
      ),
    );
  }
}
