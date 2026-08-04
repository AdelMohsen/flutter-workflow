import 'dart:convert';
import 'dart:io';

void main() {
  final root = File(Platform.script.toFilePath()).parent.parent;
  final installer = File(_join(root.path, 'install.dart'));
  final temporary = Directory.systemTemp.createTempSync(
    'flutter-engine-smoke-',
  );

  try {
    final valid = Directory(_join(temporary.path, 'valid'));
    final invalid = Directory(_join(temporary.path, 'invalid'));
    final legacy = Directory(_join(temporary.path, 'legacy'));
    final pending = Directory(_join(temporary.path, 'pending'));
    _fixture(valid, flutter: true);
    _fixture(invalid, flutter: false);
    _fixture(legacy, flutter: true);
    _fixture(pending, flutter: true);
    Directory(
      _join(legacy.path, '.flutter-workflow/work-items'),
    ).createSync(recursive: true);

    final first = _install(installer, valid);
    _expect(first.exitCode == 0, first.stderr.toString());
    final output = first.stdout.toString();
    _expect(output.contains('Flutter Engine · v2.1.0'), 'Missing V2.1 banner.');
    _expect(
      !output.toLowerCase().contains('created by'),
      'Creator footer must not be rendered.',
    );

    const paths = [
      '.specify/extensions/flutter-engine/engine.json',
      '.specify/extensions/flutter-engine/extension.yml',
      '.specify/extensions/flutter-engine/references/lifecycle.md',
      '.specify/extensions/flutter-engine/references/security/owasp.md',
      '.specify/extensions/flutter-engine/references/unit-testing/unit-tests.md',
      '.specify/extensions/flutter-engine/components/project-foundation-v2/component.yml',
      '.specify/extensions/flutter-engine/components/project-foundation-v2/assets/foundation.yaml',
      '.specify/extensions/flutter-engine/components/project-foundation-v2/assets/lib/main.dart',
      '.specify/extensions/flutter-engine/components/project-foundation-v2/assets/lib/core/network/api_client.dart',
      '.specify/extensions/flutter-engine/components/project-foundation-v2/assets/lib/core/ui/app_content.dart',
      '.specify/extensions/flutter-engine/components/auth-account-v2/component.yml',
      '.specify/templates/flutter-engine/context.md',
      '.specify/templates/flutter-engine/spec.md',
      '.specify/templates/flutter-engine/plan.md',
      '.specify/templates/flutter-engine/tasks.md',
      '.specify/templates/flutter-engine/decisions.md',
      '.specify/templates/flutter-engine/result.md',
      '.specify/workflows/flutter-engine-delivery/workflow.yml',
      '.specify/workflows/flutter-engine-operations/workflow.yml',
      '.specify/flutter-engine/engine.lock.json',
      '.specify/flutter-engine/design/design-contract.json',
      '.specify/flutter-engine/installed/project-profile.md',
      '.agents/skills/flutter-engine/SKILL.md',
      '.agents/skills/ponytail/SKILL.md',
      '.agents/skills/flutter-owasp-security/SKILL.md',
      '.agents/skills/flutter-unit-tests/SKILL.md',
    ];
    for (final path in paths) {
      _expect(File(_join(valid.path, path)).existsSync(), 'Missing $path.');
    }

    final profile = File(
      _join(valid.path, '.specify/flutter-engine/installed/project-profile.md'),
    )..writeAsStringSync('project-owned profile\n');
    final design = File(
      _join(valid.path, '.specify/flutter-engine/design/design-contract.json'),
    )..writeAsStringSync('{"project":"owned"}\n');
    final managedSkill = File(
      _join(valid.path, '.agents/skills/flutter-engine/SKILL.md'),
    )..writeAsStringSync('stale managed skill\n');

    final second = _install(installer, valid);
    _expect(second.exitCode == 0, second.stderr.toString());
    _expect(
      profile.readAsStringSync() == 'project-owned profile\n',
      'Reinstall replaced the project profile.',
    );
    _expect(
      design.readAsStringSync() == '{"project":"owned"}\n',
      'Reinstall replaced the Design Contract.',
    );
    _expect(
      managedSkill.readAsStringSync().contains('name: flutter-engine'),
      'Reinstall did not refresh managed skills.',
    );

    final lock = jsonDecode(
      File(
        _join(valid.path, '.specify/flutter-engine/engine.lock.json'),
      ).readAsStringSync(),
    );
    _expect(lock is Map && lock['version'] == '2.1.0', 'Invalid Engine lock.');
    _expect(!(lock as Map).containsKey('creator'), 'Creator metadata remains.');
    _expect(
      lock['managed_checksums'] is Map &&
          (lock['managed_checksums'] as Map).isNotEmpty,
      'Managed SHA-256 checksums were not recorded.',
    );
    _expect(lock['migration_state'] == 'not_required', 'Unexpected migration.');
    _expect(
      File(
        _join(valid.path, '.gitignore'),
      ).readAsStringSync().contains('.specify/flutter-engine/cache/'),
      'Session cache is not ignored.',
    );
    final extensions = File(
      _join(valid.path, '.specify/extensions.yml'),
    ).readAsStringSync();
    _expect(
      extensions.contains('- flutter-engine'),
      'Spec Kit did not register the Engine extension.',
    );
    final workflowRegistry = jsonDecode(
      File(
        _join(valid.path, '.specify/workflows/workflow-registry.json'),
      ).readAsStringSync(),
    );
    _expect(
      workflowRegistry is Map &&
          (workflowRegistry['workflows'] as Map).containsKey(
            'flutter-engine-delivery',
          ) &&
          (workflowRegistry['workflows'] as Map).containsKey(
            'flutter-engine-operations',
          ),
      'Spec Kit did not register both Engine workflows.',
    );

    final changedLock = Map<String, dynamic>.from(lock);
    changedLock['version'] = '1.9.0';
    File(
      _join(valid.path, '.specify/flutter-engine/engine.lock.json'),
    ).writeAsStringSync(jsonEncode(changedLock));
    final refusedUpdate = _install(installer, valid);
    _expect(
      refusedUpdate.exitCode != 0 &&
          refusedUpdate.stderr.toString().contains('requires an approved'),
      'Installer changed the pinned Engine version without approval.',
    );
    final approvedUpdate = _install(installer, valid, allowVersionUpdate: true);
    _expect(
      approvedUpdate.exitCode == 0,
      'Explicitly approved version update was refused.',
    );

    final legacyInstall = _install(installer, legacy);
    _expect(legacyInstall.exitCode == 0, legacyInstall.stderr.toString());
    final legacyLock = jsonDecode(
      File(
        _join(legacy.path, '.specify/flutter-engine/engine.lock.json'),
      ).readAsStringSync(),
    );
    _expect(
      legacyLock['migration_state'] == 'pending_plan',
      'V1 migration was not detected.',
    );
    _expect(
      Directory(_join(legacy.path, '.flutter-workflow')).existsSync(),
      'Installer deleted V1 before an approved migration.',
    );

    final pendingInstall = _install(installer, pending, withoutSpecKit: true);
    _expect(pendingInstall.exitCode == 0, pendingInstall.stderr.toString());
    final pendingLock = jsonDecode(
      File(
        _join(pending.path, '.specify/flutter-engine/engine.lock.json'),
      ).readAsStringSync(),
    );
    _expect(
      pendingLock['spec_kit_status'] == 'pending setup',
      'Missing Spec Kit did not defer safely to flow:setup.',
    );

    final lifecycle = File(
      _join(
        root.path,
        'template/.specify/extensions/flutter-engine/references/lifecycle.md',
      ),
    ).readAsStringSync();
    for (final phrase in [
      'There is no Playback gate',
      'plan hash',
      'ACTIVE_SESSION_EXISTS',
      'Do not spawn subagents',
    ]) {
      _expect(lifecycle.contains(phrase), 'Lifecycle missing: $phrase');
    }

    final commands = File(
      _join(
        root.path,
        'template/.specify/extensions/flutter-engine/references/commands/commands.md',
      ),
    ).readAsStringSync();
    for (final command in [
      'flow:setup',
      'flow:chat',
      'flow:onboard',
      'flow:component',
      'flow:design-sync',
      'flow:feature',
      'flow:change',
      'flow:bug',
      'flow:unit-test',
      'flow:test',
      'flow:resume',
      'flow:check',
      'flow:engine-update',
    ]) {
      _expect(commands.contains(command), 'Command contract missing $command.');
    }

    for (final phrase in [
      'Group every independent material question',
      'typed static repository',
      'Open decisions',
      'Chat creates no Work Item',
      'Project Fact',
      'Figma MCP context',
      'route new behavior to `feature`',
    ]) {
      _expect(commands.contains(phrase), 'Discovery contract missing: $phrase');
    }

    final contextTemplate = File(
      _join(root.path, 'template/.specify/templates/flutter-engine/context.md'),
    ).readAsStringSync();
    for (final phrase in [
      'Material questions and answers',
      'Missing inputs ledger',
      'FALLBACK_SELECTED',
      'Later resolutions',
    ]) {
      _expect(contextTemplate.contains(phrase), 'Context missing: $phrase');
    }

    final foundation = File(
      _join(
        root.path,
        'template/.specify/extensions/flutter-engine/references/components/project-foundation.md',
      ),
    ).readAsStringSync();
    for (final phrase in [
      'Adaptive and responsive UI',
      'maxContentWidth: 720',
      'Web configuration',
      'Asset and localization hygiene',
    ]) {
      _expect(foundation.contains(phrase), 'Foundation missing: $phrase');
    }

    final bad = _install(installer, invalid);
    _expect(bad.exitCode != 0, 'A non-Flutter target was accepted.');
    stdout.writeln('Flutter Engine installer smoke check passed.');
  } finally {
    temporary.deleteSync(recursive: true);
  }
}

void _fixture(Directory root, {required bool flutter}) {
  Directory(_join(root.path, 'lib')).createSync(recursive: true);
  File(_join(root.path, 'lib/main.dart')).writeAsStringSync('void main() {}\n');
  File(_join(root.path, 'pubspec.yaml')).writeAsStringSync(
    flutter
        ? '''
name: engine_smoke
environment:
  sdk: ">=3.0.0 <4.0.0"
dependencies:
  flutter:
    sdk: flutter
'''
        : '''
name: engine_smoke
dependencies: {}
''',
  );
}

ProcessResult _install(
  File installer,
  Directory target, {
  bool allowVersionUpdate = false,
  bool withoutSpecKit = false,
}) => Process.runSync(
  Platform.resolvedExecutable,
  [
    'run',
    installer.path,
    '--target',
    target.path,
    if (allowVersionUpdate) '--allow-version-update',
  ],
  workingDirectory: installer.parent.path,
  environment: withoutSpecKit ? {'PATH': '/usr/bin:/bin'} : null,
);

String _join(String root, String relative) => relative
    .split('/')
    .fold(root, (path, part) => '$path${Platform.pathSeparator}$part');

void _expect(bool value, String message) {
  if (!value) throw StateError(message);
}
