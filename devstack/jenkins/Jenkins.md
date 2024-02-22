# Jenkins

## Environment variables:

http://localhost:8080/env-vars.html/

## Partitions

In fstab:

```
LABEL=jenkins           /home/jenkins   ext4    defaults        0 0
/home/jenkins/var-lib-docker /var/snap/docker/common/var-lib-docker none defauts,bind   0 0
```

## Native setup

```
mkdir -p /var/backups/jenkins
chown -R jenkins /var/backups/jenkins

usermod -a -G docker jenkins

ufw allow Jenkins

#
# Change home to be in /home/jenkins
#   for snaps
#   thanks to https://dzone.com/articles/jenkins-02-changing-home-directory
#
cp /etc/default/jenkins /etc/default/jenkins.bak
sed -i "s/JENKINS_HOME=.*/JENKINS_HOME=\/home\/jenkins/" /etc/default/jenkins

if [ -d /var/lib/jenkins ]; then
    mv /var/lib/jenkins /home
fi

mkdir -p /home/jenkins
chown jenkins /home/jenkins
```
