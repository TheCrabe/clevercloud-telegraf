
# clevercloud-telegraf
Telegraf instance to deploy on CleverCloud in a golang app

## Setup
0. Init golang app on CleverCloud  
   **[CleverCloud Console](https://console.clever-cloud.com)**  
   Create... > an application > CREATE A BRAND NEW APP > Go

   **clever-tools**  
   `clever create --type go [APP-NAME]`
1. Add remote repository
   `git remote add clever $(jq -r '.apps[0].git_ssh_url' .clever.json)`
2. Push to CleverCloud
   `git push clever master`