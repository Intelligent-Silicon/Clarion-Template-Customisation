<#
    Powershell Script to Patch or Revert Clarion Template changes.
	
	
	https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7.5
	
	ExecutionPolicy
	Restricted		Scripts will not run.
	RemoteSigned	Locally created scripts can run and scripts that were created on another machine will only run if signed by a trusted publisher.
	AllSigned		Scripts (including locally created scripts) only run if signed by a trusted publisher.
	Unrestricted	All scripts run regardless of who created them and whether they’re signed.
	Other ExecutionPolicy's exist check the link above to see them.
	
	Scope
	LocalMachine	All Users like Registry Settings	- Required for Clarion Templates if default install
	CurrentUser		Current User like Registry Settings	- Required for Clarion Templates if Clarion is installed in a %USERPROFILE% folder location.
	Other Scope options exist, check the link above to see them.
	
	Get-ExecutionPolicy
	Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine -Force
	
#>


$ClarionTemplateFilename1 		= "EXTENS.TPW"
$ActionP1						= "Patch Default Resize strategy from Spread to Centered"
$ActionR1						= "Revert Default Resize strategy from Centered to Spread"
$OriginalString1 	= 
"#PROMPT('Resize Strategy: ',DROP('Use Anchor|Centered|Resize|Spread|Don''t alter controls')),%AppStrategy,DEFAULT('Spread')"
$PatchString1 		=
"#PROMPT('Resize Strategy: ',DROP('Use Anchor|Centered|Resize|Spread|Don''t alter controls')),%AppStrategy,DEFAULT('Centred')"

$ClarionTemplateFilename2 		= "ABWINDOW.TPW"
$ActionP2						= "Patch Default Resize strategy from Spread to Centered"
$ActionR2						= "Revert Default Resize strategy from Centered to Spread"
$OriginalString2 	= 
"#PROMPT('Resize Strategy: ',DROP('Use Anchor|Centered|Resize|Spread|Surface|Don''t alter controls')),%AppStrategy,DEFAULT('Spread')"
$PatchString2 		= 
"#PROMPT('Resize Strategy: ',DROP('Use Anchor|Centered|Resize|Spread|Surface|Don''t alter controls')),%AppStrategy,DEFAULT('Centered')"


$ActionP3						= "Patch Default Restrict Minimum Window Size from False to True"
$ActionR3						= "Revert Default Restrict Minimum Window Size from True to False"
$OriginalString3 	= 
"#PROMPT('Restrict Minimum Window Size',CHECK),%RestrictMinSize,DEFAULT(%False),AT(5)"
$PatchString3 		= 
"#PROMPT('Restrict Minimum Window Size',CHECK),%RestrictMinSize,DEFAULT(%True),AT(5)"

$ActionP4						= "Patch Default Restrict Minimum Window Size Width from unspecified to 420"
$ActionR4						= "Revert Default Restrict Minimum Window Size Width from 420 to unspecified"
$OriginalString4 	= 
"#PROMPT('Minimum Width:',@n5),%WindowMinWidth"
$PatchString4 		= 
"#PROMPT('Minimum Width:',@n5),%WindowMinWidth,Default(420)"

$ActionP5						= "Patch Default Restrict Minimum Window Size Height from unspecified to 270"
$ActionR5						= "Revert Default Restrict Minimum Window Size Height from 270 to unspecified"
$OriginalString5 	= 
"#PROMPT('Minimum Height:',@n5),%WindowMinHeight"
$PatchString5 		= 
"#PROMPT('Minimum Height:',@n5),%WindowMinHeight,Default(270)"

$ActionP6						= "Patch Default Control Override Horizontal Resize Strategy from Resize to Lock Width"
$ActionR6						= "Revert Default Control Override Horizontal Resize Strategy from Lock Width to Resize"
$OriginalString6 	= 
"#PROMPT('&Horizontal Resize Strategy',DROP('Resize|Lock Width|Constant Right Border|Constant Right Center Border')),%HorizResize,DEFAULT('Resize'),AT(10,15,170),PROMPTAT(10,2,170)"
$PatchString6 		=
"#PROMPT('&Horizontal Resize Strategy',DROP('Resize|Lock Width|Constant Right Border|Constant Right Center Border')),%HorizResize,DEFAULT('Lock Width'),AT(10,15,170),PROMPTAT(10,2,170)"

$ActionP7						= "Patch Default Control Override Vertical Resize Strategy from Resize to Lock Height"
$ActionR7						= "Revert Default Control Override Vertical Resize Strategy from Lock Height to Resize"
$OriginalString7 	= 
"#PROMPT('&Vertical Resize Strategy',DROP('Resize|Lock Height|Constant Bottom Border|Constant Bottom Center Border')),%VertResize,DEFAULT('Resize'),AT(10,15,170),PROMPTAT(10,2,170)"
$PatchString7 		=
"#PROMPT('&Vertical Resize Strategy',DROP('Resize|Lock Height|Constant Bottom Border|Constant Bottom Center Border')),%VertResize,DEFAULT('Lock Height'),AT(10,15,170),PROMPTAT(10,2,170)"

$ActionP8						= "Patch Default Control Override Horizontal Position Strategy from Move to Fix Left"
$ActionR8						= "Revert Default Control Override Horizontal Position Strategy from Fix Left to Move"
$OriginalString8 	= 
"#PROMPT('Horizontal &Positional Strategy',DROP('Move|Lock Position|Fix Right|Fix Left|Fix Center|Fix Nearest|Fix To Center')),%HorizPositional,DEFAULT('Move'),AT(10,15,170),PROMPTAT(10,2,170)"
$PatchString8 		=
"#PROMPT('Horizontal &Positional Strategy',DROP('Move|Lock Position|Fix Right|Fix Left|Fix Center|Fix Nearest|Fix To Center')),%HorizPositional,DEFAULT('Fix Left'),AT(10,15,170),PROMPTAT(10,2,170)"

$ActionP9						= "Patch Default Control Override Vertical Position Strategy from Move to Fix Top"
$ActionR9						= "Revert Default Control Override Vertical Position Strategy from Fix Top to Move"
$OriginalString9 	= 
"#PROMPT('Vertical P&ositional Strategy',DROP('Move|Lock Position|Fix Bottom|Fix Top|Fix Center|Fix Nearest|Fix To Center')),%VertPositional,DEFAULT('Move'),AT(10,15,170),PROMPTAT(10,2,170)"
$PatchString9 		=
"#PROMPT('Vertical P&ositional Strategy',DROP('Move|Lock Position|Fix Bottom|Fix Top|Fix Center|Fix Nearest|Fix To Center')),%VertPositional,DEFAULT('Fix Top'),AT(10,15,170),PROMPTAT(10,2,170)"




Write-Host ""
Write-Host ""
Write-Host "	Update the Clarion Window Control Resizing Template Defaults"
Write-Host "	============================================================"
Write-Host ""
Write-Host "See https://github.com/Intelligent-Silicon/Clarion-Template-Customisation for more information."
Write-Host ""
Write-Host "Execution Policy $(Get-ExecutionPolicy)"
Write-Host "Powershell Version $($PSVersionTable.PSVersion)"
Write-Host ""
Write-Host ""


$PatchChoice	= Read-Host "Choose to [P]atch or [R]evert or [Q]uit"
$PatchChoice	= $PatchChoice.ToUpper()

IF ( $PatchChoice -ne "P" -And $PatchChoice -ne "R" -And $PatchChoice -ne "Q" )
{
	Write-Host "Invalid Choice. Quiting..."
	Return 
}
ElseIF ( $PatchChoice -eq "Q" )
{
	Write-Host "Quiting..."
	Return 
}
ElseIF ( $PatchChoice -eq "P" )
{
	Write-Host ""
	Write-Host "Patching chosen..."
	Write-Host ""
}
ElseIF ( $PatchChoice -eq "R" )
{
	Write-Host ""
	Write-Host "Reverting Patch chosen..."
	Write-Host ""
}


$ClarionTemplateFolderDefault 	= 'C:\Clarion11\template\win'
$ClarionTemplateFolderInput		= Read-Host "Specify the Clarion Template Folder [$($ClarionTemplateFolderDefault)]"
$ClarionTemplateFolder			= ($ClarionTemplateFolderDefault,$ClarionTemplateFolderInput)[[bool]$ClarionTemplateFolderInput]

IF ( (Get-Item $ClarionTemplateFolder) -isnot [System.IO.DirectoryInfo] )
{
	Write-Host "Invalid Folder. Quiting..."
	return
}
Write-Host "Clarion Template Folder: $ClarionTemplateFolder"




$ClarionTemplateFolder			= $ClarionTemplateFolder.TrimEnd('\')
$ClarionTemplateFilePath1		= $ClarionTemplateFolder +'\'+ $ClarionTemplateFilename1
$ClarionTemplateFilePath2		= $ClarionTemplateFolder +'\'+ $ClarionTemplateFilename2


IF ($PatchChoice -eq "P")
{
Write-Host ""

#Comment out the changes you do not want
Write-Host "$ActionP1"
Write-Host ""
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath1).Replace($OriginalString1,$PatchString1)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath1, $content)
Write-Host ""

Write-Host "$ActionP2"
Write-Host ""
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath2).Replace($OriginalString2,$PatchString2)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath2, $content)
Write-Host ""

Write-Host "$ActionP3"
Write-Host ""
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath2).Replace($OriginalString3,$PatchString3)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath2, $content)
Write-Host ""

Write-Host "$ActionP4"
Write-Host ""
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath2).Replace($OriginalString4,$PatchString4)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath2, $content)
Write-Host ""

Write-Host "$ActionP5"
Write-Host ""
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath2).Replace($OriginalString5,$PatchString5)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath2, $content)
Write-Host ""

Write-Host "$ActionP6"
Write-Host ""
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath2).Replace($OriginalString6,$PatchString6)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath2, $content)
Write-Host ""

Write-Host "$ActionP7"
Write-Host ""
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath2).Replace($OriginalString7,$PatchString7)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath2, $content)
Write-Host ""

Write-Host "$ActionP8"
Write-Host ""
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath2).Replace($OriginalString8,$PatchString8)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath2, $content)
Write-Host ""

Write-Host "$ActionP9"
Write-Host ""
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath2).Replace($OriginalString9,$PatchString9)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath2, $content)
Write-Host ""

Write-Host ""
Write-Host "Completed Patching: $ClarionTemplateFilePath1"
Write-Host "Completed Patching: $ClarionTemplateFilePath2"
Write-Host ""
}
ElseIf ($PatchChoice -eq "R")
{
Write-Host ""

#Comment out the changes you do not want
Write-Host "$ActionR1"
Write-Host ""
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath1).Replace($PatchString1,$OriginalString1)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath1, $content)
Write-Host ""

Write-Host "$ActionR2"
Write-Host ""
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath2).Replace($PatchString2,$OriginalString2)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath2, $content)
Write-Host ""

Write-Host "$ActionR3"
Write-Host ""
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath2).Replace($PatchString3,$OriginalString3)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath2, $content)
Write-Host ""

Write-Host "$ActionR4"
Write-Host ""
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath2).Replace($PatchString4,$OriginalString4)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath2, $content)
Write-Host ""

Write-Host "$ActionR5"
Write-Host ""
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath2).Replace($PatchString5,$OriginalString5)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath2, $content)
Write-Host ""

Write-Host "$ActionR6"
Write-Host ""
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath2).Replace($PatchString6,$OriginalString6)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath2, $content)
Write-Host ""

Write-Host "$ActionR7"
Write-Host ""
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath2).Replace($PatchString7,$OriginalString7)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath2, $content)
Write-Host ""

Write-Host "$ActionR8"
Write-Host ""
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath2).Replace($PatchString8,$OriginalString8)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath2, $content)
Write-Host ""

Write-Host "$ActionR9"
Write-Host ""
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath2).Replace($PatchString9,$OriginalString9)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath2, $content)
Write-Host ""

Write-Host ""
Write-Host "Completed Reverting Patch: $ClarionTemplateFilePath1"
Write-Host "Completed Reverting Patch: $ClarionTemplateFilePath2"
Write-Host ""
}
