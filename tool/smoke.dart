import 'dart:io';

void main() {
  final repositoryRoot = File(Platform.script.toFilePath()).parent.parent;
  final installer = File(
    '${repositoryRoot.path}${Platform.pathSeparator}install.dart',
  );
  final temporaryRoot = Directory.systemTemp.createTempSync(
    'flutter-codex-workflow-smoke-',
  );

  try {
    final valid = Directory(
      '${temporaryRoot.path}${Platform.pathSeparator}valid',
    );
    final invalid = Directory(
      '${temporaryRoot.path}${Platform.pathSeparator}invalid',
    );
    _createFixture(valid, flutter: true);
    _createFixture(invalid, flutter: false);

    final firstInstall = _runInstaller(installer, valid);
    _expect(firstInstall.exitCode == 0, firstInstall.stderr.toString());
    _expect(
      File(
        '${valid.path}${Platform.pathSeparator}FLUTTER-WORKFLOW.md',
      ).existsSync(),
      'The canonical workflow file was not installed.',
    );

    final constitution = File(
      '${valid.path}${Platform.pathSeparator}.flutter-workflow'
      '${Platform.pathSeparator}constitution.md',
    );
    constitution.writeAsStringSync('project-owned\n');

    final secondInstall = _runInstaller(installer, valid);
    _expect(secondInstall.exitCode == 0, secondInstall.stderr.toString());
    _expect(
      constitution.readAsStringSync() == 'project-owned\n',
      'Reinstallation changed a project-owned constitution.',
    );

    final invalidInstall = _runInstaller(installer, invalid);
    _expect(invalidInstall.exitCode != 0, 'A non-Flutter target was accepted.');

    stdout.writeln('Installer smoke check passed.');
  } finally {
    temporaryRoot.deleteSync(recursive: true);
  }
}

void _createFixture(Directory root, {required bool flutter}) {
  Directory(
    '${root.path}${Platform.pathSeparator}lib',
  ).createSync(recursive: true);
  File(
    '${root.path}${Platform.pathSeparator}lib'
    '${Platform.pathSeparator}main.dart',
  ).writeAsStringSync('void main() {}\n');
  File('${root.path}${Platform.pathSeparator}pubspec.yaml').writeAsStringSync(
    flutter
        ? '''
name: workflow_smoke
environment:
  sdk: ">=3.0.0 <4.0.0"
dependencies:
  flutter:
    sdk: flutter
'''
        : '''
name: workflow_smoke
environment:
  sdk: ">=3.0.0 <4.0.0"
dependencies: {}
''',
  );
}

ProcessResult _runInstaller(File installer, Directory target) {
  return Process.runSync(Platform.resolvedExecutable, [
    'run',
    installer.path,
    '--target',
    target.path,
  ], workingDirectory: installer.parent.path);
}

void _expect(bool condition, String message) {
  if (!condition) throw StateError(message);
}
