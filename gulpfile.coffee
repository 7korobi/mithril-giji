gulp = require 'gulp'
$ = require('gulp-load-plugins')()

pkg = require './package.json'
banner = """
/**
 <%= pkg.name %> - <%= pkg.description %>
 @version v<%= pkg.version %>
 @link <%= pkg.repository.url %>
 @license <%= pkg.license %>
**/


"""

gulp.task "default", ->
  gulp.watch "{src,test}/*.coffee", ["mocha"]
  gulp.start [
    "mocha"
  ]

gulp.task "make", ->
  gulp
  .src "src/*.coffee"
  .pipe $.coffee()
  .pipe $.concat "mithril-giji.js"
  .pipe $.header banner, {pkg}
  .pipe gulp.dest "."

gulp.task 'mocha', ["make"], ->
  gulp
  .src "test/*.coffee", read: false
  .pipe $.mocha reporter: "list" # "nyan"
