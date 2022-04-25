
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
    aws sts get-caller-identity
}
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
function ge() {
    cd C:\egit
}



Start-My-Shell
