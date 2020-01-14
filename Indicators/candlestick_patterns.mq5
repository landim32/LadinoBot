//+------------------------------------------------------------------+
//|                                         Candlestick Patterns.mq5 |
//|                                                         VDV Soft |
//|                                                 vdv_2001@mail.ru |
//+------------------------------------------------------------------+
#property copyright "VDV Soft"
#property link      "vdv_2001@mail.ru"
#property version   "1.00"

#include <CandlestickType.mqh>

#property indicator_chart_window

//--- plot 1
#property indicator_label1  ""
#property indicator_type1   DRAW_LINE
#property indicator_color1  Blue
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
#property indicator_buffers 5
#property indicator_plots   1
//--- input parameters
input int   InpPeriodSMA   =10;         // Period of averaging
input bool  InpAlert       =false;       // Enable. signal
input int   InpCountBars   =1000;       // Amount of bars for calculation
input color InpColorBull   =DodgerBlue; // Color of bullish models
input color InpColorBear   =Tomato;     // Color of bearish models
input bool  InpCommentOn   =true;       // Enable comment
input int   InpTextFontSize=10;         // Font size
//---- indicator buffers
//--- indicator handles
//--- list global variable
string prefix="Patterns ";
datetime CurTime=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
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
//--- We wait for a new bar
   if(rates_total==prev_calculated)
     {
      return(rates_total);
     }

////--- delete object
   string objname,comment;
//   for(int i=ObjectsTotal(0,0,-1)-1;i>=0;i--)
//     {
//      objname=ObjectName(0,i);
//      if(StringFind(objname,prefix)==-1)
//         continue;
//      else
//         ObjectDelete(0,objname);
//     }
   int objcount=0;
//---
   int limit;
   if(prev_calculated==0)
     {
      if(InpCountBars<=0 || InpCountBars>=rates_total)
         limit=InpPeriodSMA*2;
      else
         limit=rates_total-InpCountBars;
     }
   else
      limit=prev_calculated-1;
   if(!SeriesInfoInteger(Symbol(),0,SERIES_SYNCHRONIZED))
      return(0);
// Variable of time when the signal should be given
   CurTime=time[rates_total-2];
// Determine the market (forex or not)
 
   bool _forex=false;
   if(SymbolInfoInteger(Symbol(),SYMBOL_TRADE_CALC_MODE)==(int)SYMBOL_CALC_MODE_FOREX) _forex=true;
   bool _language = (TerminalInfoString(TERMINAL_LANGUAGE)=="Russian") ? true : false; // Russian language of the terminal
//--- calculate Candlestick Patterns
   for(int i=limit;i<rates_total-1;i++)
     {
      CANDLE_STRUCTURE cand1;
      if(!RecognizeCandle(_Symbol,_Period,time[i],InpPeriodSMA,cand1))
         continue;
/* Check patterns on one candlestick */
 
      //------      
      // Inverted Hammer, the bullish model
      if(cand1.trend==DOWN && // check direction of trend
         cand1.type==CAND_INVERT_HAMMER) // the "Inverted Hammer" check
        {
         comment=_language?"Inverted Hammer (Bull)":"Inverted Hammer";
         DrawSignal(prefix+"Invert Hammer the bull model"+string(objcount++),cand1,InpColorBull,comment);
        }
      // Hanging Man, the bearish model
      if(cand1.trend==UPPER && // check direction of trend
         cand1.type==CAND_HAMMER) // the "Hammer" check
        {
         comment=_language?"Hanging Man (Bear)":"Hanging Man";
         DrawSignal(prefix+"Hanging Man the bear model"+string(objcount++),cand1,InpColorBear,comment);
        }
      //------      
      // Hammer, the bullish model
      if(cand1.trend==DOWN && // check direction of trend
         cand1.type==CAND_HAMMER) // the "Hammer" check
        {
         comment=_language?"Hammer (Bull)":"Hammer";
         DrawSignal(prefix+"Hammer, the bull model"+string(objcount++),cand1,InpColorBull,comment);
        }

/* Check of patters with two candlesticks */
 
      CANDLE_STRUCTURE cand2;
      cand2=cand1;
      if(!RecognizeCandle(_Symbol,_Period,time[i-1],InpPeriodSMA,cand1))
         continue;

      //------      
      // Shooting Star, the bearish model
      if(cand1.trend==UPPER && cand2.trend==UPPER && // check direction of trend
         cand2.type==CAND_INVERT_HAMMER) // the "Inverted Hammer" check
        {
         comment=_language?"Shooting Star (Bear)":"Shooting Star";
         if(_forex)// if it's forex
           {
            if(cand1.close<=cand2.open) // close 1 is less than or equal to open 1
              {
               DrawSignal(prefix+"Shooting Star the bear model"+string(objcount++),cand2,InpColorBear,comment);
              }
           }
         else
           {
            if(cand1.close<cand2.open && cand1.close<cand2.close) // 2 candlestick is cut off from 1
              {
               DrawSignal(prefix+"Shooting Star the bear model"+string(objcount++),cand2,InpColorBear,comment);
              }
           }
        }
      // ------      
      // Belt Hold, the bullish
      if(cand2.trend==DOWN && cand2.bull && !cand1.bull && // check direction of trend and direction of candlestick
         cand2.type==CAND_MARIBOZU_LONG && // the "long Maribozu" check
         cand1.bodysize<cand2.bodysize && cand2.close<cand1.close) // body of the first candlestick is smaller than body of the second one, close price of the second candlestick is lower than the close price of the first one
        {
         comment=_language?"Belt Hold (Bull)":"Belt Hold";
         if(!_forex)// if it's not forex
           {
            DrawSignal(prefix+"Belt Hold the bull model"+string(objcount++),cand1,cand2,InpColorBull,comment);
           }
        }
      // Belt Hold, the bearish model
      if(cand2.trend==UPPER && !cand2.bull && cand1.bull && // check direction of trend and direction of candlestick
         cand2.type==CAND_MARIBOZU_LONG && // the "long Maribozu" check
         cand1.bodysize<cand2.bodysize && cand2.close>cand1.close) // body of the first candlestick is lower than body of the second one; close price of the second candlestick is higher than that of the first one
        {
         comment=_language?"Belt Hold (Bear)":"Belt Hold";
         if(!_forex)// if it's not forex
           {
            DrawSignal(prefix+"Belt Hold the bear model"+string(objcount++),cand1,cand2,InpColorBear,comment);
           }
        }
      //------      
      // Engulfing, the bullish model
      if(cand1.trend==DOWN && !cand1.bull && cand2.trend==DOWN && cand2.bull && // check direction of trend and direction of candlestick
         cand1.bodysize<cand2.bodysize) // body of the third candlestick is bigger than that of the second one
        {
         comment=_language?"Engulfing (Bull)":"Engulfing";
         if(_forex)// if it's forex
           {
            if(cand1.close>=cand2.open && cand1.open<cand2.close) // body of the first candlestick is inside of body of the second one
              {
               DrawSignal(prefix+"Engulfing the bull model"+string(objcount++),cand1,cand2,InpColorBull,comment);
              }
           }
         else
           {
            if(cand1.close>cand2.open && cand1.open<cand2.close) // body of the first candlestick inside of body of the second candlestick
              {
               DrawSignal(prefix+"Engulfing the bull model"+string(objcount++),cand1,cand2,InpColorBull,comment);
              }
           }
        }
      // Engulfing, the bearish model
      if(cand1.trend==UPPER && cand1.bull && cand2.trend==UPPER && !cand2.bull && // check direction and direction of candlestick
         cand1.bodysize<cand2.bodysize) // body of the third candlestick is bigger than that of the second one
        {
         comment=_language?"Engulfing (Bear)":"Engulfing";
         if(_forex)// if it's forex
           {
            if(cand1.close<=cand2.open && cand1.open>cand2.close) // body of the first candlestick is inside of body of the second one
              {
               DrawSignal(prefix+"Engulfing the bear model"+string(objcount++),cand1,cand2,InpColorBear,comment);
              }
           }
         else
           {
            if(cand1.close<cand2.open && cand1.open>cand2.close) // close 1 is lower or equal to open 2; or open 1 is higher or equal to close 2
              {
               DrawSignal(prefix+"Engulfing the bear model"+string(objcount++),cand1,cand2,InpColorBear,comment);
              }
           }
        }
      //------      
      // Harami Cross, the bullish model
      if(cand1.trend==DOWN && !cand1.bull && // check direction of trend and direction of candlestick
         (cand1.type==CAND_LONG || cand1.type==CAND_MARIBOZU_LONG) && cand2.type==CAND_DOJI) // check of "long" first candlestick and Doji candlestick
        {
         comment=_language?"Harami Cross (Bull)":"Harami Cross";
         if(_forex)// if it's forex
           {
            if(cand1.close<=cand2.open && cand1.close<=cand2.close && cand1.open>cand2.close) // Doji is inside of body of the first candlestick
              {
               DrawSignal(prefix+"Harami Cross the bull model"+string(objcount++),cand1,cand2,InpColorBull,comment);
              }
           }
         else
           {
            if(cand1.close<cand2.open && cand1.close<cand2.close && cand1.open>cand2.close) // Doji is inside of body of the first candlestick
              {
               DrawSignal(prefix+"Harami Cross the bull model"+string(objcount++),cand1,cand2,InpColorBull,comment);
              }
           }
        }
      // Harami Cross, the bearish model
      if(cand1.trend==UPPER && cand1.bull && // check direction of trend and direction of candlestick
         (cand1.type==CAND_LONG || cand1.type==CAND_MARIBOZU_LONG) && cand2.type==CAND_DOJI) // check of "long" candlestick and Doji
        {
         comment=_language?"Harami Cross (Bear)":"Harami Cross";
         if(_forex)// if it's forex
           {
            if(cand1.close>=cand2.open && cand1.close>=cand2.close && cand1.close>=cand2.close) // Doji is inside of body of the first candlestick
              {
               DrawSignal(prefix+"Harami Cross the bear model"+string(objcount++),cand1,cand2,InpColorBear,comment);
              }
           }
         else
           {
            if(cand1.close>cand2.open && cand1.close>cand2.close && cand1.open<cand2.close) // Doji is inside of body of the first candlestick
              {
               DrawSignal(prefix+"Harami Cross the bear model"+string(objcount++),cand1,cand2,InpColorBear,comment);
              }
           }
        }
      //------      
      // Harami, the bullish model
      if(cand1.trend==DOWN  &&  !cand1.bull  &&  cand2.bull &&// check direction of trend and direction of candlestick
         (cand1.type==CAND_LONG || cand1.type==CAND_MARIBOZU_LONG) &&  // check of "long" first candlestick
         cand2.type!=CAND_DOJI && cand1.bodysize>cand2.bodysize) // the second candlestick is not Doji and body of the first candlestick is bigger than that of the second one
        {
         comment=_language?"Harami (Bull)":"Harami";
         if(_forex)// if it's forex
           {
            if(cand1.close<=cand2.open && cand1.close<=cand2.close && cand1.open>cand2.close) // body of the second candlestick is inside of body of the first candlestick
              {
               DrawSignal(prefix+"Harami the bull model"+string(objcount++),cand1,cand2,InpColorBull,comment);
              }
           }
         else
           {
            if(cand1.close<cand2.open && cand1.close<cand2.close && cand1.open>cand2.close) // body of the second candlestick is inside of body of the first one
              {
               DrawSignal(prefix+"Harami the bull model"+string(objcount++),cand1,cand2,InpColorBull,comment);
              }
           }
        }
      // Harami, the bearish model
      if(cand1.trend==UPPER && cand1.bull && !cand2.bull && // check direction of trend and direction of candlestick
         (cand1.type==CAND_LONG|| cand1.type==CAND_MARIBOZU_LONG) && // check of "long" first candlestick
         cand2.type!=CAND_DOJI && cand1.bodysize>cand2.bodysize) // the second candlestick is not Doji and body of the first candlestick is bigger than that of the second one
        {
         comment=_language?"Harami (Bear)":"Harami";
         if(_forex)// if it's forex
           {
            if(cand1.close>=cand2.open && cand1.close>=cand2.close && cand1.close>=cand2.close) // Doji is inside of body of the first candlestick
              {
               DrawSignal(prefix+"Harami the bear model"+string(objcount++),cand1,cand2,InpColorBear,comment);
              }
           }
         else
           {
            if(cand1.close>cand2.open && cand1.close>cand2.close && cand1.open<cand2.close) // Doji is inside of body of the first candlestick
              {
               DrawSignal(prefix+"Harami the bear model"+string(objcount++),cand1,cand2,InpColorBear,comment);
              }
           }
        }
      //------      
      // Doji Star, the bullish model
      if(cand1.trend==DOWN && !cand1.bull && // check direction of trend and direction of candlestick
         (cand1.type==CAND_LONG || cand1.type==CAND_MARIBOZU_LONG) && cand2.type==CAND_DOJI) // check first "long" candlestick and 2 doji
        {
         comment=_language?"Doji Star (Bull)":"Doji Star";
         if(_forex)// if it's forex
           {
            if(cand1.close>=cand2.open) // Open price of Doji is lower or equal to close price of the first candlestick
              {
               DrawSignal(prefix+"Doji Star the bull model"+string(objcount++),cand1,cand2,InpColorBull,comment);

              }
           }
         else
           {
            if(cand1.close>cand2.open && cand1.close>cand2.close) // Body of Doji is cut off the body of the first candlestick
              {
               DrawSignal(prefix+"Doji Star the bull model"+string(objcount++),cand1,cand2,InpColorBull,comment);

              }
           }
        }
      // Doji Star, the bearish model
      if(cand1.trend==UPPER && cand1.bull && // check direction of trend and direction of candlestick
         (cand1.type==CAND_LONG || cand1.type==CAND_MARIBOZU_LONG) && cand2.type==CAND_DOJI) // check first "long" candlestick and 2 doji
        {
         comment=_language?"Doji Star (Bear)":"Doji Star";
         if(_forex)// if it's forex
           {
            if(cand1.close<=cand2.open) // // open price of Doji is higher or equal to close price of the first candlestick
              {
               DrawSignal(prefix+"Doji Star the bear model"+string(objcount++),cand1,cand2,InpColorBear,comment);

              }
           }
         else
           {
            if(cand1.close<cand2.open && cand1.close<cand2.close) // // body of Doji is cut off the body of the first candlestick
              {
               DrawSignal(prefix+"Doji Star the bear model"+string(objcount++),cand1,cand2,InpColorBear,comment);

              }
           }
        }
      //------      
      // Piercing Line, the bull model
      if(cand1.trend==DOWN && !cand1.bull && cand2.trend==DOWN && cand2.bull && // check direction of trend and direction of candlestick
         (cand1.type==CAND_LONG || cand1.type==CAND_MARIBOZU_LONG) && (cand2.type==CAND_LONG || cand2.type==CAND_MARIBOZU_LONG) && // check of "long" candlestick
         cand2.close>(cand1.close+cand1.open)/2)// close price of the second candle is higher than the middle of the first one
        {
         comment=_language?"Piercing Line (Bull)":"Piercing Line";
         if(_forex)// if it's forex
           {
            if(cand1.close>=cand2.open && cand2.close<=cand1.open)
              {
               DrawSignal(prefix+"Piercing Line"+string(objcount++),cand1,cand2,InpColorBull,comment);
              }
           }
         else
           {
            if(cand2.open<cand1.low && cand2.close<=cand1.open) // open price of the second candle is lower than LOW price of the first one 
              {
               DrawSignal(prefix+"Piercing Line"+string(objcount++),cand1,cand2,InpColorBull,comment);
              }
           }
        }
      // Dark Cloud Cover, the bearish model
      if(cand1.trend==UPPER && cand1.bull && cand2.trend==UPPER && !cand2.bull && // check direction and direction of candlestick
         (cand1.type==CAND_LONG || cand1.type==CAND_MARIBOZU_LONG) && (cand2.type==CAND_LONG || cand2.type==CAND_MARIBOZU_LONG) && // check of "long" candlestick
         cand2.close<(cand1.close+cand1.open)/2)// close price of 2-nd candlestick is lower than the middle of the body of the 1-st one
        {
         comment=_language?"Dark Cloud Cover (Bear)":"Dark Cloud Cover";
         if(_forex)// if it's forex
           {
            if(cand1.close<=cand2.open && cand2.close>=cand1.open)
              {
               DrawSignal(prefix+"Dark Cloud Cover"+string(objcount++),cand1,cand2,InpColorBear,comment);

              }
           }
         else
           {
            if(cand1.high<cand2.open && cand2.close>=cand1.open)
              {
               DrawSignal(prefix+"Dark Cloud Cover"+string(objcount++),cand1,cand2,InpColorBear,comment);

              }
           }
        }
      //------      
      // Meeting Lines the bull model / Встречающиеся свечи бычья модель
      if(cand1.trend==DOWN && !cand1.bull && cand2.trend==DOWN && cand2.bull && // check direction of trend and direction of candlestick
         (cand1.type==CAND_LONG || cand1.type==CAND_MARIBOZU_LONG) && (cand2.type==CAND_LONG || cand2.type==CAND_MARIBOZU_LONG) && // check of "long" candlestick
         cand1.close==cand2.close && cand1.bodysize<cand2.bodysize && cand1.low>cand2.open) // close prices are equal, size of the first candlestick is smaller than that of the second one; open price of the second one is lower than minimum of the first one
        {
         comment=_language?"Meeting Lines (Bull)":"Meeting Lines";
         if(!_forex)// if it's not forex
           {
            DrawSignal(prefix+"Meeting Lines the bull model"+string(objcount++),cand1,cand2,InpColorBull,comment);
           }
        }
      // Meeting Lines, the bearish model
      if(cand1.trend==UPPER && cand1.bull && cand2.trend==UPPER && !cand2.bull && // check direction and direction of candlestick
         (cand1.type==CAND_LONG || cand1.type==CAND_MARIBOZU_LONG) && // check of "long" candlestick
         cand1.close==cand2.close && cand1.bodysize<cand2.bodysize && cand1.high<cand2.open) // // close prices are equal, size of the first one is smaller than that of the second one, open price of the second one is higher than the maximum of the first one
        {
         comment=_language?"Meeting Lines (Bear)":"Meeting Lines";
         if(!_forex)// if it's not forex
           {
            DrawSignal(prefix+"Meeting Lines the bear model"+string(objcount++),cand1,cand2,InpColorBear,comment);
           }
        }
      //------      
      // Matching Low, the bullish model
      if(cand1.trend==DOWN && !cand1.bull && cand2.trend==DOWN && !cand2.bull && // check direction of trend and direction of candlestick
         cand1.close==cand2.close && cand1.bodysize>cand2.bodysize) // close price are equal, size of the first one is greater than that of the second one
        {
         comment=_language?"Matching Low (Bull)":"Matching Low";
         if(!_forex)// if it's not forex
           {
            DrawSignal(prefix+"Matching Low the bull model"+string(objcount++),cand1,cand2,InpColorBull,comment);
           }
        }
      //------      
      // Homing Pigeon, the bullish model
      if(cand1.trend==DOWN && !cand1.bull && cand2.trend==DOWN && !cand2.bull && // check direction of trend and direction of candlestick
         (cand1.type==CAND_LONG || cand1.type==CAND_MARIBOZU_LONG) && // check of "long" candlestick
         cand1.close<cand2.close  &&  cand1.open>cand2.open) // body of the second candlestick is inside of body of the first one
        {
         comment=_language?"Homing Pigeon (Bull)":"Homing Pigeon";
         if(!_forex)// if it's not forex
           {
            DrawSignal(prefix+"Homing Pigeon the bull model"+string(objcount++),cand1,cand2,InpColorBull,comment);
           }
        }
/* Continuation Models */
 
      //------      
      // Kicking, the bull model
      if(!cand1.bull && cand2.bull && // check direction of trend and direction of candlestick
         cand1.type==CAND_MARIBOZU_LONG && cand2.type==CAND_MARIBOZU_LONG && // two maribozu
         cand1.open<cand2.open) // gap between them
        {
         comment=_language?"Kicking (Bull)":"Kicking";
         if(!_forex)// if it's not forex
           {
            DrawSignal(prefix+"Kicking the bull model"+string(objcount++),cand1,cand2,InpColorBull,comment);
           }
        }
      // Kicking, the bearish model
      if(cand1.bull && !cand2.bull && // check direction of trend and direction of candlestick
         cand1.type==CAND_MARIBOZU_LONG && cand2.type==CAND_MARIBOZU_LONG && // two maribozu
         cand1.open>cand2.open) // gap between them
        {
         comment=_language?"Kicking (Bear)":"Kicking";
         if(!_forex)// if it's not forex
           {
            DrawSignal(prefix+"Kicking the bear model"+string(objcount++),cand1,cand2,InpColorBear,comment);
           }
        }
      //------ Check of module of the neck line
      if(cand1.trend==DOWN && !cand1.bull && cand2.bull && // check direction of trend and direction of candlestick
         (cand1.type==CAND_LONG || cand1.type==CAND_MARIBOZU_LONG)) // first candlesticks is "long"
        {
         // On Neck Line, the bearish model
         if(cand2.open<cand1.low && cand2.close==cand1.low) // second candlestick is opened below the first one and is closed at the minimum level of the first one
           {
            comment=_language?"On Neck Line (Bear)":"On Neck Line";
            if(!_forex)// if it's not forex
              {
               DrawSignal(prefix+"On Neck Line the bear model"+string(objcount++),cand1,cand2,InpColorBear,comment);
              }
           }
         else
           {
            // In Neck Line, the bear model
            if(cand1.trend==DOWN && !cand1.bull && cand2.bull && // check direction of trend and direction of candlestick
               (cand1.type==CAND_LONG || cand1.type==CAND_MARIBOZU_LONG) && // first candlestick is "long"
               cand1.bodysize>cand2.bodysize && // body of the second candlestick is smaller than body of the first one
               cand2.open<cand1.low && cand2.close>=cand1.close && cand2.close<(cand1.close+cand1.bodysize*0.01)) // second candlestick is opened below the first one and is closed slightly higher the closing of the first one
              {
               comment=_language?"In Neck Line (Bear)":"In Neck Line";
               if(!_forex)// if it's not forex
                 {
                  DrawSignal(prefix+"In Neck Line the bear model"+string(objcount++),cand1,cand2,InpColorBear,comment);
                 }
              }
            else
              {
               // Thrusting Line, the bearish model
               if(cand1.trend==DOWN && !cand1.bull && cand2.bull && // check direction of trend and direction of candlestick
                  (cand1.type==CAND_LONG || cand1.type==CAND_MARIBOZU_LONG) && // first candlestick is "long"
                  cand2.open<cand1.low && cand2.close>cand1.close && cand2.close<(cand1.open+cand1.close)/2) // the second candlestick is opened below the first one and is closed above the closing of the first one, bu below its middle
                 {
                  comment=_language?"Thrusting Line (Bear)":"Thrusting Line";
                  if(!_forex)// if it's not forex
                    {
                     DrawSignal(prefix+"Thrusting Line the bear model"+string(objcount++),cand1,cand2,InpColorBear,comment);
                    }
                 }
              }
           }
        }

/* Check of patterns with three candlesticks */
 
      CANDLE_STRUCTURE cand3;
      cand3=cand2;
      cand2=cand1;
      if(!RecognizeCandle(_Symbol,_Period,time[i-2],InpPeriodSMA,cand1))
         continue;
      //------      
      // The Abandoned Baby, the bullish model
      if(cand1.trend==DOWN && !cand1.bull && cand3.trend==DOWN && cand3.bull && // check direction of trend and direction of candlestick
         (cand1.type==CAND_LONG || cand1.type==CAND_MARIBOZU_LONG) && (cand3.type==CAND_LONG || cand3.type==CAND_MARIBOZU_LONG) && // check of "long" candlestick
         cand2.type==CAND_DOJI && // check if the second candlestick is Doji
         cand3.close<cand1.open && cand3.close>cand1.close) // the third one is closed inside of body of the first one
        {
         comment=_language?"Abandoned Baby (Bull)":"Abandoned Baby";
         if(!_forex)// if it's not forex
           {
            if(cand1.low>cand2.high && cand3.low>cand2.high) // gap between candlesticks
              {
               DrawSignal(prefix+"Abandoned Baby the bull model"+string(objcount++),cand1,cand1,cand3,InpColorBull,comment);
              }
           }
        }
      // The Abandoned Baby, the bearish model
      if(cand1.trend==UPPER && cand1.bull && cand3.trend==UPPER && !cand3.bull && // check direction of trend and direction of candlestick
         (cand1.type==CAND_LONG || cand1.type==CAND_MARIBOZU_LONG) && (cand3.type==CAND_LONG || cand3.type==CAND_MARIBOZU_LONG) && // check of "long" candlestick
         cand2.type==CAND_DOJI && // check if the second candlestick is Doji
         cand3.close>cand1.open && cand3.close<cand1.close) // // the third one is closed inside of body of the second one
        {
         comment=_language?"Abandoned Baby (Bear)":"Abandoned Baby";
         if(!_forex)// if it's not forex
           {
            if(cand1.high<cand2.low && cand3.high<cand2.low) // gap between candlesticks
              {
               DrawSignal(prefix+"Abandoned Baby the bear model"+string(objcount++),cand1,cand2,cand3,InpColorBear,comment);
              }
           }
        }
      // ------      
      // Morning star, the bullish model
      if(cand1.trend==DOWN && !cand1.bull && cand3.trend==DOWN && cand3.bull && // check direction of trend and direction of candlestick
         (cand1.type==CAND_LONG || cand1.type==CAND_MARIBOZU_LONG) && (cand3.type==CAND_LONG || cand3.type==CAND_MARIBOZU_LONG) && // check of "long" candlestick
         cand2.type==CAND_SHORT && // check of "short" candlestick
         cand3.close>cand1.close && cand3.close<cand1.open) // the third candlestick is closed inside of body of the first one
        {
         comment=_language?"Morning Star (Bull)":"Morning star";
         if(_forex)// if it's forex
           {
            if(cand2.open<=cand1.close) // Open price of the second candlestick is lower than the closing of the first one
              {
               DrawSignal(prefix+"Morning star the bull model"+string(objcount++),cand1,cand2,cand3,InpColorBull,comment);
              }
           }
         else // other market
           {
            if(cand2.open<cand1.close && cand2.close<cand1.close) // distance from the second candlestick to the first one
              {
               DrawSignal(prefix+"Morning star the bull model"+string(objcount++),cand1,cand2,cand3,InpColorBull,comment);
              }
           }
        }
      // Evening star, the bearish model
      if(cand1.trend==UPPER && cand1.bull && cand3.trend==UPPER && !cand3.bull && // check direction of trend and direction of candlestick
         (cand1.type==CAND_LONG || cand1.type==CAND_MARIBOZU_LONG) && (cand3.type==CAND_LONG || cand3.type==CAND_MARIBOZU_LONG) && // check of "long" candlestick
         cand2.type==CAND_SHORT && // check of "short" candlestick
         cand3.close<cand1.close && cand3.close>cand1.open) // the third candlestick is closed inside of body of the first one
        {
         comment=_language?"Evening Star (Bear)":"Evening star";
         if(_forex)// if it's forex
           {
            if(cand2.open>=cand1.close) // open price of the second candlestick is higher than that of the first one
              {
               DrawSignal(prefix+"Evening star the bear model"+string(objcount++),cand1,cand2,cand3,InpColorBear,comment);
              }
           }
         else // other market
           {
            if(cand2.open>cand1.close && cand2.close>cand1.close) // gap between candlesticks
              {
               DrawSignal(prefix+"Evening star the bear model"+string(objcount++),cand1,cand2,cand3,InpColorBear,comment);
              }
           }
        }
      //------      
      // Morning Doji Star, the bullish model
      if(cand1.trend==DOWN && !cand1.bull && cand3.trend==DOWN && cand3.bull && // check direction of trend and direction of candlestick
         (cand1.type==CAND_LONG || cand1.type==CAND_MARIBOZU_LONG) && (cand3.type==CAND_LONG || cand3.type==CAND_MARIBOZU_LONG) && // check of "long" candlestick
         cand2.type==CAND_DOJI && // check of "doji"
         cand3.close>cand1.close && cand3.close<cand1.open) // the third candlestick is closed inside of body of the first one
        {
         comment=_language?"Morning Doji Star (Bull)":"Morning Doji Star";
         if(_forex)// if it's forex
           {
            if(cand2.open<=cand1.close) // open price of Doji is lower or equal to the close price of the first candlestick
              {
               DrawSignal(prefix+"Morning Doji Star the bull model"+string(objcount++),cand1,cand2,cand3,InpColorBull,comment);
              }
           }
         else // other market
           {
            if(cand2.open<cand1.close) // gap between Doji and the first candlestick
              {
               DrawSignal(prefix+"Morning Doji Star the bull model"+string(objcount++),cand1,cand2,cand3,InpColorBull,comment);
              }
           }
        }
      // Evening Doji Star, the bearish model
      if(cand1.trend==UPPER && cand1.bull && cand3.trend==UPPER && !cand3.bull && // check direction of trend and direction of candlestick
         (cand1.type==CAND_LONG || cand1.type==CAND_MARIBOZU_LONG) && (cand3.type==CAND_LONG || cand3.type==CAND_MARIBOZU_LONG) && // check of "long" candlestick
         cand2.type==CAND_DOJI && // check of "doji"
         cand3.close<cand1.close && cand3.close>cand1.open) // the third candlestick is closed inside of body of the first one
        {
         comment=_language?"Evening Doji Start (Bear)":"Evening Doji Star";
         if(_forex)// if it's forex
           {
            if(cand2.open>=cand1.close) // open price of Doji is higher or equal to close price of the first candlestick
              {
               DrawSignal(prefix+"Evening Doji Star the bear model"+string(objcount++),cand1,cand2,cand3,InpColorBear,comment);
              }
           }
         else // other market
           {
            if(cand2.open>cand1.close) // gap between Doji and the first candlestick
               // check of close 2 and open 3
              {
               DrawSignal(prefix+"Evening Doji Star the bear model"+string(objcount++),cand1,cand3,cand3,InpColorBear,comment);
              }
           }
        }
      //------      
      // Upside Gap Two Crows, the bearish model
      if(cand1.trend==UPPER && cand1.bull && cand2.trend==UPPER && !cand2.bull && cand3.trend==UPPER && !cand3.bull && // check direction of trend and direction of candlestick
         (cand1.type==CAND_LONG || cand1.type==CAND_MARIBOZU_LONG)  &&  // check of "long" candlestick
         cand1.close<cand2.close && cand1.close<cand3.close && // distance of the second and third candlesticks from the first one
         cand2.open<cand3.open && cand2.close>cand3.close) // the third candlestick absorbs the second one
        {
         comment=_language?"Upside Gap Two Crows (Bear)":"Upside Gap Two Crows";
         if(!_forex)// if it's not forex
           {
            DrawSignal(prefix+"Upside Gap Two Crows the bear model"+string(objcount++),cand1,cand2,cand3,InpColorBear,comment);
           }
        }
      //------      
      // Two Crows, the bearish model
      if(cand1.trend==UPPER && cand1.bull && cand2.trend==UPPER && !cand2.bull && cand3.trend==UPPER && !cand3.bull && // check direction of trend and direction of candlestick
         (cand1.type==CAND_LONG|| cand1.type==CAND_MARIBOZU_LONG) &&(cand3.type==CAND_LONG|| cand3.type==CAND_MARIBOZU_LONG) && // check of "long" candlestick
         cand1.close<cand2.close && // distance between the second and first candlesticks
         cand3.open>cand2.close && // the third candlestick is opened higher than the close price of the second one
         cand3.close<cand1.close) // the third candlestick is closed below the close price of the first one
        {
         comment=_language?"Two Crows (Bear)":"Two Crows";
         if(!_forex)// if it's not forex
           {
            DrawSignal(prefix+"Two Crows the bear model"+string(objcount++),cand1,cand2,cand3,InpColorBear,comment);
           }
        }
      //------      
      // Three Star in the South, the bullish model
      if(cand1.trend==DOWN && !cand1.bull && !cand2.bull && !cand3.bull && // check direction of trend and direction of candlestick
         (cand1.type==CAND_LONG || cand1.type==CAND_MARIBOZU_LONG) && (cand3.type==CAND_MARIBOZU || cand3.type==CAND_SHORT) && // check of "long" candlestick and "maribozu"
         cand1.bodysize>cand2.bodysize && cand1.low<cand2.low && cand3.low>cand2.low && cand3.high<cand2.high)
        {
         comment=_language?"Three Star in the South (Bull)":"Three Star in the South";
         if(_forex)// if it's forex
           {
            DrawSignal(prefix+"Three Star in the South the bull model"+string(objcount++),cand1,cand2,cand3,InpColorBull,comment);
           }
         else // other market
           {
            if(cand1.close<cand2.open && cand2.close<cand3.open) // opening inside the previous candlestick
              {
               DrawSignal(prefix+"Three Star in the South the bull model"+string(objcount++),cand1,cand2,cand3,InpColorBull,comment);
              }
           }
        }
      // Deliberation, the bear model
      if(cand1.trend==UPPER && cand1.bull && cand2.bull && cand3.bull && // check direction of trend and direction of candlestick
         (cand1.type==CAND_LONG || cand1.type==CAND_MARIBOZU_LONG) && (cand2.type==CAND_LONG || cand2.type==CAND_MARIBOZU_LONG) && // check of "long" candlestick
         (cand3.type==CAND_SPIN_TOP || cand3.type==CAND_SHORT)) // the third candlestick is the spin or start
        {
         comment=_language?"Deliberation (Bear)":"Deliberation";
         if(_forex)// if it's forex
           {
            DrawSignal(prefix+"Deliberation the bear model"+string(objcount++),cand1,cand2,cand3,InpColorBear,comment);
           }
         else // other market
           {
            if(cand1.close>cand2.open && cand2.close<=cand3.open) // opening inside the previous candlestick
               // check of close 2 and open 3
              {
               DrawSignal(prefix+"Deliberation the bear model"+string(objcount++),cand1,cand3,cand3,InpColorBear,comment);
              }
           }
        }
      //------      
      // Three White Soldiers, the bullish model
      if(cand1.trend==DOWN && cand1.bull && cand2.bull && cand3.bull && // check direction of trend and direction of candlestick
         (cand1.type==CAND_LONG || cand1.type==CAND_MARIBOZU_LONG) && (cand2.type==CAND_LONG || cand2.type==CAND_MARIBOZU_LONG) && // check of "long" candlestick or "maribozu"
         (cand3.type==CAND_LONG || cand3.type==CAND_MARIBOZU_LONG)) // check of "long" candlestick and "maribozi"
        {
         comment=_language?"Three White Soldiers (Bull)":"Three White Soldiers";
         if(_forex)// if it's forex
           {
            DrawSignal(prefix+"Three White Soldiers the bull model"+string(objcount++),cand1,cand2,cand3,InpColorBull,comment);
           }
         else // other market
           {
            if(cand1.close>cand2.open && cand2.close>cand3.open) // opening inside the previous candlestick
              {
               DrawSignal(prefix+"Three White Soldiers the bull model"+string(objcount++),cand1,cand2,cand3,InpColorBull,comment);
              }
           }
        }
      // Three Black Crows, the bearish model
      if(cand1.trend==UPPER && !cand1.bull && !cand2.bull && !cand3.bull && // check direction of trend and direction of candlestick
         (cand1.type==CAND_LONG || cand1.type==CAND_MARIBOZU_LONG) && (cand2.type==CAND_LONG || cand2.type==CAND_MARIBOZU_LONG) && // check of "long" candlestick or "maribozu"
         (cand3.type==CAND_LONG || cand3.type==CAND_MARIBOZU_LONG) && // check "long" candlestick and "maribozu"
         cand1.close<cand2.open  &&  cand2.close<cand3.open) // opening inside the previous candlestick
        {
         comment=_language?"Three Black Crows (Bear)":"Three Black Crows";
         if(!_forex) // not forex
           {
            DrawSignal(prefix+"Three Black Crows the bear model"+string(objcount++),cand1,cand3,cand3,InpColorBear,comment);
           }
        }
      //------      
      // Three Outside Up, the bullish model
      if(cand1.trend==DOWN && !cand1.bull && cand2.trend==DOWN && cand2.bull && cand3.bull && // check direction of trend and direction of candlestick
         cand2.bodysize>cand1.bodysize && // body of the second candlestick is bigger than that of the first one
         cand3.close>cand2.close) // the third day is closed higher than the second one
        {
         comment=_language?"Three Outside Up (Bull)":"Three Outside Up";
         if(_forex)// if it's forex
           {
            if(cand1.close>=cand2.open && cand1.open<cand2.close) // body of the first candlestick is inside of body of the second one
              {
               DrawSignal(prefix+"Three Outside Up the bull model"+string(objcount++),cand1,cand2,cand3,InpColorBull,comment);
              }
           }
         else
           {
            if(cand1.close>cand2.open && cand1.open<cand2.close) // body of the first candlestick inside of body of the second candlestick
              {
               DrawSignal(prefix+"Three Outside Up the bull model"+string(objcount++),cand1,cand2,cand3,InpColorBull,comment);
              }
           }
        }
      // Three Outside Down, the bearish model
      if(cand1.trend==UPPER && cand1.bull && cand2.trend==UPPER && !cand2.bull && !cand3.bull && // check direction of trend and direction of candlestick
         cand2.bodysize>cand1.bodysize && // body of the second candlestick is bigger than that of the first one
         cand3.close<cand2.close) // the third day is closed lower than the second one
        {
         comment=_language?"Three Outside Down (Bear)":"Three Outside Down";
         if(_forex)// if it's forex
           {
            if(cand1.close<=cand2.open && cand1.open>cand2.close) // body of the first candlestick is inside of body of the second one
              {
               DrawSignal(prefix+"Three Outside Down the bear model"+string(objcount++),cand1,cand2,cand3,InpColorBear,comment);
              }
           }
         else
           {
            if(cand1.close<cand2.open && cand1.open>cand2.close) // body of the first candlestick is inside of body of the second one
              {
               DrawSignal(prefix+"Three Outside Down the bear model"+string(objcount++),cand1,cand2,cand3,InpColorBear,comment);
              }
           }
        }
      //------      
      // Three Inside Up, the bullish model
      if(cand1.trend==DOWN && !cand1.bull && cand2.bull && cand3.bull && // check direction of trend and direction of candlestick
         (cand1.type==CAND_LONG || cand1.type==CAND_MARIBOZU_LONG) && // check of "long" first candle
         cand1.bodysize>cand2.bodysize && // body of the first candlestick is bigger than that of the second one
         cand3.close>cand2.close) // the third day is closed higher than the second one
        {
         comment=_language?"Three Inside Up (Bull)":"Three Inside Up";
         if(_forex)// if it's forex
           {
            if(cand1.close<=cand2.open && cand1.close<=cand2.close && cand1.open>cand2.close) // body of the second candlestick is inside of body of the first candlestick
              {
               DrawSignal(prefix+"Three Inside Up the bull model"+string(objcount++),cand1,cand2,cand3,InpColorBull,comment);
              }
           }
         else
           {
            if(cand1.close<cand2.open && cand1.close<cand2.close && cand1.open>cand2.close) // body of the second candlestick is inside of body of the first one
              {
               DrawSignal(prefix+"Three Inside Up the bull model"+string(objcount++),cand1,cand2,cand3,InpColorBull,comment);
              }
           }
        }
      // Three Inside Down, the bearish model
      if(cand1.trend==UPPER && cand1.bull && !cand2.bull && !cand3.bull && // check direction of trend and direction of candlestick
         (cand1.type==CAND_LONG || cand1.type==CAND_MARIBOZU_LONG) && // check of "long" first candle
         cand1.bodysize>cand2.bodysize && // body of the first candlestick is bigger than that of the second one
         cand3.close<cand2.close) // the third day is closed lower than the second one
        {
         comment=_language?"Three Inside Down (Bear)":"Three Inside Down";
         if(_forex)// if it's forex
           {
            if(cand1.close>=cand2.open && cand1.close>=cand2.close && cand1.close>=cand2.close) // inside of body of the first candlestick
              {
               DrawSignal(prefix+"Three Inside Down the bear model"+string(objcount++),cand1,cand2,cand3,InpColorBear,comment);
              }
           }
         else
           {
            if(cand1.close>cand2.open && cand1.close>cand2.close && cand1.open<cand2.close) // inside of body of the first candlestick
              {
               DrawSignal(prefix+"Three Inside Down the bear model"+string(objcount++),cand1,cand2,cand3,InpColorBear,comment);
              }
           }
        }
      //------      
      // Tri Star, the bullish model
      if(cand1.trend==DOWN && // check direction of trend
         cand1.type==CAND_DOJI && cand2.type==CAND_DOJI && cand3.type==CAND_DOJI) // check of Doji
        {
         comment=_language?"Tri Star (Bull)":"Tri Star";
         if(_forex)// if it's forex
           {
            DrawSignal(prefix+"Tri Star the bull model"+string(objcount++),cand1,cand2,cand3,InpColorBull,comment);
           }
         else
           {
            if(cand2.open!=cand1.close && cand2.close!=cand3.open) // the second candlestick is on the other level
              {
               DrawSignal(prefix+"Tri Star the bull model"+string(objcount++),cand1,cand2,cand3,InpColorBull,comment);
              }
           }
        }
      // Tri Star, the bearish model
      if(cand1.trend==UPPER && // check direction of trend
         cand1.type==CAND_DOJI && cand2.type==CAND_DOJI && cand3.type==CAND_DOJI) // check of Doji
        {
         comment=_language?"Tri Star (Bear)":"Tri Star";
         if(_forex)// if it's forex
           {
            DrawSignal(prefix+"Tri Star the bear model"+string(objcount++),cand1,cand2,cand3,InpColorBear,comment);
           }
         else
           {
            if(cand2.open!=cand1.close && cand2.close!=cand3.open) // the second candlestick is on the other level
              {
               DrawSignal(prefix+"Tri Star the bear model"+string(objcount++),cand1,cand2,cand3,InpColorBear,comment);
              }
           }
        }
      //------      
      // Identical Three Crows, the bearish model
      if(cand1.trend==UPPER && !cand1.bull && !cand2.bull && !cand3.bull && // check direction of trend and direction of candlestick
         (cand1.type==CAND_LONG || cand1.type==CAND_MARIBOZU_LONG) && (cand2.type==CAND_LONG || cand2.type==CAND_MARIBOZU_LONG) && // check of "long" candlestick or "maribozu"
         (cand3.type==CAND_LONG || cand3.type==CAND_MARIBOZU_LONG)) // check of "long" candlestick and "maribozi"
        {
         comment=_language?"Identical Three Crows (Bear)":"Identical Three Crows";
         if(_forex)// if it's forex
           {
            DrawSignal(prefix+"Identical Three Crows the bear model"+string(objcount++),cand1,cand2,cand3,InpColorBear,comment);
           }
         else // other market
           {
            if(cand1.close>=cand2.open && cand2.close>=cand3.open) // open price is smaller or equal to close price of the previous candlestick
              {
               DrawSignal(prefix+"Identical Three Crows the bear model"+string(objcount++),cand1,cand2,cand3,InpColorBear,comment);
              }
           }
        }
      //------      
      // Unique Three River Bottom, the bullish model
      if(cand1.trend==DOWN && !cand1.bull && !cand2.bull && cand3.bull && // check direction of trend and direction of candlestick
         (cand1.type==CAND_LONG || cand1.type==CAND_MARIBOZU_LONG) && cand3.type==CAND_SHORT && // check of "long" candlestick or "maribozu" or the third day is short
         cand2.open<cand1.open && cand2.close>cand1.close && cand2.low<cand1.low && // body of the second candlestick is inside the first one, and its minimum is lower than the first one
         cand3.close<cand2.close) // the third candlestick is lower than the second one
        {
         comment=_language?"Unique Three River Bottom (Bull)":"Unique Three River Bottom";
         if(!_forex)// not forex
           {
            DrawSignal(prefix+"Unique Three River Bottom the bull model"+string(objcount++),cand1,cand2,cand3,InpColorBull,comment);
           }
        }
/* Continuation Models */
 
      //------      
      // Upside Gap Three Methods, the bullish model
      if(cand1.trend==UPPER && cand1.bull && cand2.bull && !cand3.bull && // check direction of trend and direction of candlestick
         (cand1.type==CAND_LONG || cand1.type==CAND_MARIBOZU_LONG) && (cand2.type==CAND_LONG || cand2.type==CAND_MARIBOZU_LONG) && // the first two candles are "long"
         cand2.open>cand1.close && // gap between the second and first candlesticks
         cand3.open>cand2.open && cand3.open<cand2.close && cand3.close<cand1.close) // the third candlestick is opened inside the second one and it fills the gap
        {
         comment=_language?"Upside Gap Three Methods (Bull)":"Upside Gap Three Methods";
         if(!_forex)// not forex
           {
            DrawSignal(prefix+"Upside Gap Three Methods the bull model"+string(objcount++),cand1,cand2,cand3,InpColorBull,comment);
           }
        }
      //------      
      // Downside Gap Three Methods, the bullish model
      if(cand1.trend==DOWN && !cand1.bull && !cand2.bull && cand3.bull && // check direction of trend and direction of candlestick
         (cand1.type==CAND_LONG || cand1.type==CAND_MARIBOZU_LONG) && (cand2.type==CAND_LONG || cand2.type==CAND_MARIBOZU_LONG) && // the first two candles are "long"
         cand2.open<cand1.close && // gap between the first and second candlesticks
         cand3.open<cand2.open && cand3.open>cand2.close && cand3.close>cand1.close) // the third candlestick is opened inside the second one and fills the gap
        {
         comment=_language?"Downside Gap Three Methods (Bear)":"Downside Gap Three Methods";
         if(!_forex)// not forex
           {
            DrawSignal(prefix+"Downside Gap Three Methods the bull model"+string(objcount++),cand1,cand2,cand3,InpColorBear,comment);
           }
        }
      //------      
      // Upside Tasuki Gap, the bullish model
      if(cand1.trend==UPPER && cand1.bull && cand2.bull && !cand3.bull && // check direction of trend and direction of candlestick
         cand1.type!=CAND_DOJI && cand2.type!=CAND_DOJI && // the first two candlesticks are not Doji
         cand2.open>cand1.close && // gap between the second and first candlesticks
         cand3.open>cand2.open && cand3.open<cand2.close && cand3.close<cand2.open && cand3.close>cand1.close) // the third candlestick is opened inside the second one and is closed inside the gap
        {
         comment=_language?"Upside Tasuki Gap (Bull)":"Upside Tasuki Gap";
         if(!_forex)// not forex
           {
            DrawSignal(prefix+"Upside Tasuki Gap the bull model"+string(objcount++),cand1,cand2,cand3,InpColorBull,comment);
           }
        }
      //------      
      // Downside Tasuki Gap, the bullish model
      if(cand1.trend==DOWN && !cand1.bull && !cand2.bull && cand3.bull && // check direction of trend and direction of candlestick
         cand1.type!=CAND_DOJI && cand2.type!=CAND_DOJI && // the first two candlesticks are not Doji
         cand2.open<cand1.close && // gap between the first and second candlesticks
         cand3.open<cand2.open && cand3.open>cand2.close && cand3.close>cand2.open && cand3.close<cand1.close) // the third candlestick is opened isnside the second one, and is closed within the gap
        {
         comment=_language?"Downside Tasuki Gap (Bear)":"Downside Tasuki Gap";
         if(!_forex)// not forex
           {
            DrawSignal(prefix+"Downside Tasuki Gap the bull model"+string(objcount++),cand1,cand2,cand3,InpColorBear,comment);
           }
        }

/* Check of patterns with four candlesticks */
/* Check of patterns with four candles */
      CANDLE_STRUCTURE cand4;
      cand4=cand3;
      cand3=cand2;
      cand2=cand1;
      if(!RecognizeCandle(_Symbol,_Period,time[i-3],InpPeriodSMA,cand1))
         continue;

      //------      
      // Concealing Baby Swallow, the bullish model
      if(cand1.trend==DOWN && !cand1.bull && !cand2.bull && !cand3.bull && !cand4.bull && // check direction of trend and direction of candlestick
         cand1.type==CAND_MARIBOZU_LONG && cand2.type==CAND_MARIBOZU_LONG && cand3.type==CAND_SHORT && // check of "maribozu"
         cand3.open<cand2.close && cand3.high>cand2.close && // the third candlestick with a lower gap, maximum is inside the second candlestick
         cand4.open>cand3.high && cand4.close<cand3.low) // the fourth candlestick fully consumes the third one
        {
         comment=_language?"Concealing Baby Swallow (Bull)":"Concealing Baby Swallow";
         if(!_forex)// not forex
           {
            DrawSignal(prefix+"Concealing Baby Swallow the bull model"+string(objcount++),cand1,cand2,cand4,InpColorBull,comment);
           }
        }
      //------      
      // Three-line strike, the bullish model
      if(cand1.trend==UPPER && cand1.bull && cand2.bull && cand3.bull && !cand4.bull && // check direction of trend and direction of candlestick
         (cand1.type==CAND_LONG || cand1.type==CAND_MARIBOZU_LONG) && (cand2.type==CAND_LONG || cand2.type==CAND_MARIBOZU_LONG) && // check of "long" candlestick or "maribozu"
         (cand3.type==CAND_LONG || cand3.type==CAND_MARIBOZU_LONG) && // check "long" candlestick and "maribozu"
         cand2.close>cand1.close && cand3.close>cand2.close && cand4.close<cand1.open) // closing of the second candlestick is above the first one,closing of the third one is above the second one; the fourth candlestick is closed below the first one
        {
         comment=_language?"Three-line strike (Bull)":"Three-line strike";
         if(_forex)// if it's forex
           {
            if(cand4.open>=cand3.close) // the fourth candlestick is opened above or on the same level with the third one
              {
               DrawSignal(prefix+"Three-line strike the bull model"+string(objcount++),cand1,cand3,cand4,InpColorBull,comment);
              }
           }
         else // other market
           {
            if(cand4.open>cand3.close) // the fourth candlestick is opened above the third one
              {
               DrawSignal(prefix+"Three-line strike the bull model"+string(objcount++),cand1,cand3,cand4,InpColorBull,comment);
              }
           }
        }
      //------      
      // Three-line strike, the bearish model
      if(cand1.trend==DOWN && !cand1.bull && !cand2.bull && !cand3.bull && cand4.bull && // check direction of trend and direction of candlestick
         (cand1.type==CAND_LONG || cand1.type==CAND_MARIBOZU_LONG) && (cand2.type==CAND_LONG || cand2.type==CAND_MARIBOZU_LONG) && // check of "long" candlestick or "maribozu"
         (cand3.type==CAND_LONG || cand3.type==CAND_MARIBOZU_LONG) && // check "long" candlestick and "maribozu"
         cand2.close<cand1.close && cand3.close<cand2.close && cand4.close>cand1.open) // closing of the second one is below the first, third is below the second, fourth is closed above the first one
        {
         comment=_language?"Three-line strike (Bear)":"Three-line strike";
         if(_forex)// if it's forex
           {
            if(cand4.open<=cand3.close) // the fourth candlestick is opened below or on the same level with the third one
              {
               DrawSignal(prefix+"Three-line strike the bear model"+string(objcount++),cand1,cand3,cand4,InpColorBear,comment);
              }
           }
         else // other market
           {
            if(cand4.open<cand3.close) // the fourth candlestick is opened below the third one
              {
               DrawSignal(prefix+"Three-line strike the bear model"+string(objcount++),cand1,cand3,cand4,InpColorBear,comment);
              }
           }
        }
/* Check of patterns with five candlesticks */
/* Check of patterns with five candles */
      CANDLE_STRUCTURE cand5;
      cand5=cand4;
      cand4=cand3;
      cand3=cand2;
      cand2=cand1;
      if(!RecognizeCandle(_Symbol,_Period,time[i-4],InpPeriodSMA,cand1))
         continue;

      //------      
      // Breakaway, the bullish model
      if(cand1.trend==DOWN && !cand1.bull && !cand2.bull && !cand4.bull && cand5.bull && // check direction of trend and direction of candlestick
         (cand1.type==CAND_LONG|| cand1.type==CAND_MARIBOZU_LONG) &&  // check of "long" first candlestick
         cand2.type==CAND_SHORT && cand2.open<cand1.close && // the second "candlestick" is "short" and is cut off the first one
         cand3.type==CAND_SHORT && cand4.type==CAND_SHORT && // the third and fourth candlesticks are "short"
         (cand5.type==CAND_LONG || cand5.type==CAND_MARIBOZU_LONG) && cand5.close<cand1.close && cand5.close>cand2.open) // the fifth one is "long", white and is closed inside the gap
        {
         comment=_language?"Breakaway (Bull)":"Breakaway";
         if(!_forex)// not forex
           {
            DrawSignal(prefix+"Breakaway the bull model"+string(objcount++),cand1,cand2,cand5,InpColorBull,comment);
           }
        }
      // Breakaway, the bearish model
      if(cand1.trend==UPPER && cand1.bull && cand2.bull && cand4.bull && !cand5.bull && // check direction of trend and direction of candlestick
         (cand1.type==CAND_LONG|| cand1.type==CAND_MARIBOZU_LONG) &&  // check of "long" first candlestick
         cand2.type==CAND_SHORT && cand2.open<cand1.close && // the second "candlestick" is "short" and is cut off the first one
         cand3.type==CAND_SHORT && cand4.type==CAND_SHORT && // the third and fourth candlesticks are "short"
         (cand5.type==CAND_LONG || cand5.type==CAND_MARIBOZU_LONG) && cand5.close>cand1.close && cand5.close<cand2.open) // the fifth candlestick is "long" and is closed inside the gap
        {
         comment=_language?"Breakaway (Bear)":"Breakaway";
         if(!_forex)// not forex
           {
            DrawSignal(prefix+"Breakaway the bear model"+string(objcount++),cand1,cand2,cand5,InpColorBear,comment);
           }
        }

     } // end of cycle of checks
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//----
   string objname;
   for(int i=ObjectsTotal(0,0,-1)-1;i>=0;i--)
     {
      objname=ObjectName(0,i);
      if(StringFind(objname,prefix)==-1)
         continue;
      else
         ObjectDelete(0,objname);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawSignal(string objname,CANDLE_STRUCTURE &cand,color Col,string comment)
  {
   string objtext=objname+"text";
   if(ObjectFind(0,objtext)>=0) ObjectDelete(0,objtext);
   if(ObjectFind(0,objname)>=0) ObjectDelete(0,objname);

   if(InpAlert && cand.time>=CurTime)
     {
      Alert(Symbol()," ",PeriodToString(_Period)," ",comment);
     }
   if(Col==InpColorBull)
     {
      ObjectCreate(0,objname,OBJ_ARROW_BUY,0,cand.time,cand.low);
      ObjectSetInteger(0,objname,OBJPROP_ANCHOR,ANCHOR_TOP);
      if(InpCommentOn)
        {
         ObjectCreate(0,objtext,OBJ_TEXT,0,cand.time,cand.low);
         ObjectSetInteger(0,objtext,OBJPROP_ANCHOR,ANCHOR_LEFT);
         ObjectSetDouble(0,objtext,OBJPROP_ANGLE,-90);
        }
     }
   else
     {
      ObjectCreate(0,objname,OBJ_ARROW_SELL,0,cand.time,cand.high);
      ObjectSetInteger(0,objname,OBJPROP_ANCHOR,ANCHOR_BOTTOM);
      if(InpCommentOn)
        {
         ObjectCreate(0,objtext,OBJ_TEXT,0,cand.time,cand.high);
         ObjectSetInteger(0,objtext,OBJPROP_ANCHOR,ANCHOR_LEFT);
         ObjectSetDouble(0,objtext,OBJPROP_ANGLE,90);
        }
     }
   ObjectSetInteger(0,objname,OBJPROP_COLOR,Col);
   ObjectSetInteger(0,objname,OBJPROP_BACK,false);
   ObjectSetString(0,objname,OBJPROP_TEXT,comment);
   if(InpCommentOn)
     {
      ObjectSetInteger(0,objtext,OBJPROP_COLOR,Col);
      ObjectSetString(0,objtext,OBJPROP_FONT,"Tahoma");
      ObjectSetInteger(0,objtext,OBJPROP_FONTSIZE,InpTextFontSize);
      ObjectSetString(0,objtext,OBJPROP_TEXT,"    "+comment);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawSignal(string objname,CANDLE_STRUCTURE &cand1,CANDLE_STRUCTURE &cand2,color Col,string comment)
  {
   string objtext=objname+"text";
   double price_low=MathMin(cand1.low,cand2.low);
   double price_high=MathMax(cand1.high,cand2.high);

   if(ObjectFind(0,objtext)>=0) ObjectDelete(0,objtext);
   if(ObjectFind(0,objname)>=0) ObjectDelete(0,objname);
   if(InpAlert && cand2.time>=CurTime)
     {
      Alert(Symbol()," ",PeriodToString(_Period)," ",comment);
     }

   ObjectCreate(0,objname,OBJ_RECTANGLE,0,cand1.time,price_low,cand2.time,price_high);
   if(Col==InpColorBull)
     {
      if(InpCommentOn)
        {
         ObjectCreate(0,objtext,OBJ_TEXT,0,cand1.time,price_low);
         ObjectSetInteger(0,objtext,OBJPROP_ANCHOR,ANCHOR_LEFT);
         ObjectSetDouble(0,objtext,OBJPROP_ANGLE,-90);
        }
     }
   else
     {
      if(InpCommentOn)
        {
         ObjectCreate(0,objtext,OBJ_TEXT,0,cand1.time,price_high);
         ObjectSetInteger(0,objtext,OBJPROP_ANCHOR,ANCHOR_LEFT);
         ObjectSetDouble(0,objtext,OBJPROP_ANGLE,90);
        }
     }
   ObjectSetInteger(0,objname,OBJPROP_COLOR,Col);
   ObjectSetInteger(0,objname,OBJPROP_BACK,false);
   ObjectSetString(0,objname,OBJPROP_TEXT,comment);
   if(InpCommentOn)
     {
      ObjectSetInteger(0,objtext,OBJPROP_COLOR,Col);
      ObjectSetString(0,objtext,OBJPROP_FONT,"Tahoma");
      ObjectSetInteger(0,objtext,OBJPROP_FONTSIZE,InpTextFontSize);
      ObjectSetString(0,objtext,OBJPROP_TEXT,"    "+comment);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawSignal(string objname,CANDLE_STRUCTURE &cand1,CANDLE_STRUCTURE &cand2,CANDLE_STRUCTURE &cand3,color Col,string comment)
  {
   string objtext=objname+"text";
   double price_low=MathMin(cand1.low,MathMin(cand2.low,cand3.low));
   double price_high=MathMax(cand1.high,MathMax(cand2.high,cand3.high));

   if(ObjectFind(0,objtext)>=0) ObjectDelete(0,objtext);
   if(ObjectFind(0,objname)>=0) ObjectDelete(0,objname);
   if(InpAlert && cand3.time>=CurTime)
     {
      Alert(Symbol()," ",PeriodToString(_Period)," ",comment);
     }
   ObjectCreate(0,objname,OBJ_RECTANGLE,0,cand1.time,price_low,cand3.time,price_high);
   if(Col==InpColorBull)
     {
      if(InpCommentOn)
        {
         ObjectCreate(0,objtext,OBJ_TEXT,0,cand3.time,price_low);
         ObjectSetInteger(0,objtext,OBJPROP_ANCHOR,ANCHOR_LEFT);
         ObjectSetDouble(0,objtext,OBJPROP_ANGLE,-90);
        }
     }
   else
     {
      if(InpCommentOn)
        {
         ObjectCreate(0,objtext,OBJ_TEXT,0,cand3.time,price_high);
         ObjectSetInteger(0,objtext,OBJPROP_ANCHOR,ANCHOR_LEFT);
         ObjectSetDouble(0,objtext,OBJPROP_ANGLE,90);
        }
     }
   ObjectSetInteger(0,objname,OBJPROP_COLOR,Col);
   ObjectSetInteger(0,objname,OBJPROP_BACK,false);
   ObjectSetInteger(0,objname,OBJPROP_WIDTH,2);
   ObjectSetString(0,objname,OBJPROP_TEXT,comment);
   if(InpCommentOn)
     {
      ObjectSetInteger(0,objtext,OBJPROP_COLOR,Col);
      ObjectSetString(0,objtext,OBJPROP_FONT,"Tahoma");
      ObjectSetInteger(0,objtext,OBJPROP_FONTSIZE,InpTextFontSize);
      ObjectSetString(0,objtext,OBJPROP_TEXT,"    "+comment);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string PeriodToString(ENUM_TIMEFRAMES period)
  {
   switch(period)
     {
      case PERIOD_M1: return("M1");
      case PERIOD_M2: return("M2");
      case PERIOD_M3: return("M3");
      case PERIOD_M4: return("M4");
      case PERIOD_M5: return("M5");
      case PERIOD_M6: return("M6");
      case PERIOD_M10: return("M10");
      case PERIOD_M12: return("M12");
      case PERIOD_M15: return("M15");
      case PERIOD_M20: return("M20");
      case PERIOD_M30: return("M30");
      case PERIOD_H1: return("H1");
      case PERIOD_H2: return("H2");
      case PERIOD_H3: return("H3");
      case PERIOD_H4: return("H4");
      case PERIOD_H6: return("H6");
      case PERIOD_H8: return("H8");
      case PERIOD_H12: return("H12");
      case PERIOD_D1: return("D1");
      case PERIOD_W1: return("W1");
      case PERIOD_MN1: return("MN1");
     }
   return(NULL);
  };
//+------------------------------------------------------------------+
