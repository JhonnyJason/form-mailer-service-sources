############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("scimodule")
#endregion

############################################################
import * as sciBase from "thingy-sci-base"

############################################################
import * as formmailerRoutes from "./formmailerroutes.js"

############################################################
export prepareAndExpose = ->
    log "scimodule.prepareAndExpose"
    # restRoutes = Object.assign({}, formmailerRoutes)
    # # restRoutes = Object.assign(restRoutes, oscRoutes)
        
    # wsi.mountWSFunctions()
    sciBase.prepareAndExpose(null, formmailerRoutes)
    return
