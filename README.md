ShortHand AutoCompleter is an autocompletion UI for local datasets which is built on a [subsequence match algorithm](https://github.com/makoConstruct/CleverMatcher)(not a bog-standard substring match algo like many of you will be used to) augmented with a full appreciation for initialisms as mnemonic shorthands. This match algo will be familiar to Sublime Text users, and it'll be appreciated by any user who wants to be able to narrow in on their term with the minimum number of characters.

Adding autocomplete behavior to an input is as simple as defining the style for the dropdown menu(see the css in the [demo](http://makopool.com/autocompleteDemo.html) for a nice example which you are welcome to plagiarize), then running
```javascript
attachAutocompletion(inputElement, completionCandidateArray, selectionEventCallback);
```
`completionCandidateArray` may be ommitted if the inputElement has a datalist, we can generate a completionCandidateArray from that(and, by the way, the data list will be severred from the input, as it would only conflict with shac.js's features.)

If `completionCandidateArray` is an array of strings, when the user selects a match result, `selectionEventCallback` will be called with the index of that result.

`completionCandidateArray` may otherwise be specified as an array of pairs like `[['saint nicholas', function(){givePresents(user)}], ['krampus', function(){if(user.age < 13) harvest(user)}]]`, in this case, pressing `k` then `enter` will call `selectionEventCallback` with a function it may wish to invoke to get naughty children out of the way in the holiday season as input.

If you want more control over the Autocompletion's behavior, you can pass attachAutocompletion a config object like so:
```javascript
attachAutocompletion({
	input: inputElement, //if this has a datalist bound to it, matchsetArray can be generated from that
	matchsetArray: completionCandidateArray, //but if a matchsetArray is specified, the datalist will be ignored(in fact, it will be removed)
	matchCallback: selectionEventCallback,
	nresults //default: 10, is the maximum number of results that will be returned from a query
	dropdownCSSClass //default: 'autocompletion_drop'
	matchCSSClass //default: 'autocompletion_match'
	matchingLetterCSSClass //default: 'autocompletion_matching_letter'
	matchAllForNothing //default: false, is whether the autocomplete will get matches when the input is empty
	completeImmediatelyOnExclusiveMatch //default: false, if true, when the user provides an input that matches one and only one result, that result will be selected immediately and automatically.
	clearOnCompletion //default: true, if set, the input will be cleared when the user selects a result
	firesOnSpace //default: false, whether the current best match will be selected when the user presses space
	erasesOnEscape //default: false, whether the input will clear when the user presses escape
	matchset //default: automatically configured. Allows you to prepare your own shac MatchSet. Not recommended.
});
```