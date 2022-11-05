#!/bin/bash
# -*- ENCODING: UTF-8 -*-

COMPT=1 # Number of printed values

while true; do

curl -s https://cryptorank.io/price/bitcoin > cryptorank.txt # Scrapping Bitcoin Price

PRICE=$(cat cryptorank.txt | grep -oP '<div class="table-cell-with-update__CurrencyWrapper-sc-crypsw-0 iJwtNA">\$ \w+,\w+<' | grep -oP '\w+,\w+')
echo "BITCOIN's price, printing number $COMPT : \$$PRICE"
sleep 60 # Gives us the price every minute 

COMPT=$(( $COMPT + 1 ))

if (( $COMPT == 1440 )); then # 1440 min = 1 day 
        your_chat_id="YOUR_CHAT_ID"
        your_telegram_token="YOUR_TELEGRAM_TOKEN"
        curl --data  chat_id=$your_chat_id --data-urlencode "text= Bitcoin's price today  : \$${PRICE} ! " "https://api.telegram.org/bot$your_telegram_token/sendMessage?parse_mode=HTML" # Sending a Telegram message with current Bitcoin Price 
        echo "" # Printing nothing so next print will be on a new line
fi

done

exit
