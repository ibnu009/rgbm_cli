import '../../../common/utils/logger/log_utils.dart';
import '../../../core/internationalization.dart';
import '../../../core/locales.g.dart';
import '../../commands_list.dart';
import '../../interface/command.dart';

class HelpCommand extends Command {
  @override
  String get commandName => 'help';

  @override
  String? get hint => Translation(LocaleKeys.hint_help).tr;

  @override
  Future<void> execute() async {
    final commandsHelp = _getCommandsHelp(commands, 0);
    LogService.info('''
List available commands:
$commandsHelp

Build commands:
  rgb <command> [options]

Examples:
  rgb build -a -s    # Android staging APK
  rgb build -a -p    # Android production APK
  rgb build -aab     # Android App Bundle (production)
  rgb build -i -s    # iOS staging IPA
  rgb build -i -p    # iOS production IPA

Flags and aliases:
  -a | -android    Android
  -i | -ios        iOS
  -s | -staging    Staging environment
  -p | -production Production environment
  -aab             Android App Bundle (production)
''');
  }

  String _getCommandsHelp(List<Command> commands, int index) {
    commands.sort((a, b) {
      if (a.commandName.startsWith('-') || b.commandName.startsWith('-')) {
        return b.commandName.compareTo(a.commandName);
      }
      return a.commandName.compareTo(b.commandName);
    });
    var result = '';
    for (var command in commands) {
      final aliases = command.alias;
      final aliasText = aliases.isNotEmpty ? ' (aliases: ${aliases.join(', ')})' : '';
      result += '\n ${'  ' * index} ${command.commandName}$aliasText:  ${command.hint}';
      result += _getCommandsHelp(command.childrens, index + 1);
    }
    return result;
  }

  @override
  String get codeSample => '';

  @override
  int get maxParameters => 0;
}
