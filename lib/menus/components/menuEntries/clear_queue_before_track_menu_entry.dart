import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/menus/components/menuEntries/menu_entry.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:finamp/services/radio_service_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

class ClearQueueInDirectionMenuEntry extends ConsumerWidget implements HideableMenuEntry {
  final FinampQueueItem? queueItem;
  final AxisDirection direction;

  const ClearQueueInDirectionMenuEntry({super.key, required this.queueItem, required this.direction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    assert(direction == AxisDirection.up || direction == AxisDirection.down, 'direction must be either up or down');
    final queueService = GetIt.instance<QueueService>();

    return Visibility(
      visible: queueItem != null,
      child: MenuEntry(
        icon: direction == AxisDirection.up ? TablerIcons.fold_up : TablerIcons.fold_down,
        title: direction == AxisDirection.up
            ? AppLocalizations.of(context)!.clearQueueAbove
            : AppLocalizations.of(context)!.clearQueueBelow,
        onTap: () async {
          await withRadioLock(() async {
            await queueService.clearQueueInDirection(queueItem!, direction);
          });
        },
      ),
    );
  }

  @override
  bool get isVisible => queueItem != null;
}
