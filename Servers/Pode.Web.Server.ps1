#Requires -Modules @{ ModuleName = 'Pode'; ModuleVersion = '2.13.3' }

<#
.SYNOPSIS
    A simple web server built with Pode.

.DESCRIPTION
    A simple web server built with Pode. It has two Routes:

    1. A Route for pinging and returning the current date and time.
    2. A Page for listing the current processes on the server.

.PARAMETER Port
    The port to listen on.  (Default: Random between 4200 and 42000)

.LINK
    https://badgerati.github.io/Pode/Getting-Started/FirstApp/

.EXAMPLE
    .\Pode.Web.Server.ps1 -Port 8080

.NOTES
    1. You can test the /ping route by navigating to http://localhost:<port>/ping.
    2. You can test the /processes page by navigating to http://localhost:<port>/processes.
#>
param(
    [Parameter()]
    [int]
    $Port = (Get-Random -Minimum 4200 -Maximum 42000)
)

# Starts the Pode server, running on 2 threads (ie: runspaces)
Start-PodeServer -Threads 2 -ScriptBlock {
    # Add an HTTP endpoint, listening on localhost and the specified port
    Add-PodeEndpoint -Address 'localhost' -Port $Port -Protocol Http

    # Add a simple GET route for /ping that returns the current date and time as JSON
    Add-PodeRoute -Method Get -Path '/ping' -ScriptBlock {
        Write-PodeJsonResponse -Value @{ Pong = Get-Date }
    }

    # Add a page for /processes that lists the current processes on the server.
    Add-PodePage -Name 'processes' -ScriptBlock {
        Get-Process | Select-Object Name, Id, CPU, StartTime
    }
}