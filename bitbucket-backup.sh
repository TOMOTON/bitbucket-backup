#!/bin/bash
#Author Jobin Joseph, Dann Martens
#Blog : AWSadminz.com
#Bio  : JobinJoseph.com


#Bitbucket credentials
bbuser='USERNAME' # Bitbucket Username
bbpass='PASSWORD' # Generate APP password if you dont want to disclose the Password here
#Backup Location
backloc="/backups/bitbucket" #backup location on this system

#Snapshot name 
fname=`date +%F_%H_%M`

cd $backloc

bitbucket_get_urls () {
rm -f bitbucketurls
#Use Atlassian Bitbucket API v2.0
curl -v --user $bbuser:$bbpass https://bitbucket.org/api/2.0/repositories/ACCOUNT?pagelen=100 > bitbucket.1
#Parsing
tr ',' '\n' < bitbucket.1 > bitbucket.2
tr -d '"{}[]' < bitbucket.2 > bitbucket.3
cat bitbucket.3 | grep -i git@ | cut -c 8- > bitbucketurls
}

bb_backup () {
rm -rf `cat VERSION`
echo $fname > VERSION
mkdir $fname
cd $fname
#Bare clone
for repo in `cat ../bitbucketurls` ; do
echo "========== Cloning $repo =========="
git clone --bare $repo
done
}

#Backup starts here

bitbucket_get_urls
bb_backup

exit 0

