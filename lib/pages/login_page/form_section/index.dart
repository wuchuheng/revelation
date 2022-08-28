import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snotes/config/config.dart';
import 'package:snotes/pages/login_page/form_section/account_info.dart';
import 'package:wuchuheng_env/wuchuheng_env.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

import 'field_container.dart';

class FormSection extends StatefulWidget {
  final void Function(AccountInfo accountInfo) onSubmit;
  const FormSection({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<FormSection> createState() => _FormSectionState();
}

class _FormSectionState extends State<FormSection> {
  Color? cursorColor = Colors.grey[700];
  int maxLines = 1;
  TextAlignVertical textAlignVertical = TextAlignVertical.center;

  AccountInfo accountInfo = AccountInfo(
    userName: DotEnv.get('USER_NAME', ''),
    password: DotEnv.get('PASSWORD', ''),
    host: DotEnv.get('HOST', ''),
    port: 993,
    tls: true,
  );

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
      label: label,
      child: TextFormField(
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

  Widget _getUserNameField() {
    String label = 'User Name';
    return FieldContainer(
      label: label,
      child: TextFormField(
        initialValue: accountInfo.userName,
        autofocus: true,
        cursorColor: cursorColor,
        onChanged: (value) => setState(() => accountInfo.userName = value),
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
      label: label,
      child: TextFormField(
        initialValue: accountInfo.host,
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
      label: label,
      child: TextFormField(
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
        width: 190,
        height: 37,
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) widget.onSubmit(accountInfo);
          },
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
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        alignment: Alignment.center,
        height: 400,
        child: GridView.count(
          shrinkWrap: true,
          childAspectRatio: 6,
          crossAxisCount: 1,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Welcome to ${Config.appName}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            _getUserNameField(),
            _getPasswordField(),
            _getHostField(),
            _getPortField(),
            _getTLSField(),
            _getSubmitButtonField(),
          ],
        ),
      ),
    );
  }
}
