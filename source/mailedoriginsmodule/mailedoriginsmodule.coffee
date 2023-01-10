############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("mailedoriginsmodule")
#endregion

############################################################
originsStore = {}
origins = {
    "localhost": {
        "siteId": "CA4BD51AE638F911E8A68ED8C462D60FE6B1432C11311E21DEE4CC2595D81BA8"
    }
}

############################################################
export initialize = ->
    log "initialize"
    #Implement or Remove :-)
    return

############################################################
export setSiteId = (origin, siteId) ->
    
    return

############################################################
export setCredentials = (origin, mailAddress, password) ->
    
    return

############################################################
export validateSiteId = (origin, siteId) ->
    log "validateSiteId"
    olog origins
    log origin
    originObj = origins[origin]
    # if !originObj? then throw new Error("Unknown origin!")
    # if originObj.siteId != siteId then throw new Error("Invalid siteId!")
    if !originObj? then throw new Error("Invalid parameter!")
    if originObj.siteId != siteId then throw new Error("Invalid parameter!")
    return