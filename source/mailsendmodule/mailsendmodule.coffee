############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("mailsendmodule")
#endregion

############################################################
import * as mailer from "nodemailer"

############################################################
buildTransporter = (data) ->
    if data.security == "STARTTLS" then secure = false
    
    transportOptions = {
        host: data.host
        port: data.port
        secure: secure
        requireTLS: true # force TLS or STARTTLS
        auth: {
            user: data.user
            pass: data.password
        }
    } 

    transporter = mailer.createTransport(transportOptions)
    return transporter

############################################################
export sendMail = (data) ->
    transporter = buildTransporter(data)

    mailOptions = {
        from: data.user,
        to: data.receiver,
        subject: data.subject,
        text: data.textContent,
        html: data.htmlContent
    }

    logInfo = await transporter.sendMail(mailOptions)
    olog logInfo
    return

############################################################
export verifydata = (data) ->
    transporter = buildTransporter(data)
    return await transporter.verify()
    