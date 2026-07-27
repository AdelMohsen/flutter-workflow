import 'dart:convert';
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
      firstInstall.stdout.toString().contains('INNOVA DIGITS ENGINEERING'),
      'The installation banner was not rendered.',
    );
    _expect(
      firstInstall.stdout.toString().contains('created by Adel Mohsen'),
      'The creator footer was not rendered.',
    );

    const installedPaths = <String>[
      'FLUTTER-WORKFLOW.md',
      '.flutter-workflow/workflow.json',
      '.flutter-workflow/component-packs/auth-account-v1/pack.yaml',
      '.flutter-workflow/component-packs/auth-account-v1/questions.md',
      '.agents/skills/flutter-add-component/SKILL.md',
    ];
    for (final relativePath in installedPaths) {
      _expect(
        File(_join(valid.path, relativePath)).existsSync(),
        'The installer missed $relativePath.',
      );
    }

    final constitution = File(
      _join(valid.path, '.flutter-workflow/constitution.md'),
    );
    final profile = File(
      _join(valid.path, '.flutter-workflow/project-profile.md'),
    );
    final workItem = File(
      _join(valid.path, '.flutter-workflow/work-items/FW-0001-demo/spec.md'),
    );
    constitution.writeAsStringSync('project-owned\n');
    profile.writeAsStringSync('project-owned\n');
    workItem
      ..parent.createSync(recursive: true)
      ..writeAsStringSync('project-owned\n');

    final installedPack = File(
      _join(
        valid.path,
        '.flutter-workflow/component-packs/auth-account-v1/pack.yaml',
      ),
    );
    installedPack.writeAsStringSync('stale managed pack\n');

    final secondInstall = _runInstaller(installer, valid);
    _expect(secondInstall.exitCode == 0, secondInstall.stderr.toString());
    for (final file in [constitution, profile, workItem]) {
      _expect(
        file.readAsStringSync() == 'project-owned\n',
        'Reinstallation changed project-owned ${file.path}.',
      );
    }
    final sourcePack = File(
      _join(
        repositoryRoot.path,
        'template/.flutter-workflow/component-packs/'
        'auth-account-v1/pack.yaml',
      ),
    );
    _expect(
      installedPack.readAsStringSync() == sourcePack.readAsStringSync(),
      'Reinstallation did not refresh the managed component pack.',
    );

    final metadata = jsonDecode(
      File(
        _join(valid.path, '.flutter-workflow/installation.json'),
      ).readAsStringSync(),
    );
    _expect(
      metadata is Map &&
          metadata['version'] == '1.0.0' &&
          metadata['organization'] == 'INNOVA DIGITS',
      'Installation metadata does not use the central workflow identity.',
    );

    final questions = File(
      _join(
        repositoryRoot.path,
        'template/.flutter-workflow/component-packs/'
        'auth-account-v1/questions.md',
      ),
    ).readAsStringSync();
    _expect(
      questions.contains('Question X of Y · Z questions remaining') &&
          questions.contains('Custom Field 1 · Step 2 of 5'),
      'The component Pack is missing its question progress contract.',
    );

    const skillNames = <String>[
      'flutter-project-init',
      'flutter-new-feature',
      'flutter-change-feature',
      'flutter-fix-bug',
      'flutter-add-component',
    ];
    for (final skillName in skillNames) {
      final skill = File(
        _join(
          repositoryRoot.path,
          'template/.agents/skills/$skillName/SKILL.md',
        ),
      ).readAsStringSync();
      _expect(
        skill.contains('standard startup banner'),
        '$skillName does not use the shared startup banner.',
      );
    }

    final invalidInstall = _runInstaller(installer, invalid);
    _expect(invalidInstall.exitCode != 0, 'A non-Flutter target was accepted.');

    stdout.writeln('Installer smoke check passed.');
  } finally {
    temporaryRoot.deleteSync(recursive: true);
  }
}

String _join(String root, String relativePath) {
  return relativePath
      .split('/')
      .fold(root, (path, part) => '$path${Platform.pathSeparator}$part');
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
