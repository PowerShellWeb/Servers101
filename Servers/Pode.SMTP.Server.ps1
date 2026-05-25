#Requires -Modules @{ ModuleName = 'Pode'; ModuleVersion = '2.13.3' }

<#
.SYNOPSIS
    A simple SMTP server built with Pode.

.DESCRIPTION
    A simple SMTP server built with Pode. It has one Handler that listens for incoming emails and writes
    the details to the console.

.PARAMETER Port
    The port to listen on.  (Default: Random between 4200 and 42000)

.LINK
    https://badgerati.github.io/Pode/Servers/SMTP/

.EXAMPLE
    .\Pode.SMTP.Server.ps1 -Port 8025

.NOTES
    1. You can test the SMTP server by sending an email to localhost on the specified port.
    Send-MailMessage -From 'sender@example.com' -To 'recipient@example.com' -Subject 'Test' -Body 'This is a test email.' -SmtpServer 'localhost' -Port <port>
#>
param(
    [Parameter()]
    [int]
    $Port = (Get-Random -Minimum 4200 -Maximum 42000)
)

# Starts the Pode server, running on 2 threads (ie: runspaces)
Start-PodeServer -Threads 2 -ScriptBlock {
    # Add an SMTP endpoint, listening on localhost and the specified port
    Add-PodeEndpoint -Address 'localhost' -Port $Port -Protocol Smtp

    # Add a handler for incoming SMTP events that writes the email details to the console.
    Add-PodeHandler -Type Smtp -Name 'SmtpHandler' -ScriptBlock {
        "From: $($SmtpEvent.Email.From)" | Out-PodeHost
        "To: $($SmtpEvent.Email.To)" | Out-PodeHost
        "Subject: $($SmtpEvent.Email.Subject)" | Out-PodeHost
        "Body: $($SmtpEvent.Email.Body)" | Out-PodeHost
    }
}