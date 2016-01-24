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

describe "win", ()->
  it "censor x y z", ->
    win.do.motion
      acceleration:
        x: 0.1
        y: 0.2
        z: 0.3
    expect( win.accel.x ).to.eq 0.1
    expect( win.accel.y ).to.eq 0.2
    expect( win.accel.z ).to.eq 0.3

    win.do.motion
      accelerationIncludingGravity:
        x: 0.1
        y: 0.2
        z: 0.3
    expect( win.gravity.x ).to.eq 0.1
    expect( win.gravity.y ).to.eq 0.2
    expect( win.gravity.z ).to.eq 0.3

  it "censor alpha beta gamma", ->

    win.do.motion
      rotationRate:
        alpha: 0.1
        beta:  0.2
        gamma: 0.3
    expect( win.rotate.alpha ).to.eq 0.1
    expect( win.rotate.beta  ).to.eq 0.2
    expect( win.rotate.gamma ).to.eq 0.3

    win.do.orientation
      alpha: 0.1
      beta:  0.2
      gamma: 0.3
      webkitCompassHeading: 0.4
    expect( win.orientation.alpha ).to.eq 0.1
    expect( win.orientation.beta  ).to.eq 0.2
    expect( win.orientation.gamma ).to.eq 0.3
    expect( win.compass           ).to.eq 0.4

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


  it "events", ->
    expect ->
      win.do.load()
    .not.to.throw("Error")

    expect ->
      win.do.motion()
    .not.to.throw("Error")

    expect ->
      win.do.orientation()
    .not.to.throw("Error")

    expect ->
      win.do.resize()
    .not.to.throw("Error")

    expect ->
      win.do.scroll()
    .not.to.throw("Error")

    expect ->
      win.do.scroll_end()
    .not.to.throw("Error")
