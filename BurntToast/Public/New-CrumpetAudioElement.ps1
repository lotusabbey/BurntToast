#requires -Version 2 
function New-CrumpetAudioElement
{
    <#
        .SYNOPSIS
        
        .DESCRIPTION
        
        .INPUTS
        None

        You cannot pipe input to this cmdlet.

        .OUTPUTS
        None
        
        .NOTES
        
        .EXAMPLE
        
        .EXAMPLE

        .EXAMPLE

        .EXAMPLE

        .EXAMPLE
        
        .LINK
        https://github.com/Windos/BurntToast
    #>

    [CmdletBinding(DefaultParameterSetName = 'Sound')]
    [OutputType([Audio])]
    param
    (
        [Parameter(Mandatory = $false,
                   ParameterSetName = 'Sound')]
        [ValidateSet('Default',
                     'IM',
                     'Mail',
                     'Reminder',
                     'SMS',
                     'Alarm',
                     'Alarm2',
                     'Alarm3',
                     'Alarm4',
                     'Alarm5',
                     'Alarm6',
                     'Alarm7',
                     'Alarm8',
                     'Alarm9',
                     'Alarm10',
                     'Call',
                     'Call2',
                     'Call3',
                     'Call4',
                     'Call5',
                     'Call6',
                     'Call7',
                     'Call8',
                     'Call9',
                     'Call10')]
        [alias('Sound')]
        [String] $Source = 'Default',

        [Parameter(Mandatory = $true,
                   ParameterSetName = 'Silent')]
        [Switch] $Silent
    )

    if ($Silent)
    {
        [Audio]::new($true)
    }
    else
    {
        [Audio]::new([AudioSource]::$Source)
    }
}
