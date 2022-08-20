import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snotes/pages/login_page/form_section/account_info.dart';
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
    userName: '2831473954@qq.com',
    password: 'owtdtjnltfnndegh',
    host: 'local.wuchuheng.com',
    port: 993,
    tls: true,
  );

  final TextEditingController _usernameController = TextEditingController();

  InputDecoration _decoration(String label) {
    return InputDecoration(
      hintText: label,
      filled: true,
      border: const OutlineInputBorder(borderSide: BorderSide.none),
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
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) widget.onSubmit(accountInfo);
        },
        child: const Text('Connect'),
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
        alignment: Alignment.center,
        color: Colors.green[100],
        height: 400,
        child: GridView.count(
          shrinkWrap: true,
          childAspectRatio: 6,
          crossAxisCount: 1,
          children: [
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
