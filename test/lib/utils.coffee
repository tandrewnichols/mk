chalk = require 'chalk'

describe 'utils', ->
  Given -> @cp = spyObj 'spawn'
  Given -> @fs = spyObj 'existsSync', 'mkdirSync', 'writeFile'
  Given -> @grunt = spyObj 'tasks', 'initConfig'
  Given -> @foo = sinon.stub()
  Given -> @bar = sinon.stub()
  Given -> @stubs =
    child_process: @cp
    fs: @fs
    grunt: @grunt
    foo: @foo
    bar: @bar
  Given -> @stubs[process.env.HOME + '/.mk/config'] =
    foo: 'bar'
    '@noCallThru': true
  Given -> @foo['@noCallThru'] = true
  Given -> @bar['@noCallThru'] = true
  Given -> @subject = sandbox '../lib/utils', @stubs

  describe 'getConfig', ->
    Given -> @fs.existsSync.withArgs(process.env.HOME + '/.mk').returns true
    context 'with config', ->
      When -> @config = @subject.getConfig()
      Then -> expect(@config).to.deep.equal
        foo: 'bar'
        '@noCallThru': true

    context 'with no config', ->
      Given -> @home = process.env.HOME
      afterEach -> process.env.HOME = @home
      Given -> process.env.HOME = '/Users/Blah'
      When -> @config = @subject.getConfig()
      Then -> expect(@config).to.deep.equal {}

    context '.mk does not exist', ->
      Given -> @home = process.env.HOME
      afterEach -> process.env.HOME = @home
      Given -> process.env.HOME = '/Users/Blah'
      Given -> @fs.existsSync.withArgs(process.env.HOME + '/.mk').returns false
      When -> @config = @subject.getConfig()
      Then -> expect(@config).to.deep.equal {}
      And -> expect(@fs.mkdirSync).to.have.been.calledWith process.env.HOME + '/.mk'

  describe 'spawn', ->
    Given -> @opts =
      parent:
        rawArgs: ['node', 'mk', 'config', 'set', 'foo', 'bar']

    context 'with no num', ->
      Given -> @cp.spawn.withArgs('mk-foo', ['set', 'foo', 'bar'], { stdio: 'inherit' }).returns 'blah'
      When -> @emitter = @subject.spawn('foo', @opts)
      Then -> expect(@emitter).to.equal 'blah'

    context 'with a num', ->
      Given -> @cp.spawn.withArgs('mk-foo', ['foo', 'bar'], { stdio: 'inherit' }).returns 'blah'
      When -> @emitter = @subject.spawn('foo', @opts, 4)
      Then -> expect(@emitter).to.equal 'blah'

  describe 'exit', ->
    afterEach -> @subject.writeBlock.restore()
    afterEach -> process.exit.restore()
    Given -> sinon.stub @subject, 'writeBlock'
    Given -> sinon.stub process, 'exit'

    context 'code is string', ->
      When -> @subject.exit 'error'
      Then -> expect(@subject.writeBlock).to.have.been.calledWith chalk.red('error')
      And -> expect(process.exit).to.have.been.calledWith 1

    context 'code is numder', ->
      When -> @subject.exit 1
      Then -> expect(@subject.writeBlock).to.have.been.calledWith chalk.red('Something went wrong. The command returned code 1.')
      And -> expect(process.exit).to.have.been.calledWith 1

    context 'code is error', ->
      When -> @subject.exit(new Error('foo'))
      Then -> expect(@subject.writeBlock).to.have.been.calledWith chalk.red('foo')
      And -> expect(process.exit).to.have.been.calledWith 1

    context 'no code', ->
      When -> @subject.exit null
      Then -> expect(process.exit).to.have.been.called

  describe 'subUsage', ->
    When -> @usage = @subject.subUsage 'foo', [ 'bar', 'baz' ]
    Then -> expect(@usage).to.equal '\n     or: foo bar\n     or: foo baz'

  describe 'writeBlock', ->
    afterEach -> console.log.restore()
    Given -> sinon.stub console, 'log'

    context 'with strings', ->
      When -> @subject.writeBlock 'foo', 'bar'
      Then -> expect(console.log.getCall(0).args).to.deep.equal []
      And -> expect(console.log.getCall(1).args).to.deep.equal ['   ', 'foo']
      And -> expect(console.log.getCall(2).args).to.deep.equal ['   ', 'bar']
      And -> expect(console.log.getCall(3).args).to.deep.equal []

    context 'with an array', ->
      When -> @subject.writeBlock 'foo', ['bar', 'baz']
      Then -> expect(console.log.getCall(0).args).to.deep.equal []
      And -> expect(console.log.getCall(1).args).to.deep.equal ['   ', 'foo']
      And -> expect(console.log.getCall(2).args).to.deep.equal ['   ', 'bar', 'baz']
      And -> expect(console.log.getCall(3).args).to.deep.equal []

  describe 'writeConfig', ->
    Given -> @options =
      root: '/foo/bar'
    Given -> @config =
      foo: 'bar'
    Given -> @cb = sinon.stub()
    When -> @subject.writeConfig @options, @config, @cb
    Then -> expect(@fs.writeFile).to.have.been.calledWith '/foo/bar/config.json', JSON.stringify(@config, null, 2), @cb
