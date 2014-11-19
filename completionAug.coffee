#depends https://github.com/makoConstruct/CleverMatcher/blob/master/CleverMatcher.js

@attach_autocompletion = (input, matchset)->
	if matchset.constructor == Array
		matchset = new @MatchSet matchset
	ac = new @Autocompletion matchset
	ac.attach input
	ac

class @Autocompletion
	constructor: (@matchset)->
		@drop = document.createElement 'div'
		@drop.classList.add 'autocompletion_drop'
		document.body.appendChild @drop
		@drop_list_container = @drop
	
	attach:(new_input)->
		if @input
			@detach()
		@input = new_input
		@input.addEventListener 'input', @on_input
		@input.addEventListener 'focus', @deploy
		@input.addEventListener 'blur', @collapse
		
	detach:->
		document.body.removeChild @drop
		@input.removeEventListener 'input', @on_input
		@input.removeEventListener 'focus', @deploy
		@input.removeEventListener 'blur', @collapse
		@input = null
	
	push_to_drop: (result_list)->
		#resize display
		while @drop_list_container.children.length > result_list.length
			@drop_list_container.removeChild(@drop_list_container.lastChild)
		while @drop_list_container.children.length < result_list.length
			new_result_el = document.createElement 'div'
			new_result_el.classList.add 'match'
			@drop_list_container.appendChild new_result_el
		#replace contents
		for i in [0 ... result_list.length]
			@drop_list_container.children[i].innerHTML = result_list[i].matched
		if result_list.length > 0
			@deploy()
		else
			@collapse()
			
	deploy: =>
		if @drop_list_container.children.length > 0
			cr = @input.getBoundingClientRect()
			@drop.style.left = cr.left+'px'
			@drop.style.top = cr.bottom+'px'
			@drop.classList.add 'visible'
	collapse: =>
		@drop.classList.remove 'visible'
	on_input: =>
		res = @matchset.seek @input.value
		@push_to_drop(res)
		if res.length > 0
			@deploy()