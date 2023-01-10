############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("servicefunctions")
#endregion

############################################################
import * as auth from "./authmodule.js"

############################################################
## Client Functions
export getAuthCode = (req) ->
    log "getAuthCode"
    origin = req.hostname
    ip = req.ip
    authCode = auth.createAuthCodeFor(origin,ip)
    response = {authCode}
    return response

export sendForm = (req) ->
    log "sendForm"
    { formData } = req.body
    olog formData
    return