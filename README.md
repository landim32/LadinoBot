# LadinoBot

[![Package version](https://img.shields.io/github/release/landim32/LadinoBot.svg?style=flat-square)](https://github.com/landim32/LadinoBot/releases)
[![GitHub license](https://img.shields.io/github/license/landim32/LadinoBot.svg)](https://github.com/landim32/LadinoBot/blob/master/LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/landim32/LadinoBot.svg?style=social)](https://github.com/landim32/LadinoBot/stargazers)
[![GitHub watchers](https://img.shields.io/github/watchers/landim32/LadinoBot.svg?style=social)](https://github.com/landim32/LadinoBot/watchers)
[![GitHub issues](https://img.shields.io/github/issues/landim32/LadinoBot.svg?style=social)](https://github.com/landim32/LadinoBot/issues)
![GitHub forks](https://img.shields.io/github/forks/landim32/LadinoBot.svg?style=social)

**LadinoBot** [http://emagine.com.br/LadinoBot](http://emagine.com.br/LadinoBot) is an **Expert Advisor** Expert Advisor **Metatrader 5**. 
With it you can have a tool working for you. The robot works with various strategies and can combine different chart times. Different objectives can be used, and the exit strategies of the operation can be modified according to the evolution of the objectives.

## Downloads

- [Click here](https://github.com/landim32/LadinoBot/releases/latest/download/LadinoBot.ex5) to download [LadinoBot 1.02](https://github.com/landim32/LadinoBot/releases/latest/download/LadinoBot.ex5)

## Video

Below is a video with the January 2020 operations, where a **profit of R$ 2,435** was obtained by trading **10 mini-contracts**.
[![Watch the video](https://img.youtube.com/vi/HtU_yZhYQls/maxresdefault.jpg)](https://youtu.be/HtU_yZhYQls)

## Parameters

### Working Hours

- **Start Time** - Operations starting date;
- **Closing Time** - From this time on, new operations are not opened. Current open positions remain open.
- **Exit Time** - All operations that are still open will be closed at market price;

### Basic Operations manual

- **Operation type** - Type of operations supported. Available options are:
- **Buy and Sell** - The robot operates both buy and sell;
- **Only Buy** - Open only buy operations;
- **Only Sell** - Open only sell operations;
- **Asset type** - Type of asset to be traded. This field will influence the value of the brokerage to be accounted for. Below are the options:
- **Index** - Brokerage shall be charged per negotiated contract;
- **Stock** - Brokerage shall be charged per trade, regardless of the volume traded;
- **Risk Management** - Modified risk management. The options are:
- **Normal** - Normal risk, nothing different;
- **Progressive** - In progressive risk, the robot uses profit achieved to increase Stop Loss;
- **Input Condition** - Condition for entry into operation:
- **Thread/MM T1 (Tick)** - when Candle crosses the moving average in the main graphic time T1, not waiting for Candle to close;
- **Thread/MM T2 (Tick)** - When Candle crosses the moving average in T2 chart time, not waiting for Candle to close;
- **Thread/MM T3 (Tick)** - When Candle crosses the moving average in time graph T3, not waiting for Candle to close;
- **Thread/MM T1 (Close)** - When Candle crosses the moving average in main graphic time T1, it runs when Candle closes;
- **Thread/MM T2 (Close)** - When Candle crosses the moving average in graphical time T2, it runs when Candle closes;
- **Thread/MM T3 (Close)** - When Candle crosses the moving average in graphical time T3, it runs when Candle closes;
- **Only Trend T1** - Active when the main graphic time T1 displays flashing tops and backgrounds;

- **Value per point** - Financial value per point earned or lost;

### Financial Options

- **Brokerage value** - Value of the brokerage fee. How to account depends on the option **Asset Type**;
- ***Daily Max Gain** - Maximum daily financial gain. When the limit is reached, the system closes for new trades;
- **Daily Max Loss** - Maximum daily financial loss. When the limit is reached, the system closes for new trades;
- ***Operation Max Gain** - When the financial limit is reached, the transaction is completed;

### T1 Chart (main chart)

- **T1 Use Trendline** - Creates a trendline and only starts the operation when it prices breaks it;
- **T1 Trendline Extra** - Extra trend line value;
- **T1 Support and Resistance** - Only starts the operation when the T1 graphic displays tips and dips;
- **T1 thread Periods** - Amount of periods to be used in the thread;
- **T1 thread set Trend** - The thread in the T1 chart sets the trend. It only opens the operation if the thread is in favour of the operation;
- **T1 Moving Averange** - Number of periods used in the Moving Average;

### T2 Chart (Secondary Chart)

- **T2 Graph Extra** - Uses the secondary graph T2;
- **T2 Graph Time** - Time period used in graph T2;
- **T2 Support and Resistance** - Only starts the operation when the T2 graph displays tips and dips;
- **T2 thread Periods** - Amount of periods to be used in the thread;
- **T2 thread set Trend** - The thread in graph T2 defines the trend. It only opens the operation if the thread is in favour of the operation;
- **T2 Moving Averange** - Number of periods used in the Moving Average;

### Chart T3 (Tertiary Chart)

- **T3 Graph Extra** - uses secondary graph T3;
- **T3 Graph Time** - Time period used in graph T3;
- **T3 Support and Resistance** - Only starts the operation when the T3 chart displays tips and dips;
- **T3 thread Periods** - Amount of periods to be used in the thread;
- **T3 thread set Trend** - The thread in graph T3 defines the trend. It only opens the operation if the thread is in favour of the operation;
- **T3 Moving Averange** - Number of periods used in the Moving Average;

### Stop Loss Options

- **Stop Loss Min** - Minimum point difference between entry price and Stop Loss;
- **Stop Loss Max** - Maximum point difference between entry price and Stop Loss. If **Force entry** is active, the Stop Loss will be reduced to the value of **Stop Loss Max**, otherwise the operation will not be performed.
- **Extra Stop** - Additional Stop Loss points;
- **Stop Initial** - This is the Stop Loss model used to open the operation. Stop Loss types are valid for T1, T2 or T3 charts and are:
    * **Stop Fixed** - The Stop Loss value is a fixed value, based on the field **Stop Fixed value**;
    * **thread** - The Stop Loss is initially in the thread position and the price follows the change;
    * **Top/Bottom** - Stop Loss rises/falls as a new top or bottom appears;
    * **Worst Candle** - Stop Loss rises/falls below/above the previous Candle;
    * **Current Candle** - Stop Loss rises/falls below/above the current Candle;
- **Stop Fixed value** - Fixed Stop Loss value. The <Strong>Stop Initial</Strong> must be marked as **Stop Fixed**;
- **Force entry** - If active, the operation will be initialized by adjusting the Stop Loss value to **Stop Loss Max**. If it is not active, it will only initialize the operation if the Stop Loss value is within the limit of **Stop Loss Max**;

### Increase of position

- **Run Position Increase** - Use position increase. When you reach a new goal, if the volume is greater than zero the position will be increased;
- **Run Position Stop Extra** - Extra Stop Loss value used only for position increase;
- **Run Position Increase Minimal** - Minimum value that the price must move to allow a new entry;

### Break Even Options

- **Break Even Position** - Position where Break Even moves Stop Loss to the entry price position of the operation + **Break Even Value**;
- **Break Even Value** - Entry price + this field to move the Stop Loss;
- **Break Even Volume** - Volume to be performed when Break Even is reached. When negative will  the position, when positive will increase the position;

### Volume Options

- **Initial volume** - Initial operating volume;
- **Maximum volume** - Maximum volume of the operation. If increasing the running position is enabled, the volume may not pass this value;

#### Objective 1

- **Objective 1 Condition** - Condition for achieving objective 1. See options in **Entry condition**;
- **Objective 1 Volume** - Volume to be made when Objective 1 is reached. When negative will take the position, when positive will increase the position;
- **Objective 1 Position** - Fixed value for achieving objective 1.  **Objective 1 Condition** shall be marked as **Fixed Position**;
- **Objective 1 Stop** - This is the Stop Loss type used from the moment you reach target 1. See more details in the fields **Initial stop**;

#### Goal 2

- **Objective 2 Condition** - Condition for achieving objective 2. See options in **Entry condition**;
- **Objective 2 Volume** - Volume to be achieved when target 2 is reached. When negative will take the position, when positive will increase the position;
- **Objective 2 Position** - Fixed value for achieving objective 2.  **Objective 2 Condition** shall be marked as **Fixed Position**;
- **Objective 2 Stop** - This is the Stop Loss model used from the moment you reach target 2. See more details in the fields **Initial stop**;

#### Goal 3

- **Objective 3 Condition** - Condition for achieving objective 3. See options in **Entry condition**;
- **Objective 3 Volume** - Volume to be achieved when target 3 is reached. When negative will take the position, when positive will increase the position;
- **Objective 3 Position** - Fixed value to achieve objective 3. <Strong>Objective 3 Condition</Strong> must be marked as **Fixed**;
- **Objective 3 Stop** - This is the Stop Loss model used from the moment you reach target 3. See more details in the fields **Initial stop**;

## Histórico de lançamentos

* 1.02
    * Initial configuration revised and working
* 1.01
    * Initial version with organized code and unused objects removed
* 1.00
    * Initial version

## Meta

Rodrigo Landim - [@Landim32Oficial](https://twitter.com/landim32oficial) - rodrigo@emagine.com.br

Distributed under the GPLv2 license. See `LICENSE` for more information.

[https://github.com/landim32/LadinoBot](https://github.com/landim32/LadinoBot)

## Other Contributors

Juan Quinche (English README version) [https://github.com/juan12425](https://github.com/juan12425)

## How to Contribute

1. _fork_ the project (<https://github.com/landim32/LadinoBot/fork>)
2. Create a _branch_ for your modification (`git checkout -b landim32/LadinoBot`)
3. Do _commit_ (`git commit -am 'Add some fooBar'`)
4. Push_(`git push origin landim32/LadinoBot`)
5. Create a new _Pull Request_


## Donations

1. BTC: [18muAc1ktnJRbucfru4fkcgCwUNcTEbnJG](bitcoin://18muAc1ktnJRbucfru4fkcgCwUNcTEbnJG)



 
