###############################################################################
# Use this PowerShell script to execute the SilkSpectre script every
# 120 seconds (or configure the seconds parameter for a different waiting)
# period.
#
# The task scheduler on Windows did not work for me at all. I missed the
# cron utility but a simple script does the job for the immediate needs.
###############################################################################

Function Execute-Command () {
    param(
        [Parameter(Mandatory = $true)]
        [string] $CommandPath,

        [Parameter(Mandatory = $false)]
        [string] $CommandArguments = "",

        [Parameter(Mandatory = $false)]
        [string] $CommandTitle = ""
    )

    $FullCommandPath = (Get-ChildItem -Path $CommandPath).FullName
    $FullCommandDir = $FullCommandPath.directoryName
    # $CommandName = $FullCommandPath.name

    Try {
        $pinfo = New-Object System.Diagnostics.ProcessStartInfo
        $pinfo.FileName = $FullCommandPath
        $pinfo.RedirectStandardError = $true
        $pinfo.RedirectStandardOutput = $true
        $pinfo.UseShellExecute = $false
        $pinfo.CreateNoWindow = $true
        $pinfo.WorkingDirectory = $FullCommandDir
        $pinfo.Arguments = $CommandArguments
        $p = New-Object System.Diagnostics.Process
        $p.StartInfo = $pinfo
        $p.Start() | Out-Null
        [pscustomobject]@{
            commandTitle = $CommandTitle
            stdout       = $p.StandardOutput.ReadToEnd()
            stderr       = $p.StandardError.ReadToEnd()
            ExitCode     = $p.ExitCode
        }
        $p.WaitForExit()
    }
    Catch {
        [pscustomobject]@{
            commandTitle = $CommandTitle
            stdout       = ""
            stderr       = "Could not execute provided command: ensure it targets a valid path."
            ExitCode     = 1
        }
    }
}

function continually() {
    param(
        [Parameter(Mandatory = $true)]
        [int] $Seconds,

        [Parameter(Mandatory = $true)]
        [string] $CommandPath
    )

    -join ("Continually executing the command [", $CommandPath, "] every ", $seconds, " seconds.")

    for (; ; ) {
        try {
            # $CmdOutput = Execute-Command -CommandTitle "PS5 Avail Check" -CommandPath $CommandPath
            $CmdOutput = Invoke-Expression -Command $CommandPath

            $arr = $CmdOutput.trim().split([Environment]::NewLine)
            foreach ($line in $arr) {
                -join ((Get-Date -Format "dddd MM/dd/yyyy HH:mm - "), $line)
            }

            # If error...
            # if ($CmdOutput.ExitCode -ne 0) {
            #     -join ("Error (exit code: ", $CmdOutput.ExitCode, "): ", $CmdOutput.stderr)
            # }
            # # else success...
            # else {
            #     $arr = $CmdOutput.stdout.trim().split([Environment]::NewLine)
            #     foreach ($line in $arr) {
            #         -join ((Get-Date -Format "dddd MM/dd/yyyy HH:mm - "), $line)
            #     }
            # }
        }
        catch {
            -join ("Could not execute the command: unknown error")
        }

        # wait next iteration
        Start-Sleep $Seconds
    }
}

continually -Seconds 120 -Command .\.stack-work\install\a9625293\bin\SilkSpectre-exe.exe
