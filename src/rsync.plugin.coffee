# Prepare
safeps = require('safeps')
pathUtil = require('path')
safefs = require('safefs')
{TaskGroup} = require('taskgroup')

# Export
module.exports = (BasePlugin) ->
  # Define
  class RsyncPlugin extends BasePlugin
    # Name
    name: 'rsync'

    # Config
    config:
      dryrun       : false
      host         : null
      path         : null
      user         : null
      environment  : 'static'
      environments : {}

    # Do the Deploy
    deplowWithRsync: (next) =>
      # Prepare
      docpad = @docpad
      config = @getConfig()
      {outPath, rootPath, env} = docpad.getConfig()

      opts = config or {}
      opts.environment = env  if typeof env isnt 'undefined'
      {host, path, user} = (config.environments[opts.environment] or {})

      opts.host = host  if host?
      opts.path = path  if path?
      opts.user = user  if user?

      # Log
      docpad.log 'info', 'Deployment with rsync starting...'

      # Tasks
      tasks = new TaskGroup().done(next)

      # Check paths
      tasks.addTask (complete) ->
        # Check
        if outPath is rootPath
          err = new Error("Your outPath configuration has been customised. Please remove the customisation in order to use the GitHub Pages plugin")
          return next(err)

        # Complete
        return complete()

      # Check environment
      tasks.addTask (complete) ->
        # Check
        if not opts.path?
          err = new Error("You haven't setup deploy target for #{env} environment. Add settings to your docpad.coffee.")
          return next(err)

        opts.source = pathUtil.join(outPath, '/')

        opts.target = ""
        opts.target += "#{opts.user}@"  if opts.user?
        opts.target += "#{opts.host}:"  if opts.host?
        opts.target += pathUtil.join(opts.path, '/')

        # Complete
        return complete()

      # Cleaning out
      tasks.addTask (complete) ->
        docpad.log 'debug', 'Performing cleaning...'
        docpad.action('clean', complete)

      # Generate the static environment to out
      tasks.addTask (complete) ->
        docpad.log 'debug', 'Performing static generation...'
        docpad.action('generate', complete)

      # Fetch the project's remote url so we can push to it in our new git repo
      tasks.addTask (complete) ->
        docpad.log 'debug', "Changing permissions for #{opts.source}..."
        safeps.spawnCommand 'chmod', ['-R', 'og+Xr', opts.source], {cwd:rootPath}, (err,stdout,stderr) ->
          # Error?
          return complete(err)  if err

          # Complete
          return complete()

      # Fetch the last log so we can add a meaningful commit message
      tasks.addTask (complete) ->
        docpad.log 'info', "Deploying #{opts.source} to #{opts.target}..."

        dryrun = if config.dryrun then "-n" else ""
        ignore = pathUtil.join(rootPath, '.deployignore')
        deployignore = if safefs.existsSync(ignore) then "--exclude-from=\"#{ignore}\"" else ""

        safeps.spawnCommand 'rsync', [
          dryrun
          '-rvzph'
          '--size-only'
          '--delete'
          deployignore
          opts.source
          opts.target
        ], {cwd:outPath}, (err, stdout, stderr) ->
          # Error?
          return complete(err)  if err

          docpad.log 'debug', stdout
          docpad.log 'info', "Synced.", "\n      " + stdout.split("\n")[-3...-1].join("\n      ")

          # Complete
          return complete()

      # Start the deployment
      tasks.run()

      # Chain
      this


    # =============================
    # Events

    # Console Setup
    consoleSetup: (opts) =>
      # Prepare
      docpad = @docpad
      config = @getConfig()
      {consoleInterface,commander} = opts

      # Deploy command
      commander
        .command('deploy-rsync')
        .description("deploys your website to the remote target using rsync")
        .action consoleInterface.wrapAction(@deplowWithRsync)

      # Chain
      this
