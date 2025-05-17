<#
    Powershell Script to Patch or Revert Clarion Template changes.
	
	Alignment is suited to Notepad++
	
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

Function	Set-TemplateFileNames
{
	$Global:TemplateClaBrowse 		= "CTLBrow.TPW"		# Clarion Browse Template, Variable Scope: Global
	$Global:TemplateClaWCntrl 		= "WControl.TPW"	# Clarion Wizard Control Template, Variable Scope: Global
}

Function	Set-RegExStrings
{
	$Global:RegExClaBrowLocatorType			= "%LocatorType,DEFAULT\('(?:None|Step|Entry|Incremental|Filtered)'\)"			# Clarion Browse Template
	$Global:RegExClaBrowSortLocatorType		= "%SortLocatorType,DEFAULT\('(?:None|Step|Entry|Incremental|Filtered)'\)"		# Clarion Browse Template
	$Global:RegExClaBrowBrowseLocatorType	= "#SET\(%BrowseLocatorType,'(?:None|Step|Entry|Incremental|Filtered)'\)"		# Clarion Browse Template
	$Global:RegExClaWCntQBBLocatorType		= "%%LocatorType DEFAULT  \('(?:None|Step|Entry|Incremental|Filtered)'\)"		# Clarion WControl Template
	$Global:RegExClaWCntQBBLocator			= "WHEN  \(%ValueConstruct\) \('(?:None|Step|Entry|Incremental|Filtered)'\)"		# Clarion WControl Template
	
}

Function	Set-PatchString-ClaBrow-LocatorType
{
	$Global:PatchStringClaBrowLocatorTypeN 			= "#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%LocatorType,DEFAULT('None')"
	$Global:PatchStringClaBrowLocatorTypeS 			= "#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%LocatorType,DEFAULT('Step')"
	$Global:PatchStringClaBrowLocatorTypeE 			= "#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%LocatorType,DEFAULT('Entry')"
	$Global:PatchStringClaBrowLocatorTypeI 			= "#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%LocatorType,DEFAULT('Incremental')"
	$Global:PatchStringClaBrowLocatorTypeF 			= "#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%LocatorType,DEFAULT('Filtered')"
}

Function	Set-PatchString-ClaBrow-SortLocatorType
{
	$Global:PatchStringClaBrowSortLocatorTypeN 			= "#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%SortLocatorType,DEFAULT('None')"
	$Global:PatchStringClaBrowSortLocatorTypeS 			= "#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%SortLocatorType,DEFAULT('Step')"
	$Global:PatchStringClaBrowSortLocatorTypeE 			= "#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%SortLocatorType,DEFAULT('Entry')"
	$Global:PatchStringClaBrowSortLocatorTypeI 			= "#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%SortLocatorType,DEFAULT('Incremental')"
	$Global:PatchStringClaBrowSortLocatorTypeF 			= "#PROMPT('&Locator:',DROP('None|Step|Entry|Incremental|Filtered')),%SortLocatorType,DEFAULT('Filtered')"
}

Function	Set-PatchString-ClaBrow-BrowseLocatorType
{
	$Global:PatchStringClaBrowBrowseLocatorTypeN 		= "#SET(%BrowseLocatorType,'None')"
	$Global:PatchStringClaBrowBrowseLocatorTypeS 		= "#SET(%BrowseLocatorType,'Step')"
	$Global:PatchStringClaBrowBrowseLocatorTypeE 		= "#SET(%BrowseLocatorType,'Entry')"
	$Global:PatchStringClaBrowBrowseLocatorTypeI 		= "#SET(%BrowseLocatorType,'Incremental')"
	$Global:PatchStringClaBrowBrowseLocatorTypeF 		= "#SET(%BrowseLocatorType,'Filtered')"
}

Function	Set-PatchString-ClaWCnt-QBBLocatorType
{
	$Global:PatchStringClaWCntQBBLocatorTypeN 			= "%%LocatorType DEFAULT  ('None')"
	$Global:PatchStringClaWCntQBBLocatorTypeS 			= "%%LocatorType DEFAULT  ('Step')"
	$Global:PatchStringClaWCntQBBLocatorTypeE 			= "%%LocatorType DEFAULT  ('Entry')"
	$Global:PatchStringClaWCntQBBLocatorTypeI 			= "%%LocatorType DEFAULT  ('Incremental')"
	$Global:PatchStringClaWCntQBBLocatorTypeF 			= "%%LocatorType DEFAULT  ('Filtered')"
}

Function	Set-PatchString-ClaWCnt-QBBLocator
{
	$Global:PatchStringClaWCntQBBLocatorN 			= "WHEN  (%ValueConstruct) ('None')"
	$Global:PatchStringClaWCntQBBLocatorS 			= "WHEN  (%ValueConstruct) ('Step')"
	$Global:PatchStringClaWCntQBBLocatorE 			= "WHEN  (%ValueConstruct) ('Entry')"
	$Global:PatchStringClaWCntQBBLocatorI 			= "WHEN  (%ValueConstruct) ('Incremental')"
	$Global:PatchStringClaWCntQBBLocatorF 			= "WHEN  (%ValueConstruct) ('Filtered')"
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
	# If a lowercase value is input, the lowercase value and not uppercase value is passed to the function Patch-Template as a parameter!
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
	$Global:TemplateFilePathClaBrowse	= $TemplateFolder +'\'+ $TemplateClaBrowse		# Clarion Browse Template File, Variable Scope: Global
	$Global:TemplateFilePathClaWCntrl	= $TemplateFolder +'\'+ $TemplateClaWCntrl		# Clarion Wizard Control Template File, Variable Scope: Global
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
		$PatchStringIncremental,			#	    |
		$PatchStringFiltered,				#      \/
		[Int32[]]$RegExInstances = @(1)		# Parameter inputs
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
	
	# Write-Host "RegExInstances: $RegExInstances"		# Used for Debugging
	
	if ($RegExInstances.Length -eq 0) 
	{
		Write-Output "RegExInstances Array is empty. Setting to 1"
		[Int32[]]$RegExInstances = @(1)		# This ensures the RegExInstances is set to at least one and handles the param having no default value
	}
	
	$FileContentRegExMatchInstance = 0		# Arrays start at zero, so incremented at the end of the loop
	
	$FileContent 	= Get-Content $TemplateFilePath		# Load File
	$FileContentNew = foreach ($line in $FileContent) 	
	{
		$FileContentLineCount++
		if ($line -match $RegEx) 
		{
			Write-Host "RegEx match on Line: $FileContentLineCount"
			

			# Write-Host "FileContentRegExMatchInstance = $FileContentRegExMatchInstance " # Used for Debugging
			# Write-Host "RegExInstances[FileContentRegExMatchInstance] = $RegExInstances[ $FileContentRegExMatchInstance ] $($RegExInstances[ $FileContentRegExMatchInstance ])" # Used for Debugging
			
			if ( $RegExInstances[ $FileContentRegExMatchInstance ] -eq 1 )
			{	
				Write-Host "Replacing..."
				$FileContentTrimmedLine 		= $line.TrimStart()
				$FileContentIndent 				= $line.Length - $FileContentTrimmedLine.Length
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
				Write-Host "Skipping..."
				$line
			}
			
			Write-Host ""
			$FileContentRegExMatchInstance++
			
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
	Write-Host "Completed Patching: $TemplateFilePathClaBrowse"
	Write-Host "Completed Patching: $TemplateFilePathClaWCntrl"
	Write-Host ""
}

# Lets call the above functions. Functions need to be declared before they can be called in PowerShell
Display-Notice

Set-TemplateFileNames
Get-TemplateFolder
Set-TemplateFilePaths
Get-InputChoice

Set-RegExStrings

Set-PatchString-ClaBrow-LocatorType
Set-PatchString-ClaBrow-SortLocatorType
Set-PatchString-ClaBrow-BrowseLocatorType

Set-PatchString-ClaWCnt-QBBLocatorType
Set-PatchString-ClaWCnt-QBBLocator

Patch-Template 	$InputChoice $TemplateFilePathClaBrowse $RegExClaBrowLocatorType 		$PatchStringClaBrowLocatorTypeN 	$PatchStringClaBrowLocatorTypeS 	$PatchStringClaBrowLocatorTypeE 	$PatchStringClaBrowLocatorTypeI 	$PatchStringClaBrowLocatorTypeF   
Patch-Template 	$InputChoice $TemplateFilePathClaBrowse $RegExClaBrowSortLocatorType	$PatchStringClaBrowSortLocatorTypeN	$PatchStringClaBrowSortLocatorTypeS $PatchStringClaBrowSortLocatorTypeE $PatchStringClaBrowSortLocatorTypeI	$PatchStringClaBrowSortLocatorTypeF	   
Patch-Template 	$InputChoice $TemplateFilePathClaBrowse $RegExClaBrowBrowseLocatorType 	$PatchStringClaBrowBrowseLocatorTypeN	$PatchStringClaBrowBrowseLocatorTypeS 	$PatchStringClaBrowBrowseLocatorTypeE 	$PatchStringClaBrowBrowseLocatorTypeI 	$PatchStringClaBrowBrowseLocatorTypeF 0,1	

Patch-Template 	$InputChoice $TemplateFilePathClaWCntrl $RegExClaWCntQBBLocatorType 	$PatchStringClaWCntQBBLocatorTypeN	$PatchStringClaWCntQBBLocatorTypeS 	$PatchStringClaWCntQBBLocatorTypeE 	$PatchStringClaWCntQBBLocatorTypeI 	$PatchStringClaWCntQBBLocatorTypeF 

Patch-Template 	$InputChoice $TemplateFilePathClaWCntrl $RegExClaWCntQBBLocator 	$PatchStringClaWCntQBBLocatorN	$PatchStringClaWCntQBBLocatorS 	$PatchStringClaWCntQBBLocatorE 	$PatchStringClaWCntQBBLocatorI 	$PatchStringClaWCntQBBLocatorF 
													    
Display-Finish
