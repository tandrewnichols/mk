var spawn = require('child_process').spawn;
var chalk = require('chalk');

exports.spawn = function(cmd, opts, num) {
  return spawn('mk-' + cmd, opts.parent.rawArgs.slice(num || 3), { stdio: 'inherit' });
};

exports.exit = function(code) {
  if (typeof code === 'string') {
    console.log('   ', chalk.red(code));
    code = 1;
  } else if (code instanceof Error) {
    console.log('   ', chalk.red(code.message));
    code = 1;
  } else {
    console.log('   ', chalk.red('Something went wrong. The command returned code ' + code + '.'));
  }
  process.exit(code);
};

exports.subUsage = function(command, subcommands) {
  return [''].concat(subcommands).join('\n     or: ' + command + ' ');
};
