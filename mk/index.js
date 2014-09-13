#!/usr/bin/env node

var program = require('commander');
var mk = require('./cli');
var utils = require('../lib/utils');

program
  .version(require('../package').version)
  .usage('<command> <template> [options]');

program.name = 'mk';

program
  .command('register <template>')
  .alias('add')
  .description('Register a new template')
  .action(mk.register);

program
  .command('config')
  .usage(utils.subUsage('config|c', ['get <key>', 'set <key> <value>']))
  .alias('c')
  .description('Get and set config values')
  .action(mk.config);

if (~process.argv[1].indexOf('mk')) {
  program.parse(process.argv);
}

module.exports = program;
