module.exports = {
  options: {
    reporter: 'spec',
    ui: 'mocha-given',
    require: 'coffee-script/register'
  },
  test: {
    src: ['test/helpers.coffee', 'test/**/*.coffee']
  }
};
