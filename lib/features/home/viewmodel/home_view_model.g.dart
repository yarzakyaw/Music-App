// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getAllMusicHash() => r'cd5711795795dfbfe4e963c5e2c86202d0444a0f';

/// See also [getAllMusic].
@ProviderFor(getAllMusic)
final getAllMusicProvider =
    AutoDisposeFutureProvider<List<MusicModel>>.internal(
  getAllMusic,
  name: r'getAllMusicProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getAllMusicHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetAllMusicRef = AutoDisposeFutureProviderRef<List<MusicModel>>;
String _$getAllMusicThisWeekHash() =>
    r'025283b11ee8ae32d149a11df55237d1778aa3c3';

/// See also [getAllMusicThisWeek].
@ProviderFor(getAllMusicThisWeek)
final getAllMusicThisWeekProvider =
    AutoDisposeFutureProvider<List<MusicModel>>.internal(
  getAllMusicThisWeek,
  name: r'getAllMusicThisWeekProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getAllMusicThisWeekHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetAllMusicThisWeekRef = AutoDisposeFutureProviderRef<List<MusicModel>>;
String _$getAllArtistsHash() => r'07c71abe89089b83f00b01e1519729cc7d8aa9f2';

/// See also [getAllArtists].
@ProviderFor(getAllArtists)
final getAllArtistsProvider =
    AutoDisposeFutureProvider<List<ArtistModel>>.internal(
  getAllArtists,
  name: r'getAllArtistsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getAllArtistsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetAllArtistsRef = AutoDisposeFutureProviderRef<List<ArtistModel>>;
String _$getTenArtistsHash() => r'88ae47774ea1a7b99cfdbd8921eed527f17ce68c';

/// See also [getTenArtists].
@ProviderFor(getTenArtists)
final getTenArtistsProvider =
    AutoDisposeFutureProvider<List<ArtistModel>>.internal(
  getTenArtists,
  name: r'getTenArtistsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getTenArtistsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetTenArtistsRef = AutoDisposeFutureProviderRef<List<ArtistModel>>;
String _$getAartistByIdHash() => r'440deddee0b89218b6183dac3b11fe28b9d85753';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [getAartistById].
@ProviderFor(getAartistById)
const getAartistByIdProvider = GetAartistByIdFamily();

/// See also [getAartistById].
class GetAartistByIdFamily extends Family<AsyncValue<ArtistModel>> {
  /// See also [getAartistById].
  const GetAartistByIdFamily();

  /// See also [getAartistById].
  GetAartistByIdProvider call(
    String artistId,
  ) {
    return GetAartistByIdProvider(
      artistId,
    );
  }

  @override
  GetAartistByIdProvider getProviderOverride(
    covariant GetAartistByIdProvider provider,
  ) {
    return call(
      provider.artistId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getAartistByIdProvider';
}

/// See also [getAartistById].
class GetAartistByIdProvider extends AutoDisposeFutureProvider<ArtistModel> {
  /// See also [getAartistById].
  GetAartistByIdProvider(
    String artistId,
  ) : this._internal(
          (ref) => getAartistById(
            ref as GetAartistByIdRef,
            artistId,
          ),
          from: getAartistByIdProvider,
          name: r'getAartistByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getAartistByIdHash,
          dependencies: GetAartistByIdFamily._dependencies,
          allTransitiveDependencies:
              GetAartistByIdFamily._allTransitiveDependencies,
          artistId: artistId,
        );

  GetAartistByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.artistId,
  }) : super.internal();

  final String artistId;

  @override
  Override overrideWith(
    FutureOr<ArtistModel> Function(GetAartistByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetAartistByIdProvider._internal(
        (ref) => create(ref as GetAartistByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        artistId: artistId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ArtistModel> createElement() {
    return _GetAartistByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetAartistByIdProvider && other.artistId == artistId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, artistId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetAartistByIdRef on AutoDisposeFutureProviderRef<ArtistModel> {
  /// The parameter `artistId` of this provider.
  String get artistId;
}

class _GetAartistByIdProviderElement
    extends AutoDisposeFutureProviderElement<ArtistModel>
    with GetAartistByIdRef {
  _GetAartistByIdProviderElement(super.provider);

  @override
  String get artistId => (origin as GetAartistByIdProvider).artistId;
}

String _$getAllGenresHash() => r'0891014e0826ed27c6903dd19daa5c242a006b3a';

/// See also [getAllGenres].
@ProviderFor(getAllGenres)
final getAllGenresProvider =
    AutoDisposeFutureProvider<List<GenreModel>>.internal(
  getAllGenres,
  name: r'getAllGenresProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getAllGenresHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetAllGenresRef = AutoDisposeFutureProviderRef<List<GenreModel>>;
String _$getArtistProfileHash() => r'2befc9a8dc28922e987020be4e1a0240fc4391b0';

/// See also [getArtistProfile].
@ProviderFor(getArtistProfile)
const getArtistProfileProvider = GetArtistProfileFamily();

/// See also [getArtistProfile].
class GetArtistProfileFamily extends Family<AsyncValue<String>> {
  /// See also [getArtistProfile].
  const GetArtistProfileFamily();

  /// See also [getArtistProfile].
  GetArtistProfileProvider call(
    String artistId,
  ) {
    return GetArtistProfileProvider(
      artistId,
    );
  }

  @override
  GetArtistProfileProvider getProviderOverride(
    covariant GetArtistProfileProvider provider,
  ) {
    return call(
      provider.artistId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getArtistProfileProvider';
}

/// See also [getArtistProfile].
class GetArtistProfileProvider extends AutoDisposeFutureProvider<String> {
  /// See also [getArtistProfile].
  GetArtistProfileProvider(
    String artistId,
  ) : this._internal(
          (ref) => getArtistProfile(
            ref as GetArtistProfileRef,
            artistId,
          ),
          from: getArtistProfileProvider,
          name: r'getArtistProfileProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getArtistProfileHash,
          dependencies: GetArtistProfileFamily._dependencies,
          allTransitiveDependencies:
              GetArtistProfileFamily._allTransitiveDependencies,
          artistId: artistId,
        );

  GetArtistProfileProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.artistId,
  }) : super.internal();

  final String artistId;

  @override
  Override overrideWith(
    FutureOr<String> Function(GetArtistProfileRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetArtistProfileProvider._internal(
        (ref) => create(ref as GetArtistProfileRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        artistId: artistId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _GetArtistProfileProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetArtistProfileProvider && other.artistId == artistId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, artistId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetArtistProfileRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `artistId` of this provider.
  String get artistId;
}

class _GetArtistProfileProviderElement
    extends AutoDisposeFutureProviderElement<String> with GetArtistProfileRef {
  _GetArtistProfileProviderElement(super.provider);

  @override
  String get artistId => (origin as GetArtistProfileProvider).artistId;
}

String _$getAlbumsByArtistHash() => r'd2f678fdc416c70ed69abc65c1dd2466d1af3853';

/// See also [getAlbumsByArtist].
@ProviderFor(getAlbumsByArtist)
const getAlbumsByArtistProvider = GetAlbumsByArtistFamily();

/// See also [getAlbumsByArtist].
class GetAlbumsByArtistFamily extends Family<AsyncValue<List<AlbumModel>>> {
  /// See also [getAlbumsByArtist].
  const GetAlbumsByArtistFamily();

  /// See also [getAlbumsByArtist].
  GetAlbumsByArtistProvider call(
    String artistId,
  ) {
    return GetAlbumsByArtistProvider(
      artistId,
    );
  }

  @override
  GetAlbumsByArtistProvider getProviderOverride(
    covariant GetAlbumsByArtistProvider provider,
  ) {
    return call(
      provider.artistId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getAlbumsByArtistProvider';
}

/// See also [getAlbumsByArtist].
class GetAlbumsByArtistProvider
    extends AutoDisposeFutureProvider<List<AlbumModel>> {
  /// See also [getAlbumsByArtist].
  GetAlbumsByArtistProvider(
    String artistId,
  ) : this._internal(
          (ref) => getAlbumsByArtist(
            ref as GetAlbumsByArtistRef,
            artistId,
          ),
          from: getAlbumsByArtistProvider,
          name: r'getAlbumsByArtistProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getAlbumsByArtistHash,
          dependencies: GetAlbumsByArtistFamily._dependencies,
          allTransitiveDependencies:
              GetAlbumsByArtistFamily._allTransitiveDependencies,
          artistId: artistId,
        );

  GetAlbumsByArtistProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.artistId,
  }) : super.internal();

  final String artistId;

  @override
  Override overrideWith(
    FutureOr<List<AlbumModel>> Function(GetAlbumsByArtistRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetAlbumsByArtistProvider._internal(
        (ref) => create(ref as GetAlbumsByArtistRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        artistId: artistId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<AlbumModel>> createElement() {
    return _GetAlbumsByArtistProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetAlbumsByArtistProvider && other.artistId == artistId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, artistId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetAlbumsByArtistRef on AutoDisposeFutureProviderRef<List<AlbumModel>> {
  /// The parameter `artistId` of this provider.
  String get artistId;
}

class _GetAlbumsByArtistProviderElement
    extends AutoDisposeFutureProviderElement<List<AlbumModel>>
    with GetAlbumsByArtistRef {
  _GetAlbumsByArtistProviderElement(super.provider);

  @override
  String get artistId => (origin as GetAlbumsByArtistProvider).artistId;
}

String _$getAlbumMusicsHash() => r'8c4888791eb6e97eb446421452aad621e37cd3ae';

/// See also [getAlbumMusics].
@ProviderFor(getAlbumMusics)
const getAlbumMusicsProvider = GetAlbumMusicsFamily();

/// See also [getAlbumMusics].
class GetAlbumMusicsFamily extends Family<AsyncValue<List<MusicModel>>> {
  /// See also [getAlbumMusics].
  const GetAlbumMusicsFamily();

  /// See also [getAlbumMusics].
  GetAlbumMusicsProvider call(
    AlbumModel album,
  ) {
    return GetAlbumMusicsProvider(
      album,
    );
  }

  @override
  GetAlbumMusicsProvider getProviderOverride(
    covariant GetAlbumMusicsProvider provider,
  ) {
    return call(
      provider.album,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getAlbumMusicsProvider';
}

/// See also [getAlbumMusics].
class GetAlbumMusicsProvider
    extends AutoDisposeFutureProvider<List<MusicModel>> {
  /// See also [getAlbumMusics].
  GetAlbumMusicsProvider(
    AlbumModel album,
  ) : this._internal(
          (ref) => getAlbumMusics(
            ref as GetAlbumMusicsRef,
            album,
          ),
          from: getAlbumMusicsProvider,
          name: r'getAlbumMusicsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getAlbumMusicsHash,
          dependencies: GetAlbumMusicsFamily._dependencies,
          allTransitiveDependencies:
              GetAlbumMusicsFamily._allTransitiveDependencies,
          album: album,
        );

  GetAlbumMusicsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.album,
  }) : super.internal();

  final AlbumModel album;

  @override
  Override overrideWith(
    FutureOr<List<MusicModel>> Function(GetAlbumMusicsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetAlbumMusicsProvider._internal(
        (ref) => create(ref as GetAlbumMusicsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        album: album,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<MusicModel>> createElement() {
    return _GetAlbumMusicsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetAlbumMusicsProvider && other.album == album;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, album.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetAlbumMusicsRef on AutoDisposeFutureProviderRef<List<MusicModel>> {
  /// The parameter `album` of this provider.
  AlbumModel get album;
}

class _GetAlbumMusicsProviderElement
    extends AutoDisposeFutureProviderElement<List<MusicModel>>
    with GetAlbumMusicsRef {
  _GetAlbumMusicsProviderElement(super.provider);

  @override
  AlbumModel get album => (origin as GetAlbumMusicsProvider).album;
}

String _$homeViewModelHash() => r'a6d17993e087f9a9ea53fdeefe17283108c0761d';

/// See also [HomeViewModel].
@ProviderFor(HomeViewModel)
final homeViewModelProvider =
    AutoDisposeNotifierProvider<HomeViewModel, AsyncValue?>.internal(
  HomeViewModel.new,
  name: r'homeViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$homeViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HomeViewModel = AutoDisposeNotifier<AsyncValue?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
