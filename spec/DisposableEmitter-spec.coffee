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
            (-> emitter.on "event", (->)).should.not.throw()
            return

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
            (-> emitter.on "event", (->)).should.not.throw()
            return

        it "Listener really call once", ->
            emitter = new DisposableEmitter
            spy = Sinon.spy()

            emitter.once "event", spy
            emitter.emit "event"
            emitter.emit "event"

            spy.calledOnce.should.be.true()
            return

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

        return

    describe "#removeAllListeners", ->

    describe "#emit", ->
        it "Emit with binded context", ->
            emitter = new DisposableEmitter
            ctx = {}
            spy = Sinon.spy()

            emitter.on "hoge", spy, ctx
            emitter.emit "hoge"

            spy.calledOn(ctx).should.be.true()
            return

        return

    describe "#listeners", ->

    describe "#startAutoEmit", ->
        it "Execute auto emit", ->
            emitter = new DisposableEmitter
            spy = Sinon.spy()

            emitter.startAutoEmit "foo"
            emitter.on "foo", spy

            spy.called.should.be.true()
            return

        it "Execute auto emit with args", ->
            emitter = new DisposableEmitter
            spy = Sinon.spy()

            emitter.startAutoEmit "foo", "bar", {"hoge": "fuga"}
            emitter.on "foo", spy

            spy.calledWithExactly("bar", {"hoge": "fuga"}).should.be.true()
            return

        return


    describe "#stopAutoEmit", ->
        it "Unlock auto emit", ->
            emitter = new DisposableEmitter
            spyBeforeUnlock = Sinon.spy()
            spyAfterUnlock = Sinon.spy()

            emitter.startAutoEmit "baz"
            emitter.on "baz", spyBeforeUnlock

            emitter.stopAutoEmit "baz"
            emitter.on "baz", spyAfterUnlock

            spyBeforeUnlock.called.should.be.true()
            spyAfterUnlock.called.should.be.false()
            return

    describe "#isAutoEmitting", ->
        it "Check emit locked", ->
            emitter = new DisposableEmitter

            emitter.startAutoEmit "baz"
            emitter.isAutoEmitting("baz").should.be.true()
            emitter.isAutoEmitting("foo").should.be.false()

    describe "#dispose", ->
