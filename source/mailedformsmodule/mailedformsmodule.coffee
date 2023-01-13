############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("mailedformsmodule")
#endregion

############################################################
import * as dataCache from "cached-persistentstate"
import * as serviceCrypto from "./servicekeysmodule.js"
import { FormData } from "./formdatahelper.js"

############################################################
originsStore = {}
origins = {}

############################################################
export initialize = ->
    log "initialize"
    originsStore = dataCache.load("originsStore")
    if originsStore.meta? then await validateOriginsStore()
    else 
        originsStore.meta = {}
        originsStore.origins = {}
    origins = originsStore.origins
    olog origins
    return 

############################################################
validateOriginsStore = ->
    log "validateOriginsStore"
    meta = originsStore.meta
    signature = meta.serverSig
    if !signature then throw new Error("No signature in originsStore.meta !")
    meta.serverSig = ""
    originsStoreString = JSON.stringify(originsStore)
    meta.serverSig = signature
    if(await serviceCrypto.verify(signature, originsStoreString)) then return
    else throw new Error("Invalid Signature in authCodestore.meta !")

signAndSaveOriginsStore = ->
    log "validateOriginsStore"
    originsStore.meta.serverSig = ""
    originsStore.meta.serverPub = serviceCrypto.getPublicKeyHex()
    jsonString = JSON.stringify(originsStore)
    signature = await serviceCrypto.sign(jsonString)
    originsStore.meta.serverSig = signature
    dataCache.save("originsStore")
    return

############################################################
loadEncryptedData = (label) ->
    data = dataCache.load(label)
    if !data.encryptedContentHex? then return {}
    data = await serviceCrypto.decrypt(data)
    return data

saveEncryptedData = (label, data) ->
    data = await serviceCrypto.encrypt(data)
    dataCache.save(label, data)
    return


############################################################
export setFormSMTPData = (formId, smtpData) ->
    log "setFormSMTPData"
    data = await loadEncryptedData(formId)
    formDataObj = new FormData(data)
    formDataObj.setSMTPData(smtpData)
    await saveEncryptedData(formId, formDataObj.data)
    return

############################################################
export setFormBaseData = (formId, baseData) ->
    log "setFormBaseData"
    data = await loadEncryptedData(formId)
    formDataObj = new FormData(data)
    formDataObj.setBaseData(baseData)
    formDataObj.incSendCount()
    await saveEncryptedData(formId, formDataObj.data)
    return

############################################################
export setFormHTMLTemplate = (formId, template) ->
    data = await loadEncryptedData(formId)
    formDataObj = new FormData(data)
    formDataObj.setHTMLTemplate(template)
    await saveEncryptedData(formId, formDataObj.data)

############################################################
export setFormTextTemplate = (formId, template) ->
    data = await loadEncryptedData(formId)
    formDataObj = new FormData(data)
    formDataObj.setTextTemplate(template)
    await saveEncryptedData(formId, formDataObj.data)

############################################################
export getSendDataFor = (formId) ->
    data = await loadEncryptedData(formId)
    olog data
    formDataObj = new FormData(data)
    sendData = formDataObj.getSendData()
    formDataObj.incSendCount()
    await saveEncryptedData(formId, formDataObj.data)
    return sendData

############################################################
export validateFormId = (origin, formId) ->
    log "validateFormId"
    olog origins
    log origin
    originObj = origins[origin]
    # if !originObj? then throw new Error("Unknown origin!")
    # if originObj.formId != formId then throw new Error("Invalid formId!")
    if !originObj? then throw new Error("Invalid parameter!")
    if !originObj[formId]? then throw new Error("Invalid parameter!")
    return