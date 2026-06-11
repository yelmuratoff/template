import 'dart:io';

/// Rebrands the template in one pass: display name, application/bundle id,
/// and Dart package name across Android, iOS, web, l10n, and docs.
///
/// Usage:
///   dart run tool/rename_app.dart --name "My App" --id com.company.app
///   dart run tool/rename_app.dart --name "My App" --id com.company.app \
///     --package my_app --dry-run
///
/// Current values are read from `pubspec.yaml` and `flavorizr.yaml`, so the
/// script is safe to re-run for a later rename.
void main(List<String> args) {
  final options = _Options.parse(args);
  final root = _findProjectRoot();

  final oldPackage = _readPubspecName(root);
  final (oldName, oldId) = _readFlavorizr(root);

  final newPackage = options.package ?? _toSnakeCase(options.name);
  _validatePackage(newPackage);

  stdout
    ..writeln('Renaming:')
    ..writeln('  name:    "$oldName" -> "${options.name}"')
    ..writeln('  id:      $oldId -> ${options.id}')
    ..writeln('  package: $oldPackage -> $newPackage')
    ..writeln(options.dryRun ? '  (dry run, nothing is written)' : '');

  final editor = _Editor(root: root, dryRun: options.dryRun);

  _renameDartPackage(editor, oldPackage, newPackage);
  _renameApplicationId(editor, oldId, options.id);
  _renameDisplayName(editor, oldName, options.name);
  _moveMainActivity(editor, oldId, options.id);

  editor.printSummary();

  if (!options.dryRun) {
    stdout
      ..writeln('\nNext steps:')
      ..writeln('  1. flutter pub get')
      ..writeln(
        '  2. Replace the Firebase configs in firebase/ and '
        'ios/Runner/{dev,prod}/ — they are bound to the bundle id.',
      )
      ..writeln('  3. flutter run --flavor dev --target lib/main_dev.dart');
  }
}

void _renameDartPackage(_Editor e, String oldPackage, String newPackage) {
  e.replaceInFile(
    'pubspec.yaml',
    RegExp('^name: $oldPackage\$', multiLine: true),
    'name: $newPackage',
  );
  for (final dir in ['lib', 'test']) {
    e.replaceInTree(dir, 'package:$oldPackage/', 'package:$newPackage/');
  }
  for (final doc in ['README.md', 'docs/STRUCTURE.md', 'CONTRIBUTING.md']) {
    e.replaceInFile(doc, oldPackage, newPackage);
  }
}

void _renameApplicationId(_Editor e, String oldId, String newId) {
  // Plain prefix replacement also covers the ".dev" and ".RunnerTests"
  // variants derived from the base id.
  for (final file in [
    'flavorizr.yaml',
    'android/app/build.gradle',
    'ios/Runner.xcodeproj/project.pbxproj',
    'ios/Runner/GoogleService-Info.plist',
    'ios/Runner/dev/GoogleService-Info.plist',
    'ios/Runner/prod/GoogleService-Info.plist',
    'lib/src/common/constants/app_constants.dart',
  ]) {
    e.replaceInFile(file, oldId, newId);
  }
}

void _renameDisplayName(_Editor e, String oldName, String newName) {
  // "<name> Dev" / "<name> [Dev]" must be replaced before the bare name,
  // otherwise the prefix match leaves a stale suffix behind.
  for (final file in ['flavorizr.yaml', 'android/app/build.gradle']) {
    e
      ..replaceInFile(file, '"$oldName Dev"', '"$newName Dev"')
      ..replaceInFile(file, '"$oldName"', '"$newName"');
  }

  for (final flavor in ['dev', 'prod']) {
    final title = flavor == 'dev' ? '$newName Dev' : newName;
    for (final config in ['Debug', 'Release', 'Profile']) {
      final file = 'ios/Flutter/$flavor$config.xcconfig';
      e
        ..replaceInFile(
          file,
          RegExp(r'^BUNDLE_NAME=.*$', multiLine: true),
          'BUNDLE_NAME=$title',
        )
        ..replaceInFile(
          file,
          RegExp(r'^BUNDLE_DISPLAY_NAME=.*$', multiLine: true),
          'BUNDLE_DISPLAY_NAME=$title',
        );
    }
  }

  e
    ..replaceInFile('lib/flavors.dart', "'$oldName [Dev]'", "'$newName [Dev]'")
    ..replaceInFile('lib/flavors.dart', "'$oldName'", "'$newName'")
    ..replaceInFile(
      'lib/src/common/constants/app_constants.dart',
      "'$oldName'",
      "'$newName'",
    );

  for (final locale in ['en', 'ru', 'kk']) {
    e.replaceInFile(
      'lib/src/core/l10n/translations/intl_$locale.arb',
      '"appTitle": "$oldName"',
      '"appTitle": "$newName"',
    );
  }

  e
    ..replaceInTree('lib/src/core/l10n/generated', "'$oldName'", "'$newName'")
    ..replaceInFile(
      'web/manifest.json',
      '"name": "$oldName"',
      '"name": "$newName"',
    )
    ..replaceInFile(
      'web/manifest.json',
      '"short_name": "$oldName"',
      '"short_name": "$newName"',
    )
    ..replaceInFile(
      'web/index.html',
      'content="$oldName"',
      'content="$newName"',
    )
    ..replaceInFile(
      'web/index.html',
      '<title>$oldName</title>',
      '<title>$newName</title>',
    );
}

void _moveMainActivity(_Editor e, String oldId, String newId) {
  final oldDir = 'android/app/src/main/kotlin/${oldId.replaceAll('.', '/')}';
  final newDir = 'android/app/src/main/kotlin/${newId.replaceAll('.', '/')}';
  e
    ..replaceInFile(
      '$oldDir/MainActivity.kt',
      'package $oldId',
      'package $newId',
    )
    ..moveFile('$oldDir/MainActivity.kt', '$newDir/MainActivity.kt');
}

class _Options {
  const _Options({
    required this.name,
    required this.id,
    required this.package,
    required this.dryRun,
  });

  factory _Options.parse(List<String> args) {
    String? name;
    String? id;
    String? package;
    var dryRun = false;

    for (var i = 0; i < args.length; i++) {
      switch (args[i]) {
        case '--name':
          name = _value(args, ++i, '--name');
        case '--id':
          id = _value(args, ++i, '--id');
        case '--package':
          package = _value(args, ++i, '--package');
        case '--dry-run':
          dryRun = true;
        case '--help' || '-h':
          _usage(exitCode: 0);
        default:
          stderr.writeln('Unknown argument: ${args[i]}');
          _usage();
      }
    }

    if (name == null || name.trim().isEmpty) {
      stderr.writeln('Error: --name is required.');
      _usage();
    }
    if (id == null ||
        !RegExp(r'^[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*)+$').hasMatch(id)) {
      stderr.writeln(
        'Error: --id must be a valid reverse-DNS id (e.g. com.company.app).',
      );
      _usage();
    }
    return _Options(
      name: name.trim(),
      id: id,
      package: package,
      dryRun: dryRun,
    );
  }

  final String name;
  final String id;
  final String? package;
  final bool dryRun;

  static String _value(List<String> args, int index, String flag) {
    if (index >= args.length) {
      stderr.writeln('Error: missing value for $flag.');
      _usage();
    }
    return args[index];
  }

  static Never _usage({int exitCode = 64}) {
    stdout.writeln(
      'Usage: dart run tool/rename_app.dart '
      '--name "My App" --id com.company.app [--package my_app] [--dry-run]',
    );
    exit(exitCode);
  }
}

class _Editor {
  _Editor({required this.root, required this.dryRun});

  final Directory root;
  final bool dryRun;
  final List<String> changed = [];
  final List<String> skipped = [];

  void replaceInFile(String relativePath, Pattern from, String to) {
    final file = File('${root.path}/$relativePath');
    if (!file.existsSync()) {
      skipped.add(relativePath);
      return;
    }
    final content = file.readAsStringSync();
    final updated = content.replaceAll(from, to);
    if (updated == content) return;
    if (!dryRun) file.writeAsStringSync(updated);
    if (!changed.contains(relativePath)) changed.add(relativePath);
  }

  void replaceInTree(String relativeDir, String from, String to) {
    final dir = Directory('${root.path}/$relativeDir');
    if (!dir.existsSync()) {
      skipped.add(relativeDir);
      return;
    }
    for (final entity in dir.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final relative = entity.path.substring(root.path.length + 1);
      replaceInFile(relative, from, to);
    }
  }

  void moveFile(String fromPath, String toPath) {
    if (fromPath == toPath) return;
    final from = File('${root.path}/$fromPath');
    if (!from.existsSync()) {
      skipped.add(fromPath);
      return;
    }
    if (!dryRun) {
      final to = File('${root.path}/$toPath')
        ..parent.createSync(recursive: true);
      from.renameSync(to.path);
      _removeEmptyParents(from.parent);
    }
    changed.add('$fromPath -> $toPath');
  }

  void _removeEmptyParents(Directory dir) {
    var current = dir;
    final kotlinRoot = '${root.path}/android/app/src/main/kotlin';
    while (current.path != kotlinRoot &&
        current.existsSync() &&
        current.listSync().isEmpty) {
      final parent = current.parent;
      current.deleteSync();
      current = parent;
    }
  }

  void printSummary() {
    stdout.writeln('\nUpdated ${changed.length} path(s):');
    for (final path in changed) {
      stdout.writeln('  $path');
    }
    if (skipped.isNotEmpty) {
      stdout.writeln('Skipped (not found): ${skipped.toSet().join(', ')}');
    }
  }
}

Directory _findProjectRoot() {
  var dir = Directory.current;
  while (!File('${dir.path}/pubspec.yaml').existsSync()) {
    if (dir.path == dir.parent.path) {
      stderr.writeln('Error: pubspec.yaml not found; run from the repo.');
      exit(66);
    }
    dir = dir.parent;
  }
  return dir;
}

String _readPubspecName(Directory root) {
  final content = File('${root.path}/pubspec.yaml').readAsStringSync();
  final match = RegExp(r'^name: (.+)$', multiLine: true).firstMatch(content);
  if (match == null) {
    stderr.writeln('Error: could not read `name:` from pubspec.yaml.');
    exit(65);
  }
  return match.group(1)!.trim();
}

(String, String) _readFlavorizr(Directory root) {
  final content = File('${root.path}/flavorizr.yaml').readAsStringSync();
  final name = RegExp('name: "([^"]+)"').firstMatch(content);
  final id = RegExp('applicationId: "([^"]+)"').firstMatch(content);
  if (name == null || id == null) {
    stderr.writeln(
      'Error: could not read the prod name/applicationId from flavorizr.yaml.',
    );
    exit(65);
  }
  return (name.group(1)!, id.group(1)!);
}

String _toSnakeCase(String name) {
  final snake = name
      .trim()
      .replaceAll(RegExp('[^A-Za-z0-9]+'), '_')
      .replaceAllMapped(RegExp('(?<=[a-z0-9])(?=[A-Z])'), (_) => '_')
      .toLowerCase()
      .replaceAll(RegExp('_+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '');
  _validatePackage(snake);
  return snake;
}

void _validatePackage(String package) {
  if (!RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(package)) {
    stderr.writeln(
      'Error: package "$package" is not a valid Dart package name; '
      'pass one explicitly via --package.',
    );
    exit(64);
  }
}
