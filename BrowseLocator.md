# Browse Locator Template Mod

### Overview 

A Powershell script to modify the templates to set the default ABC and Clarion (CW) browse locator with an option to revert (undo) the changes.


### Instructions

Download script to the required folder, open Powershell with Administrator rights, navigate to the required folder ```cd "c:\Long Folder Name with spaces"```, type ```.\ABCBrwLocate.ps1``` or ```.\ClaBrwLocate.ps1``` .

Check the ```.\ABCBrwLocate.ps1``` or ```.\ClaBrwLocate.ps1``` script for a relevant explanation on Powershell Execution Policy and Scope which can affect running a script.

To prevent changing elements of the template, comment out each line with the hash (#) symbol or encapsulate sections of code with the block comment (<#) before and (#>) after.

The powershell scripts demonstrate the use of variable/object scopes, datatype specification, parameter passing with default parameter values and the use of Regular Expressions.

Modify ABC template 

[ABCBrwLocate.ps1](/ABCBrwLocate.ps1)

![Screenshot](https://github.com/Intelligent-Silicon/Clarion-Template-Customisation/tree/main/ABCBrwLocate.png)


Modify Clarion template

[ClaBrwLocate.ps1](/ClaBrwLocate.ps1)

![Screenshot](https://github.com/Intelligent-Silicon/Clarion-Template-Customisation/tree/main/ClaBrwLocate.png)



