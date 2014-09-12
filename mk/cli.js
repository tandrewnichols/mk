var spawn = require('child_process').spawn;
var utils = require('../lib/utils');

exports.register = function() {

};

exports.config = function() {
  utils.spawn('config', arguments).on('close', utils.exit);
};
