#depends https://github.com/makoConstruct/CleverMatcher/blob/master/CleverMatcher.js

#shims
arrayRemoveElement = (ar, el)->
	i = ar.indexOf el
	if i >= 0
		ar.splice(i,1)
#no IE 8
elBounds = (el)->
	eb = el.getBoundingClientRect()
	x: eb.left - document.body.scrollLeft
	y: eb.top - document.body.scrollTop
	w: eb.width
	h: eb.height


@attachAutocompletion = (input, matchsetArray, matchCallback)->
	config = null
	if input.constructor == Object
		config = input
	else
		config = {input, matchsetArray, matchCallback}
	config.dropdownCSSClass ||= 'autocompletion_drop'
	config.matchingLetterCSSClass ||= 'autocompletion_matching_letter'
	config.matchCSSClass ||= 'autocompletion_match'
	config.nresults ||= 10
	config.matchset ||= new @MatchSet config.matchsetArray, config.matchingLetterCSSClass
	ac = new @Autocompletion config.matchset, config.nresults, config.dropdownCSSClass, config.matchCSSClass
	ac.attach input
	ac.addFiringListener config.matchCallback if config.matchCallback
	ac

#workhorsey
class @Autocompletion
	constructor: (@matchset, @nresults, dropClass, @matchClass)->
		@drop = document.createElement 'div'
		@drop.classList.add dropClass
		@dropListContainer = @drop
		@currentResultList = []
		@firingListeners = []
	
	attach:(newInput)->
		if @input
			@detach()
		document.body.appendChild @drop
		@input = newInput
		@input.addEventListener 'input', @onInput
		@input.addEventListener 'focus', @deploy
		@input.addEventListener 'blur', @collapse
		@input.addEventListener 'keydown', @keydown
	detach:->
		document.body.removeChild @drop
		@input.removeEventListener 'input', @onInput
		@input.removeEventListener 'focus', @deploy
		@input.removeEventListener 'blur', @collapse
		@input.removeEventListener 'keydown', @keydown
		@input = null
	
	pushToDrop: (resultList)->
		@currentResultList = resultList
		#resize display
		while @dropListContainer.children.length > resultList.length
			@dropListContainer.removeChild(@dropListContainer.lastChild)
		while @dropListContainer.children.length < resultList.length
			newResultEl = document.createElement 'div'
			newResultEl.classList.add @matchClass
			@dropListContainer.appendChild newResultEl
		#replace contents
		for i in [0 ... resultList.length]
			@dropListContainer.children[i].innerHTML = resultList[i].matched
		if resultList.length > 0
			@deploy()
		else
			@collapse()
	
	addFiringListener: (callback)->
		@firingListeners.push callback
	removeFiringListener: (callback)->
		arrayRemoveElement(@firingListeners, callback)
	fireFiringListeners: (keyKey)->
		for fl in @firingListeners
			fl keyKey
			
	deploy: =>
		if @dropListContainer.children.length > 0
			ep = elBounds @input
			@drop.style.left = ep.x+'px'
			@drop.style.top = ep.y+ep.h+'px'
			@drop.classList.add 'visible'
	collapse: =>
		@drop.classList.remove 'visible'
	onInput: =>
		res = @matchset.seek @input.value, @nresults
		@pushToDrop(res)
		if res.length > 0
			@deploy()
	keydown: (ev)=>
		switch ev.keyCode
			when 13 #return
				if @currentResultList.length > 0
					#hum. Assigning to input.value seems to prevent input's change event from firing in chrome. I shall have to forgo using the change event.
					@input.value = @currentResultList[0].text
					@fireFiringListeners @currentResultList[0].key
			when 27 #escape
				@collapse()
			# when 9 #tab
				#cycle through alternatives?