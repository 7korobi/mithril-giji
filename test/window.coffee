chai = require 'chai'
sinon = require 'sinon'
expect = chai.expect

chai.use require 'sinon-chai'

global.window =
  innerHeight: 100
  innerWidth: 100
  scrollX: 10
  scrollY: 20
  requestAnimationFrame: (cb)->
    cb()
global.document =
  documentElement:
    clientWidth: 90
  createElement: (o)-> console.log o
win = require("../mithril-giji.js")

describe "window property", ()->
  it "browser window", ->
    win.do.scroll {}
    expect( win.height ).to.eq 100
    expect( win.width  ).to.eq  90

    expect( win.top ).to.eq 20
    expect( win.horizon ).to.eq 50
    expect( win.bottom ).to.eq 120
    expect( win.left ).to.eq 10
    expect( win.right ).to.eq 110

  it "follows", ->
    expect( win.is_tap ).to.eq false
