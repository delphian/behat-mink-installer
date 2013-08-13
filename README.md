Behat Mink Installer
====================

Please see this original document at https://github.com/delphian/behat-mink-installer/wiki

Easy installation of behat with mink extension. Copy and paste a single line into the shell to install.

#### License ####

Copyright (c) 2013 Bryan Hazelbaker <bryan.hazelbaker@gmail.com>
Released under the MIT license. Read the entire license located in the project root or at http://opensource.org/licenses/mit-license.php

#### Installation ####

First navigate to your project folder then copy and paste this into your shell to install everything:

```
curl -L -o bootstrap.sh http://goo.gl/0VxD7M && chmod 744 bootstrap.sh && ./bootstrap.sh
```

Installation script will:

* Download php archives into /usr/local/bin:
  * behat.phar (and makes executable)
  * mink.phar
  * mink_extension.phar
* Create `behat` in current directory to hold yaml configuration and feature tests.
* Create yaml configuration file to point behat at mink php archives.
* Modifies default behat class to extend MinkContext.
* Create example feature file that examines the google home page.
* Downloads selenium2 server to /usr/local/bin and launches in background.
* Launches behat test of google home page (firefox will open).

#### Help and Support ####

Feel free to contact me bryan.hazelbaker@gmail.com with any questions. Submit all bug reports or feature requests
to the [Issue Queue](https://github.com/delphian/behat-mink-installer/issues). Please see the 
[Wiki](https://github.com/delphian/behat-mink-installer/wiki) for more information.

