import 'package:flutter/material.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/config/markdown_generator.dart';
import 'package:markdown_widget/config/toc.dart';
import 'package:markdown_widget/widget/blocks/container/table.dart';
import 'package:markdown_widget/widget/blocks/leaf/code_block.dart';
import 'package:chat_all/component/latex.dart';
import 'package:flutter_highlight/theme_map.dart';
import 'code_wrapper.dart';

class MdCodeMath extends StatelessWidget {
  MdCodeMath(this.mdText, {super.key});

  late String mdText;
  final tocController = TocController();

  Widget buildTocWidget() => TocWidget(controller: tocController);

  List<Widget> buildMarkdownWidget(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final config =
    isDark ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig;

    codeWrapper(child, text, language) =>
        CodeWrapperWidget(child: child, text: text);

    return MarkdownGenerator(
        inlineSyntaxList: [LatexSyntax()],
        generators: [latexGenerator]
    ).buildWidgets(
      mdText,
      config: config.copy(configs: [
        isDark
            ? PreConfig.darkConfig.copy(wrapper: codeWrapper,theme: themeMap['tomorrow-night'])
            : const PreConfig().copy(wrapper: codeWrapper,theme: themeMap['tomorrow']),
        TableConfig(
            wrapper: (table) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: table,
            )),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: buildMarkdownWidget(context),
          ),
        ));
  }
}