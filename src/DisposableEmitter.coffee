{CompositeDisposable, Disposable} = require "event-kit"

module.exports =
class DisposableEmitter
    ###*
    # @class DisposableEmitter
    # @constructor
    ###
    constructor : ->
        @disposed = false
        @_events = Object.create null
        @_observedEvents  = Object.create null
        @_eventDisposers = new CompositeDisposable


    ###*
    # @return {Disposable}
    ###
    on : (event, fn, context = @) ->
        if @disposed
            throw new Error("Emitter has been disposed")

        if @_observedEvents[event]?
            fn.apply context, @_observedEvents[event].args

        listener = {listener: fn, context: context ? @, once: false}
        (@_events[event] ?= []).push listener

        disposer = new Disposable => @off event, fn
        @_eventDisposers.add disposer
        listener.disposer = disposer
        disposer


    ###*
    # @return {Disposable}
    ###
    once : (event, fn, context = @) ->
        if @disposed
            throw new Error("Emitter has been disposed")

        if @_observedEvents[event]?
            fn.apply context, @_observedEvents[event].args
            new Disposable ->

        listener = {listener: fn, context: context ? @, once: true}
        (@_events[event] ?= []).push listener

        disposer = new Disposable => @off event, fn
        @_eventDisposers.add disposer
        listener.disposer = disposer
        disposer


    ###*
    # @return {DisposableEmitter}
    ###
    off : (event, fn, context, once) ->
        return @ if @disposed

        listeners = @_events[event]
        return @ if not listeners? or listeners.length is 0

        newListeners = []
        for entry in listeners
            if  (entry.listener isnt fn) or
                (once? and entry.once isnt once) or
                (context? and entry.context isnt context)
                    newListeners.push entry

        @_events[event] = newListeners
        @


    ###*
    # @return {DisposableEmitter}
    ###
    removeAllListeners : (event) ->
        return @ if @disposed

        disposers = @_eventDisposers

        if event?
            listeners = @_events[event]
            return @ if not listeners? or listeners.length is 0

            for entry in listeners
                disposers.remove entry.disposer

            @_events[event] = []

        else
            disposers.clear()
            @_events = Object.create null

        @


    ###*
    # @return {DisposableEmitter}
    ###
    emit : (event, args...) ->
        if @disposed
            throw new Error("Emitter has been disposed")

        listeners = @_events[event]
        return @ if not listeners? or listeners.length is 0

        for entry in listeners
            if entry.once
                @off event, entry.fn, entry.context, true

            entry.listeners.apply entry.context, args

        @


    ###*
    # @return {Array|Boolean}
    ###
    listeners : (event, exists) ->
        if @disposed
            throw new Error("Emitter has been disposed")

        available = @_events[event]? and @_events[event].length isnt 0

        return available if exists
        return [] unless available
        return (entry.listener for entry in @_events[event])


    ###*
    # @return {DisposableEmitter}
    ###
    observeAddListener : (event, args...) ->
        if @disposed
            throw new Error("Emitter has been disposed")

        return false if @_observedEvents[event]?
        @_observedEvents[event] = {args}
        @emit event, args...
        @


    ###*
    # @return {DisposableEmitter}
    ###
    unobserveAddListener : (event) ->
        return if @disposed
        return false unless @_observedEvents[event]?
        delete @_observedEvents[event]
        @

    ###*
    # @return {Boolean}
    ###
    dispose : ->
        @_events = null
        @_observedEvents = null
        @_eventDisposers.dispose()
        @_eventDisposers = null
        @disposed = true



    addListener : @::on
    removeListener : @::off
