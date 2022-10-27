import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revelation/pages/setting_page/devices/lg1024/general_section/sync_state_section.dart';
import 'package:revelation/pages/setting_page/devices/lg1024/user_section/item_section.dart';
import 'package:revelation/service/global_service.dart';
import 'package:revelation/utils/date_time_util.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';

class GeneralSection extends StatefulWidget {
  final GlobalService globalService;
  GeneralSection({Key? key, required BuildContext context})
      : globalService = RepositoryProvider.of<GlobalService>(context),
        super(key: key);

  @override
  State<GeneralSection> createState() => _GeneralSectionState();
}

class _GeneralSectionState extends State<GeneralSection> {
  UnsubscribeCollect unsubscribeCollect = UnsubscribeCollect([]);
  TextEditingController controller = TextEditingController();
  late int newInterval;
  final _formKey = GlobalKey<FormState>();

  onSubmit() async {
    if (_formKey.currentState!.validate()) {
      await widget.globalService.generalService.setSyncInterval(newInterval);
    }
  }

  @override
  void initState() {
    newInterval = widget.globalService.generalService.syncIntervalHook.value;
    unsubscribeCollect = UnsubscribeCollect([
      widget.globalService.generalService.lastSyncTimeHook.subscribe((value) => setState(() {})),
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
    if (widget.globalService.generalService.lastSyncTimeHook.value != null) {
      lastSyncTime = DateTimeUtil.formatDateTime(widget.globalService.generalService.lastSyncTimeHook.value!);
    }
    final String syncInterval = widget.globalService.generalService.syncIntervalHook.value.toString();

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
                  SyncStateSection(globalService: widget.globalService),
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
