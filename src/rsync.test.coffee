# Test our plugin using DocPad's Testers
require('docpad').require('testers')
	.test(
			testerName: 'deploy-rsync static environment'
			pluginPath: __dirname + '/..'
		,
			env: 'static'
			logLevel: 7
	)
