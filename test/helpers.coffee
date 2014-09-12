global.sinon = require 'sinon'
global.expect = require('indeed').expect
indeed = require('indeed').indeed
_ = require 'lodash'
indeed.mixin
  functions: (conditions) ->
    (val) ->
      _.every conditions, (condition) ->
        typeof val[condition] == 'function'

global.sandbox = require 'proxyquire'

global.spyObj = (fns...) ->
  _.reduce fns, (obj, fn) ->
    obj[fn] = sinon.stub()
    obj
  , {}

global.stubAll = (obj, stubs) ->
  if _.isArray stubs
    for name in stubs
      obj[name] =
        bind: sinon.stub()
      obj[name].bind.returns name
  else if _.isObject(stubs) && stubs.constructor.name == 'Object'
    for k, v of stubs
      obj[k] = sinon.stub()
      obj[k].returns v
