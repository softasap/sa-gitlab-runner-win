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
