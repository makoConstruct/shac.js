An autocomplete library for local datasets built on a [subsequence match algorithm](https://github.com/makoConstruct/CleverMatcher)(not a crappy old substring match algo like many of you will be used to) augmented with a full appreciation for initialisms as mnemonic shorthands. This match algo will be familiar to Sublime Text users, and it'll be appreciated by any user who wants to be able to narrow in on their term with the minimum of characters.

Adding autocomplete behavior to an input is as simple as defining the style for the dropdown menu(see the css in the [demo](http://makopool.com/autocompleteDemo.html) for a nice example which you are welcome to rip off), then running
```javascript
attachAutocompletion(inputElement, completionCandidateArray, selectionEventCallback);
```
Where `completionCandidateArray` is an array of strings, when the user selects a match result, `selectionEventCallback` will be called with the index of that result.

`completionCandidateArray` may otherwise be specified as an array of pairs(EG: `[['saint nicholas', function(){givePresents(user)}], ['krampus', function(){if(user.age < 14) harvest(user)}]]`, in this pressing `k, enter` will give the callback a function for getting naughty children out of the way for the holiday season.

If you want control over the css class names used to build the dropdown menu, or the number of search results that will be displayed, you can use the alternate form
```javascript
attachAutocompletion({
	input: inputElement,
	matchsetArray: completionCandidateArray,
	matchCallback: selectionEventCallback,
	nresults: ... //default: 10
	dropdownCSSClass: ... //default: 'autocompletion_drop'
	matchingLetterCSSClass: ... //default: 'autocompletion_matching_letter'
	matchCSSClass: ... //default: 'autocompletion_match'
});
```