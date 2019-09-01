import 'package:sqljocky5/sqljocky.dart';
import 'package:dart_mysql/db.dart' as db;

main(List<String> arguments) async {
  dynamic conn = await db.createConnection();

  var transaction = await conn.begin();

  try {
    await createTable(conn);
    await insertData(conn);
    await listData(conn);
    await removeData(conn);
    await dropTable(conn);
    transaction.commit();
  } catch (e) {
    print("Error: $e");
    await transaction.rollback();
  } finally {
    print("Connection closed!");
    await conn.close();
  }
}

Future<void> dropTable(MySqlConnection conn) async {
  print("Removing table...");

  String query = "DROP TABLE people";

  await conn.execute(query);

  print("Table removed successfully!");
}

Future<void> removeData(MySqlConnection conn) async {
  print("Removing data...");

  String query = "DELETE FROM people";

  await conn.execute(query);

  print("Data removed successfully!");
}

Future<void> listData(MySqlConnection conn) async {
  print("Listing data...");

  String query = "SELECT * FROM people";

  Results results = await conn.execute(query);

  results.forEach(
      (Row row) => print("ID: ${row[0]}\nNAME: ${row[1]}\n${row[2]}\n\n"));

  print("Successfullt listed data!");
}

Future<void> insertData(MySqlConnection conn) async {
  print("Entering data...");

  List datas = [
    ["Thiago", "t@email.com", 34],
    ["Ana", "a@email.com.br", 30],
    ["Leo", "l@email", 1]
  ];

  String query = "INSERT INTO people (name, email, age) values (?, ?, ?)";

  await conn.preparedMulti(query, datas);

  print("Successfully entered data!");
}

Future<void> createTable(MySqlConnection conn) async {
  print('Creating table...');

  String query = "CREATE TABLE IF NOT EXISTS people (" +
      "id INTEGER NOT NULL AUTO_INCREMENT, " +
      "name VARCHAR(255), " +
      "age INTEGER, " +
      "email VARCHAR(255), " +
      "PRIMARY KEY(id));";

  await conn.execute(query);

  print("Successfully created table!");
}
