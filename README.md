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
2. The second is the url of the login page. Best to use the `{URL}` placeholder which will use the URL entered in the Add/Edit Entry dialog.
3. Next argument are actions to enter the username and password (again use placeholders) and submit the login form.
4. Final optional argument is to action to check if when the page is open then the user is already logged in.

##Actions

For the third and forth arguments then there are a comma separated list of actions.
Each action will a simple operation such aa population the login form details or submitting the login request.

```
"action,action,action"
```

Each action started with the selection of fields, the followed 

###Element Selection

There are two ways an element/field can be selected;
1. `id[idOfFieldName]` - Select by element ID, this will always just select one element.
2. `name[inputFieldName]` - Select by input field name, this could select multiple field, the action will be performed on all fields.

Once a field is selected then it can be assigned a value, either a fixed value or KeePass placeholder.
e.g. `id[h_username]={USERNAME}` will populate the username field with the ... err ... username.

###Element Operations

Next there can can be a series of operations that can be performed. Note that is is best to use use ID selection of a field as this will always return a single field,
- `.focus` - move the input focus to the current field.
- `.tab` - tabs to the next field.
- `.shiftTab` - tabs to the previous field.
- `.space` - spacebar keypress. Useful for selecting checkboxes.
- `.enter` - Enter keypress. Can be used to submit a form from a button.
- `.submit` - Performs a direct form submit.
- `.wait(x)` - add s delay of x milli seconds.

e.g. `id[h_password].focus.tab.enter` - move to the password field, then tabs onto the next field which is a button and then hits enter.

##TODOs

- Element ID and Name selectors - possible use JQuery style
- checkboxes - add command for force checked or unchecked

##Useful References

- http://keepass.info/help/base/autourl.html
- http://keepass.info/help/base/placeholders.html

