#! /bin/bash
coffee --map -c completionAug.coffee
uglifyjs --screw-ie8 --in-source-map "completionAug.js.map" --preamble "//This file provides shorthand autocompletion. See https://github.com/makoConstruct/shac.js for more info." -o shac.js CleverMatcher.js completionAug.js