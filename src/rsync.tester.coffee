# Export Plugin Tester
module.exports = (testers) ->
	# Define My Tester
	class MyTester extends testers.RendererTester
		# Test Generate
		testGenerate: testers.RendererTester::testGenerate

		# Custom test
		testCustom: (next) ->
			tester = this
			@suite 'deploy-rsync', (suite,test) ->
				test 'deploy', (complete) ->
					tester.docpad.getPlugin('rsync').deplowWithRsync(complete)
