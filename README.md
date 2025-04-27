# Clarion-Template-Customisation

Customisations to perform on the default shipping templates.
 
 
### Window Resizing Template
Resize Strategy = Spread ( Default )

Resize Strategy = Centred

Override Control Strategies

Horizontal Resize Strategy = Resize ( Default )

Vertical Resize Strategy = Resize ( Default )

Horizontal Positional Strategy = Move ( Default )

Vertical Positional Strategy = Move ( Default )


This configuration requires the least number of HVHV changes to individual controls using the Clarion Resizing Template. Other 3rd party resizing templates exist, or you can write your own.
 
Horizontal Resize Strategy = Lock Width

Vertical Resize Strategy = Lock Height

Horizontal Positional Strategy = Fix Left (or Right if using Arabic Right To Left languages)

Vertical Positional Strategy = Fix Top


Notepad++

Search using Find in Files
 
Find What: Centred
 
Filters: `*.*`

Directory: C:\Clarion11\template\win


C:\Clarion11\template\win\ABWINDOW.TPW
 
```
#EXTENSION (WindowResize, 'Allows controls to be resized with window'), PROCEDURE,HLP('~TPLExtensionWindowResize.htm')
#PROMPT('Resize Strategy: ',DROP('Use Anchor|Centered|Resize|Spread|Surface|Don''t alter controls')),%AppStrategy,DEFAULT('Spread')
```

Change to
```
#EXTENSION (WindowResize, 'Allows controls to be resized with window'), PROCEDURE,HLP('~TPLExtensionWindowResize.htm')
#PROMPT('Resize Strategy: ',DROP('Use Anchor|Centered|Resize|Spread|Surface|Don''t alter controls')),%AppStrategy,DEFAULT('Centered')
```

C:\Clarion11\template\win\EXTENS.TPW
```
#EXTENSION (WindowResize, 'Allows controls to be resized with window'), PROCEDURE,HLP('~TPLExtensionWindowResize.htm')
#PROMPT('Resize Strategy: ',DROP('Use Anchor|Centered|Resize|Spread|Don''t alter controls')),%AppStrategy,DEFAULT('Spread')
```

Change to 
```
#EXTENSION (WindowResize, 'Allows controls to be resized with window'), PROCEDURE,HLP('~TPLExtensionWindowResize.htm')
#PROMPT('Resize Strategy: ',DROP('Use Anchor|Centered|Resize|Spread|Don''t alter controls')),%AppStrategy,DEFAULT('Centred')
```

Find What: Lock Width
 
Filters: `*.*`

Directory: C:\Clarion11\template\win

C:\Clarion11\template\win\ABWINDOW.TPW
```
#GROUP(%ResizeOptions)
#PROMPT('&Horizontal Resize Strategy',DROP('Resize|Lock Width|Constant Right Border|Constant Right Center Border')),%HorizResize,DEFAULT('Resize'),AT(10,15,170),PROMPTAT(10,2,170)
```

Change to
```
#GROUP(%ResizeOptions)
#PROMPT('&Horizontal Resize Strategy',DROP('Resize|Lock Width|Constant Right Border|Constant Right Center Border')),%HorizResize,DEFAULT('Lock Width'),AT(10,15,170),PROMPTAT(10,2,170)
```

```
#PROMPT('&Vertical Resize Strategy',DROP('Resize|Lock Height|Constant Bottom Border|Constant Bottom Center Border')),%VertResize,DEFAULT('Resize'),AT(10,15,170),PROMPTAT(10,2,170)
```

Change to
```
#PROMPT('&Vertical Resize Strategy',DROP('Resize|Lock Height|Constant Bottom Border|Constant Bottom Center Border')),%VertResize,DEFAULT('Lock Height'),AT(10,15,170),PROMPTAT(10,2,170)
```

```
#GROUP(%ResizeOptions)
#PROMPT('Horizontal &Positional Strategy',DROP('Move|Lock Position|Fix Right|Fix Left|Fix Center|Fix Nearest|Fix To Center')),%HorizPositional,DEFAULT('Move'),AT(10,15,170),PROMPTAT(10,2,170)
```

Change to
```
#PROMPT('Horizontal &Positional Strategy',DROP('Move|Lock Position|Fix Right|Fix Left|Fix Center|Fix Nearest|Fix To Center')),%HorizPositional,DEFAULT('Fix Left'),AT(10,15,170),PROMPTAT(10,2,170)
```

```
#GROUP(%ResizeOptions)
#PROMPT('Vertical P&ositional Strategy',DROP('Move|Lock Position|Fix Bottom|Fix Top|Fix Center|Fix Nearest|Fix To Center')),%VertPositional,DEFAULT('Move'),AT(10,15,170),PROMPTAT(10,2,170)
```

Change to
```
#PROMPT('Vertical P&ositional Strategy',DROP('Move|Lock Position|Fix Bottom|Fix Top|Fix Center|Fix Nearest|Fix To Center')),%VertPositional,DEFAULT('Fix Top'),AT(10,15,170),PROMPTAT(10,2,170)
```


### Remove blank PRE() from AppGen generated Global Data

ABProgram.TPW
```
#GROUP(%GenerateGlobalDataField,%pGlobalDataLocalExternal='EXTERNAL')
```

Change to
```
#GROUP(%GenerateGlobalDataField,%pGlobalDataLocalExternal='EXTERNAL')
#Declare(%GlobalDataStatementMod,String)
#Set(%GlobalDataStatementMod,%GlobalDataStatement)
#Call(%RemoveBlankPrefix,%GlobalDataStatementMod)
```

```
    #IF(%GlobalDataInDictionary AND %GlobalExternal AND %GlobalDataLevel = %BaseDataLevel AND %GlobalData ~= '')
%[20]GlobalData %GlobalDataStatement,EXTERNAL,DLL(_ABCDllMode_) !33
    #ELSE
        #IF(UPPER(%pGlobalDataLocalExternal)='EXTERNAL' AND %GlobalDataLevel = %BaseDataLevel AND %GlobalData ~= '')
%[20 + ((%GlobalDataLevel - %BaseDataLevel) * 2)]GlobalData %GlobalDataStatement,EXTERNAL
        #ELSE
%[20 + ((%GlobalDataLevel - %BaseDataLevel) * 2)]GlobalData %GlobalDataStatement
        #ENDIF
    #ENDIF
```

Change to
```
    #IF(%GlobalDataInDictionary AND %GlobalExternal AND %GlobalDataLevel = %BaseDataLevel AND %GlobalData ~= '')
%[20]GlobalData %GlobalDataStatementMod,EXTERNAL,DLL(_ABCDllMode_) !33
    #ELSE
        #IF(UPPER(%pGlobalDataLocalExternal)='EXTERNAL' AND %GlobalDataLevel = %BaseDataLevel AND %GlobalData ~= '')
%[20 + ((%GlobalDataLevel - %BaseDataLevel) * 2)]GlobalData %GlobalDataStatementMod,EXTERNAL
        #ELSE
%[20 + ((%GlobalDataLevel - %BaseDataLevel) * 2)]GlobalData %GlobalDataStatementMod
        #ENDIF
    #ENDIF
```

At the end of the file add...
```
#!
#Group(%RemoveBlankPrefix, *%pVarDeclaration)
#Declare( %PrefixPosStart, Long )
#Set( %PrefixPosStart, StrPos( Upper( %pVarDeclaration ), ',<32>*PRE(<32>*)' ) )
#IF( %PrefixPosStart )																	
	#Set( %pVarDeclaration, Sub( %pVarDeclaration, 1 , %PrefixPosStart-1 ) ) 
#ENDIF
#Return
```

