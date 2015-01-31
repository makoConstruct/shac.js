#depends https://github.com/makoConstruct/CleverMatcher/blob/master/CleverMatcher.js

#shims
arrayRemoveElement = (ar, el)->
	i = ar.indexOf el
	if i >= 0
		ar.splice(i,1)
elBounds = (el)->
	eb = el.getBoundingClientRect()
	x: eb.left + document.body.scrollLeft
	y: eb.top + document.body.scrollTop
	#no IE8
	w: eb.width
	h: eb.height

@attachAutocompletion = -> new Autocompletion(arguments...)

#workhorsey
class @Autocompletion
	constructor: (args...)->
		config = 
			if args.length == 1
				args[0]
			else if args.length == 2
				if args[0].list
					{input:args[0], matchCallback:args[1]}
				else
					throw new Error('args must be formatted as: (<config> | <input with datalist>, <callback> | <input without datalist>, <data list>, <callback>)')
			else if args.length == 3
				{input:args[0], matchsetArray:args[1], matchCallback:args[2]}
		@nresults = config.nresults || 10
		@matchingLetterCSSClass = config.matchingLetterCSSClass || 'autocompletion_matching_letter'
		@matchAllForNothing = config.matchAllForNothing || false
		@completeImmediatelyOnExclusiveMatch = config.completeImmediatelyOnExclusiveMatch || false
		datalist = config.input.list
		if datalist
			#cut out the data list so that it doesn't interfere
			config.input.setAttribute("list", null)
			if !config.matchsetArray
				#assimilate a datalist and generate a matchsetArray from it.
				li = (opt.value for opt in datalist.children)
				config.matchsetArray = li
		@matchset = config.matchset || matchset config.matchsetArray, @matchingLetterCSSClass, @matchAllForNothing
		@firesOnSpace = config.firesOnSpace || false
		@clearOnCompletion = config.clearOnCompletion || false
		dropClass = config.dropdownCSSClass || 'autocompletion_drop'
		@matchClass = config.matchCSSClass || 'autocompletion_match'
		@erasesOnEscape = config.erasesOnEscape || false
		@drop = document.createElement 'div'
		@drop.classList.add dropClass
		@dropListContainer = @drop
		@currentResultList = []
		@firingListeners = []
		
		@attach config.input if config.input
		@addFiringListener config.matchCallback if config.matchCallback
	
	attach:(newInput)->
		if @input
			@detach()
		document.body.appendChild @drop
		@input = newInput
		@currentResultList = @matchset.seek @input.value, @nresults
		@input.addEventListener 'input', @onInput
		@input.addEventListener 'focus', @focused
		@input.addEventListener 'blur', @collapse
		@input.addEventListener 'keydown', @keydown
	detach:->
		document.body.removeChild @drop
		@currentResultList = []
		@input.removeEventListener 'input', @onInput
		@input.removeEventListener 'focus', @focused
		@input.removeEventListener 'blur', @collapse
		@input.removeEventListener 'keydown', @keydown
		@input = null
	
	setMatchset:(@matchset)->
	
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
		if @clearOnCompletion then @input.value = ''
		for fl in @firingListeners
			fl keyKey
	fireOnFirstResult: ->
		if @currentResultList.length > 0
			#hum. Assigning to input.value seems to prevent input's change event from firing in chrome. I shall have to forgo using the change event to catch selections.
			@input.value = @currentResultList[0].text
			@collapse()
			@fireFiringListeners @currentResultList[0].key
	deploy: =>
		if @dropListContainer.children.length > 0
			ep = elBounds @input
			@drop.style.left = ep.x+'px'
			@drop.style.top = ep.y+ep.h+'px'
			@drop.classList.add 'visible'
	focused: =>
		if @currentResultList.length > 0
			@pushToDrop(@currentResultList)
	collapse: =>
		@drop.classList.remove 'visible'
	onInput: =>
		res = @matchset.seek @input.value, @nresults
		if @completeImmediatelyOnExclusiveMatch and res.length == 1
			@fireOnFirstResult()
		@pushToDrop(res)
	keydown: (ev)=>
		switch ev.keyCode
			when 13 #return
				@fireOnFirstResult()
			when 27 #escape
				@collapse()
				if @erasesOnEscape
					@input.value = ''
			when 9 #tab
				#cycle through alternatives? Maybe not. Users might expect this, just as they might expect to be able to click on the search result they want. Both of these expectations show a lack of appreciation of the modus operandi.
				#instead I will have it select the first result, promoting left-hand operation
				@fireOnFirstResult()
				ev.preventDefault()
			when 32 #space
				if @firesOnSpace
					@fireOnFirstResult()
					ev.preventDefault()