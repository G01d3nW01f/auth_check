#!/bin/bash


RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
MAGENTA='\033[35m'
CYAN='\033[36m'
RESET='\033[0m'

echo "-------------------------------------------------------------------"

# initialize
AUTH_LOG=""

if [ -f /var/log/auth.log ]; then

	
    echo -e "[+]TYPE: ${RED}debian base${RESET}"
    AUTH_LOG="/var/log/auth.log"

else
    echo -e "[+]TYPE: ${RED}redhat${RESET}"
    AUTH_LOG="/var/log/secure"
fi

echo "-------------------------------------------------------------------"

# IP address regular expression
PRIVATE_IP_REGEX_V4="^((10\.)|(172\.(1[6-9]|2[0-9]|3[01]))|(192\.168))"
PRIVATE_IP_REGEX_V6="^((fc00:|fe80:).*)"


ipv4s=($(grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' $AUTH_LOG | grep -Ev $PRIVATE_IP_REGEX_V4 | uniq))
ipv6s=($(grep -Eo '([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}' $AUTH_LOG | grep -Ev $PRIVATE_IP_REGEX_V6 | uniq))

for ipv4 in "${ipv4s[@]}"; do
	echo -e "${GREEN}[!]IPAddress(ipv4) $ipv4${BLUE}"
    grep $ipv4 $AUTH_LOG
done


for ipv6 in "${ipv6s[@]}"; do
	echo -e "${GREEN}[!]IPAddress(ipv6) $ipv6${BLUE}"
    grep $ipv6 $AUTH_LOG
done


grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' $AUTH_LOG | grep -E $PRIVATE_IP_REGEX_V4 | uniq | while read -r private_ipv4; do
echo -e "${GREEN}[!]IPAddress(ipv4) $private_ipv4${BLUE}"
    grep $private_ipv4 $AUTH_LOG
done
echo -e "${RESET}"

grep -Eo '([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}' $AUTH_LOG | grep -E $PRIVATE_IP_REGEX_V6 | uniq | while read -r private_ipv6; do
echo -e "${BLUE}[!]IPAddress(ipv6) $private_ipv6${RESET}"
    grep $private_ipv6 $AUTH_LOG
done
