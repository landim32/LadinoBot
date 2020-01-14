//+------------------------------------------------------------------+
//|                                           TrendLinesCrossing.mq5 |
//|                                            Copyright 2012, Rone. |
//|                                            rone.sergey@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, Rone."
#property link      "rone.sergey@gmail.com"
#property version   "1.00"
#property description "Trend Lines Crossing"
//+------------------------------------------------------------------+
//| includes                                                         |
//+------------------------------------------------------------------+
#include <ChartObjects\ChartObjectsTxtControls.mqh>
//+------------------------------------------------------------------+
//| Indicator settings                                               |
//+------------------------------------------------------------------+
#property indicator_chart_window
//+------------------------------------------------------------------+
//| Structs and enums                                                |
//+------------------------------------------------------------------+
struct lineData {
   string name;
   double curPrice;
   bool crossing;
   int counter;
};
//---
enum SIG_MODE {
   NO_SIG,        // No signal
   ONLY_SOUND,    // Only sound
   ALERT          // Alert
};
//+------------------------------------------------------------------+
//| Input parameters                                                 |
//+------------------------------------------------------------------+
input SIG_MODE InpSignalMode = ONLY_SOUND;      // Signal mode
input int      InpPause = 3;                    // Seconds between signals
input int      InpSignals = 5;                  // Signals Quantity
input string   InpSoundName = "alarm.wav";      // Sound Filename
input bool     InpShowInfo = true;              // Show Lines Info
input string   InpLabelPrefix = "Tsl_Label_";   // Label name prefix
//+------------------------------------------------------------------+
//| Global variables                                                 |
//+------------------------------------------------------------------+
int            pause;
int            signals;
string         fileName;
string         labelPrefix;
int            prefixLen;
string         btnName;
//---
lineData             lines[];
CChartObjectButton   updateBtn;
CChartObjectLabel    header[2];
CChartObjectLabel    nameLabels[];
CChartObjectLabel    priceLabels[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {
//---
   if ( InpPause < 1 || InpPause > 60 ) {
      pause = 5;
      printf("Incorrected input parameter InpPause = %d. Indicator will use value %d.", InpPause, pause);
   } else {
      pause = InpPause;
   }
//---
   if ( InpSignals < 1 || InpSignals > 50 ) {
      signals = 5;
      printf("Incorrected input parameter InpSignals = %d. Indicator will use value %d.", InpSignals, signals);
   } else {
      signals = InpSignals;
   }
//---
   if ( FileIsExist(InpSoundName, 0) == false ) {
      fileName = "alert.wav";
      printf("The file named %s does not exist. Indicator will use file %s", InpSoundName, fileName);
   } else {
      fileName = "\\Files\\" + InpSoundName;
   }
//---
   prefixLen = StringLen(InpLabelPrefix);
   if ( prefixLen < 5 ) {
      labelPrefix = "Tsl_Label_";
      prefixLen = StringLen(labelPrefix);
      printf("Incorrected input parameter InpLabelPrefix = %s. Indicator will use value %s.", InpLabelPrefix, labelPrefix);
   } else {
      labelPrefix = InpLabelPrefix;
   }
   btnName = labelPrefix + "UpdateButton";
//---
   deleteIndLabels();
   if ( InpShowInfo ) {
      createButton();
   }
//---
   ChartSetInteger(0, CHART_EVENT_OBJECT_DELETE, true);
//---
   EventSetTimer(pause);
//---
   return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
//---
   deleteIndLabels();
   if ( ObjectFind(0, btnName) == 0 ) {
      ObjectDelete(0, btnName);
   }
   EventKillTimer();
//---
}
//+------------------------------------------------------------------+
//| Create Update button function                                    |
//+------------------------------------------------------------------+
void createButton() {
//---
   if ( ObjectFind(0, btnName) < 0 ) {
      int sy = (ChartGetInteger(0, CHART_SHOW_OHLC)) ? 26 : 10;
      
      updateBtn.Create(0, btnName, 0, 10, sy, 100, 20);
      updateBtn.Description("Update Info");
      updateBtn.Color(clrGreen);
      updateBtn.FontSize(8);
   }
//---
}
//+------------------------------------------------------------------+
//| Update trend lines info function                                 |
//+------------------------------------------------------------------+
void updateInfo() {
//---
   datetime time[1];
//---
   if ( CopyTime(_Symbol, _Period, 0, 1, time) != 1 ) {
      Print("CopyTime Failed. Error #", GetLastError());
      return;
   }
   checkTrendLines(time[0]);
//---
}
//+------------------------------------------------------------------+
//| Delete indicator labels function                                 |
//+------------------------------------------------------------------+
void deleteIndLabels() {
//---
   int total = ObjectsTotal(0, 0, OBJ_LABEL);
   
   for ( int i = 0; i < total; i++ ) {
      string name = ObjectName(0, i, 0, OBJ_LABEL);
      
      if ( StringSubstr(name, 0, prefixLen) == labelPrefix ) {
         ObjectDelete(0, name);
      }
   }
   ChartRedraw();
//---
}
//+------------------------------------------------------------------+
//| Check trend lines function                                       |
//+------------------------------------------------------------------+
void checkTrendLines(datetime time) {
//---
   int total = ObjectsTotal(0, 0, OBJ_TREND);
//---   
   ArrayFree(lines);
   ArrayResize(lines, total);
//---
   for ( int i = 0; i < total; i++ ) {
      lines[i].name = ObjectName(0, i, 0, OBJ_TREND);
      lines[i].curPrice = NormalizeDouble(ObjectGetValueByTime(0, lines[i].name, time), _Digits+1);
      lines[i].crossing = false;
      lines[i].counter = 0;
   }
//---   
   if ( InpShowInfo ) {
      showInfo(total);
   }
//---
}
//+------------------------------------------------------------------+
//| Show trend lines info function                                   |
//+------------------------------------------------------------------+
void showInfo(int total) {
//---
   deleteIndLabels();
//---
   ArrayFree(nameLabels);
   ArrayFree(priceLabels);
   ArrayResize(nameLabels, total);
   ArrayResize(priceLabels, total);
//---
   int sy = (ChartGetInteger(0, CHART_SHOW_OHLC)) ? 50 : 34;
   int dy = 16;
   color nameColor, priceColor;
   
   nameColor = (color)(ChartGetInteger(0, CHART_COLOR_BACKGROUND)^0xFFFFFF);
   priceColor = (color)(nameColor^0x202020);
//---  
   header[0].Create(0, labelPrefix+"Total", 0, 10, sy);
   header[0].Description("Total");
   header[0].Color(nameColor);
   header[0].FontSize(8);
   //---
   header[1].Create(0, labelPrefix+"Qty", 0, 120, sy);
   header[1].Description(IntegerToString(total));
   header[1].Color(priceColor);
   header[1].FontSize(8);
//---
   sy += 20;
//---   
   for ( int i = 0; i < total; i++ ) {
      nameLabels[i].Create(0, labelPrefix+"Name"+IntegerToString(i), 0, 10, sy+dy*i);
      nameLabels[i].Description(lines[i].name);
      nameLabels[i].Color(nameColor);
      nameLabels[i].FontSize(8);
      //---
      priceLabels[i].Create(0, labelPrefix+"Price"+IntegerToString(i), 0, 120, sy+dy*i);
      priceLabels[i].Description(DoubleToString(lines[i].curPrice, _Digits+1));
      priceLabels[i].Color(priceColor);
      priceLabels[i].FontSize(8);
   }
   
   ChartRedraw();
//---
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
//---
   int lastBar = rates_total - 1;
//---   
   if ( prev_calculated != rates_total ) {
      checkTrendLines(time[lastBar]);
   }
//---
   int size = ArraySize(lines);
      
   for ( int i = 0; i < size; i++ ) {
      int prevBar = lastBar - 1;
      double price = lines[i].curPrice;
         
      if ( (MathMin(close[prevBar], open[lastBar]) < price && close[lastBar] >= price) ||
         (MathMax(close[prevBar], open[lastBar]) > price && close[lastBar] <= price) )
      {
         lines[i].crossing = true;
         if ( InpShowInfo ) {
            color lineColor = (color)ObjectGetInteger(0, lines[i].name, OBJPROP_COLOR);
            nameLabels[i].Color(lineColor);
            priceLabels[i].Color(lineColor);
         }
      }
   }
//--- return value of prev_calculated for next call
   return(rates_total);
}
//+------------------------------------------------------------------+
//| Custom indicator timer function                                  |
//+------------------------------------------------------------------+
void OnTimer() {
//---
   if ( InpSignalMode == NO_SIG ) {
      return;
   }
//---
   int size = ArraySize(lines);
   
   for ( int i = 0; i < size; i++ ) {
      if ( lines[i].crossing && lines[i].counter < signals ) {
         if ( InpSignalMode == ONLY_SOUND ) {
            PlaySound(fileName);
         } else {
            Alert("Price crossed TrendLine named ", lines[i].name, " at ", DoubleToString(lines[i].curPrice, _Digits+1));
         }
         lines[i].counter += 1;
      }
   }
//---
}
//+------------------------------------------------------------------+
//| Custom indicator chart event function                            |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
//---
   if ( id == CHARTEVENT_OBJECT_CHANGE || id == CHARTEVENT_OBJECT_DRAG ||
      (id == CHARTEVENT_OBJECT_DELETE && StringSubstr(sparam, 0, prefixLen) != labelPrefix) ) 
   {
      updateInfo();
   }
   if ( updateBtn.State() ) {
      updateBtn.State(false);
      updateInfo();
   }
//---
}
//+------------------------------------------------------------------+
