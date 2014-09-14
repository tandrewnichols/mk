describe 'mk-config cli', ->
  Given -> @utils = spyObj 'getConfig', 'exit'
  Given -> @utils.getConfig.returns
    foo: 'bar'
  Given -> @fs = spyObj 'writeFile'
  Given -> @subject = sandbox '../lib/config/cli',
    '../utils': @utils
    fs: @fs

  describe 'get', ->
    afterEach -> console.log.restore()
    Given -> sinon.stub console, 'log'
    Given -> @opts = {}
    When -> @subject.get 'foo', @opts
    Then -> expect(console.log).to.have.been.called

  describe 'set', ->
    Given -> @opts = {}
    When -> @subject.set 'foo', 'baz', @opts
    Then -> expect(@fs.writeFile).to.have.been.calledWith process.env.HOME + '/.mk/config.json', JSON.stringify({foo: 'baz'}, null, 2), @utils.exit
