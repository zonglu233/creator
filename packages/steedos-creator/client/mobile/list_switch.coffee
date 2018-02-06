Template.listSwitch.onRendered ->
	this.$("#list_switch").removeClass "hidden"	
	this.$("#list_switch").animateCss "fadeInRight"


Template.listSwitch.helpers
	list_views: ()->
		object_name = this.object_name
		return Creator.getListViews(object_name)

	custom_list_views: ()->
		object_name = this.object_name
		return Creator.Collections.object_listviews.find({object_name: object_name}).fetch()

	getListViewUrl: (list_view_id)->
		app_id = Template.instance().data.app_id
		object_name = Template.instance().data.object_name
		return Creator.getSwitchListUrl(object_name, app_id, list_view_id)

Template.listSwitch.events
	'click .list-switch-back': (event, template)->
		lastUrl = urlQuery[urlQuery.length - 2]
		template.$("#list_switch").animateCss "fadeOutRight", ->
			Blaze.remove(template.view)
			urlQuery.pop()
			if lastUrl
				FlowRouter.go lastUrl
			else
				FlowRouter.go '/app/menu'