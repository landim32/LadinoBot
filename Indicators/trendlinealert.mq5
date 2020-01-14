//+------------------------------------------------------------------+
//|                                               TrendLineAlert.mq5 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Coders' Guru"
#property link      "http://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_plots   0
//--- input parameters
enum Direction
{
   up = 0, //Up Direction
   dn = 1, //Down Direction
   both = 2 //Both Directiond
};
input string   TrendLineName = "WL1"; //Enter Trend Line Name
input Direction      TouchDirection; //Enter the Touch Direction
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
   if(TrendLineName!="")
   {
      double TrendValue = GetTrend(TrendLineName);
      Comment("Trend Line("+TrendLineName+") value = "+DoubleToString(TrendValue,_Digits)); 
      if(TrendValue>0)
      {
         ArraySetAsSeries(close,true);
         ArraySetAsSeries(low,true);
         ArraySetAsSeries(high,true);
         if((TouchDirection==0 || TouchDirection==2) && close[0]>=TrendValue && low[0]<TrendValue)
         {
            AlertOnce("Price touched UP the trendline!",0);
            SendMailOnce("UP","Price touched UP the trendline!",0);
         }
         if((TouchDirection==0 || TouchDirection==2) && close[0]<=TrendValue && high[0]>TrendValue)
         {
            AlertOnce("Price touched DOWN the trendline!",1);
            SendMailOnce("DOWN","Price touched DOWN the trendline!",1);
         }         
      }
   }
   return(rates_total);
}
//+------------------------------------------------------------------+
double GetTrend(string trend_name)
{
   for(int cnt=0; cnt<ObjectsTotal(0); cnt++)
   {
      string objName = ObjectName(0,cnt);
      
      if(StringFind(objName,trend_name)>-1)
      {
         return(ObjectGetValueByTime(0,objName,TimeCurrent()));
      }      
   }
   return(0);
}
//+------------------------------------------------------------------+
bool AlertOnce(string msg, int ref)
{  
   static int LastAlert[3];
   
   if( LastAlert[ref] == 0 || LastAlert[ref] < Bars(_Symbol,_Period))
   {
      Alert(msg);
      LastAlert[ref] = Bars(_Symbol,_Period);
      return (true);
   }
   return(false);
}
//+------------------------------------------------------------------+
bool SendMailOnce(string subject, string body, int ref)
{  
   static int LastAlert[3];
   
   if( LastAlert[ref] == 0 || LastAlert[ref] < Bars(_Symbol,_Period))
   {
      SendMail(subject,body);
      LastAlert[ref] = Bars(_Symbol,_Period);
      return (true);
   }
   return(false);
}
//+------------------------------------------------------------------+