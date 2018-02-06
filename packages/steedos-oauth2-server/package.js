Package.describe({
	name: 'steedos:oauth2-server',
	version: '0.0.1',
	summary: 'Add oauth2 server support to your application.'
});

Npm.depends({
	"express": "4.13.4",
	"body-parser": "1.14.2",
	"oauth2-server": "2.4.1"
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');
	api.use('coffeescript@1.11.1_4');
	api.use('blaze@2.1.9');
	api.use('templating@1.2.15');
	api.use('kadira:blaze-layout@2.3.0');
	api.use('kadira:flow-router@2.10.1');
	
	api.use('webapp', 'server');
	api.use('check', 'server');
	api.use('meteorhacks:async@1.0.0', 'server');
	api.use('simple:json-routes@2.1.0', 'server');

	api.use('http');

	api.use('steedos:creator');

	api.addFiles('lib/common.js', ['client', 'server']);
	api.addFiles('lib/meteor-model.js', 'server');
	api.addFiles('lib/server.js', 'server');
	api.addFiles('lib/client.js', 'client');

	api.addFiles('client/oauth2authorize.html', 'client');
	api.addFiles('client/oauth2authorize.coffee', 'client');

	api.addFiles('client/router.coffee', 'client');

	api.addFiles('server/rest.coffee', 'server');
	// api.addFiles('server/getAuthCode.coffee', 'server');
	// api.addFiles('server/getAccessToken.coffee', 'server');

	api.export('oAuth2Server', ['client', 'server']);
});

Package.onTest(function(api) {

});