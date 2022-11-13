#!/bin/bash

COMPT=0 # Number of printed values
declare -a VALUES # Array that will stack prices of Bitcoin
while true; do
curl -s https://cryptorank.io/price/bitcoin > cryptorank.txt # Scrapping Bitcoin Price

# The next 3 lines delete the ',' between Bitcoin Values (ex : 16,123 => 16123)
PRICE=$(cat cryptorank.txt | grep -oP '<div class="table-cell-with-update__CurrencyWrapper-sc-crypsw-0 iJwtNA">\$ \w+,\w+<' | grep -oP '\w+,\w+')
TAMP=$(echo $PRICE | sed 's/,//')
PRICE=$(($TAMP)) 

echo "BITCOIN's price, printing number $(($COMPT+1)) : \$$PRICE" # You can mute this line if you don't want any print

COMPT=$(( $COMPT + 1 )) # Incrementation of COMPT

sleep 60 # Gives us the price every minute 

VALUES[$(($COMPT))]=$PRICE # Keep every value that will be necessary for total, mean, max and min
#echo ${VALUES[*]}

# The next 4 lines initilalize values
TOTAL=0
MEAN=0
min=1000000
max=0

for n in "${VALUES[@]}" ; do
    if  ((n > max)); then # Keeping the max
            max=$n
    fi
    if  ((min > n)); then # Keeping the min
            min=$n
    fi
    TOTAL=$(($TOTAL + $n)) # Summing the total
done

MEAN=$(($TOTAL / ($COMPT))) # Calculating the mean

# You can unmute the next 8 lines if you want the values at every print
#echo "MAX"
#echo $max
#echo "MIN"
#echo $min
#echo "TOTAL"
#echo $TOTAL
#echo "MEAN"
#echo $MEAN

your_chat_id="YOUR_CHAT_ID"
your_telegram_token="YOUR_TELEGRAM_TOKEN"

if (( $(($COMPT % 60)) == 0 )); then # 60 min = 1 hour
        curl --data  chat_id=$your_chat_id --data-urlencode "text= Bitcoin's price now  : \$${PRICE} !" "https://api.telegram.org/bot$your_telegram_token/sendMessage?parse_mode=HTML" # Sending a Telegram message with current Bitcoin Price, its Max, Min and Mean of the last 24 hours 
        echo "" # Printing nothing so next print will be on a new line
fi

if (( $COMPT == 1440 )); then # 1440 min = 1 day 
        curl --data  chat_id=$your_chat_id --data-urlencode "text= Bitcoin's price now  : \$${PRICE} 
Mean in the last 24h : ${MEAN}
Lower price : ${min}
Higher price : ${max} " "https://api.telegram.org/bot$your_telegram_token/sendMessage?parse_mode=HTML" # Sending a Telegram message with current Bitcoin Price, its Max, Min and Mean of the last 24 hours 
        echo "" # Printing nothing so next print will be on a new line
        COMPT=0 # Restart for next day
        unset VALUES # Restart for next day
        declare -a VALUES # Restart for next day
fi

done

exit
