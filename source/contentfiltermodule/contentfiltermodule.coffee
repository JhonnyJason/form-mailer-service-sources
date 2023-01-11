############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("contentfiltermodule")
#endregion

############################################################
import sanitizer from "sanitize-html"

############################################################
export throwOnMalicousness = (formData) ->
    for label,content of formData
        throw "Content not a String!" unless typeof content == "string"
        throw "Undesired HTML detected!"  unless content == sanitizer(content)
    return 
