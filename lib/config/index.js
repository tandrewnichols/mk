#!/usr/bin/env node

var program = require('commander');
var config = require('./cli');

program
  .version(require('../../package').version)
  .usage('<key> <value> [options]');

program.name = 'mk-config';

program
  .command('get <key> <value>')
  .description('Get a config value')
  .action(config.get);

program
  .command('set <key> <value>')
  .description('Set a config value')
  .action(config.set);

if (~process.argv[1].indexOf('mk-config')) {
  program.parse(process.argv);
}

module.exports = program;
