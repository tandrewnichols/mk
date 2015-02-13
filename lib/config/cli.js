var utils = require('../utils');
var fs = require('fs');
//var _ = utils._;
var _ = require('underscore');
_.mixin(require('safe-obj'));

exports.get = function(key, options) {
  var config = utils.getConfig();
  if (/^templates\./.test(key)) {
    var parts = key.split('.');
    //var index = _.findIndex(config.templates, { key: parts[1] });
    var index = 0;
    key = parts.splice(1, 0, index).join('.');
  }
  console.log(_.safe(utils.getConfig(), key, ''));
};

exports.set = function(key, value, options) {
  var conf = utils.getConfig();
  conf[key] = value;
  fs.writeFile(process.env.HOME + '/.mk/config.json', JSON.stringify(conf, null, 2), utils.exit);
};
