'
' List of fields to be populated or actions
Set objRE = New RegExp
Set WshShell = WScript.CreateObject("WScript.Shell")
Dim IE
Set IE = WScript.CreateObject("InternetExplorer.Application")
Dim returnCode

returnCode = 0
Call Main
Wscript.Quit returnCode


Function Main
    Wscript.Echo "parameters: " & WScript.Arguments.Count
    Set objArgs = WScript.Arguments
    If WScript.Arguments.Count < 2 or WScript.Arguments.Count > 3 Then
        Wscript.Echo "Error: 2 or 3 parameters are required URL, fields, [loginCheck]"
        Wscript.Quit 1
    End If
    
    siteUrl = objArgs.Item(0)
    allFields = objArgs.Item(1)

    'MsgBox( "URL: " & siteUrl & chr(13) & "allFields: " & allFields)
    
    IE.Visible = True
    IE.Navigate siteUrl
    Wait IE

    WshShell.AppActivate "IE"
    'MsgBox( "Opened: " & siteUrl & chr(13) & "allFields: " & allFields)
    
    If WScript.Arguments.Count = 3 Then
        checkLoggedInField = objArgs.Item(2)
        Wscript.Echo "Login check on field " & checkLoggedInField
        isAleadyLoggedIn = isLoggedIn( checkLoggedInField)
        If isAleadyLoggedIn Then
            Wscript.Echo "Skipped login attempt, you already are"
            Wscript.Quit 0
        End If
    End If

    fields = Split( allFields, ",")
    For Each field In fields
        ' stuff 
        Wscript.Echo "field: " & field
        processField( field)
    Next        
    
End Function

Sub Wait(IE)
  Do
    WScript.Sleep 250
  Loop While IE.ReadyState < 4 And IE.Busy
  WScript.Sleep 250
End Sub

Function processField( field)
    Wscript.Echo "processField: " & field
    With objRE
        .Pattern    = "^((id)|(name))\[([\w-]*)](.*)$"
        .IgnoreCase = false
        .Global     = true
    End With
    Set objMatch = objRE.Execute( field)
    WScript.Echo "objMatch " & objMatch.Count
    If objMatch.Count = 1 Then
        Set fieldContent = objMatch.Item(0).Submatches
        WScript.Echo "fieldtype " & fieldtype & ", fieldContent " & fieldContent.Count
        fieldtype = fieldContent(0)
        id = fieldContent(3)
        action = fieldContent(4)
        If fieldtype = "id" Then
            lookupId id, action
        ElseIf fieldtype = "name" Then
            lookupName id, action
        Else
            Wscript.Echo "Just id or name can be looked up"
        End If
    End If
End Function

Function isLoggedIn( field)
    dim loggedIn
    loggedIn = False
    Wscript.Echo "isLoggedIn: " & field
    With objRE
        .Pattern    = "^id\[([\w-]*)]$"
        .IgnoreCase = false
        .Global     = true
    End With
    Set objMatch = objRE.Execute( field)
    WScript.Echo "objMatch " & objMatch.Count
    If objMatch.Count = 1 Then
        Set fieldContent = objMatch.Item(0).Submatches
        WScript.Echo "fieldContent " & fieldContent.Count
        dim loggedInId
        loggedInId = fieldContent(0)
        On Error Resume Next
        Wscript.Echo "isLoggedIn id: " & loggedInId
        If Not IE.Document.getElementById( loggedInId) Is Nothing Then
            Wscript.Echo "is already logged in YEAH"
            loggedIn = True
        End If
        Wscript.Echo "Error = " & Err.Number
        If Err.Number <> 0 Then
            Wscript.Echo "Error: " & Err.Number
            Err.Clear
            loggedIn = False
        End If
    End If
    Wscript.Echo "isLoggedIn response: " & loggedIn
    isLoggedIn = loggedIn
End Function

Function lookupId( id, actionfield)
    Wscript.Echo "lookupId: " & id & ", actionfield " & actionfield
    Dim lookupField
    lookupField = IE.Document.getElementById( id)
    If lookupField <> "" Then
        Set lookupFieldObject = IE.Document.getElementById( id)
        Wscript.Echo "lookupField: " & lookupField
        performAction lookupFieldObject, actionfield
    Else
        displayWarning( "Failed to find a field with id: " & id )
    End If
End Function

Function lookupName( name, actionfield)
    Wscript.Echo "lookupName: " & name & ", actionfield " & actionfield
    Set nodeList = IE.Document.getElementsByName(name)
    For Each element In nodeList
        performAction element, actionfield
    Next        
End Function

Function keyPressAction( keyPress)
    Wscript.Echo "keyPressAction: " & keyPress
    Dim returnValue
    If keyPress = "enter" Then
        returnValue = True
        WshShell.SendKeys "{ENTER}"
    ElseIf keyPress = "tab" Then
        returnValue = True
        WshShell.SendKeys "{TAB}"
    ElseIf keyPress = "shiftTab" Then
        returnValue = True
        WshShell.SendKeys "+{TAB}"
    ElseIf keyPress = "space" Then
        returnValue = True
        WshShell.SendKeys " "
    Else
        returnValue = False
        displayWarning( "Unsupported key press type: " & keyPress)
    End If
    keyPressAction = returnValue
End Function

Function performAction( field, actionfield)
    Wscript.Echo "performAction: " & field & ", actionfield " & actionfield
    actionType = Left( actionField, 1)
    newFieldValue = Mid( actionField, 2)
    If actionType = "=" Then
        field.value = newFieldValue
    ElseIf actionType = "." Then
        actions = Split( newFieldValue, ".")
        Dim action
        For Each action In actions
            Wscript.Echo "action:" & action
            If action = "focus" Then
                WScript.Sleep 100
                field.focus
            ElseIf action = "submit" Then
                WScript.Sleep 100
                field.submit
            ElseIf InStr( action, "wait") = 1 Then
                Dim sleepTime
                sleepTime = Replace( action, "wait(", "")
                sleepTime = Replace( sleepTime, ")", "")
                sleepTime = CInt( sleepTime)
                WScript.Sleep sleepTime
            Else
                WScript.Sleep 100
                keyActionResponse = keyPressAction( action)
                If Not keyActionResponse Then
                    displayWarning( "Unsupported action: " & action)
                End If
            End If
        Next        
    Else
      displayWarning( "Unsupported action type: " & actionType)
    End If
End Function

Function displayWarning( message)
    MsgBox( message)
    returnCode = 1
End Function

