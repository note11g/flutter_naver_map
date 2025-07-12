#!/usr/bin/env dart

import "dart:io";
import "dart:convert";

void main() async {
  try {
    print("Starting version extraction from project root: ${Directory.current.path}");

    // Extract package_version from pubspec.yaml
    final packageVersion = await extractPackageVersion();
    print("Found package_version: $packageVersion");

    // Extract native_dependency_version for Android
    final androidDependencies = await extractAndroidDependencies();
    print("Found Android native_dependency_versions: $androidDependencies");

    // Extract native_dependency_version for iOS
    final iosDependencies = await extractIosDependencies();
    print("Found iOS native_dependency_versions: $iosDependencies");

    // Create version.json
    await createVersionJson(packageVersion, androidDependencies, iosDependencies);

    print("\nSuccessfully created version.json:");
    final versionContent = await File("version.json").readAsString();
    print(versionContent);
  } catch (e) {
    print("Error: $e");
    exit(1);
  }
}

Future<String> extractPackageVersion() async {
  final pubspecFile = File("pubspec.yaml");
  if (!await pubspecFile.exists()) {
    throw "Could not find pubspec.yaml";
  }

  final lines = await pubspecFile.readAsLines();
  for (final line in lines) {
    if (line.startsWith("version:")) {
      final version = line.substring("version:".length).trim();
      if (version.isEmpty) {
        throw "Could not find 'version' in pubspec.yaml";
      }
      return version;
    }
  }
  throw "Could not find 'version' in pubspec.yaml";
}

// Helper function to check if a line starts a block
bool isStartOfBlock(String line, String blockName) {
  final regex = RegExp("$blockName\\s*\\{");
  return regex.hasMatch(line.trim());
}

// Helper class to track nested blocks
class BlockTracker {
  final Map<String, int> _braceCounters = {};
  
  void enterBlock(String blockName) {
    _braceCounters[blockName] = 1;
  }
  
  bool isInBlock(String blockName) {
    return (_braceCounters[blockName] ?? 0) > 0;
  }
  
  void updateBraces(String line, String blockName) {
    if (!isInBlock(blockName)) return;
    
    for (final char in line.split("")) {
      if (char == "{") {
        _braceCounters[blockName] = (_braceCounters[blockName] ?? 0) + 1;
      } else if (char == "}") {
        _braceCounters[blockName] = (_braceCounters[blockName] ?? 1) - 1;
      }
    }
  }
  
  bool hasExitedBlock(String blockName) {
    return _braceCounters[blockName] == 0;
  }
}

Future<Map<String, String>> extractAndroidDependencies() async {
  final buildGradleFile = File("android/build.gradle");
  if (!await buildGradleFile.exists()) {
    throw "Could not find android/build.gradle";
  }

  final dependencies = <String, String>{};
  final gradleContent = await buildGradleFile.readAsString();
  final lines = gradleContent.split("\n");
  
  final tracker = BlockTracker();
  final dependencyLineRegex = RegExp(r'''(\w+)\s+['"]([^:]+):([^:]+):([^'"]+)['"]''');
  
  for (final line in lines) {
    final trimmedLine = line.trim();
    
    // Check for android block
    if (!tracker.isInBlock("android") && isStartOfBlock(trimmedLine, "android")) {
      tracker.enterBlock("android");
      continue;
    }
    
    if (tracker.isInBlock("android")) {
      // Update brace counts
      tracker.updateBraces(line, "android");
      
      // Check for dependencies block within android
      if (!tracker.isInBlock("dependencies") && isStartOfBlock(trimmedLine, "dependencies")) {
        tracker.enterBlock("dependencies");
        tracker.updateBraces(line, "dependencies"); // Count the opening brace
        continue;
      }
      
      if (tracker.isInBlock("dependencies")) {
        tracker.updateBraces(line, "dependencies");
        
        // Skip debug dependencies
        if (trimmedLine.contains("debug")) {
          continue;
        }
        
        // Parse dependency
        final match = dependencyLineRegex.firstMatch(trimmedLine);
        if (match != null) {
          final group = match.group(2);
          final artifact = match.group(3);
          final version = match.group(4);
          dependencies["$group:$artifact"] = version!;
        }
        
        // Check if we've exited dependencies block
        if (tracker.hasExitedBlock("dependencies")) {
          tracker._braceCounters.remove("dependencies");
        }
      }
      
      // Check if we've exited android block
      if (tracker.hasExitedBlock("android")) {
        break;
      }
    }
  }
  
  if (dependencies.isEmpty) {
    throw "Could not find Android native dependency version in android/build.gradle";
  }
  
  return dependencies;
}

Future<Map<String, String>> extractIosDependencies() async {
  final packageSwiftFile = File("ios/flutter_naver_map/Package.swift");
  if (!await packageSwiftFile.exists()) {
    throw "Could not find ios/flutter_naver_map/Package.swift";
  }

  final dependencies = <String, String>{};
  final content = await packageSwiftFile.readAsString();
  
  // First, parse package dependencies to get URL to version mapping
  final packageVersionMap = <String, String>{};
  final packagePattern = RegExp(
    r'\.package\s*\(\s*url:\s*"([^"]+)"[^)]*from:\s*"([^"]+)"\s*\)',
    multiLine: true,
  );
  
  final packageMatches = packagePattern.allMatches(content);
  for (final match in packageMatches) {
    final url = match.group(1)!;
    final version = match.group(2)!;
    // Extract package identifier from URL (last part without .git)
    final packageId = url.split("/").last.replaceAll(".git", "");
    packageVersionMap[packageId] = version;
  }
  
  // Then, find the actual product names used in dependencies
  final productPattern = RegExp(
    r'\.product\s*\(\s*name:\s*"([^"]+)"\s*,\s*package:\s*"([^"]+)"\s*\)',
    multiLine: true,
  );
  
  final productMatches = productPattern.allMatches(content);
  for (final match in productMatches) {
    final productName = match.group(1)!;
    final packageName = match.group(2)!;
    
    // Find the version for this package
    final version = packageVersionMap[packageName];
    if (version != null) {
      dependencies[productName] = version;
    }
  }
  
  if (dependencies.isEmpty) {
    throw "Could not find iOS native dependency version in ios/flutter_naver_map/Package.swift";
  }
  
  return dependencies;
}

Future<void> createVersionJson(
    String packageVersion, 
    Map<String, String> androidDependencies, 
    Map<String, String> iosDependencies) async {
  final versionData = {
    "_comment": "This file is auto-generated by ./tool/update_version.dart script. Do not edit manually.",
    "package_version": packageVersion,
    "native_dependency_version": {
      "android": androidDependencies,
      "ios": iosDependencies,
    },
  };

  const encoder = JsonEncoder.withIndent("  ");
  final jsonContent = encoder.convert(versionData);
  
  await File("version.json").writeAsString("$jsonContent\n");
}