sa-gitlab-runner-win
====================

[![Build Status](https://travis-ci.org/softasap/sa-gitlab-runner-win.svg?branch=master)](https://travis-ci.org/softasap/sa-gitlab-runner-win)

Note: Remote windows should be prepared for ansible provisioning in advance. See https://github.com/softasap/sa-win for details.

```pwsh
Set-ExecutionPolicy Bypass -Scope Process -Force;
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/softasap/sa-win/master/bootstrap.ps1'))
```

See box-example for play example.

Example of usage:

Simple

```YAML

     - {
         role: "sa-gitlab-runner-win"
       }


```

Advanced

```YAML

     - {
         role: "sa-gitlab-runner-win",
         gitlab_runner_ci_url: https://gitlab.com/,
         gitlab_runner_registration_token: SPECIFY,
         gitlab_builds_dir: "c:/workspaces/builds",
         gitlab_caches_dir: "c:/workspaces/caches",
         gitlab_shell: powershell, # Select bash or powershell [%RUNNER_SHELL%]
         gitlab_environment: ["GIT_SSL_NO_VERIFY=true"],
         gitlab_runner_description: "{{ ansible_hostname }} - Experimental windows runner"
       }


```

Note, that cmd runner stating from v13 is deprecated.

Windows runner registration
---------------------------

If you haven't provided `gitlab_runner_registration_token` on install, you will have to proceed with runner registration procedure


To register a Runner under Windows:
Run the following command:

```sh
./gitlab-runner.exe register
```

Enter your GitLab instance URL:

```
Please enter the gitlab-ci coordinator URL (e.g. https://gitlab.com )
https://gitlab.com
```

Enter the token you obtained to register the Runner:

```
Please enter the gitlab-ci token for this runner
xxx
```

Enter a description for the Runner, you can change this later in GitLab’s UI:

```
Please enter the gitlab-ci description for this runner
[hostname] my-runner
```

Enter the tags associated with the Runner, you can change this later in GitLab’s UI:

```
Please enter the gitlab-ci tags for this runner (comma separated):
my-tag,another-tag
```

Enter the Runner executor:

```
Please enter the executor: ssh, docker+machine, docker-ssh+machine, kubernetes, docker, parallels, virtualbox, docker-ssh, shell, powershell, cmd:
cmd
```

If you chose Docker as your executor, you’ll be asked for the default image to be used for projects that do not define one in .gitlab-ci.yml:

```
Please enter the Docker image (eg. ruby:2.6):
alpine:latest
```

Registering runner as service
-----------------------------

Install the Runner as a service and start it. You can either run the service using the Built-in System Account (recommended) or using a user account.

Run service using Built-in System Account (under directory created in step 1. from above, ex.: C:\GitLab-Runner)

```sh
cd C:\GitLab-Runner
.\gitlab-runner.exe install
.\gitlab-runner.exe start
```

Run service using user account (under directory created during install, ex.: C:\GitLab-Runner)

You have to enter a valid password for the current user account, because it’s required to start the service by Windows:
Note, that if this instance is cloud one - do not forget to disable password expiration for that account, or do not forget
to change password in service settings periodically

```sh
cd C:\GitLab-Runner
.\gitlab-runner.exe install --user ENTER-YOUR-USERNAME --password ENTER-YOUR-PASSWORD
.\gitlab-runner.exe start
```

(Optional) Update Runners concurrent value in C:\GitLab-Runner\config.toml to allow multiple concurrent jobs as detailed in advanced configuration details. Additionally, you can use the advanced configuration details to update your shell executor to use Bash or PowerShell rather than Batch.
Voila! Runner is installed, running, and will start again after each system reboot. Logs are stored in Windows Event Log

Side note on a config files, if , saying, you are building some .net stuff

For your user NuGet Config files used:

```
    C:\Users\YOURUSER\AppData\Roaming\NuGet\NuGet.Config
    C:\Program Files (x86)\NuGet\Config\Microsoft.VisualStudio.Offline.config
```

IF  your runner is running on behalf of SYSTEM path will be
```
C:\Windows\system32\config\systemprofile\AppData\Roaming\NuGet\NuGet.Config
```

i.e. home for the system user would be `C:\Windows\system32\config\systemprofile`


Again, if runner is running under system account, you might want to troubleshoot smth interactively, thus you need console
on behalf of system account. What could you do?

Running console as system interactively

```sh
psexec.exe -i -s -d cmd.exe
```

Running console as system in ConEmu

Create launch item `Shells::cmd(System)` with content

```
cmd.exe -new_console:aA
```

You can always check who are you by invoking

```sh
echo %USERDOMAIN%\%USERNAME%
```

or in powershell

```sh
write-host $env:userdomain\$env:username
```

or you might also have similar to linux system whoami utility already

```sh
whoami
```

Using as a part of AMI
----------------------

You are about to install role setting `option_gitlab_register_runner: false`

```YAML

     - {
         role: "sa-gitlab-runner-win",
         gitlab_runner_ci_url: https://gitlab.com/,
         gitlab_runner_registration_token: SPECIFY,
         gitlab_builds_dir: "c:/workspaces/builds",
         gitlab_caches_dir: "c:/workspaces/caches",
         gitlab_shell: powershell, # Select bash or powershell [%RUNNER_SHELL%]
         gitlab_environment: ["GIT_SSL_NO_VERIFY=true"],
         gitlab_runner_description: "{{ ansible_hostname }} - Experimental windows runner"
       }
```

later, on your ami startup script you can 

```ps1

Set-Location c:\gitlab-runner

Import-Module ./register-runner.ps1

# register default runner with powershell
gitlab-runner-register -gitRegistrationToken SPECIFY  -hostTags "windows"
# OR
# register oldschool runner with windows cmd
gitlab-runner-register -gitRegistrationToken SPECIFY  -hostTags "windows" -gitlab_executor "shell" -gitlab_shell "cmd"

iex "cat .\config.toml | grep token"
if($lastexitcode -ne '0')
{
    while($lastexitcode -ne '0')
    {
        Start-Sleep -s 5
        Write-Host "Retrying registration...."
        # register default runner with powershell
        gitlab-runner-register -gitRegistrationToken SPECIFY  -hostTags "windows"
        # OR
        # register oldschool runner with windows cmd
        gitlab-runner-register -gitRegistrationToken SPECIFY  -hostTags "windows" -gitlab_executor "shell" -gitlab_shell "cmd"
        iex "cat .\config.toml | grep token"
    }
}
Write-Host "Registration complete...."

# install runner service as localsystem
gitlab-service-register

# install runner service on behalf of specific user
Grant-LogonAsService "$env:COMPUTERNAME\ieuser"
gitlab-service-register -gitlab_runner_username "ieuser" -gitlab_runner_pass "Passw0rd!"

```

nearby there is also script for a self signed gitlab runner,
as well as version update.


Usage with ansible galaxy workflow
----------------------------------

If you installed the `sa-gitlab-runner-win` role using the command


`
   ansible-galaxy install softasap.sa-gitlab-runner-win
`

the role will be available in the folder `library/softasap.sa-gitlab-runner-win`
Please adjust the path accordingly.

```YAML

     - {
         role: "softasap.sa-gitlab-runner-win"
       }

```




Copyright and license
---------------------

Code is dual licensed under the [BSD 3 clause] (https://opensource.org/licenses/BSD-3-Clause) and the [MIT License] (http://opensource.org/licenses/MIT). Choose the one that suits you best.

Reach us:

Subscribe for roles updates at [FB] (https://www.facebook.com/SoftAsap/)

Join gitter discussion channel at [Gitter](https://gitter.im/softasap)

Discover other roles at  http://www.softasap.com/roles/registry_generated.html

visit our blog at http://www.softasap.com/blog/archive.html 
