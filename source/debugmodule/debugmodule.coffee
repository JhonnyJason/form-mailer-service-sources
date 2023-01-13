

import { addModulesToDebug } from "thingy-debug"

############################################################
export modulesToDebug = {
    authenticationfunctions: true
    authmodule: true
    # configmodule: true
    formdatahelper: true
    mailedformsmodule: true
    mailsendmodule: true
    # scimodule: true
    servicefunctions: true
}
    
addModulesToDebug(modulesToDebug)