﻿class Audio
{
    [string] $Source
    [boolean] $Loop
    [boolean] $Silent

    Audio ([String] $Source)
    {
        if ($Source -in [AudioSource].GetEnumNames())
        {
            $SourceString = $Source.Substring(0,1).ToUpper() + $Source.Substring(1).ToLower()
            if ($Source -like 'Call*' -or $Source -like 'Alarm*')
            {
                $this.Source = "Looping.$SourceString"
                $this.Loop = $true
            }
            else
            {
                $this.Source = $SourceString
                $this.Loop = $false
            }
            $this.Silent = $false
        }
        else
        {
            throw "$Source is not a valid Audio Source, please see help."
        }
    }

    Audio ([Boolean] $Silent)
    {
        $this.Silent = $true
    }

    Audio ()
    {
        $this.Source = 'Default'
        $this.Loop = $false
        $this.Silent = $false
    }

    [string] GetXML ()
    {
        $AudioXML = '<audio '

        if ($this.Silent)
        {
            $AudioXML += 'silent="true" />'
        }
        else
        {
            $AudioXML += "src=`"ms-winsoundevent:Notification.$($this.Source)`" "

            if ($this.Loop)
            {
                $AudioXML += 'loop="true" />'
            }
            else
            {
                $AudioXML += '/>'
            }
        }

        return $AudioXML
    }
}

class Text
{
    # Look for api with 'BCP-47 language tags such as "en-US" or "fr-FR".'

    #[string] $Language
    [string] $Content
    [boolean] $Empty

    Text ([string] $Content)
    {
        $this.Content = $Content
    }

    Text ([boolean] $Empty)
    {
        if ($Empty)
        {
            $this.Empty = $Empty
        }
        else
        {
            throw 'Don''t set the empty property to false, instead provide content.'
        }
    }

    Text ()
    {
        $this.Empty = $true
    }

    [string] GetXML ()
    {
        $TextXML = '<text'

        if ($this.Empty)
        {
            $TextXML += ' />'
        }
        else
        {
            $TextXML += ">$($this.Content)</text>"
        }

        return $TextXML
    }
}

class Image
{
    [string] $Source
    [ImagePlacement] $Placement
    [string] $Alt
    [ImageCrop] $Crop

    Image ([String] $Source)
    {
        $this.Source = $Source
    }

    Image ([String] $Source, [string] $Alt)
    {
        $this.Source = $Source
        $this.Alt = $Alt
    }

    Image ([String] $Source, [ImagePlacement] $Placement)
    {
        $this.Source = $Source
        $this.Placement = $Placement
    }

    Image ([String] $Source, [ImagePlacement] $Placement, [ImageCrop] $Crop)
    {
        $this.Source = $Source
        $this.Placement = $Placement
        $this.Crop = $crop
    }

    Image ([String] $Source, [string] $Alt, [ImagePlacement] $Placement)
    {
        $this.Source = $Source
        $this.Alt = $Alt
        $this.Placement = $Placement
    }

    Image ([String] $Source, [string] $Alt, [ImagePlacement] $Placement, [ImageCrop] $Crop)
    {
        $this.Source = $Source
        $this.Alt = $Alt
        $this.Placement = $Placement
        $this.Crop = $crop
    }

    [string] GetXML ()
    {
        $ImageXML = "<image src=`"$($this.Source)`" "

        if ($this.Alt)
        {
            $ImageXML += "alt=`"$($this.Alt)`" "
        }
        
        $ImageXML += "placement=`"$($this.Placement)`" hint-crop=`"$($this.crop)`" />"

        return $ImageXML
    }
}

class Binding
{
    [string] $Template = 'ToastGeneric'
    #[string] $Language
    [object[]] $Element = @()

    Binding () {}

    [void] AddElement ([Text] $Element)
    {
        $this.Element += $Element
    }

    [void] AddElement ([Image] $Element)
    {
        $this.Element += $Element
    }
    
    [string] GetXML ()
    {
        $BindingXML = [System.Text.StringBuilder]::new()
        $WriterSettings = [System.Xml.XmlWriterSettings]::new()
        $WriterSettings.ConformanceLevel = 'Fragment'
        $WriterSettings.Encoding = [System.Text.Encoding]::UTF8
        $WriterSettings.OmitXmlDeclaration = $true
        $XmlWriter = [System.Xml.XmlWriter]::Create($BindingXML, $WriterSettings)

        $XmlWriter.WriteStartElement('binding')
        $XmlWriter.WriteAttributeString('template', 'ToastGeneric')
        
        foreach ($Element in $this.Element)
        {
            $XmlReader = [System.Xml.XmlReader]::Create([System.IO.StringReader]::new($Element.GetXML()))
            $XmlWriter.WriteNode($XmlReader, $true)
            $XmlReader.Close()
        }

        $XmlWriter.WriteEndElement() # binding
        
        $XmlWriter.Finalize
        $XmlWriter.Flush
        $XmlWriter.Close()

        return $BindingXML.ToString()
    }
}

class Visual
{
    #[string] $Language
    [Binding] $Binding

    Visual ([Binding] $Binding)
    {
        $this.Binding = $Binding
    }
    
    [string] GetXML ()
    {
        $VisualXML = [System.Text.StringBuilder]::new()
        $WriterSettings = [System.Xml.XmlWriterSettings]::new()
        $WriterSettings.ConformanceLevel = 'Fragment'
        $WriterSettings.Encoding = [System.Text.Encoding]::UTF8
        $WriterSettings.OmitXmlDeclaration = $true
        $XmlWriter = [System.Xml.XmlWriter]::Create($VisualXML, $WriterSettings)

        $XmlWriter.WriteStartElement('visual')
        
        $XmlReader = [System.Xml.XmlReader]::Create([System.IO.StringReader]::new($this.Binding.GetXML()))
        $XmlWriter.WriteNode($XmlReader, $true)
        $XmlReader.Close()

        $XmlWriter.WriteEndElement() # binding
        
        $XmlWriter.Finalize
        $XmlWriter.Flush
        $XmlWriter.Close()

        return $VisualXML.ToString()
    }
}

class Toast
{
    #[string] $Language
    [Visual] $Visual
    [Scenario] $Scenario
    [Audio] $Audio
    [Duration] $Duration

    Toast ([Visual] $Visual)
    {
        $this.Visual = $Visual
    }

    Toast ([Visual] $Visual, [Audio] $Audio)
    {
        $this.Visual = $Visual
        $this.Audio = $Audio
    }
    
    Toast ([Scenario] $Scenario, [Visual] $Visual)
    {
        $this.Visual = $Visual
        $this.Scenario = $Scenario
    }

    Toast ([Scenario] $Scenario, [Visual] $Visual, [Audio] $Audio)
    {
        $this.Visual = $Visual
        $this.Scenario = $Scenario
        $this.Audio = $Audio
    }

    Toast ([Scenario] $Scenario, [Visual] $Visual, [Audio] $Audio, [Duration] $Duration)
    {
        $this.Visual = $Visual
        $this.Scenario = $Scenario
        $this.Audio = $Audio
        $this.Duration = $Duration
    }
    
    [string] GetXML ()
    {
        $ToastXML = [System.Text.StringBuilder]::new()
        $WriterSettings = [System.Xml.XmlWriterSettings]::new()
        $WriterSettings.ConformanceLevel = 'Fragment'
        $WriterSettings.Encoding = [System.Text.Encoding]::UTF8
        $WriterSettings.OmitXmlDeclaration = $true
        $XmlWriter = [System.Xml.XmlWriter]::Create($ToastXML, $WriterSettings)

        $XmlWriter.WriteStartElement('toast')
        $XmlWriter.WriteAttributeString('scenario', $this.Scenario)
        $XmlWriter.WriteAttributeString('duration', $this.Scenario)
        
        $XmlReader = [System.Xml.XmlReader]::Create([System.IO.StringReader]::new($this.Visual.GetXML()))
        $XmlWriter.WriteNode($XmlReader, $true)
        $XmlReader.Close()

        if ($this.Audio)
        {
            $XmlReader = [System.Xml.XmlReader]::Create([System.IO.StringReader]::new($this.Audio.GetXML()))
            $XmlWriter.WriteNode($XmlReader, $true)
            $XmlReader.Close()
        }

        $XmlWriter.WriteEndElement() # binding
        
        $XmlWriter.Finalize
        $XmlWriter.Flush
        $XmlWriter.Close()

        return $ToastXML.ToString()
    }
}

enum AudioSource
{
    Default
    IM
    Mail
    Reminder
    SMS
    Alarm
    Alarm2
    Alarm3
    Alarm4
    Alarm5
    Alarm6
    Alarm7
    Alarm8
    Alarm9
    Alarm10
    Call
    Call2
    Call3
    Call4
    Call5
    Call6
    Call7
    Call8
    Call9
    Call10
}

enum ImagePlacement
{
    inline
    appLogoOverride
}

enum ImageCrop
{
    none
    circle
}

enum Scenario
{
    default
    alarm
    reminder
    incomngCall
}

enum Duration
{
    short
    long
}

$text1 = [Text]::new('This is a test')
$text2 = [Text]::new('This more testing')
$image1 = [Image]::new('C:\GitHub\BurntToast\BurntToast.png', [ImagePlacement]::appLogoOverride, [ImageCrop]::circle)
$binding1 = [Binding]::new()
$binding1.AddElement($text1)
$binding1.AddElement($text2)
$binding1.AddElement($image1)
$visual1 = [Visual]::new($binding1)
$audio1 = [Audio]::new('Alarm3')
$toast1 = [Toast]::new([Scenario]::alarm, $visual1, $audio1)

$AppId = ( ((Get-StartApps -Name '*PowerShell*') | Select-Object -First 1).AppId )

$null = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
[xml]$ToastTemplate = $toast1.GetXML()

$ToastXml = [Windows.Data.Xml.Dom.XmlDocument]::new()
$ToastXml.LoadXml($ToastTemplate.OuterXml)

[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($AppId).Show($ToastXml)
