import 'dart:convert';
import 'dart:io';

void main() {
  final root = File(Platform.script.toFilePath()).parent.parent;
  final assets = Directory(
    _join(
      root.path,
      'template/.specify/extensions/flutter-engine/components/project-foundation-v2/assets',
    ),
  );
  _auditAssets(assets);

  final temporary = Directory.systemTemp.createTempSync(
    'flutter_engine_foundation_',
  );
  final project = Directory(_join(temporary.path, 'app'));
  try {
    _run('flutter', [
      'create',
      '--empty',
      '--platforms=android,ios,web',
      project.path,
    ], temporary);

    _copy(
      Directory(_join(assets.path, 'lib')),
      Directory(_join(project.path, 'lib')),
    );
    _copy(
      Directory(_join(assets.path, 'test')),
      Directory(_join(project.path, 'test')),
    );
    File(
      _join(assets.path, 'l10n.yaml'),
    ).copySync(_join(project.path, 'l10n.yaml'));
    File(
      _join(assets.path, 'analysis_options.yaml'),
    ).copySync(_join(project.path, 'analysis_options.yaml'));

    final pubspec = File(_join(project.path, 'pubspec.yaml'));
    pubspec.writeAsStringSync(
      pubspec.readAsStringSync().replaceFirst(
        'uses-material-design: true',
        'uses-material-design: true\n  generate: true',
      ),
    );

    _run('flutter', [
      'pub',
      'add',
      'flutter_localizations',
      '--sdk=flutter',
    ], project);
    _run('flutter', [
      'pub',
      'add',
      'flutter_web_plugins',
      '--sdk=flutter',
    ], project);
    _run('flutter', [
      'pub',
      'add',
      'flutter_bloc',
      'dio',
      'go_router',
      'flutter_secure_storage',
      'google_fonts',
      'hexcolor',
      'image_picker',
      'file_picker',
      'loader_overlay',
      'toastification',
      'intl',
      'cupertino_icons',
    ], project);
    _run('flutter', ['pub', 'add', '--dev', 'flutter_lints'], project);
    _run('flutter', ['gen-l10n'], project);
    _run('dart', ['format', 'lib', 'test'], project);
    _run('flutter', ['analyze'], project);
    _run('flutter', ['test'], project);
    _run('flutter', ['build', 'web'], project);
    stdout.writeln('Project Foundation fixture smoke check passed.');
  } finally {
    temporary.deleteSync(recursive: true);
  }
}

void _auditAssets(Directory assets) {
  final forbidden = assets
      .listSync(recursive: true)
      .whereType<File>()
      .where(
        (file) => RegExp(
          r'\.(png|jpe?g|svg)$',
          caseSensitive: false,
        ).hasMatch(file.path),
      )
      .toList();
  if (forbidden.isNotEmpty) {
    throw StateError('Foundation contains unapproved image/icon assets.');
  }

  final localeFiles = Directory(_join(assets.path, 'lib/l10n'))
      .listSync()
      .whereType<File>()
      .where((file) => file.path.endsWith('.arb'))
      .toList();
  if (localeFiles.length < 2)
    throw StateError('Foundation needs at least two locales.');

  Set<String>? expected;
  for (final file in localeFiles) {
    final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    final keys = json.keys.where((key) => !key.startsWith('@')).toSet();
    if (keys.isEmpty) throw StateError('Empty locale: ${file.path}');
    expected ??= keys;
    if (expected.length != keys.length || !expected.containsAll(keys)) {
      throw StateError('Locale keys differ: ${file.path}');
    }
  }

  final dartSource = Directory(_join(assets.path, 'lib'))
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .map((file) => file.readAsStringSync())
      .join('\n');
  for (final key in expected!) {
    if (!dartSource.contains('.$key')) {
      throw StateError('Unused localization key: $key');
    }
  }
}

void _copy(Directory source, Directory destination) {
  if (destination.existsSync()) destination.deleteSync(recursive: true);
  destination.createSync(recursive: true);
  for (final entity in source.listSync(recursive: true)) {
    final relative = entity.path.substring(source.path.length + 1);
    final target = _join(destination.path, relative);
    if (entity is Directory) {
      Directory(target).createSync(recursive: true);
    } else if (entity is File) {
      File(target).parent.createSync(recursive: true);
      entity.copySync(target);
    }
  }
}

void _run(
  String executable,
  List<String> arguments,
  Directory workingDirectory,
) {
  final result = Process.runSync(
    executable,
    arguments,
    workingDirectory: workingDirectory.path,
    runInShell: Platform.isWindows,
  );
  if (result.exitCode == 0) return;
  stderr.writeln(result.stdout);
  stderr.writeln(result.stderr);
  throw StateError('$executable ${arguments.join(' ')} failed.');
}

String _join(String root, String relative) => relative
    .split('/')
    .fold(root, (path, part) => '$path${Platform.pathSeparator}$part');
