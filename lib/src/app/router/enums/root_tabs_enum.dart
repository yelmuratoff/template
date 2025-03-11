/// RootTabsEnum enumeration
enum RootTabsEnum implements Comparable<RootTabsEnum> {
  /// Home
  home(bucket: 'home-tab', value: 'home'),

  /// Profile
  profile(bucket: 'profile-tab', value: 'profile');

  const RootTabsEnum({
    required this.bucket,
    required this.value,
  });

  /// Creates a new instance of [RootTabsEnum] from a given string.
  static RootTabsEnum parse(
    String? value, {
    RootTabsEnum? fallback,
  }) =>
      switch (value?.trim().toLowerCase()) {
        'home' => home,
        'profile' => profile,
        _ => fallback ?? (throw ArgumentError.value(value)),
      };

  /// Creates a new instance of [RootTabsEnum] from a given string.
  static RootTabsEnum? tryParse(
    String? value,
  ) =>
      switch (value?.trim().toLowerCase()) {
        'home' => home,
        'profile' => profile,
        _ => null,
      };

  /// Returns the bucket of the current [RootTabsEnum].
  final String bucket;

  /// Returns the name of the current [RootTabsEnum].
  final String value;

  /// Pattern matching
  T map<T>({
    required T Function() home,
    required T Function() profile,
  }) =>
      switch (this) {
        RootTabsEnum.home => home(),
        RootTabsEnum.profile => profile(),
      };

  /// Pattern matching
  T maybeMap<T>({
    required T Function() orElse,
    T Function()? home,
    T Function()? profile,
  }) =>
      map<T>(
        home: home ?? orElse,
        profile: profile ?? orElse,
      );

  /// Pattern matching
  T? maybeMapOrNull<T>({
    T Function()? home,
    T Function()? profile,
  }) =>
      maybeMap<T?>(
        orElse: () => null,
        home: home,
        profile: profile,
      );

  @override
  int compareTo(RootTabsEnum other) => index.compareTo(other.index);

  @override
  String toString() => name;
}
