$text1 = [Text]::new('This is a test')
$text2 = [Text]::new('This more testing')
$image1 = [Image]::new('C:\GitHub\BurntToast\BurntToast.png', [ImagePlacement]::appLogoOverride, [ImageCrop]::circle)
$binding1 = [Binding]::new()
$binding1.AddElement($text1)
$binding1.AddElement($text2)
$binding1.AddElement($image1)
$visual1 = [Visual]::new($binding1)

#$audio1 = [Audio]::new([AudioSource]::SMS)
$audio1 = New-CrumpetAudioElement -Source Call7

#$action1 = [Action]::new('Open LCTV','https://www.livecoding.tv/livestreams/',[ActivationType]::protocol)
#$BurntToastPath = Join-Path -Path (Split-Path -Path (Get-Module BurntToast -ListAvailable).Path) -ChildPath 'BurntToast.png'
#$action2 = [Action]::new('Burn Toast',$BurntToastPath,[ActivationType]::protocol)
#$actions1 = [Actions]::new()
#$actions1.AddElement($action1)
#$actions1.AddElement($action2)

$actions1 = [Actions]::new('SnoozeAndDismiss')
$toast1 = [Toast]::new([Scenario]::reminder, $visual1, $audio1, $actions1)

$AppId = ( ((Get-StartApps -Name '*PowerShell*') | Where-Object -FilterScript {$_.AppId -like '*.exe'} | Select-Object -First 1).AppId  )

$null = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
$null = [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]

[xml]$ToastTemplate = $toast1.GetXML()

$ToastXml = [Windows.Data.Xml.Dom.XmlDocument]::new()
$ToastXml.LoadXml($ToastTemplate.OuterXml)

$Toast = [Windows.UI.Notifications.ToastNotification]::new($ToastXml)

# $Toast.SuppressPopup = $true

[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($AppId).Show($Toast)
