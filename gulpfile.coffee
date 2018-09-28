gulp = require 'gulp'
browserify = require 'browserify'
vinylStream = require 'vinyl-source-stream'
vinylBuffer = require 'vinyl-buffer'
watchify = require 'watchify'
exorcist = require 'exorcist'
exposify = require 'exposify'
log = require 'fancy-log'
del = require 'del'
glob = require 'glob'
plugins = require('gulp-load-plugins')()

# Task names.
MODULES = 'modules'
INDEX = 'index'
BUNDLE = 'bundle'
UNITTEST = 'unittest'
DIST = 'dist'
WATCH = 'watch'
CLEAN = 'clean'

# General configuration.
rootDir = '.'
sourceDir = "src"
buildDir = "dist"
nodeDir = "node_modules"
bundleEntry = 'index.coffee'
unittestsGlob = "#{sourceDir}/**/*-test.coffee"
modulesGlob = ["#{sourceDir}/**/*.coffee", "!#{unittestsGlob}"]
jsBundleName = 'backbone-bulma.js'
jsSourceMapDest = "#{jsBundleName}.map"
unittestBundleName = 'tests.js'
unittestEntries = glob.sync unittestsGlob
buildProductGlob = '{,src/}*.js{,.map}'

# Libraries which are inserted through <script> tags rather than being bundled
# by Browserify.
browserLibs = [{
    module: 'underscore'
    global: '_'
}, {
    module: 'backbone'
    global: 'Backbone'
}]

exposify.filePattern = /.*(js|coffee|babel)$/
exposify.config = browserLibs.reduce ((config, lib) ->
    config[lib.module] = lib.global
    config
), {}

babelUmdConfig = [
    'transform-es2015-modules-umd'
    globals: exposify.config
]

babelAliasConfig = [
    'module-resolver'
    alias:
        modules: "./#{buildDir}"
]

aliasifyConfig =
    aliases:
        modules: "./#{sourceDir}"

csBrowserify = browserify(
    debug: yes
    standalone: 'BackboneBulma'
    entries: [bundleEntry]
    extensions: ['.coffee']
    cache: {}
    packageCache: {}
).transform('coffeeify').transform('babelify',
    presets: ['env']
    extensions: ['.coffee']
).transform(exposify).transform('aliasify', aliasifyConfig)

csTestBrowserify = browserify(
    entries: unittestEntries
    extensions: ['.coffee']
    cache: {}
    packageCache: {}
).transform('coffeeify').transform('babelify',
    presets: ['env']
    extensions: ['.coffee']
)

jsBundle = ->
    csBrowserify.bundle()
    .pipe(exorcist jsSourceMapDest)
    .pipe(vinylStream jsBundleName)
    .pipe(gulp.dest rootDir)
    .pipe(plugins.rename suffix: '.min')
    .pipe(vinylBuffer())
    .pipe(plugins.uglify())
    .pipe(gulp.dest rootDir)

jsUnittest = ->
    csTestBrowserify.bundle()
    .pipe(vinylStream unittestBundleName)
    .pipe(vinylBuffer())
    .pipe(plugins.jasmineBrowser.specRunner console: yes)
    .pipe(plugins.jasmineBrowser.headless driver: 'phantomjs', port: 8088)

gulp.task BUNDLE, jsBundle

gulp.task UNITTEST, jsUnittest

gulp.task INDEX, ->
    gulp.src(bundleEntry)
    .pipe(plugins.changed rootDir, extension: '.js')
    .pipe(plugins.sourcemaps.init())
    .pipe(plugins.coffee())
    .pipe(plugins.babel presets: ['env'], plugins: [babelAliasConfig])
    .pipe(plugins.sourcemaps.write rootDir)
    .pipe(gulp.dest rootDir)

gulp.task MODULES, ->
    gulp.src(modulesGlob)
    .pipe(plugins.changed buildDir, extension: '.js')
    .pipe(plugins.sourcemaps.init())
    .pipe(plugins.coffee())
    .pipe(plugins.babel presets: ['env'], plugins: [babelUmdConfig])
    .pipe(plugins.sourcemaps.write rootDir)
    .pipe(gulp.dest buildDir)
    .pipe(plugins.filter '**/*.js')
    .pipe(plugins.stripLine 'sourceMappingURL')
    .pipe(plugins.rename suffix: '.min')
    .pipe(plugins.uglify())
    .pipe(gulp.dest buildDir)

gulp.task DIST, gulp.parallel MODULES, INDEX, BUNDLE

gulp.task WATCH, (callback) ->
    csTestBrowserify.plugin watchify
    csTestBrowserify.on 'update', jsUnittest
    jsUnittest()
    return

gulp.task CLEAN, -> del [buildDir, buildProductGlob]

gulp.task 'default', gulp.series CLEAN, WATCH
