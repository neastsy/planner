import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import 'package:sticky_headers/sticky_headers.dart';
import '../models/activity_template_model.dart';
import '../providers/template_provider.dart';
import '../widgets/add_edit_template_sheet.dart';

class TemplateManagerPage extends StatefulWidget {
  const TemplateManagerPage({super.key});

  @override
  State<TemplateManagerPage> createState() => _TemplateManagerPageState();
}

class _TemplateManagerPageState extends State<TemplateManagerPage> {
  final Set<String> _deletingIds = {};
  // YENİ: Kaydırma pozisyonunu kontrol etmek için bir controller.
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose(); // Controller'ı dispose etmeyi unutma.
    super.dispose();
  }

  void _showAddEditSheet(BuildContext context,
      {ActivityTemplate? template}) async {
    final provider = Provider.of<TemplateProvider>(context, listen: false);
    final result = await showModalBottomSheet<ActivityTemplate>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddEditTemplateSheet(templateToEdit: template),
    );
    if (result != null && mounted) {
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
        title: Text(l10n.templateManagerTitle),
      ),
      body: Consumer<TemplateProvider>(
        builder: (context, provider, child) {
          if (provider.templates.isEmpty && _deletingIds.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  l10n.noTemplates,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        height: 1.5,
                      ),
                ),
              ),
            );
          }

          final categorizedTemplates = provider.templatesByCategory;
          final sortedCategories = categorizedTemplates.keys.toList()
            ..sort((a, b) {
              if (a == 'untagged') return 1;
              if (b == 'untagged') return -1;
              return a.compareTo(b);
            });

          return ListView.builder(
            controller:
                _scrollController, // YENİ: Controller'ı ListView'a bağla.
            itemCount: sortedCategories.length,
            itemBuilder: (context, index) {
              final category = sortedCategories[index];
              final templates = categorizedTemplates[category]!;
              if (templates.every((t) => _deletingIds.contains(t.id))) {
                return const SizedBox.shrink();
              }
              return StickyHeader(
                header: Container(
                  height: 50.0,
                  color: Theme.of(context)
                      .scaffoldBackgroundColor
                      .withAlpha((255 * 0.95).round()),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    category == 'untagged' ? l10n.untagged : category,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                content: Column(
                  children: templates.map((template) {
                    final isDeleting = _deletingIds.contains(template.id);
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: isDeleting ? 0 : null,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: isDeleting ? 0 : 1,
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: ListTile(
                            leading:
                                Container(width: 10, color: template.color),
                            title: Text(template.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(l10n.durationLabel(
                                template.durationInMinutes.toString())),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: _getNotificationIconForTemplate(
                                      template, context),
                                  onPressed: null,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _showAddEditSheet(context,
                                      template: template),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.redAccent),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text(l10n.deleteTemplateTitle),
                                        content: Text(
                                            l10n.deleteTemplateContent(
                                                template.name)),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text(l10n.cancel),
                                            onPressed: () =>
                                                Navigator.of(ctx).pop(),
                                          ),
                                          TextButton(
                                            child: Text(l10n.delete,
                                                style: const TextStyle(
                                                    color: Colors.redAccent)),
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                              final currentOffset =
                                                  _scrollController.offset;

                                              setState(() {
                                                _deletingIds.add(template.id);
                                              });

                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 350), () {
                                                if (mounted) {
                                                  provider.deleteTemplate(
                                                      template.id);
                                                  _deletingIds
                                                      .remove(template.id);

                                                  // 2. Silme işleminden sonra, kaydırma pozisyonunu
                                                  // sakladığımız yere geri getir.
                                                  // 'jumpTo' anında, 'animateTo' ise yumuşak bir geçişle yapar.
                                                  if (_scrollController
                                                      .hasClients) {
                                                    _scrollController
                                                        .jumpTo(currentOffset);
                                                  }
                                                }
                                              });
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
                        ),
                      ),
                    );
                  }).toList(),
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
