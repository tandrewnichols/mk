var tm = require('task-master');

module.exports = function(grunt) {
  tm(grunt, { dependencies: true });
  grunt.registerTask('mocha', ['mochaTest:test']);
  grunt.registerTask('default', ['jshint:all', 'mocha']);
  grunt.registerTask('coverage', ['mochacov:html']);
  grunt.registerTask('ci', ['jshint:all', 'mocha'/*, 'travis'*/]);
};
