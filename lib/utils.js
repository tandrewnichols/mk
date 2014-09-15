var spawn = require('child_process').spawn;
var chalk = require('chalk');
var fs = require('fs');
var grunt = require('grunt');

exports.getConfig = function() {
  if (!fs.existsSync(process.env.HOME + '/.mk')) {
    fs.mkdirSync(process.env.HOME + '/.mk');
  }
  
  try {
    return require(process.env.HOME + '/.mk/config');
  } catch (e) {
    return {};
  }
};

exports.spawn = function(cmd, opts, num) {
  return spawn('mk-' + cmd, opts.parent.rawArgs.slice(num || 3), { stdio: 'inherit' });
};

exports.exit = function(code) {
  if (typeof code === 'string') {
    exports.writeBlock(chalk.red(code));
    process.exit(1);
  } else if (code instanceof Error) {
    exports.writeBlock(chalk.red(code.message));
    process.exit(1);
  } else if (code) {
    exports.writeBlock(chalk.red('Something went wrong. The command returned code ' + code + '.'));
    process.exit(code);
  } else {
    process.exit();
  }
};

exports.subUsage = function(command, subcommands) {
  return [''].concat(subcommands).join('\n     or: ' + command + ' ');
};

exports.writeBlock = function() {
  var logs = [].slice.call(arguments);
  console.log();
  logs.forEach(function(log) {
    console.log.apply(console, ['   '].concat(log));
  });
  console.log();
};

exports.writeConfig = function(options, config, cb) {
  fs.writeFile(options.root + '/config.json', JSON.stringify(config, null, 2), cb);
};
