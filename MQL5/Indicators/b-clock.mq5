//+------------------------------------------------------------------+
//|                                                      b-clock.mq5 |
//|                                Copyright 2013, Totom Sukopratomo |
//|                        https://login.mql5.com/en/users/tomsuk001 |
//|                                      totom.sukopratomo@yahoo.com |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                   Convert from : |
//+--------                                                          +
//|                                                      b-clock.mq4 |
//|                                     Core time code by Nick Bilak |
//|        http://metatrader.50webs.com/         beluck[at]gmail.com |
//|                                  modified by adoleh2000 and dwt5 | 
//+-----                                                             +
//|        Original MQL4 code found at: http://codebase.mql4.com/590 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, Totom Sukopratomo"
#property link      "https://login.mql5.com/en/users/tomsuk001"
#property version   "2.00"
#property indicator_chart_window
//--- input parameters
input bool     ShowComment=true;
input color    FontColor=clrDarkGray;
input int      FontSize=10;
input string   FontName="Tahoma";
input int      Offset=5;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping

//---
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                        |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   Comment("");
   ObjectDelete(0,"time");
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const int begin,
                const double &price[])
  {
   MqlRates rates[];
   MqlTick tick;
   SymbolInfoTick(Symbol(),tick);
   if(CopyRates(Symbol(),PERIOD_CURRENT,0,1,rates)<1)return(0);
   double i;
   long m,s;
   m=rates[0].time+GetMinute()*60-tick.time;
   i=m/60.0;
   s=m%60;
   m=(m-m%60)/60;

   if(ShowComment)
      Comment(IntegerToString(m,0,' ')+" minutes "+IntegerToString(s,0,' ')+" seconds left to bar end");

   string text="  <"+IntegerToString(m,0,' ')+":"+IntegerToString(s,0,' ');
   if(ObjectFind(0,"time")<1)
     {
      ObjectCreate(0,"time",OBJ_TEXT,0,rates[0].time,tick.bid+Point()*Offset);
      ObjectSetString(0,"time",OBJPROP_TEXT,text);
      ObjectSetInteger(0,"time",OBJPROP_COLOR,FontColor);
      ObjectSetInteger(0,"time",OBJPROP_FONTSIZE,FontSize);
      ObjectSetString(0,"time",OBJPROP_FONT,FontName);
     }
   else
     {
      ObjectSetString(0,"time",OBJPROP_TEXT,text);
      ObjectMove(0,"time",0,rates[0].time,tick.bid+Point()*Offset);
     }
//---

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+

int GetMinute()
  {
   switch(Period())
     {
      case PERIOD_M1: return(1);
      case PERIOD_M2: return(2);
      case PERIOD_M3: return(3);
      case PERIOD_M4: return(4);
      case PERIOD_M5: return(5);
      case PERIOD_M6: return(6);
      case PERIOD_M10: return(10);
      case PERIOD_M12: return(12);
      case PERIOD_M15: return(15);
      case PERIOD_M20: return(20);
      case PERIOD_M30: return(30);
      case PERIOD_H1: return(60);
      case PERIOD_H2: return(120);
      case PERIOD_H3: return(180);
      case PERIOD_H4: return(240);
      case PERIOD_H6: return(360);
      case PERIOD_H8: return(480);
      case PERIOD_H12: return(720);
      case PERIOD_D1: return(1440);
      case PERIOD_W1: return(10080);
      case PERIOD_MN1: return(43200);
     }
   return(1);
  }
//+------------------------------------------------------------------+
