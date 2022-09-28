param(
    [string]
    $PresetFileName,

    [switch]
    $NoKeyCopying
)

$ErrorActionPreference = "Stop"

# Global variables
# $launcherParametersFile = "..\parameters.json"

# Default global values, overriden by user in parameters.json file
$a3RootPath = "$env:arma3/"
$serverExeName = "arma3_x64.exe"
$port = 2302

# Relative paths to server config files
$presetsFolder = "..\presets\"
$serverConfigPath = "..\config\server.cfg"
$basicConfigPath = "..\config\gfx.cfg"
$profileName = $env:a3name
$profilesPath = "..\profiles"

# Arma 3 Server process names
$arma3server64ProcessName = "arma3server_x64"
$arma3serverProcessName = "arma3server"

# Creator DLCs name and path resolution table
$CDLCs = @{
    gm = @{
        Name = "Global Mobilization";
        Path = "GM";
    }
    vn = @{
        Name = "S.O.G. Praire Fire";
        Path = "vn"
    }
    cslr= @{
        Name = "CSLA Iron Curtain";
        Path = "CSLA"
    } 
    ws = @{
        Name = "Western Sahara";
        Path = "WS"
    } 
}

# Include utility functions
. '.\functionsfp.ps1'

function Launch()
{
    Set-WindowTitle

#   $launcherParameters = Read-LauncherParametersFile $launcherParametersFile

	$a3RootPath = "$env:arma3/"
	$serverExeName = "arma3_x64.exe"
	$port = 2302
    $webhook = $launcherParameters.Webhook
    $executeWebhook = $webhook.Enabled

    if (!(Confirm-ServerNotRunning))
    {
        Write-Host "Another server instance is already running." -BackgroundColor Yellow -ForegroundColor Black
    }

    Write-Host
    Write-Host "Reading presets..."
    Write-Host

    $presets = Get-PresetFiles

    if ($PresetFileName)
    {
        $preset = Select-PresetByName -PresetList $presets -PresetName $PresetFileName
    }
    else
    {
        Write-PresetList $presets
        Write-Host

        $preset = Select-PresetByIndex $presets
        Write-Host

        if ($webhook.Enabled)
        {
            $executeWebhook = Read-WebhookExecution
            Write-Host
        }
    }

    $mods = Read-PresetFile $($preset.Path)
    $modParameter = Initialize-GlobalModParameter -ModNames $mods.global
    $serverModParameter = Initialize-ServerModParameter -ModNames $mods.server
    Show-OptionalMods -ModNames $mods.optional
    Write-Host

    if ($NoKeyCopying -ne $true)
    {
        Clear-KeysFolder
        Copy-Keys -ModNames $($mods.global + $mods.server + $mods.optional)
    }

    if ($executeWebhook)
    {
        $content = Initialize-WebhookContent $mods.global $mods.optional $port
        Invoke-Webhook $content $webhook
    }

    Write-Host

    Start-Server -ModParameter $modParameter -ServerModParameter $serverModParameter

    Read-ExitAction
    Write-Host

    Write-Host "Exiting." -ForegroundColor Black -BackgroundColor DarkGray
    exit
}

try {
    Launch
}
catch {
    Write-Host
    Write-Host "An error has occured" -ForegroundColor White -BackgroundColor Red -NoNewline
    Write-Host " $($_.Exception.Message)"

    Write-Host
    Write-Host "Press any key to exit."
    [console]::ReadKey()
}
