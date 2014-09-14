var utils = require('../utils');

exports.register = function() {

};

exports.config = function() {
  utils.spawn('config', [].slice.call(arguments, -1).pop()).on('close', utils.exit);
};
