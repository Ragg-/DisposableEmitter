should = require "should"
Sinon = require "sinon"
DisposableEmitter = require "../src/DisposableEmitter"

describe "DisposableEmitter", ->
    describe "#on", ->
        it "Correctry added listener by #on in listeners?", ->
            emitter = new DisposableEmitter
            listener = ->
            emitter.on "event", listener
            emitter.listeners("event").should.containEql(listener)
            return

        it "Can't be add listener of non-function by #on", ->
            emitter = new DisposableEmitter
            (-> emitter.on "event", null).should.throw()
            return

    describe "#once", ->
        it "Correctry added listener by #once in listeners?", ->
            emitter = new DisposableEmitter
            listener = ->
            emitter.on "event", listener
            emitter.listeners("event").should.containEql(listener)
            return

        it "Can't be add listener of non-function by #once", ->
            emitter = new DisposableEmitter
            (-> emitter.on "event", null).should.throw()
            return

        it "Listener really call once", ->
            emitter = new DisposableEmitter
            spy = Sinon.spy()

            emitter.once "event", spy

            emitter.emit "event"
            emitter.emit "event"

            spy.calledOnce.should.be.true()
            return


    describe "#off", ->
        it "Basic remove listener", ->
            emitter = new DisposableEmitter

            spyListener1 = Sinon.spy()
            spyListener2 = Sinon.spy()

            emitter.on "event", spyListener1
            emitter.on "event", spyListener2

            emitter.off "event", spyListener1
            emitter.off "event", spyListener2

            emitter.emit "event"

            spyListener1.called.should.be.false()
            spyListener2.called.should.be.false()
            return

        it "Really removed only specified listener", ->
            emitter = new DisposableEmitter

            uncallSpy = Sinon.spy()
            callingSpy = Sinon.spy()

            emitter.on "event", uncallSpy
            emitter.on "event", callingSpy

            emitter.off "event", uncallSpy

            emitter.emit "event"

            uncallSpy.called.should.be.false()
            callingSpy.called.should.be.true()
            return

    describe "#removeAllListeners", ->
    describe "#emit", ->
    describe "#listeners", ->
    describe "#observeAddListener", ->
    describe "#unobserveAddListener", ->
    describe "#dispose", ->
