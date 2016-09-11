#autoLogin KeePass Plugin

Auto Login plugin for KeyPass, it will open website in IE (sadly IE only:unamused:) then enter and submit login credentials.

##Install

Download files login.cmd and autoLogin.vbs place in directory named autoLogin under the Keepass plugins directory (`C:\Program Files (x86)\KeePass Password Safe 2\plugins\autoLogin`)

## Configure 

To configure then goto the properties tab of the Add/Edit Entry dialog.

![Edit Entery Properties](https://github.com/whamBamDev/autoLogin/raw/master/docs/images/KeePass-EditEntry-properties.png)

Then a command needs to be added in the 'Override URL', it will something like;

```
cmd://"{APPDIR}\plugins\autoLogin\login.cmd" "{URL}" "id[h_username]={USERNAME},id[h_password]={PASSWORD},id[h_password].focus.tab.enter" "id[logged-in]"
```

The command is made of 4 arguments, the first 3 are mandatory, the 4th is optional.

1. The first is command that runs the script, always the same.
2. The the is the url of the login page. Best to use the `{URL}` placeholder which will use the URL entered in the Add/Edit Entry dialog.
3. Next actions to enter the username and password (again use placeholders) and submit the login form.
4. Final optional argument is to action to check if when the page is open then the user is already logged in.

##Actions

action,action,action 

id[idOfFieldName]
name[inputFieldName] 

    If keyPress = "enter" Then
    ElseIf keyPress = "tab" Then
    ElseIf keyPress = "shiftTab" Then
    ElseIf keyPress = "space" Then
            If action = "focus" Then
                WScript.Sleep 100
                field.focus
            ElseIf action = "submit" Then
            ElseIf InStr( action, "wait(x)") = 1 Then


##Useful References

- http://keepass.info/help/base/autourl.html
- http://keepass.info/help/base/placeholders.html



