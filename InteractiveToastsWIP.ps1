class Toast
{
    [Scenario] $Scenario
    [VisualElement] $Visual
    [AudioElement] $Audio
    [ActionsElement] $Actions
}

class VisualElement
{
    
}

class AudioElement
{
    [string] $Source
    [boolean] $Loop
    [boolean] $Silent

    AudioElement([string] $Source, [boolean] $Loop, [boolean] $Silent)
    {
        if ($Source -in [AudioSource].GetEnumNames())
        {
            $this.Source = $Source
            $this.Loop = $Loop
            $this.Silent = $Silent
        }
        else
        {
            throw "$Source is not a valid audio source."
        }
    }
    
    AudioElement([string] $Source, [boolean] $Loop)
    {
        if ($Source -in [AudioSource].GetEnumNames())
        {
            $this.Source = $Source
            $this.Loop = $Loop
        }
        else
        {
            throw "$Source is not a valid audio source."
        }
    }

    AudioElement([string] $Source)
    {
        if ($Source -in [AudioSource].GetEnumNames())
        {
            $this.Source = $Source
        }
        else
        {
            throw "$Source is not a valid audio source."
        }
    }

    AudioElement([boolean] $Silent)
    {
        $this.Silent = $Silent
    }
}

class ActionsElement
{
    
}

enum Scenario
{
    default
    alarm
    reminder
    incomingCall
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