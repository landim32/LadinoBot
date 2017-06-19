//+------------------------------------------------------------------+
//|                                                        Fibos.mq5 |
//|                                        Developed by Coders' Guru |
//|                                            http://www.xpworx.com |
//|                                        Last Modified: 2013.02.04 |
//+------------------------------------------------------------------+
#property copyright "Coders' Guru"
#property link      "http://www.xpworx.com"
#property version   "1.00"
//+------------------------------------------------------------------+
#property indicator_chart_window
#property indicator_buffers 8
#property indicator_plots   8
//+------------------------------------------------------------------+
input bool  HighToLow  = true;
input double Fibo_Level_1 = 0.236;
input double Fibo_Level_2 = 0.382;
input double Fibo_Level_3 = 0.500;
input double Fibo_Level_4 = 0.618;
input double Fibo_Level_5 = 0.764;
input double Fibo_Level_6 = 0.886;
input int    StartBar     = 0;
input int    BarsBack     = 20;
input bool   Pause        = false;
color VerticalLinesColor = clrRed;
color FiboLinesColors = clrBlue;
//+------------------------------------------------------------------+
double Fibo_Level_0 = 0.000;
double Fibo_Level_7 = 1.000;
//+------------------------------------------------------------------+
double f_1[];
double f_2[];
double f_3[];
double f_4[];
double f_5[];
double f_6[];
double f_7[];
double f_8[];
//+------------------------------------------------------------------+
#define MODE_OPEN 0
#define MODE_LOW 1
#define MODE_HIGH 2
#define MODE_CLOSE 3
#define MODE_VOLUME 4 
#define MODE_TIME 5
#define MODE_REAL_VOLUME 5
//+------------------------------------------------------------------+
int OnInit()
{
   SetIndexBuffer(0,f_1,INDICATOR_DATA);
   SetIndexBuffer(1,f_2,INDICATOR_DATA);
   SetIndexBuffer(2,f_3,INDICATOR_DATA);
   SetIndexBuffer(3,f_4,INDICATOR_DATA);
   SetIndexBuffer(4,f_5,INDICATOR_DATA);
   SetIndexBuffer(5,f_6,INDICATOR_DATA);
   SetIndexBuffer(6,f_7,INDICATOR_DATA);
   SetIndexBuffer(7,f_8,INDICATOR_DATA);
   
   PlotIndexSetString(0,PLOT_LABEL,"Fibo_"+DoubleToString(Fibo_Level_0,4));
   PlotIndexSetString(1,PLOT_LABEL,"Fibo_"+DoubleToString(Fibo_Level_1,4));
   PlotIndexSetString(2,PLOT_LABEL,"Fibo_"+DoubleToString(Fibo_Level_2,4));
   PlotIndexSetString(3,PLOT_LABEL,"Fibo_"+DoubleToString(Fibo_Level_3,4));
   PlotIndexSetString(4,PLOT_LABEL,"Fibo_"+DoubleToString(Fibo_Level_4,4));
   PlotIndexSetString(5,PLOT_LABEL,"Fibo_"+DoubleToString(Fibo_Level_5,4));
   PlotIndexSetString(6,PLOT_LABEL,"Fibo_"+DoubleToString(Fibo_Level_6,4));
   PlotIndexSetString(7,PLOT_LABEL,"Fibo_"+DoubleToString(Fibo_Level_7,4));
   
   ObjectsDeleteAll(0);
   
   return(0);
}   
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
   if(Pause==false)
   {
      int LowBar = 0, HighBar= 0;
      double LowValue = 0 ,HighValue = 0;
     
      int lowest_bar = iLowest(NULL,0,MODE_LOW,BarsBack,StartBar);
      int highest_bar = iHighest(NULL,0,MODE_HIGH,BarsBack,StartBar);
     
      double higher_point = 0;
      double lower_point = 0;
      HighValue=High(highest_bar);
      LowValue=Low(lowest_bar);
       
      if(HighToLow)
      {
         DrawVerticalLine("v_u_hl",highest_bar,VerticalLinesColor);
         DrawVerticalLine("v_l_hl",lowest_bar,VerticalLinesColor);
           
         if(ObjectFind(0,"trend_hl")<0)
         ObjectCreate(0,"trend_hl",OBJ_TREND,0,Time(highest_bar),HighValue,Time(lowest_bar),LowValue);
         ObjectSetInteger(0,"trend_hl",OBJPROP_TIME,0,Time(highest_bar));
         ObjectSetInteger(0,"trend_hl",OBJPROP_TIME,1,Time(lowest_bar));
         ObjectSetDouble(0,"trend_hl",OBJPROP_PRICE,0,HighValue);
         ObjectSetDouble(0,"trend_hl",OBJPROP_PRICE,1,LowValue);
         ObjectSetInteger(0,"trend_hl",OBJPROP_COLOR,VerticalLinesColor);
         ObjectSetInteger(0,"trend_hl",OBJPROP_STYLE,STYLE_DOT);
         ObjectSetInteger(0,"trend_hl",OBJPROP_RAY,false);
           
         if(ObjectFind(0,"Fibo_hl")<0)
         ObjectCreate(0,"Fibo_hl",OBJ_FIBO,0,0,HighValue,0,LowValue);  
         ObjectSetDouble(0,"Fibo_hl",OBJPROP_PRICE,0,HighValue);
         ObjectSetDouble(0,"Fibo_hl",OBJPROP_PRICE,1,LowValue);
         ObjectSetInteger(0,"Fibo_hl",OBJPROP_TIME,0,Time(highest_bar));
         ObjectSetInteger(0,"Fibo_hl",OBJPROP_TIME,1,Time(lowest_bar));
         ObjectSetInteger(0,"Fibo_hl",OBJPROP_COLOR,FiboLinesColors);
         ObjectSetInteger(0,"Fibo_hl",OBJPROP_LEVELCOLOR,0,FiboLinesColors);
         ObjectSetInteger(0,"Fibo_hl",OBJPROP_LEVELCOLOR,1,FiboLinesColors);
         ObjectSetInteger(0,"Fibo_hl",OBJPROP_LEVELCOLOR,2,FiboLinesColors);
         ObjectSetInteger(0,"Fibo_hl",OBJPROP_LEVELCOLOR,3,FiboLinesColors);
         ObjectSetInteger(0,"Fibo_hl",OBJPROP_LEVELCOLOR,4,FiboLinesColors);
         ObjectSetInteger(0,"Fibo_hl",OBJPROP_LEVELCOLOR,5,FiboLinesColors);
         ObjectSetInteger(0,"Fibo_hl",OBJPROP_LEVELCOLOR,6,FiboLinesColors);
         ObjectSetInteger(0,"Fibo_hl",OBJPROP_LEVELCOLOR,7,FiboLinesColors);
         ObjectSetInteger(0,"Fibo_hl",OBJPROP_LEVELS,8);
         ObjectSetDouble(0,"Fibo_hl",OBJPROP_LEVELVALUE,0,Fibo_Level_0);  
         ObjectSetDouble(0,"Fibo_hl",OBJPROP_LEVELVALUE,1,Fibo_Level_1); 
         ObjectSetDouble(0,"Fibo_hl",OBJPROP_LEVELVALUE,2,Fibo_Level_2);  
         ObjectSetDouble(0,"Fibo_hl",OBJPROP_LEVELVALUE,3,Fibo_Level_3);  
         ObjectSetDouble(0,"Fibo_hl",OBJPROP_LEVELVALUE,4,Fibo_Level_4);  
         ObjectSetDouble(0,"Fibo_hl",OBJPROP_LEVELVALUE,5,Fibo_Level_5); 
         ObjectSetDouble(0,"Fibo_hl",OBJPROP_LEVELVALUE,6,Fibo_Level_6);  
         ObjectSetDouble(0,"Fibo_hl",OBJPROP_LEVELVALUE,7,Fibo_Level_7); 
         ObjectSetInteger(0,"Fibo_hl",OBJPROP_RAY_RIGHT,true);
         ChartRedraw();           
           
         for(int i=prev_calculated;i<rates_total;i++)
         {
            f_8[i] = NormalizeDouble(LowValue+(HighValue-LowValue)*Fibo_Level_7,_Digits);
            f_7[i] = NormalizeDouble(LowValue+(HighValue-LowValue)*Fibo_Level_6,_Digits);
            f_6[i] = NormalizeDouble(LowValue+(HighValue-LowValue)*Fibo_Level_5,_Digits);
            f_5[i] = NormalizeDouble(LowValue+(HighValue-LowValue)*Fibo_Level_4,_Digits);
            f_4[i] = NormalizeDouble(LowValue+(HighValue-LowValue)*Fibo_Level_3,_Digits);
            f_3[i] = NormalizeDouble(LowValue+(HighValue-LowValue)*Fibo_Level_2,_Digits);
            f_2[i] = NormalizeDouble(LowValue+(HighValue-LowValue)*Fibo_Level_1,_Digits);
            f_1[i] = NormalizeDouble(LowValue+(HighValue-LowValue)*Fibo_Level_0,_Digits);
         }
      }
      else //LowToHigh
      {
         DrawVerticalLine("v_u_hl",highest_bar,VerticalLinesColor);
         DrawVerticalLine("v_l_hl",lowest_bar,VerticalLinesColor);
           
         if(ObjectFind(0,"trend_hl")<0)
         ObjectCreate(0,"trend_hl",OBJ_TREND,0,Time(lowest_bar),LowValue,Time(highest_bar),HighValue);
         ObjectSetInteger(0,"trend_hl",OBJPROP_TIME,0,Time(lowest_bar));
         ObjectSetInteger(0,"trend_hl",OBJPROP_TIME,1,Time(highest_bar));
         ObjectSetDouble(0,"trend_hl",OBJPROP_PRICE,0,LowValue);
         ObjectSetDouble(0,"trend_hl",OBJPROP_PRICE,1,HighValue);
         ObjectSetInteger(0,"trend_hl",OBJPROP_STYLE,STYLE_DOT);
         ObjectSetInteger(0,"trend_hl",OBJPROP_RAY,false);    
         
         if(ObjectFind(0,"Fibo_hl")<0)
         ObjectCreate(0,"Fibo_hl",OBJ_FIBO,0,0,LowValue,0,HighValue);  
         ObjectSetDouble(0,"Fibo_hl",OBJPROP_PRICE,0,LowValue);
         ObjectSetDouble(0,"Fibo_hl",OBJPROP_PRICE,1,HighValue);
         ObjectSetInteger(0,"Fibo_hl",OBJPROP_TIME,0,Time(lowest_bar));
         ObjectSetInteger(0,"Fibo_hl",OBJPROP_TIME,1,Time(highest_bar));
         ObjectSetInteger(0,"Fibo_hl",OBJPROP_LEVELCOLOR,FiboLinesColors);
         ObjectSetInteger(0,"Fibo_hl",OBJPROP_LEVELS,8);
         ObjectSetDouble(0,"Fibo_hl",OBJPROP_LEVELVALUE,0,Fibo_Level_0);   //ObjectSetFiboDescription("Fibo_hl",0,DoubleToStr(Fibo_Level_0,4));
         ObjectSetDouble(0,"Fibo_hl",OBJPROP_LEVELVALUE,1,Fibo_Level_1);   //ObjectSetFiboDescription("Fibo_hl",1,DoubleToStr(Fibo_Level_1,4));
         ObjectSetDouble(0,"Fibo_hl",OBJPROP_LEVELVALUE,2,Fibo_Level_2);   //ObjectSetFiboDescription("Fibo_hl",2,DoubleToStr(Fibo_Level_2,4));
         ObjectSetDouble(0,"Fibo_hl",OBJPROP_LEVELVALUE,3,Fibo_Level_3);   //ObjectSetFiboDescription("Fibo_hl",3,DoubleToStr(Fibo_Level_3,4));
         ObjectSetDouble(0,"Fibo_hl",OBJPROP_LEVELVALUE,4,Fibo_Level_4);   //ObjectSetFiboDescription("Fibo_hl",4,DoubleToStr(Fibo_Level_4,4));
         ObjectSetDouble(0,"Fibo_hl",OBJPROP_LEVELVALUE,5,Fibo_Level_5);   //ObjectSetFiboDescription("Fibo_hl",5,DoubleToStr(Fibo_Level_5,4));
         ObjectSetDouble(0,"Fibo_hl",OBJPROP_LEVELVALUE,6,Fibo_Level_6);   //ObjectSetFiboDescription("Fibo_hl",6,DoubleToStr(Fibo_Level_6,4));
         ObjectSetDouble(0,"Fibo_hl",OBJPROP_LEVELVALUE,7,Fibo_Level_7);   //ObjectSetFiboDescription("Fibo_hl",7,DoubleToStr(Fibo_Level_7,4));
         ObjectSetInteger(0,"Fibo_hl",OBJPROP_RAY_RIGHT,true);
         ChartRedraw();    
         
         for(int i=prev_calculated;i<rates_total;i++)
         {
            f_8[i] = NormalizeDouble(LowValue,_Digits);
            f_7[i] = NormalizeDouble(HighValue-(HighValue-LowValue)*Fibo_Level_6,_Digits);
            f_6[i] = NormalizeDouble(HighValue-(HighValue-LowValue)*Fibo_Level_5,_Digits);
            f_5[i] = NormalizeDouble(HighValue-(HighValue-LowValue)*Fibo_Level_4,_Digits);
            f_4[i] = NormalizeDouble(HighValue-(HighValue-LowValue)*Fibo_Level_3,_Digits);
            f_3[i] = NormalizeDouble(HighValue-(HighValue-LowValue)*Fibo_Level_2,_Digits);
            f_2[i] = NormalizeDouble(HighValue-(HighValue-LowValue)*Fibo_Level_1,_Digits);
            f_1[i] = NormalizeDouble(HighValue,_Digits);
         }
      }
   }
   return(rates_total);
}
//+------------------------------------------------------------------+
void DrawVerticalLine(string name , int bar , color clr)
{
   if(ObjectFind(0,name)<0)
   {
      ObjectCreate(0,name,OBJ_VLINE,0,Time(bar),0);
      ObjectSetInteger(0,name,OBJPROP_COLOR,clr);
      ObjectSetInteger(0,name,OBJPROP_STYLE,STYLE_DASH);
      ObjectSetInteger(0,name,OBJPROP_WIDTH,1);
      ChartRedraw();
   }
   else
   {    
      ObjectSetInteger(0,name,OBJPROP_TIME,Time(bar));
      ObjectSetInteger(0,name,OBJPROP_COLOR,clr);
      ObjectSetInteger(0,name,OBJPROP_STYLE,STYLE_DASH);
      ObjectSetInteger(0,name,OBJPROP_WIDTH,1);
      ChartRedraw();
   }

}
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   ObjectsDeleteAll(0);
}
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
// Some MQ4 style code
//+------------------------------------------------------------------+
int iHighest(string symbol, int timeframe, int type=MODE_HIGH, int count=WHOLE_ARRAY, int start=0)
{
   if(start <0) return(-1);

   if(count==0) count=Bars(symbol,ToTimeFrame(timeframe));
   
   if(type==MODE_HIGH)
   {
      double Arr[];
      if(CopyHigh(symbol,ToTimeFrame(timeframe),start,count,Arr)>0)  return((count-ArrayMaximum(Arr)-1)+start);
      else return(-1);
   } 
   else if(type==MODE_LOW)
   {   
      double Arr[];
      if(CopyLow(symbol,ToTimeFrame(timeframe),start,count,Arr)>0) return((count-ArrayMaximum(Arr)-1)+start);
      else return(-1);
   }
   else if(type==MODE_OPEN)
   {   
      double Arr[];
      if(CopyOpen(symbol,ToTimeFrame(timeframe),start,count,Arr)>0) return((count-ArrayMaximum(Arr)-1)+start);
      else return(-1);
   }  
   else if(type==MODE_CLOSE)
   {
      double Arr[];
      if(CopyClose(symbol,ToTimeFrame(timeframe),start,count,Arr)>0) return((count-ArrayMaximum(Arr)-1)+start);
      else return(-1);
   }      
   else if(type==MODE_VOLUME)
   {
      long Arr[];
      if(CopyTickVolume(symbol,ToTimeFrame(timeframe),start,count,Arr)>0) return((count-ArrayMaximum(Arr)-1)+start);
      else return(-1);
   }      
   else if(type==MODE_REAL_VOLUME)
   {
      long Arr[];
      if(CopyRealVolume(symbol,ToTimeFrame(timeframe),start,count,Arr)>0) return((count-ArrayMaximum(Arr)-1)+start);
      else return(-1);
   }            
   else return(-1);
}
//+------------------------------------------------------------------+
int iLowest(string symbol, int timeframe, int type=MODE_LOW, int count=WHOLE_ARRAY, int start=0)
{
   if(start <0) return(-1);
   
   if(count==0) count=Bars(symbol,ToTimeFrame(timeframe));   
   
   if(type==MODE_LOW)
   {         
      double Arr[];
      if(CopyLow(symbol,ToTimeFrame(timeframe),start,count,Arr)>0)  return((count-ArrayMinimum(Arr)-1)+start);
      else return(-1);
   }
   else if(type==MODE_HIGH)
   {
      double Arr[];
      if(CopyHigh(symbol,ToTimeFrame(timeframe),start,count,Arr)>0) return((count-ArrayMinimum(Arr)-1)+start);
      else return(-1);
   }
   if(type==MODE_OPEN)
   {   
      double Arr[];
      if(CopyOpen(symbol,ToTimeFrame(timeframe),start,count,Arr)>0) return((count-ArrayMinimum(Arr)-1)+start);
      else return(-1);
   }
   else if(type==MODE_CLOSE)
   {
      double Arr[];
      if(CopyClose(symbol,ToTimeFrame(timeframe),start,count,Arr)>0) return((count-ArrayMinimum(Arr)-1)+start);
      else return(-1);
   }   
   else if(type==MODE_VOLUME)
   {
      long Arr[];
      if(CopyTickVolume(symbol,ToTimeFrame(timeframe),start,count,Arr)>0) return((count-ArrayMinimum(Arr)-1)+start);
      else return(-1);
   }      
   else if(type==MODE_REAL_VOLUME)
   {
      long Arr[];
      if(CopyRealVolume(symbol,ToTimeFrame(timeframe),start,count,Arr)>0) return((count-ArrayMinimum(Arr)-1)+start);
      else return(-1);
   }         
   else return(-1);
}
//+------------------------------------------------------------------+
double iHigh(string symbol, int timeframe, int shift) 
{
  if(shift < 0) return(-1);  
  double Arr[];
  if(CopyHigh(symbol, ToTimeFrame(timeframe), shift, 1, Arr)>0) return(Arr[0]);
  return(-1);
} 
//+------------------------------------------------------------------+
double iLow(string symbol, int timeframe, int shift) 
{
  if(shift < 0) return(-1);  
  double Arr[];
  if(CopyLow(symbol, ToTimeFrame(timeframe), shift, 1, Arr)>0) return(Arr[0]);
  return(-1);
} 
//+------------------------------------------------------------------+
datetime iTime(string symbol, int timeframe, int shift) 
{
  if(shift < 0) return(-1);  
  datetime Arr[];
  if(CopyTime(symbol, ToTimeFrame(timeframe), shift, 1, Arr)>0) return(Arr[0]);
  return(-1);
} 
//+------------------------------------------------------------------+
double High(int bar=0) {return (iHigh(Symbol(),0,bar));}
double Low(int bar=0) {return (iLow(Symbol(),0,bar));}
datetime Time(int bar=0) {return (iTime(Symbol(),0,bar));}
//+------------------------------------------------------------------+
ENUM_TIMEFRAMES ToTimeFrame(int timeframe)
{  
   switch(timeframe)
   {
      case 0: return(PERIOD_CURRENT);
      case 1: return(PERIOD_M1);
      case 5: return(PERIOD_M5);
      case 15: return(PERIOD_M15);
      case 30: return(PERIOD_M30);
      case 60: return(PERIOD_H1);
      case 240: return(PERIOD_H4);
      case 1440: return(PERIOD_D1);
      case 10080: return(PERIOD_W1);
      case 43200: return(PERIOD_MN1);
   }
   return(PERIOD_CURRENT);
}
//+------------------------------------------------------------------+
