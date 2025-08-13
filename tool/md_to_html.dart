import 'dart:io';

import 'package:args/args.dart';
import 'package:markdown/markdown.dart' as md;

/// Simple Markdown to HTML renderer that injects content into an HTML template.
///
/// Usage:
///   dart tool/md_to_html.dart --html path/to/template.html path/to/file.md > out.html
void main(List<String> args) {
  final argParser = ArgParser(allowTrailingOptions: true)
    ..addOption('html', help: 'Template HTML file path.');
  final options = argParser.parse(args);

  final htmlTemplatePath = options['html'] as String?;
  final markdownPath = options.rest.singleOrNull;

  if (htmlTemplatePath == null || markdownPath == null) {
    stderr.writeln(
        'Usage: dart tool/md_to_html.dart --html template.html input.md');
    exit(2);
  }

  final mdSource = File(markdownPath).readAsStringSync();
  final htmlBody = md.markdownToHtml(
    mdSource,
    extensionSet: md.ExtensionSet.gitHubWeb,
  );

  final template = File(htmlTemplatePath).readAsStringSync();
  final output = template
      .replaceFirst('<!-- GENERATED HTML -->', htmlBody)
      .replaceFirst('/* GENERATED CSS */', '');

  stdout.write(output);
}
