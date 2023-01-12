############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("formdatahelper")
#endregion

############################################################
export class FormData
    constructor: (@data) ->
        if !@data.smtp? then @data.smtp = {}
        olog this
        return

    setSMTPData: (smtpData) ->
        { host, port, security, user, password } = smtpData
        if host? then @data.smtp.host = host
        if port? then @data.smtp.port = port
        if security? then @data.smtp.security = security
        if user? then @data.smtp.user = user
        if password? then @data.smtp.password = password
        return

    setBaseData: (data) ->
        { origin, formName, receiver, sendCount } = data
        if origin? then @data.origin = origin
        if formName? then @data.formName = formName
        if receiver? then @data.receiver = receiver
        if sendCount? then @data.sendCount = sendCount
        return

    setHTMLTemplate: (template) ->
        if !@data.templates? then @data.templates = {}
        @data.templates.htmlTemplate = template
        return

    setTextTemplate: (template) ->
        if !@data.templates? then @data.templates = {}
        @data.templates.textTemplate = template
        return

    getSendData: ->
        { host, port, security, user, password } = @data.smtp
        { origin, formName, receiver, sendCount, template } = @data
        subject = "[#{origin}] #{formName} #{sendCount}"
        return { host, port, security, user, password, subject, receiver, template }

    incSendCount: -> @data.sendCount++ 
