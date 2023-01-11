############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("servicefunctions")
#endregion

############################################################
import * as auth from "./authmodule.js"
import * as forms from "./mailedformsmodule.js"
import * as formatter from "./contentformattermodule.js"
import * as sender from "./mailsendmodule.js"
import * as filter from "./contentfiltermodule.js"

############################################################
## Client Functions
export getAuthCode = (req) ->
    log "getAuthCode"
    formId = req.body.formId
    { ip, origin } = req

    authCode = auth.createAuthCodeFor(origin,ip,formId)
    response = {authCode}
    return response

export sendForm = (req) ->
    log "sendForm"
    { formData, formId } = req.body
    origin = req.origin

    filter.throwOnMalicousness(formData)
    ## TODO check the formBody for malicousness

    contentData = formatter.formToMailContent(formData)
    olog contentData

    data = await forms.getSendDataFor(formId)
    Object.assign(data, contentData)
    olog data

    await sender.sendMail(data)
    return