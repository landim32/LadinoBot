//+------------------------------------------------------------------+
//|                                                 ChartInChart.mq5 |
//|                   Copyright 2009-2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "2009-2017, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
//--- inputs
input color TextColor=White;
input color BGColor=SteelBlue;
input int   XPosition=10;
input int   YPosition=10;
input int   XSize=450;
input int   YSize=300;
//--- variables
int xsize=450;
int ysize=300;
int xdist=10;
int ydist=10;
int scale=1;
int show=1;
int showdates =0;
int showprices=0;
//---
string          curr_symbol;
string          curr_period_str;
ENUM_TIMEFRAMES curr_period;
ENUM_TIMEFRAMES enper;
//+------------------------------------------------------------------+
//| Initialize expert                                                |
//+------------------------------------------------------------------+
void OnInit()
  {
//--- default value for symbol and period
   curr_symbol=Symbol();
   curr_period=Period();
   PeriodToStr(curr_period,curr_period_str);
//--- copy sizes
   xsize=XSize;
   ysize=YSize;
   xdist=XPosition;
   ydist=YPosition;
//--- create objects
   PIPCreate();
   PIPSetParams();
//---
   ChartRedraw();
  }
//+------------------------------------------------------------------+
//| Process chart events                                             |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,const long& lparam,const double& dparam,const string& sparam)
  {
   if(id==CHARTEVENT_OBJECT_ENDEDIT && sparam=="PIPSymbol")
     {
      curr_symbol=ObjectGetString(0,"PIPSymbol",OBJPROP_TEXT);
      ObjectSetString(0,"PIPChart",OBJPROP_SYMBOL,curr_symbol);
      ChartRedraw();
      //--- check symbol
      curr_symbol=ObjectGetString(0,"PIPChart",OBJPROP_SYMBOL);
      ObjectSetString(0,"PIPSymbol",OBJPROP_TEXT,curr_symbol);
     }
   else
   if(id==CHARTEVENT_OBJECT_ENDEDIT && sparam=="PIPPeriod")
     {
      string per=ObjectGetString(0,"PIPPeriod",OBJPROP_TEXT);
      if(StrToPeriod(per,enper))
        {
         if(enper) curr_period=enper;
         PeriodToStr(curr_period,curr_period_str);
         ObjectSetInteger(0,"PIPChart",OBJPROP_PERIOD,curr_period);
         ChartRedraw();
        }
     }
   else
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="PIPPricesButton")
     {
      showprices=(int)ObjectGetInteger(0,"PIPPricesButton",OBJPROP_STATE);
      ObjectSetInteger(0,"PIPChart",OBJPROP_PRICE_SCALE,showprices);
      ChartRedraw();
     }
   else   
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="PIPDatesButton")
     {
      showdates=(int)ObjectGetInteger(0,"PIPDatesButton",OBJPROP_STATE);
      ObjectSetInteger(0,"PIPChart",OBJPROP_DATE_SCALE,showdates);
      ChartRedraw();
     }
   else   
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="PIPPlusButton")
     {
      ObjectSetInteger(0,"PIPPlusButton",OBJPROP_STATE,0);
      if(scale<5)
        {
         scale++;
         ObjectSetInteger(0,"PIPChart",OBJPROP_CHART_SCALE,scale);
        }
      ChartRedraw();
     }
   else
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="PIPMinusButton")
     {
      ObjectSetInteger(0,"PIPMinusButton",OBJPROP_STATE,0);
      if(scale>0)
        {
         scale--;
         ObjectSetInteger(0,"PIPChart",OBJPROP_CHART_SCALE,scale);
        }
      ChartRedraw();
     }
   else
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="PIPHideButton")
     {
      ObjectSetInteger(0,"PIPHideButton",OBJPROP_STATE,0);
      if(show)
        {
         //--- hide chart
         ObjectSetString(0,"PIPHideButton",OBJPROP_TEXT,"\n");
         PIPHideChart();
        }
      else
        {
         //--- restore chart
         PIPSetParams();
        }
      //--- change state
      show=1-show;
      ChartRedraw();
     }
  }
//+------------------------------------------------------------------+
//| Deinitialize expert                                              |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- delete all our objects
   PIPDelete();
//---
   ChartRedraw();
  }
//+------------------------------------------------------------------+
//| Create objects                                                   |
//+------------------------------------------------------------------+
void PIPCreate()
  {
   ObjectCreate(0,"PIPSymbol",OBJ_EDIT,0,0,0,0,0);
   ObjectCreate(0,"PIPPeriod",OBJ_EDIT,0,0,0,0,0);
   ObjectCreate(0,"PIPPlusButton",OBJ_BUTTON,0,0,0,0,0);
   ObjectCreate(0,"PIPMinusButton",OBJ_BUTTON,0,0,0,0,0);
   ObjectCreate(0,"PIPHideButton",OBJ_BUTTON,0,0,0,0,0);
   ObjectCreate(0,"PIPDatesButton",OBJ_BUTTON,0,0,0,0,0);
   ObjectCreate(0,"PIPPricesButton",OBJ_BUTTON,0,0,0,0,0);
   ObjectCreate(0,"PIPChart",OBJ_CHART,0,0,0,0,0);
  }
//+------------------------------------------------------------------+
//| Delete objects                                                   |
//+------------------------------------------------------------------+
void PIPDelete()
  {
   ObjectDelete(0,"PIPSymbol");
   ObjectDelete(0,"PIPPeriod");
   ObjectDelete(0,"PIPPlusButton");
   ObjectDelete(0,"PIPMinusButton");
   ObjectDelete(0,"PIPHideButton");
   ObjectDelete(0,"PIPDatesButton");
   ObjectDelete(0,"PIPPricesButton");
   ObjectDelete(0,"PIPChart");
  }
//+------------------------------------------------------------------+
//| Set objects params                                               |
//+------------------------------------------------------------------+
void PIPSetParams()
  {
//--- check size
   if(xsize<250) xsize=250;
   if(ysize<100) ysize=100;
//--- Symbol
   ObjectSetInteger(0,"PIPSymbol",OBJPROP_COLOR,TextColor);
   ObjectSetInteger(0,"PIPSymbol",OBJPROP_BGCOLOR,BGColor);
   ObjectSetInteger(0,"PIPSymbol",OBJPROP_XDISTANCE,xdist);
   ObjectSetInteger(0,"PIPSymbol",OBJPROP_YDISTANCE,ydist);
   ObjectSetInteger(0,"PIPSymbol",OBJPROP_XSIZE,xsize-198);
   ObjectSetInteger(0,"PIPSymbol",OBJPROP_YSIZE,18);
   ObjectSetString(0,"PIPSymbol",OBJPROP_FONT,"Arial");
   ObjectSetString(0,"PIPSymbol",OBJPROP_TEXT,curr_symbol);
   ObjectSetInteger(0,"PIPSymbol",OBJPROP_FONTSIZE,10);
   ObjectSetInteger(0,"PIPSymbol",OBJPROP_SELECTABLE,0);
//--- Period
   ObjectSetInteger(0,"PIPPeriod",OBJPROP_COLOR,TextColor);
   ObjectSetInteger(0,"PIPPeriod",OBJPROP_BGCOLOR,BGColor);
   ObjectSetInteger(0,"PIPPeriod",OBJPROP_XDISTANCE,xdist+xsize-197);
   ObjectSetInteger(0,"PIPPeriod",OBJPROP_YDISTANCE,ydist);
   ObjectSetInteger(0,"PIPPeriod",OBJPROP_XSIZE,40);
   ObjectSetInteger(0,"PIPPeriod",OBJPROP_YSIZE,18);
   ObjectSetString(0,"PIPPeriod",OBJPROP_FONT,"Arial");
   ObjectSetString(0,"PIPPeriod",OBJPROP_TEXT,curr_period_str);
   ObjectSetInteger(0,"PIPPeriod",OBJPROP_FONTSIZE,10);
   ObjectSetInteger(0,"PIPPeriod",OBJPROP_SELECTABLE,0);
//--- Dates
   ObjectSetInteger(0,"PIPDatesButton",OBJPROP_COLOR,TextColor);
   ObjectSetInteger(0,"PIPDatesButton",OBJPROP_BGCOLOR,BGColor);
   ObjectSetInteger(0,"PIPDatesButton",OBJPROP_XDISTANCE,xdist+xsize-156);
   ObjectSetInteger(0,"PIPDatesButton",OBJPROP_YDISTANCE,ydist);
   ObjectSetInteger(0,"PIPDatesButton",OBJPROP_XSIZE,49);
   ObjectSetInteger(0,"PIPDatesButton",OBJPROP_YSIZE,18);
   ObjectSetString(0,"PIPDatesButton",OBJPROP_TEXT,"Dates");
   ObjectSetString(0,"PIPDatesButton",OBJPROP_FONT,"Arial");
   ObjectSetInteger(0,"PIPDatesButton",OBJPROP_FONTSIZE,10);
   ObjectSetInteger(0,"PIPDatesButton",OBJPROP_STATE,showdates);
   ObjectSetInteger(0,"PIPDatesButton",OBJPROP_SELECTABLE,0);
//--- Prices
   ObjectSetInteger(0,"PIPPricesButton",OBJPROP_COLOR,TextColor);
   ObjectSetInteger(0,"PIPPricesButton",OBJPROP_BGCOLOR,BGColor);
   ObjectSetInteger(0,"PIPPricesButton",OBJPROP_XDISTANCE,xdist+xsize-106);
   ObjectSetInteger(0,"PIPPricesButton",OBJPROP_YDISTANCE,ydist);
   ObjectSetInteger(0,"PIPPricesButton",OBJPROP_XSIZE,49);
   ObjectSetInteger(0,"PIPPricesButton",OBJPROP_YSIZE,18);
   ObjectSetString(0,"PIPPricesButton",OBJPROP_TEXT,"Prices");
   ObjectSetString(0,"PIPPricesButton",OBJPROP_FONT,"Arial");
   ObjectSetInteger(0,"PIPPricesButton",OBJPROP_FONTSIZE,10);
   ObjectSetInteger(0,"PIPPricesButton",OBJPROP_STATE,showprices);
   ObjectSetInteger(0,"PIPPricesButton",OBJPROP_SELECTABLE,0);   
//--- Scale +
   ObjectSetInteger(0,"PIPPlusButton",OBJPROP_COLOR,TextColor);
   ObjectSetInteger(0,"PIPPlusButton",OBJPROP_BGCOLOR,BGColor);
   ObjectSetInteger(0,"PIPPlusButton",OBJPROP_XDISTANCE,xdist+xsize-56);
   ObjectSetInteger(0,"PIPPlusButton",OBJPROP_YDISTANCE,ydist);
   ObjectSetInteger(0,"PIPPlusButton",OBJPROP_XSIZE,18);
   ObjectSetInteger(0,"PIPPlusButton",OBJPROP_YSIZE,18);
   ObjectSetString(0,"PIPPlusButton",OBJPROP_TEXT,"+");
   ObjectSetString(0,"PIPPlusButton",OBJPROP_FONT,"Arial");
   ObjectSetInteger(0,"PIPPlusButton",OBJPROP_FONTSIZE,10);
   ObjectSetInteger(0,"PIPPlusButton",OBJPROP_STATE,0);
   ObjectSetInteger(0,"PIPPlusButton",OBJPROP_SELECTABLE,0);
//--- Scale -
   ObjectSetInteger(0,"PIPMinusButton",OBJPROP_COLOR,TextColor);
   ObjectSetInteger(0,"PIPMinusButton",OBJPROP_BGCOLOR,BGColor);
   ObjectSetInteger(0,"PIPMinusButton",OBJPROP_XDISTANCE,xdist+xsize-37);
   ObjectSetInteger(0,"PIPMinusButton",OBJPROP_YDISTANCE,ydist);
   ObjectSetInteger(0,"PIPMinusButton",OBJPROP_XSIZE,18);
   ObjectSetInteger(0,"PIPMinusButton",OBJPROP_YSIZE,18);
   ObjectSetString(0,"PIPMinusButton",OBJPROP_TEXT,"-");
   ObjectSetString(0,"PIPMinusButton",OBJPROP_FONT,"Arial");
   ObjectSetInteger(0,"PIPMinusButton",OBJPROP_FONTSIZE,10);
   ObjectSetInteger(0,"PIPMinusButton",OBJPROP_STATE,0);
   ObjectSetInteger(0,"PIPMinusButton",OBJPROP_SELECTABLE,0);
//--- Hide/Show
   ObjectSetInteger(0,"PIPHideButton",OBJPROP_COLOR,TextColor);
   ObjectSetInteger(0,"PIPHideButton",OBJPROP_BGCOLOR,BGColor);
   ObjectSetInteger(0,"PIPHideButton",OBJPROP_XDISTANCE,xdist+xsize-18);
   ObjectSetInteger(0,"PIPHideButton",OBJPROP_YDISTANCE,ydist);
   ObjectSetInteger(0,"PIPHideButton",OBJPROP_XSIZE,18);
   ObjectSetInteger(0,"PIPHideButton",OBJPROP_YSIZE,18);
   ObjectSetString(0,"PIPHideButton",OBJPROP_TEXT,"_");
   ObjectSetString(0,"PIPHideButton",OBJPROP_FONT,"Arial");
   ObjectSetInteger(0,"PIPHideButton",OBJPROP_FONTSIZE,8);
   ObjectSetInteger(0,"PIPHideButton",OBJPROP_STATE,0);
   ObjectSetInteger(0,"PIPHideButton",OBJPROP_SELECTABLE,0);
//--- Chart
   ObjectSetString(0,"PIPChart",OBJPROP_SYMBOL,curr_symbol);
   ObjectSetInteger(0,"PIPChart",OBJPROP_PERIOD,curr_period);
   ObjectSetInteger(0,"PIPChart",OBJPROP_XDISTANCE,xdist);
   ObjectSetInteger(0,"PIPChart",OBJPROP_YDISTANCE,ydist+20);
   ObjectSetInteger(0,"PIPChart",OBJPROP_XSIZE,xsize);
   ObjectSetInteger(0,"PIPChart",OBJPROP_YSIZE,ysize);
   ObjectSetInteger(0,"PIPChart",OBJPROP_DATE_SCALE,showdates);
   ObjectSetInteger(0,"PIPChart",OBJPROP_PRICE_SCALE,showprices);
   ObjectSetInteger(0,"PIPChart",OBJPROP_SELECTABLE,0);
   ObjectSetInteger(0,"PIPChart",OBJPROP_CHART_SCALE,scale);
  }
//+------------------------------------------------------------------+
//| Hide chart object                                                |
//+------------------------------------------------------------------+
void PIPHideChart()
  {
   ObjectSetInteger(0,"PIPChart",OBJPROP_XDISTANCE,-1);
   ObjectSetInteger(0,"PIPChart",OBJPROP_YDISTANCE,-1);
   ObjectSetInteger(0,"PIPChart",OBJPROP_XSIZE,0);
   ObjectSetInteger(0,"PIPChart",OBJPROP_YSIZE,0);
  }
//+------------------------------------------------------------------+
//| Convert string to history period                                 |
//+------------------------------------------------------------------+
bool StrToPeriod(const string strper,ENUM_TIMEFRAMES& period)
  {
   bool res=true;
//--- месяц
   if(strper=="MN" || strper=="MN1" || strper=="MONTH" || strper=="MONTHLY") period=PERIOD_MN1;
//--- неделя
   else if(strper=="W" || strper=="W1" || strper=="WEEK" || strper=="10080" || strper=="WEEKLY") period=PERIOD_W1;
//--- день
   else if(strper=="D" || strper=="D1" || strper=="DAY" || strper=="1440" || strper=="DAILY") period=PERIOD_D1;
//--- часовки
   else if(strper=="H" || strper=="H1" || strper=="HOUR" || strper=="60") period=PERIOD_H1;
   else if(strper=="H12" || strper=="720") period=PERIOD_H12;
   else if(strper=="H8" || strper=="480") period=PERIOD_H8;
   else if(strper=="H6" || strper=="360") period=PERIOD_H6;
   else if(strper=="H4" || strper=="240") period=PERIOD_H4;
   else if(strper=="H3" || strper=="180") period=PERIOD_H3;
   else if(strper=="H2" || strper=="120") period=PERIOD_H2;
//--- минутки
   else if(strper=="M" || strper=="M1" || strper=="MIN" || strper=="1" || strper=="MINUTE") period=PERIOD_M1;
   else if(strper=="M30" || strper=="30") period=PERIOD_M30;
   else if(strper=="M20" || strper=="20") period=PERIOD_M20;
   else if(strper=="M15" || strper=="15") period=PERIOD_M15;
   else if(strper=="M12" || strper=="12") period=PERIOD_M12;
   else if(strper=="M10" || strper=="10") period=PERIOD_M10;
   else if(strper=="M6" || strper=="6") period=PERIOD_M6;
   else if(strper=="M5" || strper=="5") period=PERIOD_M5;
   else if(strper=="M4" || strper=="4") period=PERIOD_M4;
   else if(strper=="M3" || strper=="3") period=PERIOD_M3;
   else if(strper=="M2" || strper=="2") period=PERIOD_M2;
//--- не получилось
   else res=false;
//---
   return(res);
  }
//+------------------------------------------------------------------+
//| Convert history period to string                                 |
//+------------------------------------------------------------------+
bool PeriodToStr(ENUM_TIMEFRAMES period,string& strper)
  {
   bool res=true;
//---
   switch(period)
     {
      case PERIOD_MN1 : strper="MN1"; break;
      case PERIOD_W1 :  strper="W1";  break;
      case PERIOD_D1 :  strper="D1";  break;
      case PERIOD_H1 :  strper="H1";  break;
      case PERIOD_H2 :  strper="H2";  break;
      case PERIOD_H3 :  strper="H3";  break;
      case PERIOD_H4 :  strper="H4";  break;
      case PERIOD_H6 :  strper="H6";  break;
      case PERIOD_H8 :  strper="H8";  break;
      case PERIOD_H12 : strper="H12"; break;
      case PERIOD_M1 :  strper="M1";  break;
      case PERIOD_M2 :  strper="M2";  break;
      case PERIOD_M3 :  strper="M3";  break;
      case PERIOD_M4 :  strper="M4";  break;
      case PERIOD_M5 :  strper="M5";  break;
      case PERIOD_M6 :  strper="M6";  break;
      case PERIOD_M10 : strper="M10"; break;
      case PERIOD_M12 : strper="M12"; break;
      case PERIOD_M15 : strper="M15"; break;
      case PERIOD_M20 : strper="M20"; break;
      case PERIOD_M30 : strper="M30"; break;
      default : res=false;
     }
//---
   return(res);
  }
//+------------------------------------------------------------------+
