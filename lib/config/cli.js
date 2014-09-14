var utils = require('../utils');
var fs = require('fs');

exports.get = function(key, options) {
  console.log(utils.getConfig()[key]);
};

exports.set = function(key, value, options) {
  var conf = utils.getConfig();
  conf[key] = value;
  fs.writeFile(process.env.HOME + '/.mk/config.json', JSON.stringify(conf, null, 2), utils.exit);
};
