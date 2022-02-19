import 'package:dio/dio.dart';
import 'package:wakaranai/repositories/configs_repository/configs_repository.dart';
import 'package:wakaranai/res.dart';
import 'package:wakaranai_json_runtime/wakaranai_js_runtime.dart';
import 'package:flutter/services.dart' show rootBundle;

class ConfigsService {
  static const String ORG = 'KoneruHodl';
  static const String REPOSITORY = 'wakaranai_configs';

  final ConfigsRepository _repository = ConfigsRepository(Dio());

  Future<List<WakaranaiJsRuntime>> getMangaConfigs() async {
    return await Future.wait(
        (await _repository.getMangaConfigs(ORG, REPOSITORY)).map((e) async =>
            WakaranaiJsRuntime.fromUrl(
                url: e.download_url,
                lib: await rootBundle.loadString(Res.fast_html_dom_parser))));
  }
}
