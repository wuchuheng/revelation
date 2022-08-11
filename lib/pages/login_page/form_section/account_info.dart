class AccountInfo {
  String userName;
  String password;
  String host;
  int port;
  bool tls;

  AccountInfo({
    required this.userName,
    required this.password,
    required this.host,
    required this.port,
    required this.tls,
  });
}
