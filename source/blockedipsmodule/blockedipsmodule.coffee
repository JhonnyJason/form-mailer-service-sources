############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("blockedipsmodule")
#endregion

############################################################
blockedIps = {}

## TODO optimal implementation would be to use the OS
#   probably we shall have a service in the OS 
#   we speak to this service here on block()
#   the service maintains a list of blocked IPs
#   it directly uses nftables to block it at network level

############################################################
export passOrThrow = (ip) ->
    return # for now donot block at all here
    if blockedIps[ip] then throw new Error("Your IP address has been blocked!")
    return

############################################################
export block = (ip) ->
    return # for now donot block at all here
    blockedIps[ip] = true
    return