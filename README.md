## Telegram's notification with current Bitcoin Price
This is a code that scrap and send Telegram message with the current price of Bitcoin. 
- Every hour this code send the current price of Bitcoin.
- Every day this code send the current price of Bitcoin, the mean of the Bitcoin price, his lowest/highest prices, his maximum gap in the last 24h, his evolution and his open/close prices of the last 24h.

## Scrapping Information :
- I scrapped Bictoin's Price from this website :  https://cryptorank.io/price/bitcoin

## Sending Telegram Message
- I used @BotFather on Telegram to create a bot with a token. After creating a channel with this bot I wrote the main.sh code to make him text me.

## How to use it ?
- You only have to put your chat id and your token id lines 72 & 73, then execute the main.sh file
