import 'package:sqljocky5/sqljocky.dart';

createConnection() async {
  var settings = ConnectionSettings(
    user: "root",
    password: "root",
    host: "localhost",
    port: 3306,
    db: "dart",
  );

  return await MySqlConnection.connect(settings);
}
