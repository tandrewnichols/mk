#!/usr/bin/env node

var config = require('commander');

program
  .version(require('./package').version)
  .usage('<command> <template> [options]');

program.name = 'mk-config';

program
  .command('set <key> <value>')
  .description('Set config values')
  .action(mk.config);

if (~process.argv[1].indexOf('mk')) {
  program.parse(process.argv);
}

module.exports = program;
