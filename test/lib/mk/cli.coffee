EventEmitter = require('events').EventEmitter
chalk = require 'chalk'

describe 'mk cli', ->
  Given -> @utils = spyObj 'spawn', 'exit', 'writeBlock', 'registerTasks', 'resolveTemplate', 'runTasks'
  Given -> @path = {}
  Given -> @subject = sandbox '../lib/mk/cli',
    '../utils': @utils
    path: @path

  describe 'register', ->
    Given -> @opts = {}
    Given -> @utils.resolveTemplate.withArgs('template').returns 'git@github.com:some/template.git'
    Given -> @path.resolve = sinon.stub()
    Given -> @path.resolve.returns 'foo/bar'

    context 'with no name', ->
      When -> @subject.register 'template', undefined, @opts
      Then -> expect(@utils.registerTasks).to.have.been.calledWith 'grunt-simple-git', 'foo/bar'
      And -> expect(@utils.runTasks).to.have.been.calledWith
        git:
          options:
            cwd: process.env.HOME + '/.mk'
          clone:
            cmd: 'clone git@github.com:some/template.git'
        config:
          key: 'template'
          value:
            path: process.env.HOME + '/.mk/template'
      , ['git:clone', 'config'], 'Register template'

    context 'with a name', ->
      When -> @subject.register 'template', 'name', @opts
      Then -> expect(@utils.registerTasks).to.have.been.calledWith 'grunt-simple-git', 'foo/bar'
      And -> expect(@utils.runTasks).to.have.been.calledWith
        git:
          options:
            cwd: process.env.HOME + '/.mk'
          clone:
            cmd: 'clone git@github.com:some/template.git name'
        config:
          key: 'name'
          value:
            path: process.env.HOME + '/.mk/name'
      , ['git:clone', 'config'], 'Register template as name'

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
