import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wakaranai/blocs/remote_configs/remote_configs_cubit.dart';
import 'package:wakaranai/env.dart';
import 'package:wakaranai/models/configs_source_item/configs_source_item.dart';
import 'package:wakaranai/models/configs_source_type/configs_source_type.dart';
import 'package:wakaranai/services/settings_service/settings_service.dart';
import 'package:wakaranai/ui/manga_service_viewer/concrete_viewer/chapter_viewer/chapter_view_mode.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({required this.remoteConfigsCubit}) : super(SettingsInitial());

  // static final DefaultConfigsServiceItem = ConfigsSourceItem(
  //     baseUrl:
  //         '${Env.OFFICIAL_GITHUB_CONFIGS_SOURCE_ORG}/${Env.OFFICIAL_GITHUB_CONFIGS_SOURCE_REPOSITORY}',
  //     name: S.current.github_configs_source_type,
  //     type: ConfigsSourceType.GIT_HUB);
  static final DefaultConfigsServiceItem = ConfigsSourceItem(
      baseUrl: Env.LOCAL_REPOSITORY_URL,
      name: "LOCAL REST",
      type: ConfigsSourceType.REST);

  final RemoteConfigsCubit remoteConfigsCubit;

  final SettingsService _settingsService = SettingsService();

  void init() async {
    emit(SettingsInitialized(
        defaultMode: await _settingsService.getDefaultReaderMode(),
        defaultConfigsSourceId:
            await _settingsService.getDefaultConfigsSourceId()));
  }

  void onChangedDefaultReadMode(ChapterViewMode mode) async {
    await _settingsService.setDefaultReaderMode(mode);
    emit((state as SettingsInitialized).copyWith(defaultMode: mode));
  }
}
