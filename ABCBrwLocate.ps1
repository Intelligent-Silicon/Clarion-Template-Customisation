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

# https://stackoverflow.com/questions/45023110/powershell-foreach-get-the-number-of-line
# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions?view=powershell-7.5


Function	Set-TemplateFileNames
{
	$Global:TemplateABBrowse 		= "ABBROWSE.TPW"	# ABC Browse Template, Variable Scope: Global
	$Global:TemplateABWCntrl 		= "ABWCNTRL.TPW"	# ABC Wizard Control Template, Variable Scope: Global
}

Function	Set-RegExStrings
{
	$Global:RegExABCBrowseDefaultProc 		= "%LocatorType STRING  \('(?:None|Step|Entry|Incremental|Filtered)'\)" 	# ABC Browse Template
	$Global:RegExABCBrowseSortNo			= "%LocatorType,DEFAULT\('(?:None|Step|Entry|Incremental|Filtered)'\)"		# ABC Browse Template
	$Global:RegExABCBrowseSortType			= "%SortLocatorType,DEFAULT\('(?:None|Step|Entry|Incremental|Filtered)'\)"	# ABC Browse Template
	
	$Global:RegExABCQBBLocatorDefault		= "%%LocatorType DEFAULT  \('(?:None|Step|Entry|Incremental|Filtered)'\)"	# ABC Wizard Control Template
	$Global:RegExABCQBBLocatorWhen			= "WHEN  \(%ValueConstruct\) \('(?:None|Step|Entry|Incremental|Filtered)'\)"	# ABC Wizard Control Template
}

Function	Set-PatchString-ABBrowse-DefaultProc
{
	$Global:PatchStringABBrowseNDefaultProc = "%LocatorType STRING  ('None')"
	$Global:PatchStringABBrowseSDefaultProc = "%LocatorType STRING  ('Step')"
	$Global:PatchStringABBrowseEDefaultProc = "%LocatorType STRING  ('Entry')"
	$Global:PatchStringABBrowseIDefaultProc = "%LocatorType STRING  ('Incremental')"
	$Global:PatchStringABBrowseFDefaultProc = "%LocatorType STRING  ('Filtered')"
}

Function	Set-PatchString-ABBrowse-SortNo
{
	$Global:PatchStringABBrowseNSortNo		= "#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%LocatorType,DEFAULT('None'),WHENACCEPTED(%SetLocatorClass(0,%LocatorType))"
	$Global:PatchStringABBrowseSSortNo		= "#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%LocatorType,DEFAULT('Step'),WHENACCEPTED(%SetLocatorClass(0,%LocatorType))"
	$Global:PatchStringABBrowseESortNo		= "#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%LocatorType,DEFAULT('Entry'),WHENACCEPTED(%SetLocatorClass(0,%LocatorType))"
	$Global:PatchStringABBrowseISortNo		= "#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%LocatorType,DEFAULT('Incremental'),WHENACCEPTED(%SetLocatorClass(0,%LocatorType))"
	$Global:PatchStringABBrowseFSortNo		= "#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%LocatorType,DEFAULT('Filtered'),WHENACCEPTED(%SetLocatorClass(0,%LocatorType))"
}

Function	Set-PatchString-ABBrowse-SortType
{
	$Global:PatchStringABBrowseNSortType 	= "#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%SortLocatorType,DEFAULT('None'),WHENACCEPTED(%SetLocatorClass(%SortOrder,%SortLocatorType))"
	$Global:PatchStringABBrowseSSortType 	= "#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%SortLocatorType,DEFAULT('Step'),WHENACCEPTED(%SetLocatorClass(%SortOrder,%SortLocatorType))"
	$Global:PatchStringABBrowseESortType 	= "#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%SortLocatorType,DEFAULT('Entry'),WHENACCEPTED(%SetLocatorClass(%SortOrder,%SortLocatorType))"
	$Global:PatchStringABBrowseISortType 	= "#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%SortLocatorType,DEFAULT('Incremental'),WHENACCEPTED(%SetLocatorClass(%SortOrder,%SortLocatorType))"
	$Global:PatchStringABBrowseFSortType 	= "#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%SortLocatorType,DEFAULT('Filtered'),WHENACCEPTED(%SetLocatorClass(%SortOrder,%SortLocatorType))"
}

Function	Set-PatchString-ABBrowse-QBBLocatorDefault
{
	$Global:PatchStringABQBBLocatorNDefault 	= "%%LocatorType DEFAULT  ('None')"
	$Global:PatchStringABQBBLocatorSDefault 	= "%%LocatorType DEFAULT  ('Step')"
	$Global:PatchStringABQBBLocatorEDefault 	= "%%LocatorType DEFAULT  ('Entry')"
	$Global:PatchStringABQBBLocatorIDefault 	= "%%LocatorType DEFAULT  ('Incremental')"
	$Global:PatchStringABQBBLocatorFDefault 	= "%%LocatorType DEFAULT  ('Filtered')"
}

Function	Set-PatchString-ABBrowse-QBBLocatorWhen
{
	$Global:PatchStringABQBBLocatorNWhen 	= "WHEN  (%ValueConstruct) ('None')"
	$Global:PatchStringABQBBLocatorSWhen 	= "WHEN  (%ValueConstruct) ('Step')"
	$Global:PatchStringABQBBLocatorEWhen 	= "WHEN  (%ValueConstruct) ('Entry')"
	$Global:PatchStringABQBBLocatorIWhen 	= "WHEN  (%ValueConstruct) ('Incremental')"
	$Global:PatchStringABQBBLocatorFWhen 	= "WHEN  (%ValueConstruct) ('Filtered')"
}

Function 	Display-Notice
{
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
}

Function 	Get-InputChoice
{
	$Global:InputChoice	= (Read-Host "Set Browse Locator to [D]efault (Step), [N]one, [S]tep, [E]ntry, [I]ncremental, [F]iltered or [Q]uit").ToUpper()
	# In a lowercase value is input, the lowercase value and not uppercase value is passed to the function Patch-Template as a parameter.
	#$InputChoice		= Read-Host "Set Browse Locator to [D]efault (Step), [N]one, [S]tep, [E]ntry, [I]ncremental, [F]iltered or [Q]uit"
	#$InputChoice		= $InputChoice.ToUpper() 
	
	IF ( $InputChoice -ne "D" -And $InputChoice -ne "N" -And $InputChoice -ne "S" -And $InputChoice -ne "E" -And $InputChoice -ne "I" -And $InputChoice -ne "F" -And $InputChoice -ne "Q")
		{
			Write-Host "Invalid Choice. Quiting..."
			Exit 	# Exit this Script here
		}
	ElseIF ( $InputChoice -eq "Q" )
		{
			Write-Host "Quiting..."
			Exit 	# Exit this script here
		}
	ElseIF ( $InputChoice -eq "D" )
		{
			Write-Host ""
			Write-Host "Setting Browse Locator to Default (Step)"
			Write-Host ""
		}
	ElseIF ( $InputChoice -eq "N" )
		{
			Write-Host ""
			Write-Host "Setting Browse Locator to None"
			Write-Host ""
		}
	ElseIF ( $InputChoice -eq "S" )
		{
			Write-Host ""
			Write-Host "Setting Browse Locator to Step"
			Write-Host ""
		}
	ElseIF ( $InputChoice -eq "E" )
		{
			Write-Host ""
			Write-Host "Setting Browse Locator to Entry"
			Write-Host ""
		}
	ElseIF ( $InputChoice -eq "I" )
		{
			Write-Host ""
			Write-Host "Setting Browse Locator to Incremental"
			Write-Host ""
		}
	ElseIF ( $InputChoice -eq "F" )
		{
			Write-Host ""
			Write-Host "Setting Browse Locator to Filtered"
			Write-Host ""
		}
}

Function 	Get-TemplateFolder
{
	
	Write-Host "Specify the Clarion Template Folder."
	$TemplateFolderDefault 	= 'C:\Clarion11\template\win'	# Variable Scope: Function
	$TemplateFolderInput	= Read-Host "Hit Enter to use the default Clarion 11 template path : $($TemplateFolderDefault) " # Variable Scope: Function
	$Global:TemplateFolder	= ($TemplateFolderDefault,$TemplateFolderInput)[[bool]$TemplateFolderInput] # Variable Scope: Global

	IF ( (Get-Item $TemplateFolder) -isnot [System.IO.DirectoryInfo] )	# If not a valid folder
	{
		Write-Host "Invalid Folder. Quiting..."
		return
	}
	Write-Host "Clarion Template Folder: $TemplateFolder"
}

Function 	Set-TemplateFilePaths
{
	$TemplateFolder						= $TemplateFolder.TrimEnd('\')
	$Global:TemplateFilePathABBrowse	= $TemplateFolder +'\'+ $TemplateABBrowse		# ABC Browse Template File, Variable Scope: Global
	$Global:TemplateFilePathABWCntrl	= $TemplateFolder +'\'+ $TemplateABWCntrl		# ABC Browse Wizard Template File, Variable Scope, Global
}																				

Function 	Debug-Check 
{
	Param
	(
		[string[]]$PatchChoice,				# Parameter inputs
		[string[]]$TemplateFilePath,		#		/\
		[string[]]$RegEx,					#		|
		$PatchStringNone,					#		|			Using [string[]] removes the object attributes like $PatchStringNone.Length
		$PatchStringStep,					#		|
		$PatchStringEntry,					#		|
		$PatchStringIncremental,			#	   \/
		$PatchStringFiltered				# Parameter inputs
    )
	
	<# 
	# Used to help debug the parameter values
	Write-Host ""
	Write-Host "PatchChoice is $PatchChoice"
	Write-Host "TemplateFilePath is $TemplateFilePath"
	Write-Host "RegEx is $RegEx"
	Write-Host "PatchStringNone is $PatchStringNone"
	Write-Host "PatchStringStep is $PatchStringStep"
	Write-Host "PatchStringEntry is $PatchStringEntry"
	Write-Host "PatchStringIncremental is $PatchStringIncremental"
	Write-Host "PatchStringFiltered is $PatchStringFiltered"
	Write-Host ""
	#>
}

Function 	Patch-Template 
{
	Param
	(
		[string[]]$PatchChoice,				# Parameter inputs
		[string[]]$TemplateFilePath,		#		/\
		[string[]]$RegEx,					#		|
		$PatchStringNone,					#		|		Using [string[]] removes the object attributes like $PatchStringNone.Length
		$PatchStringStep,					#		|
		$PatchStringEntry,					#		|
		$PatchStringIncremental,			#	   \/
		$PatchStringFiltered				# Parameter inputs
    )

	<#
	# Used to help debug the parameter values
	 Write-Host "PatchChoice 						= $PatchChoice"
	 Write-Host "TemplateFilePath 					= $TemplateFilePath"
	 Write-Host "RegEx 								= $RegEx"
	 Write-Host "PatchStringNone 					= $PatchStringNone"
	 Write-Host "PatchStringStep 					= $PatchStringStep"
	 Write-Host "PatchStringEntry					= $PatchStringEntry"
	 Write-Host "PatchStringIncremental 			= $PatchStringIncremental"
	 Write-Host "PatchStringFiltered				= $PatchStringFiltered"
	 Write-Host "PatchStringNone Length 			= $($PatchStringNone.Length)"
	 Write-Host "PatchStringStep Length 			= $($PatchStringStep.Length)"
	 Write-Host "PatchStringEntry Length			= $($PatchStringEntry.Length)"
	 Write-Host "PatchStringIncremental Length 		= $($PatchStringIncremental.Length)"
	 Write-Host "PatchStringFiltered Length			= $($PatchStringFiltered.Length)"
	#>
	
	Clear-Variable -name FileContent*		# This clears all the variables beginning with FileContent
	
	Write-Host "Template File: $TemplateFilePath"
	
	$FileContent 	= Get-Content $TemplateFilePath
	$FileContentNew = foreach ($line in $FileContent) 
	{
		$FileContentLineCount++
		if ($line -match $RegEx) 
		{
			Write-Host "RegEx match on Line: $FileContentLineCount"
			Write-Host ""

			$FileContentTrimmedLine 	= $line.TrimStart()
			$FileContentIndent 			= $line.Length - $FileContentTrimmedLine.Length
			# Write-Host "FileContentIndent = $FileContentIndent"  # Used for Debugging
			
			IF ( $PatchChoice -eq "D" -OR  $PatchChoice -eq "S" )
				{ $PatchStringStep.PadLeft( 		$FileContentIndent + 	$PatchStringstep.Length ) }
			ElseIF ( $PatchChoice -eq "N" )
				{ $PatchStringNone.PadLeft(			$FileContentIndent +	$PatchStringNone.Length ) }
			ElseIF ( $PatchChoice -eq "E" )
				{ $PatchStringEntry.PadLeft(		$FileContentIndent +	$PatchStringEntry.Length ) }
			ElseIF ( $PatchChoice -eq "I" )
				{ $PatchStringIncremental.PadLeft(	$FileContentIndent +	$PatchStringIncremental.Length ) }
			ElseIF ( $PatchChoice -eq "F" )
				{ $PatchStringFiltered.PadLeft(		$FileContentIndent +	$PatchStringFiltered.Length ) }
        }
		else 
		{
			$line
		}
	}
	$FileContentNew | Set-Content $TemplateFilePath

}

Function  	Display-Finish
{
	Write-Host ""
	Write-Host "Completed Patching: $TemplateFilePathABBrowse"
	Write-Host "Completed Patching: $TemplateFilePathABWCntrl"
	Write-Host ""
}

# Lets call the above functions. Functions need to be declared before they can be called in PowerShell
Display-Notice
Set-TemplateFileNames
Get-TemplateFolder
Set-TemplateFilePaths
Get-InputChoice
Set-RegExStrings
Set-PatchString-ABBrowse-SortNo
Set-PatchString-ABBrowse-SortType
Set-PatchString-ABBrowse-DefaultProc

Set-PatchString-ABBrowse-QBBLocatorDefault
Set-PatchString-ABBrowse-QBBLocatorWhen

Debug-Check 	$InputChoice $TemplateFilePathABBrowse $RegExABCBrowseDefaultProc 		$PatchStringABBrowseNDefaultProc 	$PatchStringABBrowseSDefaultProc 	$PatchStringABBrowseEDefaultProc 	$PatchStringABBrowseIDefaultProc 	$PatchStringABBrowseFDefaultProc   
Debug-Check 	$InputChoice $TemplateFilePathABBrowse $RegExABCBrowseSortNo 			$PatchStringABBrowseNSortNo 		$PatchStringABBrowseSSortNo 		$PatchStringABBrowseESortNo 		$PatchStringABBrowseISortNo 		$PatchStringABBrowseFSortNo	   
Debug-Check 	$InputChoice $TemplateFilePathABBrowse $RegExABCBrowseSortType 			$PatchStringABBrowseNSortType 		$PatchStringABBrowseSSortType 		$PatchStringABBrowseESortType 		$PatchStringABBrowseISortType 		$PatchStringABBrowseFSortType	   

Patch-Template 	$InputChoice $TemplateFilePathABBrowse $RegExABCBrowseDefaultProc 		$PatchStringABBrowseNDefaultProc 	$PatchStringABBrowseSDefaultProc 	$PatchStringABBrowseEDefaultProc 	$PatchStringABBrowseIDefaultProc 	$PatchStringABBrowseFDefaultProc   
Patch-Template 	$InputChoice $TemplateFilePathABBrowse $RegExABCBrowseSortNo 			$PatchStringABBrowseNSortNo 		$PatchStringABBrowseSSortNo 		$PatchStringABBrowseESortNo 		$PatchStringABBrowseISortNo 		$PatchStringABBrowseFSortNo	   
Patch-Template 	$InputChoice $TemplateFilePathABBrowse $RegExABCBrowseSortType 			$PatchStringABBrowseNSortType 		$PatchStringABBrowseSSortType 		$PatchStringABBrowseESortType 		$PatchStringABBrowseISortType 		$PatchStringABBrowseFSortType	   
													    
Patch-Template 	$InputChoice $TemplateFilePathABWCntrl $RegExABCQBBLocatorDefault 		$PatchStringABQBBLocatorNDefault 	$PatchStringABQBBLocatorSDefault 	$PatchStringABQBBLocatorEDefault 	$PatchStringABQBBLocatorIDefault 	$PatchStringABQBBLocatorFDefault	   
Patch-Template 	$InputChoice $TemplateFilePathABWCntrl $RegExABCQBBLocatorWhen 			$PatchStringABQBBLocatorNWhen 		$PatchStringABQBBLocatorSWhen 		$PatchStringABQBBLocatorEWhen 		$PatchStringABQBBLocatorIWhen 		$PatchStringABQBBLocatorFWhen	   

Display-Finish
