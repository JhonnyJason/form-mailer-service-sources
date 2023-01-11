############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("authenticationfunctions")
#endregion

############################################################
import * as secUtl from "secret-manager-crypto-utils"
import * as timestampVerifier from "./validatabletimestampmodule.js"
import * as blocker from "key-block"
import * as auth from "./authmodule.js"
import * as ips from "./blockedipsmodule.js"
import * as forms from "./mailedformsmodule.js"

############################################################
export masterAuthentication = (route, args) ->
    return
    log "masterAuthentication"
    sigHex = args.signature
    timestamp = args.timestamp

    if !timestamp then throw new Error("No Timestamp!") 
    if !sigHex then throw new Error("No Signature!")

    idHex = auth.getMasterKeyId()

    olog args
    # olog sigHex
    # olog timestamp

    # assert that the signature has not been used yet
    blocker.blockOrThrow(sigHex)
    # will throw if timestamp is not valid 
    timestampVerifier.assertValidity(timestamp) 

    delete args.signature
    content = route+JSON.stringify(args)
    verified = await secUtl.verify(sigHex, idHex, content)
    args.signature = sigHex

    if !verified then throw new Error("Invalid Signature!")
    return
    
export clientAuthentication = (route, req) ->
    log "authenticateClient"
    { formId, authCode } = req.body
    ip = req.ip
    origin = req.get("origin")
    
    ## For non CORS requests
    if !origin? then origin = req.hostname
    req.origin = origin

    ## TODO probably deprecate this
    ips.passOrThrow(ip)

    try switch route
        when "/getAuthCode" then forms.validateFormId(origin, formId)
        when "/sendForm" then formId = auth.validateAuthCode(origin, ip, authCode)
    catch err
        auth.printData()
        ips.block(ip)
        throw err
        
    ## small pfusch to save formId over client authentiction requests
    req.body.formId = formId
    return

