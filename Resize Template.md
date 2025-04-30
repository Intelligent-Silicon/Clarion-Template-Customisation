# Window Resizing Template

### Overview 

A Powershell Script to change the default resizing options with an option to revert (undo) the changes.

### Instructions

Download script to required folder, open Powershell with Administrator rights, navigate to the required folder ```cd "c:\Long Folder Name with spaces"```, type ```.\resize.ps1```

Check the ```.\resize.ps1``` script for a relevant explanation on Powershell Execution Policy and Scope which can affect running a script.

To prevent changing elements of the template, comment out with the hash (#) symbol the command starting with $content (see below) that corresponds to the relevant $OriginalStringX and $PatchStringX.

```
$content = [System.IO.File]::ReadAllText($ClarionTemplateFilePathX).Replace($OriginalStringX,$PatchStringX)
[System.IO.File]::WriteAllText($ClarionTemplateFilePathX, $content)
```

[Resize.ps1](/resize.ps1)

![Screenshot](https://github.com/Intelligent-Silicon/Clarion-Template-Customisation/tree/main/ResizeTemplates.png)



### Patch Changes

Set controls without an override to Centred.

Set minimum window size to True.

Set minimum window width to 420 pixels.

Set minimum window height to 270 pixels.



Set control override for Horizontal Resize to Lock Width.

Set control override for Vertical Resize to Lock Height.

Set control override for Horizontal Position to Fix Left.

Set control override for Vertical Position to Fix Top.


### Revert Changes ( back to Default Options)

Set controls without an override to Spread.

Set minimum window size to False.

Set minimum window width to unspecified.

Set minimum window height to unspecified.



Set control override for Horizontal Resize to Resize.

Set control override for Vertical Resize to Resize.

Set control override for Horizontal Position to Move.

Set control override for Vertical Position to Move.


### Patch Changes...

### Set controls without an override to Centred.

C:\Clarion11\template\win\EXTENS.TPW
```
#PROMPT('Resize Strategy: ',DROP('Use Anchor|Centered|Resize|Spread|Don''t alter controls')),%AppStrategy,DEFAULT('Spread')
```

Change to 
```
#PROMPT('Resize Strategy: ',DROP('Use Anchor|Centered|Resize|Spread|Don''t alter controls')),%AppStrategy,DEFAULT('Centred')
```


C:\Clarion11\template\win\ABWINDOW.TPW
 
```
#PROMPT('Resize Strategy: ',DROP('Use Anchor|Centered|Resize|Spread|Surface|Don''t alter controls')),%AppStrategy,DEFAULT('Spread')
```

Change to
```
#PROMPT('Resize Strategy: ',DROP('Use Anchor|Centered|Resize|Spread|Surface|Don''t alter controls')),%AppStrategy,DEFAULT('Centered')
```

### Set minimum window size to True.

```
#PROMPT('Restrict Minimum Window Size',CHECK),%RestrictMinSize,DEFAULT(%False),AT(5)
```

Change to
```
#PROMPT('Restrict Minimum Window Size',CHECK),%RestrictMinSize,DEFAULT(%True),AT(5)
```

### Set minimum window width to 420 pixels.

```
#PROMPT('Minimum Width:',@n5),%WindowMinWidth
```

Change to 
```
#PROMPT('Minimum Width:',@n5),%WindowMinWidth,Default(420)
```

### Set minimum window height to 270 pixels.

```
#PROMPT('Minimum Height:',@n5),%WindowMinHeight
```

Change to
```
#PROMPT('Minimum Height:',@n5),%WindowMinHeight,Default(270)
```

### Individual Control Override Section.

### Set control override for Horizontal Resize to Lock Width.

```
#PROMPT('&Horizontal Resize Strategy',DROP('Resize|Lock Width|Constant Right Border|Constant Right Center Border')),%HorizResize,DEFAULT('Resize'),AT(10,15,170),PROMPTAT(10,2,170)
```

Change to
```
#PROMPT('&Horizontal Resize Strategy',DROP('Resize|Lock Width|Constant Right Border|Constant Right Center Border')),%HorizResize,DEFAULT('Lock Width'),AT(10,15,170),PROMPTAT(10,2,170)
```

### Set control override for Vertical Resize to Lock Height.

```
#PROMPT('&Vertical Resize Strategy',DROP('Resize|Lock Height|Constant Bottom Border|Constant Bottom Center Border')),%VertResize,DEFAULT('Resize'),AT(10,15,170),PROMPTAT(10,2,170)
```

Change to
```
#PROMPT('&Vertical Resize Strategy',DROP('Resize|Lock Height|Constant Bottom Border|Constant Bottom Center Border')),%VertResize,DEFAULT('Lock Height'),AT(10,15,170),PROMPTAT(10,2,170)
```

### Set control override for Horizontal Position to Fix Left.

```
#PROMPT('Horizontal &Positional Strategy',DROP('Move|Lock Position|Fix Right|Fix Left|Fix Center|Fix Nearest|Fix To Center')),%HorizPositional,DEFAULT('Move'),AT(10,15,170),PROMPTAT(10,2,170)
```

Change to
```
#PROMPT('Horizontal &Positional Strategy',DROP('Move|Lock Position|Fix Right|Fix Left|Fix Center|Fix Nearest|Fix To Center')),%HorizPositional,DEFAULT('Fix Left'),AT(10,15,170),PROMPTAT(10,2,170)
```

### Set control override for Vertical Position to Fix Top.

```
#PROMPT('Vertical P&ositional Strategy',DROP('Move|Lock Position|Fix Bottom|Fix Top|Fix Center|Fix Nearest|Fix To Center')),%VertPositional,DEFAULT('Move'),AT(10,15,170),PROMPTAT(10,2,170)
```

Change to
```
#PROMPT('Vertical P&ositional Strategy',DROP('Move|Lock Position|Fix Bottom|Fix Top|Fix Center|Fix Nearest|Fix To Center')),%VertPositional,DEFAULT('Fix Top'),AT(10,15,170),PROMPTAT(10,2,170)
```
