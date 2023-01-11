############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("authmodule")
#endregion

############################################################
import { randomBytes } from "crypto"

############################################################
#region internal Variables
allAuthCodes = {}
authCodeFor = {}

############################################################
authCodeValidityMS = 7200000

#endregion

############################################################
export initialize = ->
    log "initialize"
    c = allModules.configmodule
    if c.authCodeValidityMS? then authCodeValidityMS = c.authCodeValidityMS
    return

############################################################
#region exposed Functions
export printData = ->
    olog authCodeFor
    olog allAuthCodes
    return

############################################################
export createAuthCodeFor = (origin, ip, secret) ->
    log "generateAuthCodeFor"
    authCode = createNewAuthCode()
    timestamp = Date.now()
    key = origin+ip 

    ## clear authCode if one exists for this key
    if authCodeFor[key]?
        clearTimeout(authCodeFor[key].timeoutId)
        delete allAuthCodes[authCodeFor[key].authCode]
    
    ## delete authCode after Validity Period
    deletion = ->
        delete allAuthCodes[authCodeFor[key].authCode]
        delete authCodeFor[key]
        # log " - - - - - - - - -"
        # log "deleted "+key
        # printData()
        return
    timeoutId = ""+setTimeout(deletion, authCodeValidityMS)
    ## set the new authCodeObj
    authCodeFor[key] = {authCode, timestamp, timeoutId, secret}
    # log " - - - - - - - - -"
    # log "created authObj for "+key
    # printData()
    return authCode

############################################################
export validateAuthCode = (origin, ip, authCode) ->
    log "validateAuthCode"
    # log " - - - - - - - - -"
    key = origin+ip

    if!authCodeFor[key]? then throw new Error("Invalid AuthCode!")
    # log "we do have the authObj for "+key
    isCorrect = authCode != authCodeFor[key].authCode
    # log "isCorrect: "+isCorrect
    # printData()

    authSecret = authCodeFor[key].secret
    clearTimeout(authCodeFor[key].timeoutId)
    delete allAuthCodes[authCodeFor[key].authCode]
    delete authCodeFor[key]
    
    # log "now we should have deleted it..."
    # printData()
    if isCorrect then throw new Error("Invalid AuthCode!")
    # log "great success!"
    return authSecret

#endregion

############################################################
createNewAuthCode = ->
    newAuthCode = randomBytes(32).toString("hex")
    while allAuthCodes[newAuthCode]? 
        newAuthCode = randomBytes(32).toString("hex")
    allAuthCodes[newAuthCode] = true
    return newAuthCode