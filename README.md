TestNetFxInstall Readme
=======================

TestNetFxInstall is a powershell module to detect .net framework
installation by checking windows registry values, and it support
detecting .net framework version from 1.0 to 4.6.1. It is
inspired by this
[MSDN Blog Post](http://blogs.msdn.com/b/astebner/archive/2009/06/16/9763379.aspx).

How to use TestNetFxInstall
---------------------------
Copy TestNetFxInstall directory to

    %UserProfile%\Documents\WindowsPowerShell\Modules

Then from the powershell prompt, type

    Import-Module TestNetFxInstall

Cmdlets
-------
Once TestNetFxInstall module is imported into powershell, these
additional cmdlets will be available to you current powershell
session:

- Test-NetFx10Install
- Test-NetFx11Install
- Test-NetFx20Install
- Test-NetFx30Install
- Test-NetFx35Install
- Test-NetFx40ClientInstall
- Test-NetFx40FullInstall
- Test-NetFx45Install
- Test-NetFx451Install
- Test-NetFx452Install
- Test-NetFx46Install
- Test-NetFx461Install
- Get-NetFxInstalled

Examples
--------

To check if .net framework 3.5 is installed

    if (Test-NetFx35Install) { Write-Output ".Net 3.5 is installed" }
    else { Write-Output ".Net 3.5 is not installed" }

To list all .net frameworks installed

    Get-NetFxInstalled

Acknowledgement
---------------
Thanks [Aaron Stebner](http://blogs.msdn.com/b/astebner/)http://blogs.msdn.com/b/astebner)
for providing .net framework installation registry information.
