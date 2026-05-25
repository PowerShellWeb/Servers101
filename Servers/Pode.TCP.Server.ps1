#Requires -Modules @{ ModuleName = 'Pode'; ModuleVersion = '2.13.3' }

<#
.SYNOPSIS
    A simple TCP server built with Pode.

.DESCRIPTION
    A simple TCP server built with Pode. It has three Verbs that listen for incoming messages and respond accordingly.

.PARAMETER Port
    The port to listen on.  (Default: Random between 4200 and 42000)

.LINK
    https://badgerati.github.io/Pode/Servers/TCP/

.EXAMPLE
    .\Pode.TCP.Server.ps1 -Port 9000

.NOTES
    1. You can test the TCP server by connecting to localhost on the specified port via telnet.

    $> telnet localhost <port>
    S> Welcome!
    C> HELLO
    S> Hi!
    C> DATE
    S> 6/10/2024 2:30:00 PM
    C> BYE
    S> Goodbye!
#>
param(
    [Parameter()]
    [int]
    $Port = (Get-Random -Minimum 4200 -Maximum 42000)
)

# Starts the Pode server, running on 2 threads (ie: runspaces)
Start-PodeServer -Threads 2 -ScriptBlock {
    # Add a TCP endpoint, listening on localhost and the specified port
    Add-PodeEndpoint -Address 'localhost' -Port $Port -Protocol Tcp -CRLFMessageEnd -Acknowledge 'Welcome!'

    # Adds a verb for HELLO that responds with "Hi!"
    Add-PodeVerb -Verb 'HELLO' -ScriptBlock {
        Write-PodeTcpClient -Message 'Hi!'
    }

    # Adds a verb for DATE that responds with the current date and time.
    Add-PodeVerb -Verb 'DATE' -ScriptBlock {
        Write-PodeTcpClient -Message (Get-Date).ToString()
    }

    # Adds a verb for BYE that responds with "Goodbye!" and closes the connection.
    Add-PodeVerb -Verb 'BYE' -ScriptBlock {
        Write-PodeTcpClient -Message 'Goodbye!' -CloseConnection
    }
}