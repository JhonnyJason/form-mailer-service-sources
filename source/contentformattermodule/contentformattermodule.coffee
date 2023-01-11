############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("contentformattermodule")
#endregion

############################################################
formatTextLine = (label, content) ->
    return "["+label+"]:\n"+content+"\n\n"

############################################################
formatHTMLLine = (label, content) ->
    return "<p>["+label+"]:<br>"+content+"<br><br></p>"

############################################################
export formToMailContent = (formData) ->
    textContent = ""
    htmlContent = ""
    for label,content of formData
        textContent += formatTextLine(label, content)
        htmlContent += formatHTMLLine(label, content)
    return { textContent, htmlContent }