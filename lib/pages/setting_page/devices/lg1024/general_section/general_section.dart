import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:revelation/pages/setting_page/devices/lg1024/general_section/sync_state_section.dart';
import 'package:revelation/pages/setting_page/devices/lg1024/user_section/item_section.dart';
import 'package:revelation/service/general_service/general_service.dart';
import 'package:revelation/utils/date_time_util.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';

class GeneralSection extends StatefulWidget {
  const GeneralSection({Key? key}) : super(key: key);

  @override
  State<GeneralSection> createState() => _GeneralSectionState();
}

class _GeneralSectionState extends State<GeneralSection> {
  UnsubscribeCollect unsubscribeCollect = UnsubscribeCollect([]);
  TextEditingController controller = TextEditingController();
  int newInterval = GeneralService.syncIntervalHook.value;
  final _formKey = GlobalKey<FormState>();

  onSubmit() async {
    if (_formKey.currentState!.validate()) {
      await GeneralService.setSyncInterval(newInterval);
    }
  }

  @override
  void initState() {
    unsubscribeCollect = UnsubscribeCollect([
      GeneralService.lastSyncTimeHook.subscribe((value) => setState(() {})),
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
    String lastSyncTime = '';
    if (GeneralService.lastSyncTimeHook.value != null) {
      lastSyncTime = DateTimeUtil.formatDateTime(GeneralService.lastSyncTimeHook.value!);
    }
    final String syncInterval = GeneralService.syncIntervalHook.value.toString();

    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        height: 400,
        width: 400,
        child: Column(
          children: [
            ItemSection(
              label: 'Last sync at',
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SyncStateSection(),
                  Text(lastSyncTime),
                ],
              ),
            ),
            ItemSection(
              label: 'Sync interval',
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                    child: TextFormField(
                        initialValue: syncInterval,
                        validator: (String? value) => (value == null || value == '' || int.parse(value) == 0)
                            ? 'Parameters must have greater than 0'
                            : null,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        onChanged: (value) {
                          if (value != '') newInterval = int.parse(value);
                        }),
                  ),
                  const Text('S'),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  height: 35,
                  margin: const EdgeInsets.only(top: 150),
                  child: ElevatedButton(
                    onPressed: onSubmit,
                    child: const Text('Save'),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
