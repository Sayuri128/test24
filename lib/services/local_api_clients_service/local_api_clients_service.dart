import 'package:wakaranai/models/data/local_api_client.dart';
import 'package:wakaranai/services/local_config_info_service/local_config_info_service.dart';
import 'package:wakaranai/services/sqflite_service/query_item.dart';
import 'package:wakaranai/services/sqflite_service/sqflite_exists_check_result.dart';
import 'package:wakaranai/services/sqflite_service/sqflite_service.dart';

class LocalApiClientsService extends SqfliteService<LocalApiClient> {
  LocalApiClientsService({required this.localConfigInfoService})
      : super(tableName: apiConfigsTableName);

  final LocalConfigInfoService localConfigInfoService;

  static const String apiConfigsTableName = 'api_configs';
  static const String createApiConfigsTable = '''
      create table $apiConfigsTableName (
        id integer PRIMARY KEY AUTOINCREMENT,
        code VARCHAR(20000) NOT NULL,
        type integer NOT NULL,
        localConfigInfoId integer NOT NULL,
        created DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY(localConfigInfoId) REFERENCES ${LocalConfigInfoService.localConfigInfoTableName}(id)
      );
  ''';

  @override
  Future<LocalApiClient> mapConfig(Map<String, dynamic> map) async {
    final Map<String, dynamic> res = Map.from(map);
    res['localConfigInfo'] =
        (await localConfigInfoService.get(map['localConfigInfoId'])).toMap(lazy: false);

    return LocalApiClient.fromMap(res);
  }

  @override
  Future<int> insert(LocalApiClient item) async {
    item.localConfigInfo.id =
        await localConfigInfoService.insert(item.localConfigInfo);
    return super.insert(item);
  }

  Future<Map<String, dynamic>> getMapByConfigUid(int configId) async {
    final res = await queryMap(query: [
      SqfliteQueryKeyValueItem(key: "localConfigInfoId", value: configId)
    ]);
    if (res.isNotEmpty) {
      return res.first;
    }
    throw Exception("LocalApiClient with config id $configId does not exist");
  }

  Future<LocalApiClient> getByConfigUid(int configId) async =>
      LocalApiClient.fromMap(await getMapByConfigUid(configId));

  Future<SqfliteExistsCheckResult> checkExists(LocalApiClient client) async {
    final configExists = await localConfigInfoService.checkExists(
        name: client.localConfigInfo.name,
        version: client.localConfigInfo.version);
    Map<String, dynamic>? clientData;
    if (configExists.value) {
      clientData = await getMapByConfigUid(configExists.data!['id']);
    }
    return SqfliteExistsCheckResult(
        value: configExists.value, data: clientData);
  }
}
