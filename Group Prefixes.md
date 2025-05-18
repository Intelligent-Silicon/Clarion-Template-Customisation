# Group Prefix Template Mod

### Overview 

A Powershell script to modify the templates to remove the blank group prefixes from dictionary and AppGen group's with an option to revert (undo) the changes.
This demonstrates how you can change the default IDE generated data statement, for global, module and procedure Dct & AppGen data by removing the default PRE() from GROUP structures. If you were to write some templates to generate code in other programming languages, this is one technique that shows how you would change the default Clarion data types into another languages data type, or to force a data type to behave differently for 64bit or unicode data types.

### Instructions

Download script to required folder, open Powershell with Administrator rights, navigate to the required folder ```cd "c:\Long Folder Name with spaces"```, type ```.\GroupPrefix.ps1```

Check the ```.\GroupPrefix.ps1``` script for a relevant explanation on Powershell Execution Policy and Scope which can affect running a script.

To prevent changing elements of the template, comment out with the hash (#) symbol the two command lines (see below) that corresponds to the relevant $OriginalStringX and $PatchStringX.

```
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePathX).Replace($OriginalStringX,$PatchStringX)
[System.IO.File]::WriteAllText($ClarionTemplateFilePathX, $content)
```

[GroupPrefix.ps1](/GroupPrefix.ps1)

![Screenshot](https://github.com/Intelligent-Silicon/Clarion-Template-Customisation/tree/main/GroupPrefix.png)

See the Powershell script to see the lines searched for and replaced in the template files: ABProgrm.TPW, ABMODULE.TPW, ABProcs.tpw

