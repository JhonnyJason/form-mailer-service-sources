############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("contentformattermodule")
#endregion

############################################################

import M from "mustache"

############################################################
isEmailRegEx = /\S+@\S+\.\S+/;

############################################################
isValidEmail = (email) ->
    if typeof email != "string" then return false
    email = email.trim()
    return isEmailRegEx.test(email);

############################################################
formatTextLine = (label, content) ->
    return "["+label+"]:\n"+content+"\n\n"

############################################################
formatHTMLLine = (label, content) ->
    return '<h1 style="font-size: 1.2em;">'+label+'</h1><p style="font-size:1em;padding: 15px;">'+content+'</p>'

############################################################
export formToMailContent = (formData, templates) ->
    log "formToMailContent"
    olog templates
    if templates? then { htmlTemplate, textTemplate } = templates
    
    if formData.email? and isValidEmail(formData.email) 
        replyTo = formData.email

    # Text Template
    if textTemplate? then textContent = M.render(textTemplate, formData)
    else
        textContent = ""
        for label,content of formData
            textContent += formatTextLine(label, content)
    
    # HTML Template
    if htmlTemplate? then htmlContent = M.render(htmlTemplate, formData)
    else
        htmlContent = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/><meta name="viewport" content="width=device-width, initial-scale=1.0"/><title></title></head><body style="color: #012;">'
        for label,content of formData
            htmlContent += formatHTMLLine(label, content)
        htmlContent += "</body></html>"
        
    return { textContent, htmlContent, replyTo }