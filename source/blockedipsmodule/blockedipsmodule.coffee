############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("blockedipsmodule")
#endregion

############################################################
blockedIps = {}

############################################################
export initialize = ->
    log "initialize"
    #Implement or Remove :-)
    return

export passOrThrow = (ip) ->
    if blockedIps[ip] then throw new Error("Your IP address has been blocked!")
    return

export block = (ip) ->
    blockedIps[ip] = true
    return