// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dhamma_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getAllDhammaTracksHash() =>
    r'6e4e8106c2a4b659a89a48e28d4e5e8cb8b4d3de';

/// See also [getAllDhammaTracks].
@ProviderFor(getAllDhammaTracks)
final getAllDhammaTracksProvider =
    AutoDisposeFutureProvider<List<MusicModel>>.internal(
  getAllDhammaTracks,
  name: r'getAllDhammaTracksProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getAllDhammaTracksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetAllDhammaTracksRef = AutoDisposeFutureProviderRef<List<MusicModel>>;
String _$getAllTracksThisMonthHash() =>
    r'55f2203db2e20fa81ba4e252b13650b63b805df6';

/// See also [getAllTracksThisMonth].
@ProviderFor(getAllTracksThisMonth)
final getAllTracksThisMonthProvider =
    AutoDisposeFutureProvider<List<MusicModel>>.internal(
  getAllTracksThisMonth,
  name: r'getAllTracksThisMonthProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getAllTracksThisMonthHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetAllTracksThisMonthRef
    = AutoDisposeFutureProviderRef<List<MusicModel>>;
String _$getSuggestedDhammaTracksHash() =>
    r'bbded40e3b99b738d4b098575eb4eb3e069ee04b';

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

/// See also [getSuggestedDhammaTracks].
@ProviderFor(getSuggestedDhammaTracks)
const getSuggestedDhammaTracksProvider = GetSuggestedDhammaTracksFamily();

/// See also [getSuggestedDhammaTracks].
class GetSuggestedDhammaTracksFamily
    extends Family<AsyncValue<List<MusicModel>>> {
  /// See also [getSuggestedDhammaTracks].
  const GetSuggestedDhammaTracksFamily();

  /// See also [getSuggestedDhammaTracks].
  GetSuggestedDhammaTracksProvider call(
    int offset,
    int limit,
  ) {
    return GetSuggestedDhammaTracksProvider(
      offset,
      limit,
    );
  }

  @override
  GetSuggestedDhammaTracksProvider getProviderOverride(
    covariant GetSuggestedDhammaTracksProvider provider,
  ) {
    return call(
      provider.offset,
      provider.limit,
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
  String? get name => r'getSuggestedDhammaTracksProvider';
}

/// See also [getSuggestedDhammaTracks].
class GetSuggestedDhammaTracksProvider
    extends AutoDisposeFutureProvider<List<MusicModel>> {
  /// See also [getSuggestedDhammaTracks].
  GetSuggestedDhammaTracksProvider(
    int offset,
    int limit,
  ) : this._internal(
          (ref) => getSuggestedDhammaTracks(
            ref as GetSuggestedDhammaTracksRef,
            offset,
            limit,
          ),
          from: getSuggestedDhammaTracksProvider,
          name: r'getSuggestedDhammaTracksProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getSuggestedDhammaTracksHash,
          dependencies: GetSuggestedDhammaTracksFamily._dependencies,
          allTransitiveDependencies:
              GetSuggestedDhammaTracksFamily._allTransitiveDependencies,
          offset: offset,
          limit: limit,
        );

  GetSuggestedDhammaTracksProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.offset,
    required this.limit,
  }) : super.internal();

  final int offset;
  final int limit;

  @override
  Override overrideWith(
    FutureOr<List<MusicModel>> Function(GetSuggestedDhammaTracksRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetSuggestedDhammaTracksProvider._internal(
        (ref) => create(ref as GetSuggestedDhammaTracksRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        offset: offset,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<MusicModel>> createElement() {
    return _GetSuggestedDhammaTracksProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetSuggestedDhammaTracksProvider &&
        other.offset == offset &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, offset.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetSuggestedDhammaTracksRef
    on AutoDisposeFutureProviderRef<List<MusicModel>> {
  /// The parameter `offset` of this provider.
  int get offset;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _GetSuggestedDhammaTracksProviderElement
    extends AutoDisposeFutureProviderElement<List<MusicModel>>
    with GetSuggestedDhammaTracksRef {
  _GetSuggestedDhammaTracksProviderElement(super.provider);

  @override
  int get offset => (origin as GetSuggestedDhammaTracksProvider).offset;
  @override
  int get limit => (origin as GetSuggestedDhammaTracksProvider).limit;
}

String _$fetchTopTenPlayedTracksByBhikkhuHash() =>
    r'bae779f97e79e41e12415dcb32a15298860054d0';

/// See also [fetchTopTenPlayedTracksByBhikkhu].
@ProviderFor(fetchTopTenPlayedTracksByBhikkhu)
const fetchTopTenPlayedTracksByBhikkhuProvider =
    FetchTopTenPlayedTracksByBhikkhuFamily();

/// See also [fetchTopTenPlayedTracksByBhikkhu].
class FetchTopTenPlayedTracksByBhikkhuFamily
    extends Family<AsyncValue<List<MusicModel>>> {
  /// See also [fetchTopTenPlayedTracksByBhikkhu].
  const FetchTopTenPlayedTracksByBhikkhuFamily();

  /// See also [fetchTopTenPlayedTracksByBhikkhu].
  FetchTopTenPlayedTracksByBhikkhuProvider call(
    String bhikkhuId,
  ) {
    return FetchTopTenPlayedTracksByBhikkhuProvider(
      bhikkhuId,
    );
  }

  @override
  FetchTopTenPlayedTracksByBhikkhuProvider getProviderOverride(
    covariant FetchTopTenPlayedTracksByBhikkhuProvider provider,
  ) {
    return call(
      provider.bhikkhuId,
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
  String? get name => r'fetchTopTenPlayedTracksByBhikkhuProvider';
}

/// See also [fetchTopTenPlayedTracksByBhikkhu].
class FetchTopTenPlayedTracksByBhikkhuProvider
    extends AutoDisposeFutureProvider<List<MusicModel>> {
  /// See also [fetchTopTenPlayedTracksByBhikkhu].
  FetchTopTenPlayedTracksByBhikkhuProvider(
    String bhikkhuId,
  ) : this._internal(
          (ref) => fetchTopTenPlayedTracksByBhikkhu(
            ref as FetchTopTenPlayedTracksByBhikkhuRef,
            bhikkhuId,
          ),
          from: fetchTopTenPlayedTracksByBhikkhuProvider,
          name: r'fetchTopTenPlayedTracksByBhikkhuProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchTopTenPlayedTracksByBhikkhuHash,
          dependencies: FetchTopTenPlayedTracksByBhikkhuFamily._dependencies,
          allTransitiveDependencies:
              FetchTopTenPlayedTracksByBhikkhuFamily._allTransitiveDependencies,
          bhikkhuId: bhikkhuId,
        );

  FetchTopTenPlayedTracksByBhikkhuProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bhikkhuId,
  }) : super.internal();

  final String bhikkhuId;

  @override
  Override overrideWith(
    FutureOr<List<MusicModel>> Function(
            FetchTopTenPlayedTracksByBhikkhuRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchTopTenPlayedTracksByBhikkhuProvider._internal(
        (ref) => create(ref as FetchTopTenPlayedTracksByBhikkhuRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bhikkhuId: bhikkhuId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<MusicModel>> createElement() {
    return _FetchTopTenPlayedTracksByBhikkhuProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchTopTenPlayedTracksByBhikkhuProvider &&
        other.bhikkhuId == bhikkhuId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bhikkhuId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchTopTenPlayedTracksByBhikkhuRef
    on AutoDisposeFutureProviderRef<List<MusicModel>> {
  /// The parameter `bhikkhuId` of this provider.
  String get bhikkhuId;
}

class _FetchTopTenPlayedTracksByBhikkhuProviderElement
    extends AutoDisposeFutureProviderElement<List<MusicModel>>
    with FetchTopTenPlayedTracksByBhikkhuRef {
  _FetchTopTenPlayedTracksByBhikkhuProviderElement(super.provider);

  @override
  String get bhikkhuId =>
      (origin as FetchTopTenPlayedTracksByBhikkhuProvider).bhikkhuId;
}

String _$getAllBhikkhusHash() => r'25e4eaf65f3c06f441f82c51495b79eacd83fcf7';

/// See also [getAllBhikkhus].
@ProviderFor(getAllBhikkhus)
final getAllBhikkhusProvider =
    AutoDisposeFutureProvider<List<BhikkhuModel>>.internal(
  getAllBhikkhus,
  name: r'getAllBhikkhusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getAllBhikkhusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetAllBhikkhusRef = AutoDisposeFutureProviderRef<List<BhikkhuModel>>;
String _$getAllMingalarDhammaPlaylistsHash() =>
    r'a2f8f4ebd9d48c9592e33c145e8102274ec18269';

/// See also [getAllMingalarDhammaPlaylists].
@ProviderFor(getAllMingalarDhammaPlaylists)
final getAllMingalarDhammaPlaylistsProvider =
    AutoDisposeFutureProvider<List<CustomPlaylistCompilationModel>>.internal(
  getAllMingalarDhammaPlaylists,
  name: r'getAllMingalarDhammaPlaylistsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getAllMingalarDhammaPlaylistsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetAllMingalarDhammaPlaylistsRef
    = AutoDisposeFutureProviderRef<List<CustomPlaylistCompilationModel>>;
String _$getTenMingalarDhammaPlaylistsHash() =>
    r'17572fe63e80e7328d6dd919671b01bfa1938691';

/// See also [getTenMingalarDhammaPlaylists].
@ProviderFor(getTenMingalarDhammaPlaylists)
final getTenMingalarDhammaPlaylistsProvider =
    AutoDisposeFutureProvider<List<CustomPlaylistCompilationModel>>.internal(
  getTenMingalarDhammaPlaylists,
  name: r'getTenMingalarDhammaPlaylistsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getTenMingalarDhammaPlaylistsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetTenMingalarDhammaPlaylistsRef
    = AutoDisposeFutureProviderRef<List<CustomPlaylistCompilationModel>>;
String _$getAllUserDhammaPlaylistsHash() =>
    r'fee15a0b89833673cd81e107b528417dff7818b7';

/// See also [getAllUserDhammaPlaylists].
@ProviderFor(getAllUserDhammaPlaylists)
final getAllUserDhammaPlaylistsProvider =
    AutoDisposeFutureProvider<List<CustomPlaylistCompilationModel>>.internal(
  getAllUserDhammaPlaylists,
  name: r'getAllUserDhammaPlaylistsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getAllUserDhammaPlaylistsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetAllUserDhammaPlaylistsRef
    = AutoDisposeFutureProviderRef<List<CustomPlaylistCompilationModel>>;
String _$getTenUserDhammaPlaylistsHash() =>
    r'6eee6f5cf60d41a29f117ab9a704570c6a3e74f1';

/// See also [getTenUserDhammaPlaylists].
@ProviderFor(getTenUserDhammaPlaylists)
final getTenUserDhammaPlaylistsProvider =
    AutoDisposeFutureProvider<List<CustomPlaylistCompilationModel>>.internal(
  getTenUserDhammaPlaylists,
  name: r'getTenUserDhammaPlaylistsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getTenUserDhammaPlaylistsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetTenUserDhammaPlaylistsRef
    = AutoDisposeFutureProviderRef<List<CustomPlaylistCompilationModel>>;
String _$getAllDhammaCategoriesHash() =>
    r'81470b656e8765d43d993f7069818d2e37e9098a';

/// See also [getAllDhammaCategories].
@ProviderFor(getAllDhammaCategories)
final getAllDhammaCategoriesProvider =
    AutoDisposeFutureProvider<List<DhammaCategoryModel>>.internal(
  getAllDhammaCategories,
  name: r'getAllDhammaCategoriesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getAllDhammaCategoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetAllDhammaCategoriesRef
    = AutoDisposeFutureProviderRef<List<DhammaCategoryModel>>;
String _$getCollectionsByBhikkhuHash() =>
    r'0592a3c76101c913cc005239831aba8bb123eb8c';

/// See also [getCollectionsByBhikkhu].
@ProviderFor(getCollectionsByBhikkhu)
const getCollectionsByBhikkhuProvider = GetCollectionsByBhikkhuFamily();

/// See also [getCollectionsByBhikkhu].
class GetCollectionsByBhikkhuFamily
    extends Family<AsyncValue<List<DhammaCollectionModel>>> {
  /// See also [getCollectionsByBhikkhu].
  const GetCollectionsByBhikkhuFamily();

  /// See also [getCollectionsByBhikkhu].
  GetCollectionsByBhikkhuProvider call(
    String bhikkhuId,
  ) {
    return GetCollectionsByBhikkhuProvider(
      bhikkhuId,
    );
  }

  @override
  GetCollectionsByBhikkhuProvider getProviderOverride(
    covariant GetCollectionsByBhikkhuProvider provider,
  ) {
    return call(
      provider.bhikkhuId,
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
  String? get name => r'getCollectionsByBhikkhuProvider';
}

/// See also [getCollectionsByBhikkhu].
class GetCollectionsByBhikkhuProvider
    extends AutoDisposeFutureProvider<List<DhammaCollectionModel>> {
  /// See also [getCollectionsByBhikkhu].
  GetCollectionsByBhikkhuProvider(
    String bhikkhuId,
  ) : this._internal(
          (ref) => getCollectionsByBhikkhu(
            ref as GetCollectionsByBhikkhuRef,
            bhikkhuId,
          ),
          from: getCollectionsByBhikkhuProvider,
          name: r'getCollectionsByBhikkhuProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getCollectionsByBhikkhuHash,
          dependencies: GetCollectionsByBhikkhuFamily._dependencies,
          allTransitiveDependencies:
              GetCollectionsByBhikkhuFamily._allTransitiveDependencies,
          bhikkhuId: bhikkhuId,
        );

  GetCollectionsByBhikkhuProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bhikkhuId,
  }) : super.internal();

  final String bhikkhuId;

  @override
  Override overrideWith(
    FutureOr<List<DhammaCollectionModel>> Function(
            GetCollectionsByBhikkhuRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetCollectionsByBhikkhuProvider._internal(
        (ref) => create(ref as GetCollectionsByBhikkhuRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bhikkhuId: bhikkhuId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<DhammaCollectionModel>>
      createElement() {
    return _GetCollectionsByBhikkhuProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetCollectionsByBhikkhuProvider &&
        other.bhikkhuId == bhikkhuId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bhikkhuId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetCollectionsByBhikkhuRef
    on AutoDisposeFutureProviderRef<List<DhammaCollectionModel>> {
  /// The parameter `bhikkhuId` of this provider.
  String get bhikkhuId;
}

class _GetCollectionsByBhikkhuProviderElement
    extends AutoDisposeFutureProviderElement<List<DhammaCollectionModel>>
    with GetCollectionsByBhikkhuRef {
  _GetCollectionsByBhikkhuProviderElement(super.provider);

  @override
  String get bhikkhuId => (origin as GetCollectionsByBhikkhuProvider).bhikkhuId;
}

String _$getTenBhikkhusHash() => r'2e5fab93b53bb12e3c09a5e02d3137807ed19073';

/// See also [getTenBhikkhus].
@ProviderFor(getTenBhikkhus)
final getTenBhikkhusProvider =
    AutoDisposeFutureProvider<List<BhikkhuModel>>.internal(
  getTenBhikkhus,
  name: r'getTenBhikkhusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getTenBhikkhusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetTenBhikkhusRef = AutoDisposeFutureProviderRef<List<BhikkhuModel>>;
String _$getBhikkhuByIdHash() => r'a3d7b14864b9aab106356e65dbb5ed793e97b3cd';

/// See also [getBhikkhuById].
@ProviderFor(getBhikkhuById)
const getBhikkhuByIdProvider = GetBhikkhuByIdFamily();

/// See also [getBhikkhuById].
class GetBhikkhuByIdFamily extends Family<AsyncValue<BhikkhuModel>> {
  /// See also [getBhikkhuById].
  const GetBhikkhuByIdFamily();

  /// See also [getBhikkhuById].
  GetBhikkhuByIdProvider call(
    String bhikkhuId,
  ) {
    return GetBhikkhuByIdProvider(
      bhikkhuId,
    );
  }

  @override
  GetBhikkhuByIdProvider getProviderOverride(
    covariant GetBhikkhuByIdProvider provider,
  ) {
    return call(
      provider.bhikkhuId,
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
  String? get name => r'getBhikkhuByIdProvider';
}

/// See also [getBhikkhuById].
class GetBhikkhuByIdProvider extends AutoDisposeFutureProvider<BhikkhuModel> {
  /// See also [getBhikkhuById].
  GetBhikkhuByIdProvider(
    String bhikkhuId,
  ) : this._internal(
          (ref) => getBhikkhuById(
            ref as GetBhikkhuByIdRef,
            bhikkhuId,
          ),
          from: getBhikkhuByIdProvider,
          name: r'getBhikkhuByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getBhikkhuByIdHash,
          dependencies: GetBhikkhuByIdFamily._dependencies,
          allTransitiveDependencies:
              GetBhikkhuByIdFamily._allTransitiveDependencies,
          bhikkhuId: bhikkhuId,
        );

  GetBhikkhuByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bhikkhuId,
  }) : super.internal();

  final String bhikkhuId;

  @override
  Override overrideWith(
    FutureOr<BhikkhuModel> Function(GetBhikkhuByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetBhikkhuByIdProvider._internal(
        (ref) => create(ref as GetBhikkhuByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bhikkhuId: bhikkhuId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<BhikkhuModel> createElement() {
    return _GetBhikkhuByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetBhikkhuByIdProvider && other.bhikkhuId == bhikkhuId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bhikkhuId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetBhikkhuByIdRef on AutoDisposeFutureProviderRef<BhikkhuModel> {
  /// The parameter `bhikkhuId` of this provider.
  String get bhikkhuId;
}

class _GetBhikkhuByIdProviderElement
    extends AutoDisposeFutureProviderElement<BhikkhuModel>
    with GetBhikkhuByIdRef {
  _GetBhikkhuByIdProviderElement(super.provider);

  @override
  String get bhikkhuId => (origin as GetBhikkhuByIdProvider).bhikkhuId;
}

String _$getPreferredCollectionsByBhikkhuHash() =>
    r'70644e9979f2f84d13ec828898d6aa5f37240e4a';

/// See also [getPreferredCollectionsByBhikkhu].
@ProviderFor(getPreferredCollectionsByBhikkhu)
const getPreferredCollectionsByBhikkhuProvider =
    GetPreferredCollectionsByBhikkhuFamily();

/// See also [getPreferredCollectionsByBhikkhu].
class GetPreferredCollectionsByBhikkhuFamily
    extends Family<AsyncValue<List<DhammaCollectionModel>>> {
  /// See also [getPreferredCollectionsByBhikkhu].
  const GetPreferredCollectionsByBhikkhuFamily();

  /// See also [getPreferredCollectionsByBhikkhu].
  GetPreferredCollectionsByBhikkhuProvider call(
    String bhikkhuId,
  ) {
    return GetPreferredCollectionsByBhikkhuProvider(
      bhikkhuId,
    );
  }

  @override
  GetPreferredCollectionsByBhikkhuProvider getProviderOverride(
    covariant GetPreferredCollectionsByBhikkhuProvider provider,
  ) {
    return call(
      provider.bhikkhuId,
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
  String? get name => r'getPreferredCollectionsByBhikkhuProvider';
}

/// See also [getPreferredCollectionsByBhikkhu].
class GetPreferredCollectionsByBhikkhuProvider
    extends AutoDisposeFutureProvider<List<DhammaCollectionModel>> {
  /// See also [getPreferredCollectionsByBhikkhu].
  GetPreferredCollectionsByBhikkhuProvider(
    String bhikkhuId,
  ) : this._internal(
          (ref) => getPreferredCollectionsByBhikkhu(
            ref as GetPreferredCollectionsByBhikkhuRef,
            bhikkhuId,
          ),
          from: getPreferredCollectionsByBhikkhuProvider,
          name: r'getPreferredCollectionsByBhikkhuProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getPreferredCollectionsByBhikkhuHash,
          dependencies: GetPreferredCollectionsByBhikkhuFamily._dependencies,
          allTransitiveDependencies:
              GetPreferredCollectionsByBhikkhuFamily._allTransitiveDependencies,
          bhikkhuId: bhikkhuId,
        );

  GetPreferredCollectionsByBhikkhuProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bhikkhuId,
  }) : super.internal();

  final String bhikkhuId;

  @override
  Override overrideWith(
    FutureOr<List<DhammaCollectionModel>> Function(
            GetPreferredCollectionsByBhikkhuRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetPreferredCollectionsByBhikkhuProvider._internal(
        (ref) => create(ref as GetPreferredCollectionsByBhikkhuRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bhikkhuId: bhikkhuId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<DhammaCollectionModel>>
      createElement() {
    return _GetPreferredCollectionsByBhikkhuProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetPreferredCollectionsByBhikkhuProvider &&
        other.bhikkhuId == bhikkhuId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bhikkhuId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetPreferredCollectionsByBhikkhuRef
    on AutoDisposeFutureProviderRef<List<DhammaCollectionModel>> {
  /// The parameter `bhikkhuId` of this provider.
  String get bhikkhuId;
}

class _GetPreferredCollectionsByBhikkhuProviderElement
    extends AutoDisposeFutureProviderElement<List<DhammaCollectionModel>>
    with GetPreferredCollectionsByBhikkhuRef {
  _GetPreferredCollectionsByBhikkhuProviderElement(super.provider);

  @override
  String get bhikkhuId =>
      (origin as GetPreferredCollectionsByBhikkhuProvider).bhikkhuId;
}

String _$getCollectionTracksHash() =>
    r'df295dbe93cbbe7f29ba4f893b9c2e8cb2269bc1';

/// See also [getCollectionTracks].
@ProviderFor(getCollectionTracks)
const getCollectionTracksProvider = GetCollectionTracksFamily();

/// See also [getCollectionTracks].
class GetCollectionTracksFamily extends Family<AsyncValue<List<MusicModel>>> {
  /// See also [getCollectionTracks].
  const GetCollectionTracksFamily();

  /// See also [getCollectionTracks].
  GetCollectionTracksProvider call(
    DhammaCollectionModel collectionModel,
  ) {
    return GetCollectionTracksProvider(
      collectionModel,
    );
  }

  @override
  GetCollectionTracksProvider getProviderOverride(
    covariant GetCollectionTracksProvider provider,
  ) {
    return call(
      provider.collectionModel,
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
  String? get name => r'getCollectionTracksProvider';
}

/// See also [getCollectionTracks].
class GetCollectionTracksProvider
    extends AutoDisposeFutureProvider<List<MusicModel>> {
  /// See also [getCollectionTracks].
  GetCollectionTracksProvider(
    DhammaCollectionModel collectionModel,
  ) : this._internal(
          (ref) => getCollectionTracks(
            ref as GetCollectionTracksRef,
            collectionModel,
          ),
          from: getCollectionTracksProvider,
          name: r'getCollectionTracksProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getCollectionTracksHash,
          dependencies: GetCollectionTracksFamily._dependencies,
          allTransitiveDependencies:
              GetCollectionTracksFamily._allTransitiveDependencies,
          collectionModel: collectionModel,
        );

  GetCollectionTracksProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.collectionModel,
  }) : super.internal();

  final DhammaCollectionModel collectionModel;

  @override
  Override overrideWith(
    FutureOr<List<MusicModel>> Function(GetCollectionTracksRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetCollectionTracksProvider._internal(
        (ref) => create(ref as GetCollectionTracksRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        collectionModel: collectionModel,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<MusicModel>> createElement() {
    return _GetCollectionTracksProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetCollectionTracksProvider &&
        other.collectionModel == collectionModel;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, collectionModel.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetCollectionTracksRef on AutoDisposeFutureProviderRef<List<MusicModel>> {
  /// The parameter `collectionModel` of this provider.
  DhammaCollectionModel get collectionModel;
}

class _GetCollectionTracksProviderElement
    extends AutoDisposeFutureProviderElement<List<MusicModel>>
    with GetCollectionTracksRef {
  _GetCollectionTracksProviderElement(super.provider);

  @override
  DhammaCollectionModel get collectionModel =>
      (origin as GetCollectionTracksProvider).collectionModel;
}

String _$dhammaViewModelHash() => r'd7c4a5b55e8ff7102302793b47db554043375c0c';

/// See also [DhammaViewModel].
@ProviderFor(DhammaViewModel)
final dhammaViewModelProvider =
    AutoDisposeNotifierProvider<DhammaViewModel, AsyncValue?>.internal(
  DhammaViewModel.new,
  name: r'dhammaViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dhammaViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DhammaViewModel = AutoDisposeNotifier<AsyncValue?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
