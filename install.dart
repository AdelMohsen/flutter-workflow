import 'dart:convert';
import 'dart:io';

const managedPaths = <String>[
  '.specify/extensions/flutter-engine',
  '.specify/templates/flutter-engine',
  '.specify/workflows/flutter-engine-delivery',
  '.specify/workflows/flutter-engine-operations',
  '.agents/skills/flutter-engine',
  '.agents/skills/ponytail',
  '.agents/skills/flutter-owasp-security',
  '.agents/skills/flutter-unit-tests',
];

void main(List<String> args) {
  if (args.contains('--help') || args.contains('-h')) {
    _usage();
    return;
  }

  final targetValue = _option(args, '--target');
  if (targetValue == null) {
    stderr.writeln('Missing required option: --target');
    _usage();
    exitCode = 64;
    return;
  }

  final repository = File(Platform.script.toFilePath()).parent;
  final template = Directory(_join(repository.path, 'template'));
  final target = Directory(targetValue).absolute;

  try {
    _validateSource(template);
    _validateFlutterProject(target);
    final identity = _identity(template);
    _guardVersionChange(
      target,
      identity,
      args.contains('--allow-version-update'),
    );
    final specKit = _ensureSpecKit(target);
    if (specKit == 'ready') _registerSpecKit(template, target);
    _installManagedFiles(template, target);
    _ensureProjectFiles(template, target);
    _writeLock(target, identity, specKit);
    _ensureGitignore(target);
    _banner(identity, 'Installation', _name(target));
    stdout.writeln('Flutter Engine installed successfully.');
    stdout.writeln('Target: ${target.path}');
    stdout.writeln('Spec Kit: $specKit');
    stdout.writeln(
      specKit == 'ready'
          ? 'Next: open this project in Codex and send '
                '"flutter run flow:setup".'
          : 'Next: open this project in Codex and send '
                '"flutter run flow:setup"; setup will install Spec Kit.',
    );
  } on FileSystemException catch (error) {
    stderr.writeln('Installation failed: ${error.message}');
    if (error.path != null) stderr.writeln('Path: ${error.path}');
    exitCode = 1;
  } on FormatException catch (error) {
    stderr.writeln('Installation failed: ${error.message}');
    exitCode = 1;
  } catch (error) {
    stderr.writeln('Installation failed: $error');
    exitCode = 1;
  }
}

void _registerSpecKit(Directory template, Directory target) {
  final extensionsFile = File(_join(target.path, '.specify/extensions.yml'));
  final extensions = extensionsFile.existsSync()
      ? extensionsFile.readAsStringSync()
      : '';
  if (!RegExp(
    r'^\s*-\s*flutter-engine\s*$',
    multiLine: true,
  ).hasMatch(extensions)) {
    _runSpecKit(target, [
      'extension',
      'add',
      '--dev',
      _join(template.path, '.specify/extensions/flutter-engine'),
    ]);
  }

  final registryFile = File(
    _join(target.path, '.specify/workflows/workflow-registry.json'),
  );
  Map<String, dynamic> registry = {};
  if (registryFile.existsSync()) {
    try {
      final decoded = jsonDecode(registryFile.readAsStringSync());
      if (decoded is Map) registry = Map<String, dynamic>.from(decoded);
    } catch (_) {
      throw const FormatException(
        'Spec Kit workflow-registry.json is unreadable.',
      );
    }
  }
  final workflows = registry['workflows'];
  final installed = workflows is Map ? workflows : const <String, dynamic>{};
  for (final id in ['flutter-engine-delivery', 'flutter-engine-operations']) {
    if (installed.containsKey(id)) continue;
    _runSpecKit(target, [
      'workflow',
      'add',
      _join(template.path, '.specify/workflows/$id/workflow.yml'),
    ]);
  }
}

void _runSpecKit(Directory target, List<String> arguments) {
  final result = Process.runSync(
    'specify',
    arguments,
    workingDirectory: target.path,
    runInShell: Platform.isWindows,
  );
  if (result.exitCode != 0) {
    final message = [
      result.stderr.toString().trim(),
      result.stdout.toString().trim(),
    ].where((part) => part.isNotEmpty).join('\n');
    throw FormatException(
      'Spec Kit command failed: specify ${arguments.join(' ')}'
      '${message.isEmpty ? '' : '\n$message'}',
    );
  }
}

void _guardVersionChange(
  Directory target,
  Map<String, String> identity,
  bool allowed,
) {
  final lock = File(
    _join(target.path, '.specify/flutter-engine/engine.lock.json'),
  );
  if (!lock.existsSync()) return;
  try {
    final current = jsonDecode(lock.readAsStringSync());
    final installed = current is Map ? current['version'] : null;
    if (installed is String && installed != identity['version'] && !allowed) {
      throw FormatException(
        'Engine version change $installed → ${identity['version']} requires an '
        'approved "flutter run flow:engine-update" plan.',
      );
    }
  } on FormatException {
    rethrow;
  } catch (_) {
    throw const FormatException(
      'Existing engine.lock.json is unreadable; run "flutter run flow:check".',
    );
  }
}

Map<String, String> _identity(Directory template) {
  final file = File(
    _join(template.path, '.specify/extensions/flutter-engine/engine.json'),
  );
  final value = jsonDecode(file.readAsStringSync());
  if (value is! Map)
    throw const FormatException('engine.json must be an object.');

  const keys = [
    'schema_version',
    'id',
    'name',
    'version',
    'organization',
    'organization_label',
    'automation',
    'creator',
    'repository',
    'spec_kit',
  ];
  final result = <String, String>{};
  for (final key in keys) {
    final item = value[key];
    if (item is! String || item.trim().isEmpty) {
      throw FormatException('engine.json has an invalid "$key" value.');
    }
    result[key] = item.trim();
  }
  return result;
}

String _ensureSpecKit(Directory target) {
  if (!_commandExists('specify')) return 'pending setup';
  if (File(_join(target.path, '.specify/integration.json')).existsSync()) {
    return 'ready';
  }

  final result = Process.runSync(
    'specify',
    [
      'init',
      '--here',
      '--integration',
      'codex',
      '--force',
      '--no-git',
      '--ignore-agent-tools',
    ],
    workingDirectory: target.path,
    runInShell: Platform.isWindows,
  );
  if (result.exitCode != 0) {
    final message = result.stderr.toString().trim();
    throw FormatException(
      'Spec Kit initialization failed${message.isEmpty ? '.' : ': $message'}',
    );
  }
  return 'ready';
}

bool _commandExists(String command) {
  final result = Process.runSync(
    Platform.isWindows ? 'where' : 'sh',
    Platform.isWindows ? [command] : ['-c', r'command -v "$1"', 'sh', command],
    runInShell: Platform.isWindows,
  );
  return result.exitCode == 0;
}

void _installManagedFiles(Directory template, Directory target) {
  final backup = Directory.systemTemp.createTempSync('flutter-engine-backup-');
  final replaced = <String>[];
  try {
    for (final path in managedPaths) {
      final source = _entity(template.path, path);
      final destination = _entity(target.path, path);
      if (_exists(destination)) {
        final destinationType = FileSystemEntity.typeSync(
          destination.path,
          followLinks: false,
        );
        if (destinationType != FileSystemEntityType.link) {
          _copy(destination, _entity(backup.path, path));
          replaced.add(path);
        }
        _delete(destination);
      }
      _copy(source, destination);
    }
  } catch (_) {
    for (final path in managedPaths.reversed) {
      final destination = _entity(target.path, path);
      if (_exists(destination)) _delete(destination);
      if (replaced.contains(path)) {
        _copy(_entity(backup.path, path), destination);
      }
    }
    rethrow;
  } finally {
    if (backup.existsSync()) backup.deleteSync(recursive: true);
  }
}

void _ensureProjectFiles(Directory template, Directory target) {
  final projectOwned = <String, String>{
    '.specify/flutter-engine/design/design-contract.json':
        '.specify/flutter-engine/design/design-contract.json',
    '.specify/flutter-engine/installed/project-profile.md':
        '.specify/flutter-engine/installed/project-profile.md',
  };
  for (final entry in projectOwned.entries) {
    final destination = File(_join(target.path, entry.key));
    if (!destination.existsSync()) {
      destination.parent.createSync(recursive: true);
      File(_join(template.path, entry.value)).copySync(destination.path);
    }
  }
  Directory(_join(target.path, '.specify/specs')).createSync(recursive: true);
  Directory(
    _join(target.path, '.specify/flutter-engine/installed/components'),
  ).createSync(recursive: true);
  Directory(
    _join(target.path, '.specify/flutter-engine/legacy'),
  ).createSync(recursive: true);
  Directory(
    _join(target.path, '.specify/flutter-engine/cache'),
  ).createSync(recursive: true);
}

void _writeLock(
  Directory target,
  Map<String, String> identity,
  String specKit,
) {
  final lock = File(
    _join(target.path, '.specify/flutter-engine/engine.lock.json'),
  );
  final now = DateTime.now().toUtc().toIso8601String();
  String installedAt = now;
  if (lock.existsSync()) {
    try {
      final old = jsonDecode(lock.readAsStringSync());
      if (old is Map && old['installed_at'] is String) {
        installedAt = old['installed_at'] as String;
      }
    } catch (_) {
      // Engine-owned unreadable metadata is safely replaced.
    }
  }

  final legacy = Directory(
    _join(target.path, '.flutter-workflow'),
  ).existsSync();
  final value = {
    'schema_version': '2.0',
    'engine': identity['id'],
    'version': identity['version'],
    'repository': identity['repository'],
    'spec_kit_requirement': identity['spec_kit'],
    'spec_kit_status': specKit,
    'installed_at': installedAt,
    'updated_at': now,
    'managed_paths': managedPaths,
    'managed_checksums': _managedChecksums(target),
    'legacy_v1_detected': legacy,
    'migration_state': legacy ? 'pending_plan' : 'not_required',
  };
  final temporary = File('${lock.path}.tmp');
  temporary.writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(value)}\n',
  );
  if (lock.existsSync()) lock.deleteSync();
  temporary.renameSync(lock.path);
}

Map<String, String> _managedChecksums(Directory target) {
  final files = <File>[];
  for (final path in managedPaths) {
    final entity = _entity(target.path, path);
    if (entity is File) {
      files.add(entity);
    } else if (entity is Directory) {
      files.addAll(
        entity.listSync(recursive: true, followLinks: false).whereType<File>(),
      );
    }
  }
  files.sort((a, b) => a.path.compareTo(b.path));
  return {
    for (final file in files)
      file.path
          .substring(target.path.length + 1)
          .replaceAll(Platform.pathSeparator, '/'): _sha256(
        file,
      ),
  };
}

String _sha256(File file) {
  final attempts = Platform.isWindows
      ? <(String, List<String>)>[
          ('certutil', ['-hashfile', file.path, 'SHA256']),
        ]
      : <(String, List<String>)>[
          ('sha256sum', [file.path]),
          ('shasum', ['-a', '256', file.path]),
        ];
  final pattern = RegExp(r'\b[0-9a-fA-F]{64}\b');
  for (final attempt in attempts) {
    try {
      final result = Process.runSync(attempt.$1, attempt.$2);
      final match = pattern.firstMatch(result.stdout.toString());
      if (result.exitCode == 0 && match != null) {
        return match.group(0)!.toLowerCase();
      }
    } catch (_) {
      // Try the next native hashing command.
    }
  }
  throw FileSystemException(
    'No SHA-256 command is available (sha256sum, shasum, or certutil)',
    file.path,
  );
}

void _ensureGitignore(Directory target) {
  final file = File(_join(target.path, '.gitignore'));
  const marker = '# Flutter Engine local state';
  const block =
      '''
$marker
.specify/flutter-engine/cache/
''';
  final current = file.existsSync() ? file.readAsStringSync() : '';
  if (current.contains(marker)) return;
  file.writeAsStringSync(
    '${current.isEmpty || current.endsWith('\n') ? current : '$current\n'}$block',
  );
}

void _validateSource(Directory template) {
  if (!template.existsSync()) {
    throw FileSystemException('Template directory is missing', template.path);
  }
  for (final path in managedPaths) {
    final item = _entity(template.path, path);
    if (!_exists(item)) {
      throw FileSystemException('Managed template path is missing', item.path);
    }
  }
}

void _validateFlutterProject(Directory target) {
  if (!target.existsSync()) {
    throw FileSystemException('Target directory does not exist', target.path);
  }
  final pubspec = File(_join(target.path, 'pubspec.yaml'));
  final lib = Directory(_join(target.path, 'lib'));
  if (!pubspec.existsSync() || !lib.existsSync()) {
    throw FileSystemException(
      'Target must contain pubspec.yaml and lib/',
      target.path,
    );
  }
  final yaml = pubspec.readAsStringSync();
  final flutter = RegExp(
    r'^dependencies:\s*$.*?^\s{2,}flutter:\s*$.*?^\s{4,}sdk:\s*flutter\s*$',
    multiLine: true,
    dotAll: true,
  );
  if (!flutter.hasMatch(yaml)) {
    throw const FormatException(
      'pubspec.yaml does not declare Flutter as an SDK dependency.',
    );
  }
}

void _banner(Map<String, String> identity, String flow, String workspace) {
  const width = 48;
  final border = List.filled(width, '─').join();
  String line(String value) => '│${' $value'.padRight(width)}│';
  stdout.writeln('╭$border╮');
  stdout.writeln(line(identity['organization_label']!));
  stdout.writeln(line('${identity['name']} · v${identity['version']}'));
  stdout.writeln(line('Automation: ${identity['automation']}'));
  stdout.writeln('╰$border╯\n');
  stdout.writeln('Flow        $flow');
  stdout.writeln('Workspace   $workspace\n');
  stdout.writeln('created by ${identity['creator']}\n');
}

String? _option(List<String> args, String name) {
  final index = args.indexOf(name);
  if (index < 0 || index + 1 >= args.length) return null;
  final value = args[index + 1].trim();
  return value.isEmpty ? null : value;
}

void _usage() => stdout.writeln(
  'Usage: dart run install.dart --target /absolute/path/to/flutter-project',
);

String _name(Directory directory) =>
    directory.uri.pathSegments.where((segment) => segment.isNotEmpty).last;

String _join(String root, String relative) => relative
    .split('/')
    .fold(root, (path, part) => '$path${Platform.pathSeparator}$part');

FileSystemEntity _entity(String root, String relative) {
  final path = _join(root, relative);
  return FileSystemEntity.typeSync(path, followLinks: false) ==
          FileSystemEntityType.directory
      ? Directory(path)
      : File(path);
}

bool _exists(FileSystemEntity entity) =>
    FileSystemEntity.typeSync(entity.path, followLinks: false) !=
    FileSystemEntityType.notFound;

void _copy(FileSystemEntity source, FileSystemEntity destination) {
  final type = FileSystemEntity.typeSync(source.path, followLinks: false);
  if (type == FileSystemEntityType.directory) {
    final output = Directory(destination.path)..createSync(recursive: true);
    for (final child in Directory(source.path).listSync(followLinks: false)) {
      final name = child.uri.pathSegments.where((part) => part.isNotEmpty).last;
      _copy(child, _entity(output.path, name));
    }
    return;
  }
  if (type == FileSystemEntityType.file) {
    final output = File(destination.path);
    output.parent.createSync(recursive: true);
    File(source.path).copySync(output.path);
    return;
  }
  throw FileSystemException('Unsupported template entry', source.path);
}

void _delete(FileSystemEntity entity) {
  if (entity is Directory) {
    entity.deleteSync(recursive: true);
  } else {
    File(entity.path).deleteSync();
  }
}
