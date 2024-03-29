import 'package:capyscript/modules/waka_models/models/manga/manga_concrete_view/chapter/pages/pages.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_concrete_view/chapters_group/chapters_group.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/manga_gallery_view.dart';
import 'package:wakaranai/ui/manga_service_viewer/concrete_viewer/chapter_viewer/chapter_view_mode.dart';

abstract class ChapterViewState {
  const ChapterViewState();
}

class ChapterViewInit extends ChapterViewState {}

class ChapterViewInitialized extends ChapterViewState {
  final List<Pages> pages;
  final Pages currentPages;

  final ChaptersGroup group;
  final MangaGalleryView galleryView;

  final int currentPage;
  final int totalPages;

  final ChapterViewMode mode;
  final bool controlsVisible;
  final bool controlsEnabled;

  final bool canGetNextPages;
  final bool canGetPreviousPages;

  const ChapterViewInitialized({
    required this.pages,
    required this.currentPages,
    required this.group,
    required this.galleryView,
    required this.currentPage,
    required this.totalPages,
    required this.mode,
    required this.controlsVisible,
    required this.controlsEnabled,
    required this.canGetNextPages,
    required this.canGetPreviousPages,
  });

  ChapterViewInitialized copyWith({
    List<Pages>? pages,
    Pages? currentPages,
    Pages? nextPages,
    Pages? previousPages,
    ChaptersGroup? group,
    MangaGalleryView? galleryView,
    int? currentPage,
    int? totalPages,
    ChapterViewMode? mode,
    bool? controlsVisible,
    bool? controlsEnabled,
    bool? canGetNextPages,
    bool? canGetPreviousPages,
  }) {
    return ChapterViewInitialized(
      pages: pages ?? this.pages,
      currentPages: currentPages ?? this.currentPages,
      group: group ?? this.group,
      galleryView: galleryView ?? this.galleryView,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      mode: mode ?? this.mode,
      controlsVisible: controlsVisible ?? this.controlsVisible,
      controlsEnabled: controlsEnabled ?? this.controlsEnabled,
      canGetNextPages: canGetNextPages ?? this.canGetNextPages,
      canGetPreviousPages: canGetPreviousPages ?? this.canGetPreviousPages,
    );
  }
}

class ChapterViewError extends ChapterViewState {
  final String message;

  const ChapterViewError({required this.message});
}
