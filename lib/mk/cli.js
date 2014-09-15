var utils = require('../utils');
var chalk = require('chalk');
var _ = require('lodash');
var spawn = require('child_process').spawn;

exports.register = function(template, name, options) {
  template = utils.resolveTemplate(template);
  var tmplName = template.split('/').pop().replace('.git', '');
  var args = ['clone', template];

  if (name) {
    args.push(name);
  }

  spawn('git', args, { stdio: 'inherit', cwd: options.root }).on('close', function(code) {
    var key = name || tmplName;
    options.config.templates = options.config.templates || [];
    options.config.templates.push({
      key: key,
      value: {
        path: options.root + '/' + key
      }
    });
    
    utils.writeBlock(chalk.green('Registered ' + tmplName + (name ? ' as ' + name : '') + '.'));
    utils.writeConfig(options, utils.exit);
  });
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
    utils.writeBlock('Additionally, any option besides username can be specified on a registered template with dot notation (e.g. "templateName.wiki")');
  }
};

exports.writeOpt = function(opt) {
  return _.rpad(chalk.magenta(opt) + ':', 20);
};
