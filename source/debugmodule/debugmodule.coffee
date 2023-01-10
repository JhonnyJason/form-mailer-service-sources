

import { addModulesToDebug } from "thingy-debug"

############################################################
export modulesToDebug = {
    authenticationfunctions: true
    authmodule: true
    # configmodule: true
    mailedoriginsmodule: true
    # scimodule: true
    servicefunctions: true
}
    
addModulesToDebug(modulesToDebug)