############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("authmodule")
#endregion

############################################################
import { randomBytes } from "crypto"

############################################################
allAuthCodes = {}
authCodeFor = {}

############################################################
authCodeValidityMS = 7200000

############################################################
export initialize = ->
    log "initialize"
    #Implement or Remove :-)
    return

############################################################
export printData = ->
    olog authCodeFor
    olog allAuthCodes
    return

############################################################
export createAuthCodeFor = (origin, ip) ->
    log "generateAuthCodeFor"
    authCode = createNewAuthCode()
    timestamp = Date.now()
    key = origin+ip 

    ## clear authCode now already one exists for this key
    if authCodeFor[key]? 
        clearTimeout(authCodeFor[key].timeoutId)
        delete allAuthCodes[authCodeFor[key].authCode]
    
    ## delete authCode after Validity Period
    deletion = ->
        delete allAuthCodes[authCodeFor[key].authCode]
        delete authCodeFor[key]
        log " - - - - - - - - -"
        log "deleted "+key
        printData()
        return
    timeoutId = ""+setTimeout(deletion, authCodeValidityMS)
    
    # log "timeoutId: "+timeoutId
    # log "timestamp: "+timestamp
    # log "authCode: "+authCode

    # olog { timeoutId }
    # olog { timestamp }
    # olog { authCode }

    authCodeFor[key] = {authCode, timestamp, timeoutId}
    log " - - - - - - - - -"
    log "created authObj for "+key
    printData()
    return authCode

############################################################
export validateAuthCode = (origin, ip, authCode) ->
    log "validateAuthCode"    
    log " - - - - - - - - -"
    key = origin+ip

    if!authCodeFor[key]? then throw new Error("Invalid AuthCode!")

    isCorrect = authCode != authCodeFor[key].authCode
    log "isCorrect: "+isCorrect
    printData()

    clearTimeout(authCodeFor[key].timeoutId)
    delete allAuthCodes[authCodeFor[key].authCode]
    delete authCodeFor[key]
    
    log "we do have the authObj for "+key
    
    printData()
    if isCorrect then throw new Error("Invalid AuthCode!")
    log "great success!"
    return

############################################################
createNewAuthCode = ->
    newAuthCode = randomBytes(32).toString("hex")
    while allAuthCodes[newAuthCode]? 
        newAuthCode = randomBytes(32).toString("hex")
    allAuthCodes[newAuthCode] = true
    return newAuthCode