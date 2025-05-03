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


$ClarionTemplateFilename1 		= "ABBROWSE.TPW"

$RegExString1 	= "%LocatorType,DEFAULT\('(?:None|Step|Entry|Incremental|Filtered)'\)"
$RegExString2 	= "%SortLocatorType,DEFAULT\('(?:None|Step|Entry|Incremental|Filtered)'\)"
$RegExString3 	= "%LocatorType STRING  \('(?:None|Step|Entry|Incremental|Filtered)'\)"


$PatchString1N 		=
"#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%LocatorType,DEFAULT('None'),WHENACCEPTED(%SetLocatorClass(0,%LocatorType))"
$PatchString1S 		=
"#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%LocatorType,DEFAULT('Step'),WHENACCEPTED(%SetLocatorClass(0,%LocatorType))"
$PatchString1E 		=
"#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%LocatorType,DEFAULT('Entry'),WHENACCEPTED(%SetLocatorClass(0,%LocatorType))"
$PatchString1I 		=
"#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%LocatorType,DEFAULT('Incremental'),WHENACCEPTED(%SetLocatorClass(0,%LocatorType))"
$PatchString1F 		=
"#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%LocatorType,DEFAULT('Filtered'),WHENACCEPTED(%SetLocatorClass(0,%LocatorType))"

$PatchString2N 		=
"#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%SortLocatorType,DEFAULT('None'),WHENACCEPTED(%SetLocatorClass(%SortOrder,%SortLocatorType))"
$PatchString2S 		=
"#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%SortLocatorType,DEFAULT('Step'),WHENACCEPTED(%SetLocatorClass(%SortOrder,%SortLocatorType))"
$PatchString2E 		=
"#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%SortLocatorType,DEFAULT('Entry'),WHENACCEPTED(%SetLocatorClass(%SortOrder,%SortLocatorType))"
$PatchString2I 		=
"#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%SortLocatorType,DEFAULT('Incremental'),WHENACCEPTED(%SetLocatorClass(%SortOrder,%SortLocatorType))"
$PatchString2F 		=
"#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%SortLocatorType,DEFAULT('Filtered'),WHENACCEPTED(%SetLocatorClass(%SortOrder,%SortLocatorType))"

$PatchString3N 		=
"%LocatorType STRING  ('None')"
$PatchString3S 		=
"%LocatorType STRING  ('Step')"
$PatchString3E 		=
"%LocatorType STRING  ('Entry')"
$PatchString3I 		=
"%LocatorType STRING  ('Incremental')"
$PatchString3F 		=
"%LocatorType STRING  ('Filtered')"

$ClarionTemplateFilename2 		= "CTLBROW.TPW"

$PatchString4N 		=
"#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%LocatorType,DEFAULT('None')"
$PatchString4S 		=
"#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%LocatorType,DEFAULT('Step')"
$PatchString4E 		=
"#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%LocatorType,DEFAULT('Entry')"
$PatchString4I 		=
"#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%LocatorType,DEFAULT('Incremental')"
$PatchString4F 		=
"#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%LocatorType,DEFAULT('Filtered')"

$PatchString5N 		=
"#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%SortLocatorType,DEFAULT('None')"
$PatchString5S 		=
"#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%SortLocatorType,DEFAULT('Step')"
$PatchString5E 		=
"#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%SortLocatorType,DEFAULT('Entry')"
$PatchString5I 		=
"#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%SortLocatorType,DEFAULT('Incremental')"
$PatchString5F 		=
"#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%SortLocatorType,DEFAULT('Filtered')"


$RegExString6 					= "%%LocatorType DEFAULT  \('(?:None|Step|Entry|Incremental|Filtered)'\)"
$ClarionTemplateFilename6 		= "ABWCNTRL.TPW"

$PatchString6N 		= "%%LocatorType DEFAULT  ('None')"
$PatchString6S 		= "%%LocatorType DEFAULT  ('Step')"
$PatchString6E 		= "%%LocatorType DEFAULT  ('Entry')"
$PatchString6I 		= "%%LocatorType DEFAULT  ('Incremental')"
$PatchString6F 		= "%%LocatorType DEFAULT  ('Filtered')"

$ClarionTemplateFilename7 		= "WCONTROL.TPW"

$RegExString7 					= "WHEN  \(%ValueConstruct\) \('(?:None|Step|Entry|Incremental|Filtered)'\)"

$PatchString7N 		= "WHEN  (%ValueConstruct) ('None')"
$PatchString7S 		= "WHEN  (%ValueConstruct) ('Step')"
$PatchString7E 		= "WHEN  (%ValueConstruct) ('Entry')"
$PatchString7I 		= "WHEN  (%ValueConstruct) ('Incremental')"
$PatchString7F 		= "WHEN  (%ValueConstruct) ('Filtered')"

Write-Host ""
Write-Host ""
Write-Host "	Update the Clarion Templates to set the default browse locator"
Write-Host "	=============================================================="
Write-Host ""
Write-Host "See https://github.com/Intelligent-Silicon/Clarion-Template-Customisation for more information."
Write-Host ""
Write-Host "Execution Policy $(Get-ExecutionPolicy)"
Write-Host "Powershell Version $($PSVersionTable.PSVersion)"
Write-Host ""
Write-Host ""


$PatchChoice	= Read-Host "Set Browse Locator to [D]efault (Step), [N]one, [S]tep, [E]ntry, [I]ncremental, [F]iltered or [Q]uit"
$PatchChoice	= $PatchChoice.ToUpper()

IF ( $PatchChoice -ne "D" -And $PatchChoice -ne "N" -And $PatchChoice -ne "S" -And $PatchChoice -ne "E" -And $PatchChoice -ne "I" -And $PatchChoice -ne "F" -And $PatchChoice -ne "Q")
{
	Write-Host "Invalid Choice. Quiting..."
	Return 
}
ElseIF ( $PatchChoice -eq "Q" )
{
	Write-Host "Quiting..."
	Return 
}
ElseIF ( $PatchChoice -eq "D" )
{
	Write-Host ""
	Write-Host "Setting Browse Locator to Default (Step)"
	Write-Host ""
}
ElseIF ( $PatchChoice -eq "N" )
{
	Write-Host ""
	Write-Host "Setting Browse Locator to None"
	Write-Host ""
}
ElseIF ( $PatchChoice -eq "S" )
{
	Write-Host ""
	Write-Host "Setting Browse Locator to Step"
	Write-Host ""
}
ElseIF ( $PatchChoice -eq "E" )
{
	Write-Host ""
	Write-Host "Setting Browse Locator to Entry"
	Write-Host ""
}
ElseIF ( $PatchChoice -eq "I" )
{
	Write-Host ""
	Write-Host "Setting Browse Locator to Incremental"
	Write-Host ""
}
ElseIF ( $PatchChoice -eq "F" )
{
	Write-Host ""
	Write-Host "Setting Browse Locator to Filtered"
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
$ClarionTemplateFilePath6		= $ClarionTemplateFolder +'\'+ $ClarionTemplateFilename6
$ClarionTemplateFilePath7		= $ClarionTemplateFolder +'\'+ $ClarionTemplateFilename7

$content1 = Get-Content $ClarionTemplateFilePath1
$newContent1 = foreach ($line in $content1) {
    if ($line -match $RegExString1) {
		$trimmedLine = $line.TrimStart()
		$numSpaces = $line.Length - $trimmedLine.Length

		IF ( $PatchChoice -eq "D" -OR  $PatchChoice -eq "S" )
			{ $PatchString1S.PadLeft($numSpaces+$PatchString1S.Length) }
		ElseIF ( $PatchChoice -eq "N" )
			{ $PatchString1N.PadLeft($numSpaces+$PatchString1N.Length) }
		ElseIF ( $PatchChoice -eq "E" )
			{ $PatchString1E.PadLeft($numSpaces+$PatchString1E.Length) }
		ElseIF ( $PatchChoice -eq "I" )
			{ $PatchString1I.PadLeft($numSpaces+$PatchString1I.Length) }
		ElseIF ( $PatchChoice -eq "F" )
			{ $PatchString1F.PadLeft($numSpaces+$PatchString1F.Length) }
        
    } else {
        $line
    }
}
$newContent1 | Set-Content $ClarionTemplateFilePath1

$content2 = Get-Content $ClarionTemplateFilePath1
$newContent2 = foreach ($line in $content2) {
	if ($line -match $RegExString2) {
		$trimmedLine = $line.TrimStart()
		$numSpaces = $line.Length - $trimmedLine.Length

		IF ( $PatchChoice -eq "D" -OR  $PatchChoice -eq "S" )
			{ $PatchString2S.PadLeft($numSpaces+$PatchString2S.Length) }
		ElseIF ( $PatchChoice -eq "N" )
			{ $PatchString2N.PadLeft($numSpaces+$PatchString2N.Length) }
		ElseIF ( $PatchChoice -eq "E" )
			{ $PatchString2E.PadLeft($numSpaces+$PatchString2E.Length) }
		ElseIF ( $PatchChoice -eq "I" )
			{ $PatchString2I.PadLeft($numSpaces+$PatchString2I.Length) }
		ElseIF ( $PatchChoice -eq "F" )
			{ $PatchString2F.PadLeft($numSpaces+$PatchString2F.Length) }
        
    } else {
        $line
    }
}
$newContent2 | Set-Content $ClarionTemplateFilePath1

$content3 = Get-Content $ClarionTemplateFilePath1
$newContent3 = foreach ($line in $content3) {
	if ($line -match $RegExString3) {
		$trimmedLine = $line.TrimStart()
		$numSpaces = $line.Length - $trimmedLine.Length

		IF ( $PatchChoice -eq "D" -OR  $PatchChoice -eq "S" )
			{ $PatchString3S.PadLeft($numSpaces+$PatchString3S.Length) }
		ElseIF ( $PatchChoice -eq "N" )
			{ $PatchString3N.PadLeft($numSpaces+$PatchString3N.Length) }
		ElseIF ( $PatchChoice -eq "E" )
			{ $PatchString3E.PadLeft($numSpaces+$PatchString3E.Length) }
		ElseIF ( $PatchChoice -eq "I" )
			{ $PatchString3I.PadLeft($numSpaces+$PatchString3I.Length) }
		ElseIF ( $PatchChoice -eq "F" )
			{ $PatchString3F.PadLeft($numSpaces+$PatchString3F.Length) }
        
    } else {
        $line
    }
}
$newContent3 | Set-Content $ClarionTemplateFilePath1

$content4 = Get-Content $ClarionTemplateFilePath2
$newContent4 = foreach ($line in $content4) {
	if ($line -match $RegExString1) {
		$trimmedLine = $line.TrimStart()
		$numSpaces = $line.Length - $trimmedLine.Length

		IF ( $PatchChoice -eq "D" -OR  $PatchChoice -eq "S" )
			{ $PatchString4S.PadLeft($numSpaces+$PatchString4S.Length) }
		ElseIF ( $PatchChoice -eq "N" )
			{ $PatchString4N.PadLeft($numSpaces+$PatchString4N.Length) }
		ElseIF ( $PatchChoice -eq "E" )
			{ $PatchString4E.PadLeft($numSpaces+$PatchString4E.Length) }
		ElseIF ( $PatchChoice -eq "I" )
			{ $PatchString4I.PadLeft($numSpaces+$PatchString4I.Length) }
		ElseIF ( $PatchChoice -eq "F" )
			{ $PatchString4F.PadLeft($numSpaces+$PatchString4F.Length) }
        
    } else {
        $line
    }
}
$newContent4 | Set-Content $ClarionTemplateFilePath2

$content5 = Get-Content $ClarionTemplateFilePath2
$newContent5 = foreach ($line in $content5) {
	if ($line -match $RegExString2) {
		$trimmedLine = $line.TrimStart()
		$numSpaces = $line.Length - $trimmedLine.Length

		IF ( $PatchChoice -eq "D" -OR  $PatchChoice -eq "S" )
			{ $PatchString5S.PadLeft($numSpaces+$PatchString5S.Length) }
		ElseIF ( $PatchChoice -eq "N" )
			{ $PatchString5N.PadLeft($numSpaces+$PatchString5N.Length) }
		ElseIF ( $PatchChoice -eq "E" )
			{ $PatchString5E.PadLeft($numSpaces+$PatchString5E.Length) }
		ElseIF ( $PatchChoice -eq "I" )
			{ $PatchString5I.PadLeft($numSpaces+$PatchString5I.Length) }
		ElseIF ( $PatchChoice -eq "F" )
			{ $PatchString5F.PadLeft($numSpaces+$PatchString5F.Length) }
        
    } else {
        $line
    }
}
$newContent5 | Set-Content $ClarionTemplateFilePath2

$content6 = Get-Content $ClarionTemplateFilePath6
$newContent6 = foreach ($line in $content6) {
	if ($line -match $RegExString6) {
		$trimmedLine = $line.TrimStart()
		$numSpaces = $line.Length - $trimmedLine.Length

		IF ( $PatchChoice -eq "D" -OR  $PatchChoice -eq "S" )
			{ $PatchString6S.PadLeft($numSpaces+$PatchString6S.Length) }
		ElseIF ( $PatchChoice -eq "N" )
			{ $PatchString6N.PadLeft($numSpaces+$PatchString6N.Length) }
		ElseIF ( $PatchChoice -eq "E" )
			{ $PatchString6E.PadLeft($numSpaces+$PatchString6E.Length) }
		ElseIF ( $PatchChoice -eq "I" )
			{ $PatchString6I.PadLeft($numSpaces+$PatchString6I.Length) }
		ElseIF ( $PatchChoice -eq "F" )
			{ $PatchString6F.PadLeft($numSpaces+$PatchString6F.Length) }
        
    } else {
        $line
    }
}
$newContent6 | Set-Content $ClarionTemplateFilePath6

$content7 = Get-Content $ClarionTemplateFilePath7
$newContent7 = foreach ($line in $content7) {
	if ($line -match $RegExString6) {
		$trimmedLine = $line.TrimStart()
		$numSpaces = $line.Length - $trimmedLine.Length

		IF ( $PatchChoice -eq "D" -OR  $PatchChoice -eq "S" )
			{ $PatchString6S.PadLeft($numSpaces+$PatchString6S.Length) }
		ElseIF ( $PatchChoice -eq "N" )
			{ $PatchString6N.PadLeft($numSpaces+$PatchString6N.Length) }
		ElseIF ( $PatchChoice -eq "E" )
			{ $PatchString6E.PadLeft($numSpaces+$PatchString6E.Length) }
		ElseIF ( $PatchChoice -eq "I" )
			{ $PatchString6I.PadLeft($numSpaces+$PatchString6I.Length) }
		ElseIF ( $PatchChoice -eq "F" )
			{ $PatchString6F.PadLeft($numSpaces+$PatchString6F.Length) }
        
    } else {
        $line
    }
}
$newContent7 | Set-Content $ClarionTemplateFilePath7

$content8 = Get-Content $ClarionTemplateFilePath6
$newContent8 = foreach ($line in $content8) {
	if ($line -match $RegExString7) {
		$trimmedLine = $line.TrimStart()
		$numSpaces = $line.Length - $trimmedLine.Length

		IF ( $PatchChoice -eq "D" -OR  $PatchChoice -eq "S" )
			{ $PatchString7S.PadLeft($numSpaces+$PatchString7S.Length) }
		ElseIF ( $PatchChoice -eq "N" )
			{ $PatchString7N.PadLeft($numSpaces+$PatchString7N.Length) }
		ElseIF ( $PatchChoice -eq "E" )
			{ $PatchString7E.PadLeft($numSpaces+$PatchString7E.Length) }
		ElseIF ( $PatchChoice -eq "I" )
			{ $PatchString7I.PadLeft($numSpaces+$PatchString7I.Length) }
		ElseIF ( $PatchChoice -eq "F" )
			{ $PatchString7F.PadLeft($numSpaces+$PatchString7F.Length) }
        
    } else {
        $line
    }
}
$newContent8 | Set-Content $ClarionTemplateFilePath6

$content9 = Get-Content $ClarionTemplateFilePath7
$newContent9 = foreach ($line in $content9) {
	if ($line -match $RegExString7) {
		$trimmedLine = $line.TrimStart()
		$numSpaces = $line.Length - $trimmedLine.Length

		IF ( $PatchChoice -eq "D" -OR  $PatchChoice -eq "S" )
			{ $PatchString7S.PadLeft($numSpaces+$PatchString7S.Length) }
		ElseIF ( $PatchChoice -eq "N" )
			{ $PatchString7N.PadLeft($numSpaces+$PatchString7N.Length) }
		ElseIF ( $PatchChoice -eq "E" )
			{ $PatchString7E.PadLeft($numSpaces+$PatchString7E.Length) }
		ElseIF ( $PatchChoice -eq "I" )
			{ $PatchString7I.PadLeft($numSpaces+$PatchString7I.Length) }
		ElseIF ( $PatchChoice -eq "F" )
			{ $PatchString7F.PadLeft($numSpaces+$PatchString7F.Length) }
        
    } else {
        $line
    }
}
$newContent9 | Set-Content $ClarionTemplateFilePath7


Write-Host ""
Write-Host "Completed Patching: $ClarionTemplateFilePath1"
Write-Host "Completed Patching: $ClarionTemplateFilePath2"
Write-Host "Completed Patching: $ClarionTemplateFilePath6"
Write-Host "Completed Patching: $ClarionTemplateFilePath7"
Write-Host ""

