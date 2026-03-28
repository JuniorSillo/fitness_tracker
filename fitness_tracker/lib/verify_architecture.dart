import 'dart:io';

void main() {
  int passed = 0;
  int failed = 0;

  void check(String description, bool result) {
    if (result) {
      print('PASS — $description');
      passed++;
    } else {
      print('FAIL — $description');
      failed++;
    }
  }

 
  final presentationFiles = _dartFilesIn('lib/presentation');
  final dataFiles         = _dartFilesIn('lib/data');
  final domainFiles       = _dartFilesIn('lib/domain');
  final modelFiles        = _dartFilesIn('lib/models');


  check(
    'presentation/ contains no shared_preferences imports',
    _noneContain(presentationFiles, 'package:shared_preferences'),
  );


  check(
    'data/ contains no ChangeNotifier references',
    _noneContain(dataFiles, 'ChangeNotifier'),
  );


  check(
    'domain/ contains no shared_preferences imports',
    _noneContain(domainFiles, 'package:shared_preferences'),
  );

  check(
    'models/ contains no flutter/material.dart imports',
    _noneContain(modelFiles, 'flutter/material.dart'),
  );
  check(
    'models/ contains no provider imports',
    _noneContain(modelFiles, 'package:provider'),
  );

 
  check(
    'data/ contains no flutter/material.dart imports',
    _noneContain(dataFiles, 'flutter/material.dart'),
  );

  print('\n─────────────────────────────────────');
  print('Results: $passed passed, $failed failed');
  if (failed == 0) {
    print('Architecture is clean!');
  } else {
    print('Fix the failing rules before submitting.');
    exit(1);
  }
}

List<File> _dartFilesIn(String path) {
  final dir = Directory(path);
  if (!dir.existsSync()) return [];
  return dir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();
}

bool _noneContain(List<File> files, String pattern) {
  for (final file in files) {
    final contents = file.readAsStringSync();
    if (contents.contains(pattern)) {
      print('   └─ Violation in: ${file.path}');
      return false;
    }
  }
  return true;
}
