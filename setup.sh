#!/bin/bash
# Input: "user"

PASS=fakepasswordhere112
RANDREPO=$(tail -n +500 /usr/share/wordlists/dirbuster/directory-list-2.3-small.txt | shuf | head -n 1)
IDENTITY=$(curl -sk https://api.namefake.com/)
NAME=$(echo ${IDENTITY} | jq -r '.name')
LOCATION=$(echo ${IDENTITY} | jq -r '.address')
COMPANY=$(echo ${IDENTITY} | jq -r '.company')
BIO=$(curl -sk https://www.twitterbiogenerator.com/generate)

# Create remote repo
curl -u "${1}:${PASS}" https://api.github.com/user/repos -d "{\"name\":\"${RANDREPO}\"}"
curl --request PATCH -u "${1}:${PASS}" https://api.github.com/user \
	--data "{\"name\": \"$NAME\", \"location\": \"${LOCATION//[$'\t\r\n']}\", \"company\": \"$COMPANY\", \"bio\": \"$BIO\"}"	

# Create local files
git init
git config user.name "${1}"
git config user.email "${1}@chary.email"
git add README.md
git add info.txt
git add .

# Upload to repo
git commit -m "first commit here"
#git remote add origin https://github.com/${1}/${RANDREPO}.git
git push -u https://${1}:${PASS}@github.com/${1}/${RANDREPO}.git master

# Clean up
rm -rf .git
