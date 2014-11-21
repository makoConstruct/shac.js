#! /bin/bash
coffee -c completionAug.coffee
uglifyjs --screw-ie8 --preamble "//This file provides shorthand autocompletion. See https://github.com/makoConstruct/shac.js for more info." -o shac.js CleverMatcher.js completionAug.js