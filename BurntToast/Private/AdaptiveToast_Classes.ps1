﻿class Audio
{
    [AudioSource] $Source
    [boolean] $Loop
    [boolean] $Silent

    Audio ([AudioSource] $Source)
    {
        if ($Source -like 'Call*' -or $Source -like 'Alarm*')
        {
            $this.Loop = $true
        }

        $this.Silent = $false
    }

    Audio ([Boolean] $Silent)
    {
        $this.Silent = $true
    }

    Audio ()
    {
        $this.Source = [AudioSource]::Default
        $this.Loop = $false
        $this.Silent = $false
    }

    [xml] GetXML ()
    {
        $AudioXML = New-Object System.XML.XMLDocument
        $AudioElement = $AudioXML.CreateElement('audio')

        if ($this.Silent)
        {
            $AudioElement.SetAttribute('silent','true')
        }
        else
        {
            $src = 'ms-winsoundevent:Notification.'
            
            if ($this.Source -like 'Call*' -or $this.Source -like 'Alarm*')
            {
                $src += 'Looping.'
            }

            $src += $this.Source
            $AudioElement.SetAttribute('src',$src)

            if ($this.Loop)
            {
                $AudioElement.SetAttribute('loop','true')
            }
        }

        $AudioXML.AppendChild($AudioElement)
        return $AudioXML
    }
}

class Actions
{
    [string] $SystemCommand = 'SnoozeAndDismiss'
    [object[]] $Element = @()

    Actions () {}
    
    Actions ([string] $SystemCommand)
    {
        $this.SystemCommand = $SystemCommand
    }

    [void] AddElement ([Action] $Element)
    {
        $this.Element += $Element
    }

    [xml] GetXML ()
    {
        $ActionsXML = New-Object System.XML.XMLDocument
        $ActionsElement = $ActionsXML.CreateElement('actions')

        if ($this.Element.Count -eq 0)
        {
            $ActionsElement.SetAttribute('hint-systemCommands', $this.SystemCommand)
            Write-Warning -Message 'The snooze button does not currently work, I''m looking into it.'
        }
        else
        {
            foreach ($Element in $this.Element)
            {
                $ElementXML = $ActionsXML.ImportNode($Element.GetXML().DocumentElement, $true)
                $ActionsElement.AppendChild($ElementXML)
            }
        }

        $ActionsXML.AppendChild($ActionsElement)
        return $ActionsXML
    }
}

class Action
{
    [string] $Content
    [string] $Arguments
    [ActivationType] $ActivationType
    [System.IO.Path] $ImageUri
    [string] $InputId

    Action ([string] $Content, [string] $Arguments)
    {
        $this.Content = $Content
        $this.Arguments = $Arguments
    }

    Action ([string] $Content, [string] $Arguments, [ActivationType] $ActivationType)
    {
        $this.Content = $Content
        $this.Arguments = $Arguments
        $this.ActivationType = $ActivationType
    }

    Action ([string] $Content, [string] $Arguments, [ActivationType] $ActivationType, [System.IO.Path] $ImageUri)
    {
        $this.Content = $Content
        $this.Arguments = $Arguments
        $this.ActivationType = $ActivationType
        $this.ImageUri = $ImageUri
    }

    Action ([string] $Content, [string] $Arguments, [ActivationType] $ActivationType, [string] $InputId)
    {
        $this.Content = $Content
        $this.Arguments = $Arguments
        $this.ActivationType = $ActivationType
        $this.InputId = $InputId
    }

    Action ([string] $Content, [string] $Arguments, [System.IO.Path] $ImageUri)
    {
        $this.Content = $Content
        $this.Arguments = $Arguments
        $this.ImageUri = $ImageUri
    }

    Action ([string] $Content, [string] $Arguments, [string] $InputId)
    {
        $this.Content = $Content
        $this.Arguments = $Arguments
        $this.InputId = $InputId
    }

    Action ([string] $Content, [string] $Arguments, [System.IO.Path] $ImageUri, [string] $InputId)
    {
        $this.Content = $Content
        $this.Arguments = $Arguments
        $this.ImageUri = $ImageUri
        $this.InputId = $InputId
    }

    Action ([string] $Content, [string] $Arguments, [ActivationType] $ActivationType, [System.IO.Path] $ImageUri, [string] $InputId)
    {
        $this.Content = $Content
        $this.Arguments = $Arguments
        $this.ActivationType = $ActivationType
        $this.ImageUri = $ImageUri
        $this.InputId = $InputId
    }

    [xml] GetXML ()
    {
        $ActionXML = New-Object System.XML.XMLDocument
        $ActionElement = $ActionXML.CreateElement('action')

        $ActionElement.SetAttribute('content', $this.Content)
        $ActionElement.SetAttribute('arguments', $this.Arguments)
        $ActionElement.SetAttribute('activationType', $this.ActivationType)

        if ($this.ImageUri)
        {
            $ActionElement.SetAttribute('imageUri', $this.ImageUri)
        }

        if ($this.InputId)
        {
            $ActionElement.SetAttribute('hint-inputId', $this.InputId)
        }

        $ActionXML.AppendChild($ActionElement)
        return $ActionXML
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

    [xml] GetXML ()
    {
        $TextXML = New-Object System.XML.XMLDocument
        $TextElement = $TextXML.CreateElement('text')

        if (!$this.Empty)
        {
            $TextElement.InnerText = $this.Content
        }

        $TextXML.AppendChild($TextElement)
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

    [xml] GetXML ()
    {
        $ImageXML = New-Object System.XML.XMLDocument
        $ImageElement = $ImageXML.CreateElement('image')

        $ImageElement.SetAttribute('src',$this.Source)

        if ($this.Alt)
        {
            $ImageElement.SetAttribute('alt',$this.Alt)
        }
        
        $ImageElement.SetAttribute('placement',$this.Placement)
        $ImageElement.SetAttribute('hint-crop',$this.Crop)
        
        $ImageXML.AppendChild($ImageElement)
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
    
    [xml] GetXML ()
    {
        $BindingXML = New-Object System.XML.XMLDocument
        $BindingElement = $BindingXML.CreateElement('binding')
        $BindingElement.SetAttribute('template', $this.Template)
        
        foreach ($Element in $this.Element)
        {
            $ElementXML = $BindingXML.ImportNode($Element.GetXML().DocumentElement, $true)
            $BindingElement.AppendChild($ElementXML)
        }

        $BindingXML.AppendChild($BindingElement)

        return $BindingXML
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
    
    [xml] GetXML ()
    {
        $VisualXML = New-Object System.XML.XMLDocument
        $VisualElement = $VisualXML.CreateElement('visual')
        
        $ElementXML = $VisualXML.ImportNode($this.Binding.GetXML().DocumentElement, $true)
        $VisualElement.AppendChild($ElementXML)

        $VisualXML.AppendChild($VisualElement)

        return $VisualXML
    }
}

class Toast
{
    #[string] $Language
    [Visual] $Visual
    [Scenario] $Scenario
    [Audio] $Audio
    [Actions] $Actions
    [Duration] $Duration

    #region constructors
    Toast ([Visual] $Visual)
    {
        $this.Visual = $Visual
    }

    Toast ([Visual] $Visual, [Duration] $Duration)
    {
        $this.Visual = $Visual
        $this.Duration = $Duration
    }

    Toast ([Visual] $Visual, [Audio] $Audio)
    {
        $this.Visual = $Visual
        $this.Audio = $Audio
    }

    Toast ([Visual] $Visual, [Audio] $Audio, [Duration] $Duration)
    {
        $this.Visual = $Visual
        $this.Audio = $Audio
        $this.Duration = $Duration
    }
    
    Toast ([Scenario] $Scenario, [Visual] $Visual)
    {
        $this.Visual = $Visual
        $this.Scenario = $Scenario
    }

    Toast ([Scenario] $Scenario, [Visual] $Visual, [Duration] $Duration)
    {
        $this.Visual = $Visual
        $this.Scenario = $Scenario
        $this.Duration = $Duration
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
    #endregion

    #region constructors-Actions
    Toast ([Visual] $Visual, [Actions] $Actions)
    {
        $this.Visual = $Visual
        $this.Actions = $Actions
    }

    Toast ([Visual] $Visual, [Duration] $Duration, [Actions] $Actions)
    {
        $this.Visual = $Visual
        $this.Duration = $Duration
        $this.Actions = $Actions
    }

    Toast ([Visual] $Visual, [Audio] $Audio, [Actions] $Actions)
    {
        $this.Visual = $Visual
        $this.Audio = $Audio
        $this.Actions = $Actions
    }

    Toast ([Visual] $Visual, [Audio] $Audio, [Duration] $Duration, [Actions] $Actions)
    {
        $this.Visual = $Visual
        $this.Audio = $Audio
        $this.Duration = $Duration
        $this.Actions = $Actions
    }
    
    Toast ([Scenario] $Scenario, [Visual] $Visual, [Actions] $Actions)
    {
        $this.Visual = $Visual
        $this.Scenario = $Scenario
        $this.Actions = $Actions
    }

    Toast ([Scenario] $Scenario, [Visual] $Visual, [Duration] $Duration, [Actions] $Actions)
    {
        $this.Visual = $Visual
        $this.Scenario = $Scenario
        $this.Duration = $Duration
        $this.Actions = $Actions
    }

    Toast ([Scenario] $Scenario, [Visual] $Visual, [Audio] $Audio, [Actions] $Actions)
    {
        $this.Visual = $Visual
        $this.Scenario = $Scenario
        $this.Audio = $Audio
        $this.Actions = $Actions
    }

    Toast ([Scenario] $Scenario, [Visual] $Visual, [Audio] $Audio, [Duration] $Duration, [Actions] $Actions)
    {
        $this.Visual = $Visual
        $this.Scenario = $Scenario
        $this.Audio = $Audio
        $this.Duration = $Duration
        $this.Actions = $Actions
    }
    #endregion

    [xml] GetXML ()
    {
        $ToastXML = New-Object System.XML.XMLDocument
        $ToastElement = $ToastXML.CreateElement('toast')

        $ToastElement.SetAttribute('scenario', $this.Scenario)
        $ToastElement.SetAttribute('duration', $this.Scenario)
        
        $VisualXML = $ToastXML.ImportNode($this.Visual.GetXML().DocumentElement, $true)
        $ToastElement.AppendChild($VisualXML)

        if ($this.Audio)
        {
            $AudioXML = $ToastXML.ImportNode($this.Audio.GetXML().DocumentElement, $true)
            $ToastElement.AppendChild($AudioXML)
        }

        if ($this.Actions)
        {
            $ActionsXML = $ToastXML.ImportNode($this.Actions.GetXML().DocumentElement, $true)
            $ToastElement.AppendChild($ActionsXML)
        }

        $ToastXML.AppendChild($ToastElement)

        return $ToastXML
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

enum ActivationType
{
    foreground
    background
    system
    protocol
}
