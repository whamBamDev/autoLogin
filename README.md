#autoLogin KeePass Plugin

Auto Login plugin for KeyPass, it will open website in IE (sadly IE only:unamused:) then enter and submit login credentials.

##Install

Download files login.cmd and autoLogin.vbs place in directory named autoLogin under the Keepass plugins directory (`C:\Program Files (x86)\KeePass Password Safe 2\plugins\autoLogin`)

## Configure 



![Edit Entery Properties](https://github.com/whamBamDev/autoLogin/raw/master/docs/images/KeePass-EditEntry-properties.png)

```
cmd://"{APPDIR}\plugins\autoLogin\login.cmd" "{URL}" "id[h_username]={USERNAME},id[h_password]={PASSWORD},id[h_password].focus.tab.enter" "id[logged-in]"
```

http://keepass.info/help/base/autourl.html

http://keepass.info/help/base/placeholders.html



