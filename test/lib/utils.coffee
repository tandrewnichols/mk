chalk = require 'chalk'

describe 'utils', ->
  Given -> @cp = spyObj 'spawn'
  Given -> @subject = sandbox '../lib/utils',
    child_process: @cp

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
    afterEach -> console.log.restore()
    afterEach -> process.exit.restore()
    Given -> sinon.stub console, 'log'
    Given -> sinon.stub process, 'exit'

    context 'code is string', ->
      When -> @subject.exit 'error'
      Then -> expect(console.log).to.have.been.calledWith '   ', chalk.red('error')
      And -> expect(process.exit).to.have.been.calledWith 1

    context 'code is numder', ->
      When -> @subject.exit 1
      Then -> expect(console.log).to.have.been.calledWith '   ', chalk.red('Something went wrong. The command returned code 1.')
      And -> expect(process.exit).to.have.been.calledWith 1

    context 'code is error', ->
      When -> @subject.exit(new Error('foo'))
      Then -> expect(console.log).to.have.been.calledWith '   ', chalk.red('foo')
      And -> expect(process.exit).to.have.been.calledWith 1

  describe 'subUsage', ->
    When -> @usage = @subject.subUsage 'foo', [ 'bar', 'baz' ]
    Then -> expect(@usage).to.equal '\n     or: foo bar\n     or: foo baz'
