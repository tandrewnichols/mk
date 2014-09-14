var utils = require('../utils');
var chalk = require('chalk');
var _ = require('lodash');

exports.register = function() {

};

exports.config = function(maybeOpts) {
  var options = [].slice.call(arguments, -1).pop();
  if (maybeOpts !== options) {
    utils.spawn('config', options).on('close', utils.exit);
  } else {
    // No additional parameters (e.g. "set/get") were passed.
    // Instead, log some help-ish info about config, including
    // the currently possible config parameters.
    utils.writeBlock(
      'The following config values can be set:',
      ['   ', exports.writeOpt('username'), 'Your github username.', chalk.cyan('<String>')],
      ['   ', exports.writeOpt('pattern'), 'Interpolation style or regex pattern.', chalk.cyan('<String|RegExp>')],
      ['   ', exports.writeOpt('private'), 'New repos should marked private.', chalk.cyan('<Boolean>')],
      ['   ', exports.writeOpt('wiki'), 'New repos should include a wiki.', chalk.cyan('<Boolean>')],
      ['   ', exports.writeOpt('issues'), 'New repos should include an issues page.', chalk.cyan('<Boolean>')]
    );
  }
};

exports.writeOpt = function(opt) {
  return _.rpad(chalk.magenta(opt) + ':', 20);
};
