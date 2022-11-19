#!/bin/bash

DAY=20 # Time between every daily report (in minute here)
HOUR=4 # Time between every message with the price (in minute here)
PAUSE=6 # Time between every scrapping
COMPT=0 # Number of printed values
declare -a VALUES # Array that will stack prices of Bitcoin 

# The next 3 lines initilalize values
TOTAL=0
min=1000000
max=0

while true; do

curl -s https://cryptorank.io/price/bitcoin > cryptorank.txt # Scrapping Bitcoin Price

# The next 3 lines delete the ',' between Bitcoin Values (ex : 16,123 => 16123)
PRICE=$(cat cryptorank.txt | grep -oP '<div class="table-cell-with-update__CurrencyWrapper-sc-crypsw-0 iJwtNA">\$ \w+,\w+<' | grep -oP '\w+,\w+')
TAMP=$(echo $PRICE | sed 's/,//')
PRICE=$(($TAMP))

echo "BITCOIN's price, printing number $(($COMPT+1)) : \$$PRICE" # You can mute this line if you don't want any print

COMPT=$(( $COMPT + 1 )) # Incrementation of COMPT

sleep $PAUSE # Gives us the price every minute

VALUES[$(($COMPT))]=$PRICE # Keep every value that will be necessary for total, mean, max and min


if (($COMPT==1)); then
    OPEN_PRICE=$PRICE # Taking the first price for the Open Price
fi

if (($COMPT==$DAY)); then

    for n in "${VALUES[@]}" ; do
        if  ((n > max)); then # Keeping the max
            max=$n
        fi
        if  ((min > n)); then # Keeping the min
            min=$n
        fi
        TOTAL=$(($TOTAL + $n)) # Summing the total
    done
    CLOSE_PRICE=$PRICE # Taking the last price for he Close Price
    DAILY_GAP=$(printf %.2f "$((10**3*($CLOSE_PRICE - $OPEN_PRICE)*100/$OPEN_PRICE))e-3")
    MAX_GAP=$(($max-$min)) # Calculaing the maximum gap between the last 24h prices
    MEAN=$(($TOTAL / ($COMPT))) # Calculating the mean

fi

# You can unmute the next 16 lines if you want the values at every print
#echo "VALUES"
#echo ${VALUES[*]}
#echo "MAX"
#echo $max
#echo "MIN"
#echo $min
#echo "TOTAL"
#echo $TOTAL
#echo "MEAN"
#echo $MEAN
#echo "Open Price :"
#echo $OPEN_PRICE
#echo "Close Price"
#echo $CLOSE_PRICE
#echo "Volatility :"
#echo $VOLATILITY

your_chat_id="YOUR_CHAT_ID"
your_telegram_token="YOUR_TELEGRAM_TOKEN"

if (( $(($COMPT % $HOUR)) == 0 )); then # 60 min = 1 hour
curl --data  chat_id=$your_chat_id --data-urlencode "text= Bitcoin's price now  : \$${PRICE} !" "https://api.telegram.org/bot$your_telegram_to
ken/sendMessage?parse_mode=HTML" # Sending a Telegram message with current Bitcoin Price, its Max, Min and Mean of the last 24 hours 
echo "" # Printing nothing so next print will be on a new line
fi

if (( $COMPT == $DAY )); then # 1440 min = 1 day 
curl --data  chat_id=$your_chat_id --data-urlencode "text= Bitcoin's price now  : \$${PRICE} 
Mean in the last 24h :\$${MEAN}
Open Price : \$${OPEN_PRICE}
Close Price : \$${CLOSE_PRICE}
Lower price : \$${min}
Higher price : \$${max}
Maximum gap : \$${MAX_GAP}
Evolution in the last 24h : ${DAILY_GAP}% " "https://api.telegram.org/bot$your_telegram_token/sendMessage?parse_mode=HTML" # Sending a Telegram messag
e with current Bitcoin Price, its Max, Min and Mean of the last 24 hours 
echo "" # Printing nothing so next print will be on a new line
COMPT=0 # Restart for next day
unset VALUES # Restart for next day
declare -a VALUES # Restart for next day

# The next 3 lines reinitilalize values
TOTAL=0
min=1000000
max=0
fi

done

exit
