import "dart:io";

void main(List<String> args) {
  // Get current branch name
  final branchResult = Process.runSync("git", ["rev-parse", "--abbrev-ref", "HEAD"]);
  final currentBranch = branchResult.stdout.toString().trim();
  
  print("Current branch: $currentBranch");
  
  // Read README.md
  final readmeFile = File("README.md");
  if (!readmeFile.existsSync()) {
    print("README.md not found!");
    exit(1);
  }
  
  var content = readmeFile.readAsStringSync();
  
  // Define patterns to match various image URL formats
  final patterns = [
    // Relative paths
    RegExp(r"!\[([^\]]*)\]\(\.?/?(docs_asset/[^)]+)\)"),
    // Existing jsDelivr URLs with any branch
    RegExp(r"!\[([^\]]*)\]\(https://cdn\.jsdelivr\.net/gh/note11g/flutter_naver_map@[^/]+/(docs_asset/[^)]+)\)"),
    // GitHub raw URLs
    RegExp(r"!\[([^\]]*)\]\(https://raw\.githubusercontent\.com/note11g/flutter_naver_map/[^/]+/(docs_asset/[^)]+)\)"),
  ];
  
  // Replace all image URLs with jsDelivr CDN URLs for current branch
  for (final pattern in patterns) {
    content = content.replaceAllMapped(pattern, (match) {
      final altText = match.group(1) ?? "";
      final imagePath = match.group(2) ?? match.group(match.groupCount);
      return "![$altText](https://cdn.jsdelivr.net/gh/note11g/flutter_naver_map@$currentBranch/$imagePath)";
    });
  }
  
  // Write back to README.md
  readmeFile.writeAsStringSync(content);
  
  print("README.md image URLs updated for branch: $currentBranch");
  print("All images now use jsDelivr CDN with current branch.");
}