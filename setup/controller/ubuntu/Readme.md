# Setup a new ansible controller from Mac

- make a copy of env_template.rc and update the values

- `source env_myEnv.rc`

- `init.sh`

Your ansible controller must be up and running


# upgrade from ubuntu 16.04 to ubuntu 18.04

```
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
source ~/.bash_profile

sudo apt update
sudo apt upgrade
sudo apt dist-upgrade
do-release-upgrade -f DistUpgradeViewNonInteractive

lsb_release -a
```

(Check with salman@us.ibm.com if any issues)

https://www.liquidweb.com/kb/how-to-upgrade-ubuntu-16-04-to-ubuntu-18-04/