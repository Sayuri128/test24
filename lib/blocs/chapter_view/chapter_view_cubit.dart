import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:wakaranai/blocs/chapter_view/chapter_view_state.dart';
import 'package:wakaranai/blocs/settings/settings_cubit.dart';
import 'package:wakaranai/ui/manga_service_viewer/concrete_viewer/chapter_viewer/chapter_view_mode.dart';
import 'package:wakaranai/ui/manga_service_viewer/concrete_viewer/chapter_viewer/chapter_viewer.dart';
import 'package:wakascript/api_clients/manga_api_client.dart';
import 'package:wakascript/models/manga/manga_concrete_view/chapter/pages/pages.dart';

class ChapterViewCubit extends Cubit<ChapterViewState> {
  ChapterViewCubit(
      {required this.apiClient,
      required this.settingsCubit,
      required this.pageController,
      required this.itemScrollController})
      : super(ChapterViewInit());

  final SettingsCubit settingsCubit;

  final MangaApiClient apiClient;

  final PageController pageController;
  final ItemScrollController itemScrollController;

  void init(ChapterViewerData data) async {
    final pagesS = [
      await apiClient.getPages(uid: data.chapter.uid, data: data.chapter.data)
    ];

    final int chapterIndex = data.group.chapters
        .indexWhere((element) => element.uid == pagesS.last.chapterUid);
    final Pages currentPages = pagesS.last;

    final canGetPreviousPages = (chapterIndex - 1) >= 0;
    final canGetNextPages = (chapterIndex + 1) < data.group.chapters.length;

    emit(ChapterViewInitialized(
        pages: pagesS,
        currentPages: currentPages,
        currentPage: 1,
        totalPages: currentPages.value.length,
        controlsVisible: true,
        controlsEnabled: false,
        mode: settingsCubit.state is SettingsInitialized
            ? (settingsCubit.state as SettingsInitialized).defaultMode
            : ChapterViewMode.RIGHT_TO_LEFT,
        group: data.group,
        galleryView: data.galleryView,
        canGetPreviousPages: canGetPreviousPages,
        canGetNextPages: canGetNextPages));
  }

  void onPagesChanged({required bool next}) async {
    if (state is ChapterViewInitialized) {
      final state = this.state as ChapterViewInitialized;

      final int chapterIndex = state.group.chapters.indexWhere(
              (element) => element.uid == state.currentPages.chapterUid) +
          (next ? 1 : -1);

      final bool canGetPreviousPages = chapterIndex > 0;
      final bool canGetNextPages = chapterIndex < state.group.chapters.length;

      Pages? optionalLoadedPages = state.pages.firstWhereOrNull((element) =>
          element.chapterUid == state.group.chapters[chapterIndex].uid);

      final List<Pages> newPages = [...state.pages];

      if (optionalLoadedPages == null) {
        optionalLoadedPages = await apiClient.getPages(
            uid: state.group.chapters[chapterIndex].uid,
            data: state.group.chapters[chapterIndex].data);
        if (next) {
          newPages.add(optionalLoadedPages);
        } else {
          newPages.insert(0, optionalLoadedPages);
        }
      }

      if (state.mode == ChapterViewMode.WEBTOON) {
        itemScrollController.jumpTo(
            index: next ? 0 : optionalLoadedPages.value.length - 1,
            alignment: 0);
      } else {
        pageController
            .jumpToPage(next ? 0 : optionalLoadedPages.value.length - 1);
      }

      emit(state.copyWith(
          canGetNextPages: canGetNextPages,
          canGetPreviousPages: canGetPreviousPages,
          pages: newPages,
          totalPages: optionalLoadedPages.value.length,
          currentPage: next ? 1 : optionalLoadedPages.value.length,
          currentPages: optionalLoadedPages));
    }
  }

  void onPageChanged(int index) {
    if (state is ChapterViewInitialized) {
      emit((state as ChapterViewInitialized).copyWith(currentPage: index));
    }
  }

  void onSetControls(bool value) {
    if (state is ChapterViewInitialized) {
      emit((state as ChapterViewInitialized).copyWith(controlsEnabled: value));
    }
  }

  void onChangeVisibility() {
    if (state is ChapterViewInitialized) {
      emit((state as ChapterViewInitialized).copyWith(
          controlsVisible: !(state as ChapterViewInitialized).controlsVisible));
    }
  }

  void onModeChanged(ChapterViewMode mode) {
    if (state is ChapterViewInitialized) {
      emit((state as ChapterViewInitialized).copyWith(mode: mode));
    }
  }
}
