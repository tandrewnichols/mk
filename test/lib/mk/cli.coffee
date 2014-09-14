EventEmitter = require('events').EventEmitter
chalk = require 'chalk'

describe 'mk cli', ->
  Given -> @utils = spyObj 'spawn', 'exit', 'writeBlock'
  Given -> @subject = sandbox '../lib/mk/cli',
    '../utils': @utils

  describe 'config', ->
    context 'with set or get', ->
      Given -> @spawn = new EventEmitter
      Given -> @utils.spawn.withArgs('config', 'baz').returns @spawn
      When -> @subject.config 'foo', 'bar', 'baz'
      And -> @spawn.emit 'close'
      Then -> expect(@utils.exit).to.have.been.called

    context 'with no parameters', ->
      Given -> @opts = {}
      When -> @subject.config @opts
      Then -> expect(@utils.writeBlock).to.have.been.calledWith(
        'The following config values can be set:',
        ['   ', chalk.magenta('username') + ': ', 'Your github username.', chalk.cyan('<String>')],
        ['   ', chalk.magenta('pattern') + ':  ', 'Interpolation style or regex pattern.', chalk.cyan('<String|RegExp>')],
        ['   ', chalk.magenta('private') + ':  ', 'New repos should marked private.', chalk.cyan('<Boolean>')],
        ['   ', chalk.magenta('wiki') + ':     ', 'New repos should include a wiki.', chalk.cyan('<Boolean>')],
        ['   ', chalk.magenta('issues') + ':   ', 'New repos should include an issues page.', chalk.cyan('<Boolean>')]
      )
