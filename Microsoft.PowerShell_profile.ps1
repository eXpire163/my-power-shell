
function Install-My-Shell {
    pip install colorama pyfiglet
    Install-Module -Name lolcat
}


function Start-My-Shell {


    # Shows navigable menu of all options when hitting Tab
    Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

    # Autocompletion for arrow keys
    Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

    $GH_HOST="git.i.mercedes-benz.com"

    # hello
    Clear-Host
    python C:\git\backup\inPath\figlet.py "hello eXpire" | lolcat
    Write-Output "change me with 'Change-Me'" | lolcat

}

function Change-Me {
    code $profile
}



#AWS helper
function Set-AWSCredential {
    param(
        [Parameter (Mandatory = $false)] [String]$AccessKey,
        [Parameter (Mandatory = $false)] [String]$SecretKey,
        [Parameter (Mandatory = $false)] [String]$SessionToken
    )
    $env:AWS_ACCESS_KEY_ID = $AccessKey
    $env:AWS_SECRET_ACCESS_KEY = $SecretKey
    $env:AWS_SESSION_TOKEN = $SessionToken
    aws sts get-caller-identity
}
function Remove-AWSCredential {

    $env:AWS_ACCESS_KEY_ID = ""
    $env:AWS_SECRET_ACCESS_KEY = ""
    $env:AWS_SESSION_TOKEN = ""
    $env:aws_profile = ""
    aws sts get-caller-identity
}

function CE-Login {
    param (
        [Parameter (Mandatory = $true)] [String]$TeamName,
        [Parameter (Mandatory = $true)] [String]$Role
    )

    Remove-AWSCredential
    $account = python C:\Git\backup\inPath\account-details.py $TeamName
    Write-Output $account
    $acc_parsed = $account | ConvertFrom-Json
    D:\Users\CWIEDEMA\IdpWin\IdpCli.exe configure-credentials --account $acc_parsed.aws_account_id --role $Role
    $env:aws_profile = "Idp" + $acc_parsed.aws_account_id + "$Role"
    aws sts get-caller-identity
}

function BB-Login {
    param (
        [Parameter (Mandatory = $true)] [String]$Role
    )

    Remove-AWSCredential
    D:\Users\CWIEDEMA\IdpWin\IdpCli.exe configure-credentials --account 618057797352 --role $Role
    $env:aws_profile = "Idp" + 618057797352 + "$Role"
    aws sts get-caller-identity
}

$sb_celogin_team = {
    param($commandName, $parameterName, $stringMatch)
    python C:\Git\backup\inPath\account-details-auto-complete.py $stringMatch | ConvertFrom-Json
}
Register-ArgumentCompleter -ParameterName TeamName -ScriptBlock $sb_celogin_team

# $sb_celogin_role = {
#     "TeamAdmin", "DhcFullAdmin", "DhcRoadOnly"
# }
# Register-ArgumentCompleter -ParameterName Role -ScriptBlock $sb_celogin_role

# aws cli autocomplete

Register-ArgumentCompleter -Native -CommandName aws -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
    $env:COMP_LINE = $wordToComplete
    $env:COMP_POINT = $cursorPosition
    aws_completer.exe | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
    Remove-Item Env:\COMP_LINE
    Remove-Item Env:\COMP_POINT
}








# alias functions
function gg() {
    cd C:\git
}
function eg() {
    cd C:\egit
}

function h0() {
    cd "C:\Users\cwiedema\Google Drive\H0\openSCAD"
}

function bb(){
    cd "C:\Git\bluebox"
}

function bbc(){
    code "C:\Git\bluebox"
}



Start-My-Shell

