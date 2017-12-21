Creator.getTabularColumns = (object_name, columns) ->
	cols = []
	_.each columns, (field_name)->
		field = Creator.getObjectField(object_name, field_name)
		if field?.type
			col = {}
			col.data = field_name
			col.render =  (val, type, doc) ->
				
			col.sTitle = '<div class="slds-truncate" title="">' + t("" + object_name + "_" + field_name.replace(/\./g,"_")); + '</div>'
			# col.createdCell = (node, cellData, rowData) ->
			# 	$(node).css()
			col.className = "slds-cell-edit cellContainer"
			col.createdCell = (cell, val, doc) ->
				$(cell).attr("data-label", field_name)
				Blaze.renderWithData(Template.creator_table_cell, {_id: doc._id, val: val, doc: doc, field: field, field_name: field_name, object_name:object_name}, cell);

			# col.tmpl = Meteor.isClient && Template.creator_table_cell
			# col.tmplContext = (rowData)->
			# 	return {
			# 		cell: rowData[field_name],
			# 		row: rowData
			# 		field_name: field_name
			# 	}

			cols.push(col)

	action_col = 
		title: '<div class="slds-th__action"></div>'
		data: "_id"
		width: '20px'
		createdCell: (node, cellData, rowData) ->
			$(node).attr("data-label", "Actions")
			$(node).html(Blaze.toHTMLWithData Template.creator_table_actions, {_id: cellData, object_name: object_name}, node)
	cols.push(action_col)
	return cols


Creator.initListViews = (object_name)->
	object = Creator.getObject(object_name)
	columns = ["name"]
	if object.list_views?.default?.columns
		columns = object.list_views.default.columns

	new Tabular.Table
		name: "creator_" + object_name,
		collection: Creator.Collections[object_name],
		pub: "steedos_object_tabular",
		columns: Creator.getTabularColumns(object_name, columns)
		dom: "tp"
		extraFields: ["_id"]
		lengthChange: false
		ordering: false
		pageLength: 20
		info: false
		searching: true
		autoWidth: true
		changeSelector: Creator.tabularChangeSelector

if Meteor.isClient
	Creator.getRelatedList = (object_name, record_id)->
		list = []

		_.each Creator.Objects, (related_object, related_object_name)->

			_.each related_object.fields, (related_field, related_field_name)->
				if related_field.type=="master_detail" and related_field.reference_to and related_field.reference_to == object_name
					tabular_name = "creator_" + related_object_name
					if Tabular.tablesByName[tabular_name]
						tabular_selector = {space: Session.get("spaceId")}
						tabular_selector[related_field_name] = record_id
						columns = ["name"]
						if related_object.list_views?.default?.columns
							columns = related_object.list_views.default.columns
						columns = _.without(columns, related_field_name)
						Tabular.tablesByName[tabular_name].options?.columns = Creator.getTabularColumns(related_object_name, columns);

						related =
							object_name: related_object_name
							columns: columns
							tabular_table: Tabular.tablesByName[tabular_name]
							tabular_selector: tabular_selector
							related_field_name: related_field_name

						list.push related

		return list



Creator.getListViews = (object_name)->
	if !object_name 
		object_name = Session.get("object_name")

	object = Creator.getObject(object_name)
	list_views = []
	list_views = _.keys Creator.baseObject.list_views
	if object.list_views
		list_views_object = _.keys object.list_views
		if list_views_object?.length>1
			list_views = list_views_object

	list_views = _.without list_views, "default"
	return list_views


Creator.getListView = (object_name, list_view_id)->
	if !object_name 
		object_name = Session.get("object_name")
	if !list_view_id
		list_view_id = Session.get("list_view_id")
	list_views = Creator.getListViews(object_name)
	if !list_view_id or list_views.indexOf(list_view_id) < 0
		list_view_id = list_views[0]
		if Meteor.isClient
			Session.set("list_view_id", list_view_id)
	object = Creator.getObject(object_name)
	if object.list_views?[list_view_id]
		list_view = object.list_views[list_view_id]
	else if Creator.baseObject.list_views?[list_view_id]
		list_view = Creator.baseObject.list_views[list_view_id]
	else
		list_view = 
			filter_scope: "mine"
			columns: ["name"]

	if !list_view.columns 
		if object.list_views?.default?.columns
			list_view.columns = object.list_views.default.columns
		else
			list_view.columns = ["name"]

	if !list_view.filter_scope
		list_view.filter_scope = "mine"

	return list_view