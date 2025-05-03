# Group Prefix Template Mod

### Overview 

A Powershell script to modify the templates to set the default browse locator with an option to revert (undo) the changes.


### Instructions

Download script to required folder, open Powershell with Administrator rights, navigate to the required folder ```cd "c:\Long Folder Name with spaces"```, type ```.\BrowseLocator.ps1```

Check the ```.\BrowseLocator.ps1``` script for a relevant explanation on Powershell Execution Policy and Scope which can affect running a script.

To prevent changing elements of the template, comment out each line with the hash (#) symbol or encapsulate sections of code with the block comment (<#) before
```$contentX = Get-Content $ClarionTemplateFilePathX```
and (#>) after 
```$newContentX | Set-Content $ClarionTemplateFilePathX```


[BrowseLocator.ps1](/BrowseLocator.ps1)

![Screenshot](https://github.com/Intelligent-Silicon/Clarion-Template-Customisation/tree/main/BrowseLocator.png)


