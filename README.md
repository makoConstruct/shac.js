##Autocompletion
Autocompletion gives an input autocompletion behavior. It's as simple as defining the style for the dropdown menu(see the css in the [demo](http://makopool.com/autocompleteDemo.html) for a nice example which you are welcome to rip off), then running
```
attachAutocompletion(inputElement, completionCandidateArray, selectionEventCallback);
```
Where `completionCandidateArray` is an array of strings, when the user selects a match result, `selectionEventCallback` will be called with the index of that result.

`completionCandidateArray` may otherwise be specified as an array of pairs(EG: `[['saint nicholas', function(){givePresents(user)}], ['krampus', function(){if(user.age < 14) harvest(user)}]]`, in this pressing `k, enter` will give the callback a function for getting naughty children out of the way for the holiday season.

If you want control over the css class names used to build the dropdown menu, you can use the alternate form
```
attachAutocompletion({
	input: inputElement,
	matchsetArray: completionCandidateArray,
	matchCallback: selectionEventCallback,
	dropdownCSSClass: ... //default: 'autocompletion_drop'
	matchingLetterCSSClass: ... //default: 'autocompletion_matching_letter'
	matchCSSClass: ... //default: 'autocompletion_match'
});
```
The [completion scheme](https://github.com/makoConstruct/CleverMatcher) employed is a substring match that goes out of its way to recognise the use of initialisms. Users who want to narrow in on their result with as little typing as possible will appreciate this.