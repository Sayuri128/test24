// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_configs_repository.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _GithubConfigsRepository implements GithubConfigsRepository {
  _GithubConfigsRepository(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'https://api.github.com/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<List<GithubRepositoryContent>> getMangaDirectories(
    org,
    repo, {
    branch = 'master',
    maxAge = 300,
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'ref': branch};
    final _headers = <String, dynamic>{r'max-age': maxAge};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<GithubRepositoryContent>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/repos/${org}/${repo}/contents/scripts/manga',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) =>
            GithubRepositoryContent.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<GithubRepositoryContent>> getAnimeDirectories(
    org,
    repo, {
    branch = 'master',
    maxAge = 300,
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'ref': branch};
    final _headers = <String, dynamic>{r'max-age': maxAge};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<GithubRepositoryContent>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/repos/${org}/${repo}/contents/scripts/anime',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) =>
            GithubRepositoryContent.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<GithubRepositoryContent>> getConcreteContent({
    required org,
    required repo,
    required directory,
    required concrete,
    maxAge = 300,
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'max-age': maxAge};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<GithubRepositoryContent>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/repos/${org}/${repo}/contents/scripts/${directory}/${concrete}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) =>
            GithubRepositoryContent.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
