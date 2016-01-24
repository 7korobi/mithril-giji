chai = require 'chai'
sinon = require 'sinon'
expect = chai.expect

chai.use require 'sinon-chai'

win = require("../mithril-giji.js")

describe "events", ()->
  it "load", ->
    expect ->
      win.do.load()
    .not.to.throw("Error")

  it "motion", ->
    expect ->
      win.do.motion()
    .not.to.throw("Error")

  it "orientation", ->
    expect ->
      win.do.orientation()
    .not.to.throw("Error")

  it "layout", ->
    expect ->
      win.do.layout()
    .not.to.throw("Error")

  it "resize", ->
    expect ->
      win.do.resize()
    .not.to.throw("Error")

  it "scroll", ->
    expect ->
      win.do.scroll()
    .not.to.throw("Error")

  it "scroll_end", ->
    expect ->
      win.do.scroll_end()
    .not.to.throw("Error")
