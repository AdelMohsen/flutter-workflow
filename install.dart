import 'dart:convert';
import 'dart:io';

const workflowName = 'flutter-codex-workflow';
const workflowVersion = '1.0.0';

const managedPaths = <String>[
  'FLUTTER-WORKFLOW.md',
  '.agents/skills/flutter-project-init',
  '.agents/skills/flutter-new-feature',
  '.agents/skills/flutter-change-feature',
  '.agents/skills/flutter-fix-bug',
];

void main(List<String> args) {
  if (args.contains('--help') || args.contains('-h')) {
    _printUsage();
    return;
  }

  final targetArgument = _readOption(args, '--target');
  if (targetArgument == null) {
    stderr.writeln('Missing required option: --target');
    _printUsage();
    exitCode = 64;
    return;
  }

  final sourceRoot = File(Platform.script.toFilePath()).parent;
  final templateRoot = Directory(
    '${sourceRoot.path}${Platform.pathSeparator}template',
  );
  final targetRoot = Directory(targetArgument).absolute;

  try {
    _validateSource(templateRoot);
    _validateFlutterProject(targetRoot);
    _install(templateRoot, targetRoot);
    stdout.writeln('Flutter Codex Workflow $workflowVersion installed.');
    stdout.writeln('Target: ${targetRoot.path}');
    stdout.writeln(
      'Next: open the project in Codex and send "flutter workflow:init".',
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

String? _readOption(List<String> args, String name) {
  final index = args.indexOf(name);
  if (index == -1 || index + 1 >= args.length) return null;
  final value = args[index + 1].trim();
  return value.isEmpty ? null : value;
}

void _printUsage() {
  stdout.writeln(
    'Usage: dart run install.dart --target /absolute/path/to/flutter-project',
  );
}

void _validateSource(Directory templateRoot) {
  if (!templateRoot.existsSync()) {
    throw FileSystemException(
      'Template directory is missing',
      templateRoot.path,
    );
  }

  for (final relativePath in managedPaths) {
    final source = _entityAt(templateRoot.path, relativePath);
    if (FileSystemEntity.typeSync(source.path) ==
        FileSystemEntityType.notFound) {
      throw FileSystemException(
        'Managed template path is missing',
        source.path,
      );
    }
  }
}

void _validateFlutterProject(Directory targetRoot) {
  if (!targetRoot.existsSync()) {
    throw FileSystemException(
      'Target directory does not exist',
      targetRoot.path,
    );
  }

  final pubspec = File(
    '${targetRoot.path}${Platform.pathSeparator}pubspec.yaml',
  );
  final lib = Directory('${targetRoot.path}${Platform.pathSeparator}lib');
  if (!pubspec.existsSync() || !lib.existsSync()) {
    throw FileSystemException(
      'Target must contain pubspec.yaml and lib/',
      targetRoot.path,
    );
  }

  final yaml = pubspec.readAsStringSync();
  final flutterSdkDependency = RegExp(
    r'^dependencies:\s*$.*?^\s{2,}flutter:\s*$.*?^\s{4,}sdk:\s*flutter\s*$',
    multiLine: true,
    dotAll: true,
  );
  if (!flutterSdkDependency.hasMatch(yaml)) {
    throw const FormatException(
      'pubspec.yaml does not declare Flutter as an SDK dependency.',
    );
  }
}

void _install(Directory templateRoot, Directory targetRoot) {
  final workflowDirectory = Directory(
    '${targetRoot.path}${Platform.pathSeparator}.flutter-workflow',
  )..createSync(recursive: true);
  Directory(
    '${workflowDirectory.path}${Platform.pathSeparator}work-items',
  ).createSync(recursive: true);

  final backupRoot = Directory(
    '${workflowDirectory.path}${Platform.pathSeparator}.install-backup-'
    '${DateTime.now().microsecondsSinceEpoch}',
  )..createSync(recursive: true);
  final replacedPaths = <String>[];

  try {
    for (final relativePath in managedPaths) {
      final source = _entityAt(templateRoot.path, relativePath);
      final destination = _entityAt(targetRoot.path, relativePath);

      if (FileSystemEntity.typeSync(destination.path) !=
          FileSystemEntityType.notFound) {
        final backup = _entityAt(backupRoot.path, relativePath);
        _copyEntity(destination, backup);
        _deleteEntity(destination);
        replacedPaths.add(relativePath);
      }

      _copyEntity(source, destination);
    }

    _writeInstallationMetadata(workflowDirectory);
    backupRoot.deleteSync(recursive: true);
  } catch (_) {
    for (final relativePath in managedPaths.reversed) {
      final destination = _entityAt(targetRoot.path, relativePath);
      if (FileSystemEntity.typeSync(destination.path) !=
          FileSystemEntityType.notFound) {
        _deleteEntity(destination);
      }
      if (replacedPaths.contains(relativePath)) {
        final backup = _entityAt(backupRoot.path, relativePath);
        _copyEntity(backup, destination);
      }
    }
    if (backupRoot.existsSync()) backupRoot.deleteSync(recursive: true);
    rethrow;
  }
}

void _writeInstallationMetadata(Directory workflowDirectory) {
  final metadataFile = File(
    '${workflowDirectory.path}${Platform.pathSeparator}installation.json',
  );
  final now = DateTime.now().toUtc().toIso8601String();
  var installedAt = now;

  if (metadataFile.existsSync()) {
    try {
      final previous = jsonDecode(metadataFile.readAsStringSync());
      if (previous is Map && previous['installed_at'] is String) {
        installedAt = previous['installed_at'] as String;
      }
    } catch (_) {
      // Replace unreadable workflow-owned metadata with a valid document.
    }
  }

  final metadata = <String, Object>{
    'schema_version': '1.0',
    'workflow': workflowName,
    'version': workflowVersion,
    'installed_at': installedAt,
    'updated_at': now,
    'managed_paths': managedPaths,
  };
  final temporary = File('${metadataFile.path}.tmp');
  temporary.writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(metadata)}\n',
  );
  if (metadataFile.existsSync()) metadataFile.deleteSync();
  temporary.renameSync(metadataFile.path);
}

FileSystemEntity _entityAt(String root, String relativePath) {
  final path = relativePath
      .split('/')
      .fold(root, (current, part) => '$current${Platform.pathSeparator}$part');
  final type = FileSystemEntity.typeSync(path, followLinks: false);
  return switch (type) {
    FileSystemEntityType.directory => Directory(path),
    _ => File(path),
  };
}

void _copyEntity(FileSystemEntity source, FileSystemEntity destination) {
  final type = FileSystemEntity.typeSync(source.path);
  if (type == FileSystemEntityType.directory) {
    final sourceDirectory = Directory(source.path);
    final destinationDirectory = Directory(destination.path)
      ..createSync(recursive: true);
    for (final child in sourceDirectory.listSync(followLinks: false)) {
      final name = child.uri.pathSegments.where((part) => part.isNotEmpty).last;
      final childDestination = _entityAt(destinationDirectory.path, name);
      _copyEntity(child, childDestination);
    }
    return;
  }

  if (type == FileSystemEntityType.file) {
    final destinationFile = File(destination.path);
    destinationFile.parent.createSync(recursive: true);
    File(source.path).copySync(destinationFile.path);
    return;
  }

  throw FileSystemException('Unsupported template entry', source.path);
}

void _deleteEntity(FileSystemEntity entity) {
  if (entity is Directory) {
    entity.deleteSync(recursive: true);
  } else {
    File(entity.path).deleteSync();
  }
}
