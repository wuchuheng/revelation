import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snotes/pages/setting_page/devices/lg1024/general_section/sync_state_section.dart';
import 'package:snotes/pages/setting_page/devices/lg1024/user_section/item_section.dart';
import 'package:snotes/service/general_service/index.dart';
import 'package:snotes/utils/date_time_util.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';

class GeneralSection extends StatefulWidget {
  const GeneralSection({Key? key}) : super(key: key);

  @override
  State<GeneralSection> createState() => _GeneralSectionState();
}

class _GeneralSectionState extends State<GeneralSection> {
  UnsubscribeCollect unsubscribeCollect = UnsubscribeCollect([]);
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    unsubscribeCollect = UnsubscribeCollect([
      GeneralService.lastSyncTime.subscribe((value) => setState(() {})),
    ]);
    super.initState();
  }

  @override
  void dispose() {
    unsubscribeCollect.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String lastSyncTime = 'Null';
    if (GeneralService.lastSyncTime.value != null) {
      lastSyncTime = DateTimeUtil.formatDateTime(GeneralService.lastSyncTime.value!);
    }

    return Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        height: 400,
        width: 400,
        child: Column(
          children: [
            ItemSection(label: 'Last sync at', child: Text(lastSyncTime)),
            ItemSection(label: 'Local DB', child: Text(lastSyncTime)),
            ItemSection(label: 'Sync state', child: const SyncStateSection()),
            ItemSection(
              label: 'Sync interval',
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                    child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        controller: controller,
                        onChanged: (value) {}),
                  ),
                  const Text('S'),
                ],
              ),
            ),
          ],
        ));
  }
}
