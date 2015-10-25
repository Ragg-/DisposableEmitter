

# DisposableEmitter
An disposable-emitter powered by [event-kit]()

Respects : [eventemitter3](), [event-kit]()

[![Build Status](https://img.shields.io/travis/Ragg-/DisposableEmitter.svg)](https://travis-ci.org/Ragg-/DisposableEmitter)
![npm license](https://img.shields.io/npm/l/disposable-emitter.svg)
[![npm version](https://img.shields.io/npm/v/disposable-emitter.svg)](https://www.npmjs.com/package/disposable-emitter)
![npm dependencies](https://david-dm.org/Ragg-/DisposableEmitter.svg)

# Example
``` coffeescript
Emitter = require "disposable-emitter"

class SomeModule extends Emitter
someModule = new SomeModule

##
## Event listening
##

listener = ->
    console.log "Event emitted!"

disposer = someModule.on "event", listener


##
##　Stop listening
##

# EventEmitter style
someModule.off "event", listener

# DisposableEmitter style
disposer.dispose()


##
## Observe listener adding
##

# observeAddListener(event, args...)
someModule.lockAutoEmit "initialized", null, "arguments"

# This listener call immediaty.
someModule.once "initialized", (err, message) ->
    console.log err, message

setTimeout ->
    # This listener will be call after 1seconds
    someModule.on "initialized", (err, message) ->
        console.log err, message
, 1000


##
## Unobserve listener adding
##

someModule.unlockAutoEmit "initialized"

# It is not called until it is emitted "initialized" event.
someModule.on "initialized", (err, message) ->
    console.log err, message


##
## Remove all listeners
##

someModule.removeAllListeners()

# if you want dispose and disabled this instance.
# Use or extends dispose method instead of removeAllListeners.
someModule.dispose()

someModule.on "event", ->
# => Error "Emitter has been disposed" thrown.
```
