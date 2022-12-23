import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

import '../../../../dao/user_dao/user_dao.dart';
import '../../../../model/user_model/user_model.dart';
import 'account_info.dart';
import 'advance_section.dart';
import 'field_container.dart';

class FormSection extends StatefulWidget {
  final void Function(AccountInfo accountInfo) onSubmit;
  const FormSection({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<FormSection> createState() => _FormSectionState();
}

class _FormSectionState extends State<FormSection> {
  late TextEditingController hostController;
  late AnimationController controller;

  Color? cursorColor = Colors.grey[700];
  int maxLines = 1;
  double itemHeight = 50;
  TextAlignVertical textAlignVertical = TextAlignVertical.center;

  AccountInfo accountInfo = AccountInfo(
    userName: '',
    password: '',
    host: '',
    port: 993,
    tls: true,
  );

  @override
  void initState() {
    final UserModel? user = UserDao().has();
    if (user != null) {
      accountInfo.userName = user.userName;
      accountInfo.host = user.host;
      accountInfo.port = user.port;
      accountInfo.tls = user.tls;
    }
    hostController = TextEditingController();
    hostController.text = accountInfo.host;
    super.initState();
  }

  @override
  void dispose() {
    hostController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      hintText: label,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      fillColor: Colors.white,
      isDense: true,
      contentPadding: const EdgeInsets.only(left: 6, top: 10, bottom: 10),
    );
  }

  Widget _getPasswordField() {
    String label = 'Password';
    return FieldContainer(
      height: itemHeight,
      label: label,
      child: TextFormField(
        onFieldSubmitted: (value) => onSubmit(),
        initialValue: accountInfo.password,
        obscureText: true,
        cursorColor: cursorColor,
        maxLines: maxLines,
        textAlignVertical: textAlignVertical,
        decoration: _decoration(label),
        onChanged: (value) => setState(() => accountInfo.password = value),
        validator: (String? value) => (value == null || value.isEmpty) ? 'The password can not empty.' : null,
      ),
    );
  }

  void onSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(accountInfo);
    } else if (controller.value == 0) {
      controller.forward(from: 0);
    }
  }

  void onChangeUsername(String value) {
    accountInfo.userName = value;
    const reg =
        r'''(?:[a-z0-9!#\$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#\$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])''';
    if (RegExp(reg).hasMatch(value)) {
      accountInfo.host = 'imap.${value.split('@')[1]}';
      hostController.text = accountInfo.host;
    }
    setState(() {});
  }

  Widget _getUserNameField() {
    String label = 'Email';
    return FieldContainer(
      height: itemHeight,
      label: label,
      child: TextFormField(
        onFieldSubmitted: (value) => onSubmit(),
        initialValue: accountInfo.userName,
        autofocus: true,
        cursorColor: cursorColor,
        onChanged: onChangeUsername,
        maxLines: maxLines,
        textAlignVertical: textAlignVertical,
        decoration: _decoration(label),
        validator: (String? value) {
          return value == null || value == '' ? 'The Account cant not empty.' : null;
        },
      ),
    );
  }

  Widget _getHostField() {
    String label = 'Host';
    return FieldContainer(
      height: itemHeight,
      label: label,
      child: TextFormField(
        onFieldSubmitted: (value) => onSubmit(),
        controller: hostController,
        maxLines: maxLines,
        textAlignVertical: textAlignVertical,
        decoration: _decoration(label),
        onChanged: (value) => setState(() => accountInfo.host = value),
        validator: (String? value) => (value == null || value.isEmpty) ? ' The host can not empty.' : null,
      ),
    );
  }

  Widget _getPortField() {
    String label = 'Port';
    return FieldContainer(
      height: itemHeight,
      label: label,
      child: TextFormField(
        onFieldSubmitted: (value) => onSubmit(),
        initialValue: accountInfo.port.toString(),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
        autofocus: true,
        cursorColor: cursorColor,
        maxLines: maxLines,
        textAlignVertical: textAlignVertical,
        onChanged: (value) => setState(() => accountInfo.port = int.parse(value)),
        decoration: _decoration(label),
        validator: (String? value) => (value == null || value.isEmpty) ? 'The port can not empty.' : null,
      ),
    );
  }

  Widget _getTLSField() {
    String label = 'TLS';
    return FieldContainer(
      height: itemHeight,
      label: label,
      cross: CrossAxisAlignment.center,
      child: Container(
        alignment: Alignment.centerLeft,
        child: Switch(
          value: accountInfo.tls,
          onChanged: (bool value) => setState(() => accountInfo.tls = value),
        ),
      ),
    );
  }

  Widget _getSubmitButtonField() {
    return Center(
      child: SizedBox(
        width: 210,
        height: 37,
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
          ),
          onPressed: onSubmit,
          child: const Text('Connect'),
        ),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Logger.info('Build widget FormSection', symbol: 'build');
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        alignment: Alignment.center,
        child: Column(
          children: [
            SizedBox(
              height: itemHeight,
              child: const Text(
                'A note based on an email',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
              ),
            ),
            _getUserNameField(),
            _getPasswordField(),
            AdvanceSection(
              onChangeController: (newController) => controller = newController,
              height: itemHeight,
              child: [
                _getHostField(),
                _getPortField(),
                _getTLSField(),
              ],
            ),
            _getSubmitButtonField(),
          ],
        ),
      ),
    );
  }
}
