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


$ClarionTemplateFilename1 		= "ABProgrm.TPW"
$ActionP1						= "Patch Line 1"
$ActionR1						= "Revert Line 2"
$OriginalString1 	= 
"#GROUP(%GenerateGlobalDataField,%pGlobalDataLocalExternal='EXTERNAL')
#DECLARE(%BaseDataLevel,LONG)"
$PatchString1 		=
"#GROUP(%GenerateGlobalDataField,%pGlobalDataLocalExternal='EXTERNAL')
#Declare(%GlobalDataStatementMod,String)
#Set(%GlobalDataStatementMod,%GlobalDataStatement)
#Call(%RemoveBlankPrefix,%GlobalDataStatementMod)
#DECLARE(%BaseDataLevel,LONG)"


$ActionP2						= "Patch Line 2"
$ActionR2						= "Revert Line 2"
$OriginalString2 	= 
"%[20]GlobalData %GlobalDataStatement,EXTERNAL,DLL(_ABCDllMode_)"
$PatchString2 		= 
"%[20]GlobalData %GlobalDataStatementMod,EXTERNAL,DLL(_ABCDllMode_)"

$ActionP3						= "Patch Line 3"
$ActionR3						= "Revert Line 3"
$OriginalString3 	= 
"%[20 + ((%GlobalDataLevel - %BaseDataLevel) * 2)]GlobalData %GlobalDataStatement,EXTERNAL"
$PatchString3 		= 
"%[20 + ((%GlobalDataLevel - %BaseDataLevel) * 2)]GlobalData %GlobalDataStatementMod,EXTERNAL"


$ActionP4						= "Patch Line 4"
$ActionR4						= "Revert Line 4"
$OriginalString4 	= 
"#ELSE
%[20 + ((%GlobalDataLevel - %BaseDataLevel) * 2)]GlobalData %GlobalDataStatement"
$PatchString4 		= 
"#ELSE
%[20 + ((%GlobalDataLevel - %BaseDataLevel) * 2)]GlobalData %GlobalDataStatementMod"

$ActionP5						= "Patch Line 5"
$ActionR5						= "Revert Line 5"
$OriginalString5 	= 
"#SET(%CustomGlobalDataBeforeFiles,%pDataBeforeFile)
#!"
$PatchString5 		= 
"#SET(%CustomGlobalDataBeforeFiles,%pDataBeforeFile)
#!
#Group(%RemoveBlankPrefix, *%pVarDeclaration)
#Declare( %PrefixPosStart, Long )
#Set( %PrefixPosStart, StrPos( Upper( %pVarDeclaration ), ',<32>*PRE(<32>*)' ) )
#IF( %PrefixPosStart )																	
	#Set( %pVarDeclaration, Sub( %pVarDeclaration, 1 , %PrefixPosStart-1 ) ) 
#ENDIF
#Return
#!"

$ClarionTemplateFilename2 		= "ABMODULE.TPW"
$ActionP6						= "Patch Line 6"
$ActionR6						= "Revert Line 6"
$OriginalString6 	= 
"#MODULE(GENERATED,'Generated Source Module'),HLP('~TPLModuleGenerated.htm') #! MODULE header
#PREEMBED('! Before Embed Point: ' & %EmbedID & ') DESC(' & %EmbedDescription & ') ARG(' & %EmbedParameters & ')',%GenerateEmbedComments)"
$PatchString6 		= 
"#MODULE(GENERATED,'Generated Source Module'),HLP('~TPLModuleGenerated.htm') #! MODULE header
#Declare(%ModuleDataStatementMod,String)
#PREEMBED('! Before Embed Point: ' & %EmbedID & ') DESC(' & %EmbedDescription & ') ARG(' & %EmbedParameters & ')',%GenerateEmbedComments)"

$ActionP7						= "Patch Line 7"
$ActionR7						= "Revert Line 7"
$OriginalString7 	= 
"#FOR(%ModuleData)
%ModuleData   %ModuleDataStatement
#ENDFOR"
$PatchString7 		=
"#FOR(%ModuleData)
#Set(%ModuleDataStatementMod,%ModuleDataStatement)
#Call(%RemoveBlankPrefix,%ModuleDataStatementMod)
%ModuleData   %ModuleDataStatementMod
#ENDFOR"

$ClarionTemplateFilename3 		= "ABProcs.tpw"
$ActionP8						= "Patch Line 8"
$ActionR8						= "Revert Line 8"
$OriginalString8 	= 
"#GROUP(%GenerateLocalData)
#!"
$PatchString8 		=
"#GROUP(%GenerateLocalData)
#Declare(%LocalDataStatementMod,String)
#!"

$ActionP9						= "Patch Line 9"
$ActionR9						= "Revert Line 9"
$OriginalString9 	= 
"#FOR(%LocalData)
#IF(LEFT(%LocalDataStatement,6)='&CLASS')
   #SET(%ValueConstruct,EXTRACT(%LocalDataStatement,'&CLASS',1))
   #IF(NOT %ValueConstruct)"
$PatchString9 		=
"#FOR(%LocalData)
#Set(%LocalDataStatementMod,%LocalDataStatement)
#Call(%RemoveBlankPrefix,%LocalDataStatementMod)
#IF(LEFT(%LocalDataStatementMod,6)='&CLASS')
   #SET(%ValueConstruct,EXTRACT(%LocalDataStatementMod,'&CLASS',1))
   #IF(NOT %ValueConstruct)"

$ActionP10						= "Patch Line 10"
$ActionR10						= "Revert Line 10"
$OriginalString10 	= 
"#IF(LEFT(%LocalDataStatement,5)='CLASS')
    #SET(%ValueConstruct,EXTRACT(%LocalDataStatement,'CLASS',1))
    #IF(%ValueConstruct)"
$PatchString10 		=
"#IF(LEFT(%LocalDataStatement,5)='CLASS')
    #SET(%ValueConstruct,EXTRACT(%LocalDataStatementMod,'CLASS',1))
    #IF(%ValueConstruct)"
	
$ActionP11						= "Patch Line 11"
$ActionR11						= "Revert Line 11"
$OriginalString11 	= 
"#ENDIF
%[20]LocalData %LocalDataStatement #<! %LocalDataDescription
#ENDIF
#ENDFOR"
$PatchString11 		=
"#ENDIF
%[20]LocalData %LocalDataStatementMod #<! %LocalDataDescription
#ENDIF
#ENDFOR"




Write-Host ""
Write-Host ""
Write-Host "	Update the Clarion Templates to prevent blank group prefixes"
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
$ClarionTemplateFilePath3		= $ClarionTemplateFolder +'\'+ $ClarionTemplateFilename3

IF ($PatchChoice -eq "P")
{
Write-Host ""

#Comment out the changes you do not want
Write-Host "$ActionP1"
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath1).Replace($OriginalString1,$PatchString1)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath1, $content)


Write-Host "$ActionP2"
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath1).Replace($OriginalString2,$PatchString2)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath1, $content)

Write-Host "$ActionP3"
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath1).Replace($OriginalString3,$PatchString3)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath1, $content)


Write-Host "$ActionP4"
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath1).Replace($OriginalString4,$PatchString4)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath1, $content)

Write-Host "$ActionP5"
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath1).Replace($OriginalString5,$PatchString5)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath1, $content)

Write-Host "$ActionP6"
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath2).Replace($OriginalString6,$PatchString6)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath2, $content)

Write-Host "$ActionP7"
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath2).Replace($OriginalString7,$PatchString7)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath2, $content)

Write-Host "$ActionP8"
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath3).Replace($OriginalString8,$PatchString8)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath3, $content)

Write-Host "$ActionP9"
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath3).Replace($OriginalString9,$PatchString9)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath3, $content)

Write-Host "$ActionP10"
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath3).Replace($OriginalString10,$PatchString10)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath3, $content)

Write-Host "$ActionP11"
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath3).Replace($OriginalString11,$PatchString11)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath3, $content)

Write-Host ""
Write-Host "Completed Patching: $ClarionTemplateFilePath1"
Write-Host "Completed Patching: $ClarionTemplateFilePath2"
Write-Host "Completed Patching: $ClarionTemplateFilePath3"
Write-Host ""
}
ElseIf ($PatchChoice -eq "R")
{
Write-Host ""

#Comment out the changes you do not want
Write-Host "$ActionR1"
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath1).Replace($PatchString1,$OriginalString1)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath1, $content)

Write-Host "$ActionR2"
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath1).Replace($PatchString2,$OriginalString2)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath1, $content)

Write-Host "$ActionR3"
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath1).Replace($PatchString3,$OriginalString3)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath1, $content)

Write-Host "$ActionR4"
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath1).Replace($PatchString4,$OriginalString4)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath1, $content)

Write-Host "$ActionR5"
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath1).Replace($PatchString5,$OriginalString5)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath1, $content)

Write-Host "$ActionR6"
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath2).Replace($PatchString6,$OriginalString6)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath2, $content)

Write-Host "$ActionR7"
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath2).Replace($PatchString7,$OriginalString7)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath2, $content)

Write-Host "$ActionR8"
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath3).Replace($PatchString8,$OriginalString8)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath3, $content)

Write-Host "$ActionR9"
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath3).Replace($PatchString9,$OriginalString9)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath3, $content)

Write-Host "$ActionR10"
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath3).Replace($PatchString10,$OriginalString10)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath3, $content)

Write-Host "$ActionR11"
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePath3).Replace($PatchString11,$OriginalString11)
[System.IO.File]::WriteAllText($ClarionTemplateFilePath3, $content)

Write-Host ""
Write-Host "Completed Reverting Patch: $ClarionTemplateFilePath1"
Write-Host "Completed Reverting Patch: $ClarionTemplateFilePath2"
Write-Host "Completed Reverting Patch: $ClarionTemplateFilePath3"
Write-Host ""
}
