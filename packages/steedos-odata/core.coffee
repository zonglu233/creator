if Meteor.isServer

	@SteedosOData = {}
	SteedosOData.VERSION = '4.0'
	SteedosOData.AUTHREQUIRED = false
	SteedosOData.API_PATH = '/api/odata/v4/:spaceId'
	SteedosOData.METADATA_PATH = '$metadata'
	SteedosOData.getRootPath = (spaceId)->
		return Meteor.absoluteUrl('api/odata/v4/' + spaceId)

	SteedosOData.getMetaDataPath = (spaceId)->
		return SteedosOData.getRootPath(spaceId) + "/#{SteedosOData.METADATA_PATH}"

	SteedosOData.getODataContextPath = (spaceId, object_name)->
		return SteedosOData.getMetaDataPath(spaceId) + "##{object_name}"



	@SteedosOdataAPI = new OdataRestivus
		apiPath: SteedosOData.API_PATH,
		useDefaultAuth: true
		prettyJson: true
		enableCors: true
		defaultHeaders:
			'Content-Type': 'application/json'