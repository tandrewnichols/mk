var chalk = require('chalk');

exports.getArgs = function(args, num) {
  return [].slice.call(args, -1).pop().parent.rawArgs.slice(num || 3);
};

exports.spawn = function(cmd, args, num) {
  return spawn('mk-' + cmd, exports.getArgs(args, num), { stdio: 'inherit' });
};

exports.exit = function(code) {
  if (typeof code === 'string') {
    console.log(chalk.red(code));
    code = 1;
  } else if (code instanceof Error) {
    console.log(chalk.red(code.message));
    code = 1;
  } else {
    console.log(chalk.red('Something went wrong. The command returned code ' + code));
  }
  process.exit(code);
};

exports.subUsage = function(subcommands) {
  if (!Array.isArray(subcommands)) {
    subcommands = [].slice.call(arguments);
  }
  return [''].concat(subcommands).join('\n     or: ');
};
