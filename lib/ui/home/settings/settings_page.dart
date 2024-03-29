import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakaranai/blocs/settings/settings_cubit.dart';
import 'package:wakaranai/generated/l10n.dart';
import 'package:wakaranai/services/protector_storage/protector_storage_service.dart';
import 'package:wakaranai/ui/manga_service_viewer/concrete_viewer/chapter_viewer/chapter_view_mode.dart';
import 'package:wakaranai/utils/app_colors.dart';
import 'package:wakaranai/utils/text_styles.dart';

// TODO: improve settings UI
class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);

  static const int DefaultConfigsSourceId = -1;

  final DropdownMenuItem<int> _defaultConfigsSourceDropdownMenuItem =
      DropdownMenuItem<int>(
          value: DefaultConfigsSourceId,
          child: Center(
              child:
                  Text(S.current.official_github_configs_source_repository)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state is SettingsInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (state is SettingsInitialized) {
            return ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Text(S.current.settings_default_reader_mode_title,
                      style: semibold(size: 18)),
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: DropdownButtonFormField<ChapterViewMode>(
                      value: state.defaultMode,
                      // borderRadius: BorderRadius.circular(16.0),
                      style: medium(),
                      icon: const Icon(Icons.arrow_drop_down_rounded),
                      decoration: _dropdownDecoration(),
                      items: ChapterViewMode.values
                          .map((e) => DropdownMenuItem(
                                value: e,
                                alignment: Alignment.center,
                                child: Text(chapterViewModelToString(e),
                                    textAlign: TextAlign.center,
                                    style: medium()),
                              ))
                          .toList(),
                      onChanged: (mode) {
                        if (mode != null) {
                          context
                              .read<SettingsCubit>()
                              .onChangedDefaultReadMode(mode);
                        }
                      }),
                ),
                const Divider(
                  height: 2,
                  color: AppColors.primary,
                ),
                const SizedBox(
                  height: 12,
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(
                //       horizontal: 16.0, vertical: 8.0),
                //   child: Text(
                //     S.current.settings_default_configs_source_title,
                //     style: semibold(size: 18),
                //   ),
                // ),
                // const Divider(
                //   height: 2,
                //   color: AppColors.primary,
                // ),
                ListTile(
                  onTap: () {
                    showOkCancelAlertDialog(
                      context: context,
                      okLabel: S.current
                          .clear_cookies_cache_dialog_confirmation_ok_label,
                      cancelLabel: S.current
                          .clear_cookies_cache_dialog_confirmation_cancel_label,
                      title: S.current
                          .clear_cookies_cache_dialog_confirmation_title,
                      message: S.current
                          .clear_cookies_cache_dialog_confirmation_message,
                    ).then((value) {
                      if (value.index == 0) {
                        ProtectorStorageService().clear().then((_) {
                          showOkAlertDialog(
                              context: context,
                              title: S.current.clear_cookies_dialog_success);
                        });
                      }
                    });
                  },
                  title: Text(S.current.clear_cookies_cache,
                      style: medium(size: 16)),
                ),
                ListTile(
                  onTap: () {
                    launchUrl(
                      Uri.parse(
                          "https://github.com/Sayuri128/wakaranai/issues/new/choose"),
                    );
                  },
                  title: Text(
                    S.current.submit_issue,
                    style: medium(size: 16),
                  ),
                )
                // ListTile(
                //   onTap: () {
                //     showOkCancelAlertDialog(
                //             context: context,
                //             title:
                //                 "Are you sure you want to delete all your data?")
                //         .then((value) {
                //       // if (value == OkCancelResult.ok) {
                //       //   waka.hardReset().then((value) {
                //       //     context.read<LocalConfigsCubit>().init();
                //       //     context.read<LibraryPageCubit>().init();
                //       //   });
                //       // }
                //     });
                //   },
                //   title: Text(
                //     "Hard reset",
                //     style: medium(size: 16),
                //   ),
                // )
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(color: Colors.transparent)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(color: Colors.transparent)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(color: Colors.transparent)));
  }
}
