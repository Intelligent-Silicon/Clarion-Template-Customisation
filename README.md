# Clarion-Template-Customisation

## Customisations that can be performed on the default shipping templates.

A Powershell script exists to make the relevant changes and revert (undo) those changes if you dont like them.

Screenshot shows you what to expect.
 
 
### Window Resizing Template


[Modify Window Resize template](Resize%20Template.md)


### Remove blank PRE() from Dct & AppGen generated Global, Module & Procedure Group's

This demonstrates how you can change the default IDE generated data statement, for global, module and procedure Dct & AppGen data by removing the default PRE() from GROUP structures. Taking this further, the #Group(%RemoveBlankPrefix, \*%pVarDeclaration) can be the start of remapping Clarion Data Types to other date types found in other programming languages, or to perform changes which can interact with new Drivers and any new data types such as Capesofts Clarion Object Based Drivers [1] . It wouldnt take much to even search through field/variable names looking for instances of a search term such as UUID and then remap the data type to a suitable UUID/GUID specific data type automatically.
 

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

At the end of the file ABProgram.TPW add...

This #Group is accessible to all the template files at Global, Module and Procedure level so only needs to be declared once before it performs its programmed changes.
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

ABMODULE.TPW

```
#MODULE(GENERATED,'Generated Source Module'),HLP('~TPLModuleGenerated.htm') #! MODULE header
```

Change to
```
#MODULE(GENERATED,'Generated Source Module'),HLP('~TPLModuleGenerated.htm') #! MODULE header
#Declare(%ModuleDataStatementMod,String)
```

```
#FOR(%ModuleData)
%ModuleData   %ModuleDataStatement
#ENDFOR
```

Change to
```
#FOR(%ModuleData)
#Set(%ModuleDataStatementMod,%ModuleDataStatement)
#Call(%RemoveBlankPrefix,%ModuleDataStatementMod)
%ModuleData   %ModuleDataStatementMod
#ENDFOR
```


ABProcs.tpw

```
#GROUP(%GenerateLocalData)
```

Change to
```
#GROUP(%GenerateLocalData)
#Declare(%LocalDataStatementMod,String)
```
```
#FOR(%LocalData)
#IF(LEFT(%LocalDataStatement,6)='&CLASS')
   #SET(%ValueConstruct,EXTRACT(%LocalDataStatement,'&CLASS',1))
   #IF(NOT %ValueConstruct)
```

Change to
```
#FOR(%LocalData)
#Set(%LocalDataStatementMod,%LocalDataStatement)
#Call(%RemoveBlankPrefix,%LocalDataStatementMod)
#IF(LEFT(%LocalDataStatementMod,6)='&CLASS')
   #SET(%ValueConstruct,EXTRACT(%LocalDataStatementMod,'&CLASS',1))
   #IF(NOT %ValueConstruct)
```

```
#IF(LEFT(%LocalDataStatement,5)='CLASS')
    #SET(%ValueConstruct,EXTRACT(%LocalDataStatement,'CLASS',1))
    #IF(%ValueConstruct)
```

Change to
```
#IF(LEFT(%LocalDataStatement,5)='CLASS')
    #SET(%ValueConstruct,EXTRACT(%LocalDataStatementMod,'CLASS',1))
    #IF(%ValueConstruct)
```

```
#ENDIF
%[20]LocalData %LocalDataStatement #<! %LocalDataDescription
#ENDIF
#ENDFOR
```

Change to
```
#ENDIF
%[20]LocalData %LocalDataStatementMod #<! %LocalDataDescription
#ENDIF
#ENDFOR
```

[1] https://capesoft.com/docs/Driverkit/ClarionObjectBasedDrivers.htm