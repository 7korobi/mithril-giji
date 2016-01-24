chai = require 'chai'
sinon = require 'sinon'
expect = chai.expect

chai.use require 'sinon-chai'

global.m =
  mount: (dom, vdom)->
    {}

global.document =
  documentElement:
    clientWidth: 90
  querySelector: (query)->
    {}
  createElement: (o)-> console.log o

win = require("../mithril-giji.js")


describe "mount", ()->
  it "layout", ->
    win.layout "#test", 10, 11, (dom, layout)->
      expect( layout.dx ).to.eq 10
      expect( layout.dy ).to.eq 11
    win.on.load = []
    win.do.load()

  it "mount", ->
    win.mount "#test", (dom)->
      expect( layout.dx ).to.eq 10
      expect( layout.dy ).to.eq 11
    win.on.load = []
    win.do.load()
