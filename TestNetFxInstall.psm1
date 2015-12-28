$regKeyNetFx10 = "HKLM:\Software\Microsoft\.NETFramework\Policy\v1.0"
$regValNetFx10 = "3705"
$regKeyNetFx10SPxMsi = "HKLM:\Software\Microsoft\Active Setup\Installed Components\{78705f0d-e8db-4b2d-8193-982bdda15ecd}"
$regKeyNetFx10SPxOcm = "HKLM:\Software\Microsoft\Active Setup\Installed Components\{FDC11A6F-17D1-48f9-9EA3-9051954BAA24}"
$regKeyNetFx11 = "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v1.1.4322"
$regKeyNetFx20 = "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v2.0.50727"
$regKeyNetFx30 = "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v3.0\Setup"
$regKeyNetFx30SP = "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v3.0"
$regValNetFx30 = "InstallSuccess"
$regKeyNetFx35 = "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v3.5"
$regKeyNetFx40Client = "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Client"
$regKeyNetFx40Full = "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Full"
$regValNetFx40SPx = "Servicing"
$regKeyNetFx45 = "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Full"
$regValNetFx45 = "Release"
$regValNetFxInstall = "Install"
$regValNetFxSP = "SP"
$regValNetFxVersion = "Version"

$versions = @{
    "30" = New-Object System.Version(3, 0, 4506, 26);
    "35" = New-Object System.Version(3, 5, 21022, 8);
    "40" = New-Object System.Version(4, 0, 30319, 0)
}

$runtimes = @{
    "10" = "v1.0.3705";
    "11" = "v1.1.4322";
    "20" = "v2.0.50727";
    "40" = "v4.0.30319"
}

$releases = @{
    "45"  = "378389";
    "451" = "378675";
    "452" = "379893";
    "46"  = "393295";
    "461" = "394254"
}

<#
.Synopsis
   Return registry value
.DESCRIPTION
   Return registry value
.EXAMPLE
   Get-RegistryValue -Key "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Full" -ValueName "Version"
.INPUTS
   Key Registry Key
   ValueName Name of registry value name
.OUTPUTS
   Value of registry name
#>
function Get-RegistryValue
{
    [CmdletBinding(SupportsShouldProcess=$true, PositionalBinding=$false)]
    [OutputType([String])]
    Param
    (
        # registry key
        [Parameter(Mandatory=$true, Position=0)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Key,

        # registry value name
        [Parameter(Mandatory=$true, Position=1)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]
        $ValueName
    )

    Begin
    {
        $value = $null
    }
    Process
    {
        if ($pscmdlet.ShouldProcess($Key, "Check registry value name '$ValueName'"))
        {
            if (Test-Path $Key)
            {
                $regKey = Get-Item -LiteralPath $Key
                $value = $regKey.GetValue($ValueName, $null)
            }
        }
        return $value
    }
    End
    {
    }
}

<#
.Synopsis
   Test registry key and value for .net framework 1.0 installation
.DESCRIPTION
   Test registry key and value for .net framework 1.0 installation
.EXAMPLE
   Test-NetFx10Install
#>
function Test-NetFx10Install()
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([bool])]
    Param()

    Begin
    {
        $value = $null
    }
    Process
    {
        $value = Get-RegistryValue -Key $regKeyNetFx10 -ValueName $regValNetFx10
        return $value -ne $null
    }
    End
    {
    }
}

<#
.Synopsis
   Test registry key and value for .net framework 1.1 installation
.DESCRIPTION
   Test registry key and value for .net framework 1.1 installation
.EXAMPLE
   Test-NetFx11Install
#>
function Test-NetFx11Install()
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([bool])]
    Param()

    Begin
    {
        $value = $null
    }
    Process
    {
        $value = Get-RegistryValue -Key $regKeyNetFx11 -ValueName $regValNetFxInstall
        return $value -eq 1
    }
    End
    {
    }
}

<#
.Synopsis
   Test registry key and value for .net framework 2.0 installation
.DESCRIPTION
   Test registry key and value for .net framework 2.0 installation
.EXAMPLE
   Test-NetFx20Install
#>
function Test-NetFx20Install()
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([bool])]
    Param()

    Begin
    {
        $value = $null
    }
    Process
    {
        $value = Get-RegistryValue -Key $regKeyNetFx20 -ValueName $regValNetFxInstall
        return $value -eq 1
    }
    End
    {
    }
}

<#
.Synopsis
   Test registry key and value for .net framework 3.0 installation
.DESCRIPTION
   Test registry key and value for .net framework 3.0 installation
.EXAMPLE
   Test-NetFx30Install
#>
function Test-NetFx30Install()
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([bool])]
    Param()

    Begin
    {
        $value = $null
    }
    Process
    {
        if (Test-NetFx20Install)
        {
            $value = Get-RegistryValue -Key $regKeyNetFx30 -ValueName $regValNetFx30
            if ($value -eq 1)
            {
                $versionString = Get-RegistryValue -Key $regKeyNetFx30 -ValueName $regValNetFxVersion

                $version = $null
                if ([System.Version]::TryParse($versionString, [ref] $version))
                {
                    return $version -ge $versions["30"]
                }
            }
        }
        return $false
    }
    End
    {
    }
}

<#
.Synopsis
   Test registry key and value for .net framework 3.5 installation
.DESCRIPTION
   Test registry key and value for .net framework 3.5 installation
.EXAMPLE
   Test-NetFx35Install
#>
function Test-NetFx35Install()
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([bool])]
    Param()

    Begin
    {
        $value = $null
    }
    Process
    {
        if (Test-NetFx30Install)
        {
            $value = Get-RegistryValue -Key $regKeyNetFx35 -ValueName $regValNetFxInstall
            if ($value -eq 1)
            {
                $versionString = Get-RegistryValue -Key $regKeyNetFx35 -ValueName $regValNetFxVersion

                $version = $null
                if ([System.Version]::TryParse($versionString, [ref] $version))
                {
                    return $version -ge $versions["35"]
                }
            }
        }
        return $false
    }
    End
    {
    }
}

<#
.Synopsis
   Test registry key and value for .net framework 4.0 client installation
.DESCRIPTION
   Test registry key and value for .net framework 4.0 client installation
.EXAMPLE
   Test-NetFx40ClientInstall
#>
function Test-NetFx40ClientInstall()
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([bool])]
    Param()

    Begin
    {
        $value = $null
    }
    Process
    {
        $value = Get-RegistryValue -Key $regKeyNetFx40Client -ValueName $regValNetFxInstall
        if ($value -eq 1)
        {
            $versionString = Get-RegistryValue -Key $regKeyNetFx40Client -ValueName $regValNetFxVersion

            $version = $null
            if ([System.Version]::TryParse($versionString, [ref] $version))
            {
                return $version -ge $versions["40"]
            }

            return $false
        }
        return $false
    }
    End
    {
    }
}

<#
.Synopsis
   Test registry key and value for .net framework 4.0 full installation
.DESCRIPTION
   Test registry key and value for .net framework 4.0 full installation
.EXAMPLE
   Test-NetFx40FullInstall
#>
function Test-NetFx40FullInstall()
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([bool])]
    Param()

    Begin
    {
        $value = $null
    }
    Process
    {
        $value = Get-RegistryValue -Key $regKeyNetFx40Full -ValueName $regValNetFxInstall
        if ($value -eq 1)
        {
            $versionString = Get-RegistryValue -Key $regKeyNetFx40Full -ValueName $regValNetFxVersion

            $version = $null
            if ([System.Version]::TryParse($versionString, [ref] $version))
            {
                return $version -ge $versions["40"]
            }

            return $false
        }
        return $false
    }
    End
    {
    }
}


<#
.Synopsis
   Test registry key and value for .net framework 4.5 installation
.DESCRIPTION
   Test registry key and value for .net framework 4.5 installation
.EXAMPLE
   Test-NetFx45Install
#>
function Test-NetFx45Install()
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([bool])]
    Param()

    Begin
    {
        $value = $null
    }
    Process
    {
        if (Test-NetFx40FullInstall)
        {
            $value = Get-RegistryValue -Key $regKeyNetFx45 -ValueName $regValNetFx45
            return $value -ge $releases["45"]
        }
        return $false
    }
    End
    {
    }
}

<#
.Synopsis
   Test registry key and value for .net framework 4.5.1 installation
.DESCRIPTION
   Test registry key and value for .net framework 4.5.1 installation
.EXAMPLE
   Test-NetFx451Install
#>
function Test-NetFx451Install()
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([bool])]
    Param()

    Begin
    {
        $value = $null
    }
    Process
    {
        if (Test-NetFx40FullInstall)
        {
            $value = Get-RegistryValue -Key $regKeyNetFx45 -ValueName $regValNetFx45
            return $value -ge $releases["451"]
        }
        return $false
    }
    End
    {
    }
}

<#
.Synopsis
   Test registry key and value for .net framework 4.5.2 installation
.DESCRIPTION
   Test registry key and value for .net framework 4.5.2 installation
.EXAMPLE
   Test-NetFx452Install
#>
function Test-NetFx452Install()
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([bool])]
    Param()

    Begin
    {
        $value = $null
    }
    Process
    {
        if (Test-NetFx40FullInstall)
        {
            $value = Get-RegistryValue -Key $regKeyNetFx45 -ValueName $regValNetFx45
            return $value -ge $releases["452"]
        }
        return $false
    }
    End
    {
    }
}

<#
.Synopsis
   Test registry key and value for .net framework 4.6 installation
.DESCRIPTION
   Test registry key and value for .net framework 4.6 installation
.EXAMPLE
   Test-NetFx46Install
#>
function Test-NetFx46Install()
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([bool])]
    Param()

    Begin
    {
        $value = $null
    }
    Process
    {
        if (Test-NetFx40FullInstall)
        {
            $value = Get-RegistryValue -Key $regKeyNetFx45 -ValueName $regValNetFx45
            return $value -ge $releases["46"]
        }
        return $false
    }
    End
    {
    }
}

<#
.Synopsis
   Test registry key and value for .net framework 4.6.1 installation
.DESCRIPTION
   Test registry key and value for .net framework 4.6.1 installation
.EXAMPLE
   Test-NetFx461Install
#>
function Test-NetFx461Install()
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([bool])]
    Param()

    Begin
    {
        $value = $null
    }
    Process
    {
        if (Test-NetFx40FullInstall)
        {
            $value = Get-RegistryValue -Key $regKeyNetFx45 -ValueName $regValNetFx45
            return $value -ge $releases["461"]
        }
        return $false
    }
    End
    {
    }
}

<#
.Synopsis
   Test if .net framework 1.0 service pack is installed
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Test-NetFx10ServicePack
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([bool])]
    Param()

    Begin
    {
        $value = $null
    }
    Process
    {
        # check media center install key first
        $value = Get-RegistryValue -Key $regKeyNetFx10SPxOcm -ValueName $regValNetFxVersion

        if ($value -eq $null)
        {
            # check standard install registry key
            $value = Get-RegistryValue -Key $regKeyNetFx10SPxMsi -ValueName $regValNetFxVersion
        }

        if ($value -ne $null)
        {
            $items = Split-String $value -Separator "," -RemoveEmptyStrings
            if ($items.Length -eq 4)
            {
                $version = $items[$items.Length - 1]
                return $version -gt 0
            }
        }
        return $false
    }
    End
    {
    }
}

<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Get-NetFxInstalled
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([String[]])]
    Param()

    Begin
    {
        $installed = @()
    }
    Process
    {
        if (Test-NetFx10Install)
        {
            $installed += "net10"
        }
        if (Test-NetFx11Install)
        {
            $installed += "net11"
        }
        if (Test-NetFx20Install)
        {
            $installed += "net20"
        }
        if (Test-NetFx30Install)
        {
            $installed += "net30"
        }
        if (Test-NetFx35Install)
        {
            $installed += "net35"
        }
        if (Test-NetFx40FullInstall)
        {
            $installed += "net40"
        }
        if (Test-NetFx40ClientInstall)
        {
            $installed += "net40client"
        }
        if (Test-NetFx45Install)
        {
            $installed += "net45"
        }
        if (Test-NetFx451Install)
        {
            $installed += "net451"
        }
        if (Test-NetFx452Install)
        {
            $installed += "net452"
        }
        if (Test-NetFx46Install)
        {
            $installed += "net46"
        }
        if (Test-NetFx461Install)
        {
            $installed += "net461"
        }

    }
    End
    {
        return $installed
    }
}