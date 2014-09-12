_ = require 'lodash'

describe 'mk', ->
  Given -> @mk = spyObj 'register', 'config'
  Given -> @subject = sandbox '../mk',
    './cli': @mk

  describe 'name', ->
    Then -> expect(@subject.name).to.equal 'mk'

  describe 'version', ->
    Then -> expect(@subject.version()).to.equal require('../package').version

  describe 'register', ->
    context 'correct settings', ->
      Given -> @cmd = _.findWhere @subject.commands, { _name: 'register' }
      Then -> expect(@cmd._alias).to.equal 'add'
      And -> expect(@cmd._description).to.equal 'Register a new template'
      And -> expect(@cmd._args).to.deep.equal [
        required: true
        name: 'template'
      ]
    
    context 'register calls mk.register', ->
      When -> @subject.parse ['node', 'mk', 'register', 'template']
      Then -> expect(@mk.register).to.have.been.called

    context 'add calls mk.register', ->
      When -> @subject.parse ['node', 'mk', 'add', 'template']
      Then -> expect(@mk.register).to.have.been.called

  describe 'config', ->
    context 'correct settings', ->
      Given -> @cmd = _.findWhere @subject.commands, { _name: 'config' }
      Then -> expect(@cmd._alias).to.equal 'c'
      And -> expect(@cmd._description).to.equal 'Get and set config values'

    context 'config calls mk.config', ->
      When -> @subject.parse ['node', 'mk', 'config', 'get', 'foo']
      Then -> expect(@mk.config).to.have.been.called

    context 'c calls mk.config', ->
      When -> @subject.parse ['node', 'mk', 'c', 'get', 'foo']
      Then -> expect(@mk.config).to.have.been.called
