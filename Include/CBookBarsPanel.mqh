//+------------------------------------------------------------------+
//|                                               CBookBarsPanel.mqh |
//|                                           Copyright 2014, denkir |
//|                           https://login.mql5.com/ru/users/denkir |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, denkir"
#property link      "https://login.mql5.com/ru/users/denkir"
//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include <Arrays\ArrayObj.mqh>
#include <ChartObjects\ChartObjectsTxtControls.mqh>
//+------------------------------------------------------------------+
//| Book record class                                                |
//+------------------------------------------------------------------+
class CBookRecord : public CObject
  {
private:
   //--- Data members
   CChartObjectRectLabel *m_rect;
   CChartObjectLabel *m_price;
   CChartObjectLabel *m_vol;
   //---
   color             m_color;

   //--- Methods
public:
   void              CBookRecord(void);
   void             ~CBookRecord(void);
   bool              Create(const string _name,const color _color,const int _X,
                            const int _Y,const int _X_size,const int _Y_size);
   //--- data
   bool              DataSet(const long _vol,const double _pr,const uint _len);
   bool              DataGet(long &_vol,double &_pr) const;

private:
   string            StringVolumeFormat(const long _vol);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
void CBookRecord::CBookRecord(void)
  {
   this.m_rect=this.m_price=this.m_vol=NULL;
//---
   this.m_color=clrNONE;
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
void CBookRecord::~CBookRecord(void)
  {
//--- delete pointers
   if(CheckPointer(this.m_rect)==POINTER_DYNAMIC)
      delete this.m_rect;
   if(CheckPointer(this.m_price)==POINTER_DYNAMIC)
      delete this.m_price;
   if(CheckPointer(this.m_vol)==POINTER_DYNAMIC)
      delete this.m_vol;
  }
//+------------------------------------------------------------------+
//| Create                                                           |
//+------------------------------------------------------------------+
bool CBookRecord::Create(const string _name,const color _color,const int _X,
                         const int _Y,const int _X_size,const int _Y_size)
  {
   this.m_rect=new CChartObjectRectLabel;
   if(CheckPointer(this.m_rect)==POINTER_DYNAMIC)
     {
      this.m_price=new CChartObjectLabel;
      if(CheckPointer(this.m_price)==POINTER_DYNAMIC)
        {
         this.m_vol=new CChartObjectLabel;
         if(CheckPointer(this.m_vol)==POINTER_DYNAMIC)
           {
            //--- create rectangle label
            if(this.m_rect.Create(0,"bar_"+_name,0,_X,_Y,_X_size,_Y_size))
               if(this.m_rect.BackColor(_color))
                  if(this.m_rect.BorderType(BORDER_FLAT))
                    {
                     //--- create price label
                     if(this.m_price.Create(0,"pr_"+_name,0,_X-15,_Y))
                        if(this.m_price.FontSize(8))
                           if(this.m_price.Color(_color))
                              if(this.m_price.Anchor(ANCHOR_RIGHT_UPPER))
                                 //--- create volume label
                                 if(this.m_vol.Create(0,"vol_"+_name,0,_X+_X_size+15,_Y))
                                    if(this.m_vol.FontSize(8))
                                       if(this.m_vol.Color(_color))
                                          if(this.m_vol.Anchor(ANCHOR_LEFT_UPPER))
                                             return true;
                    }
           }
        }
     }
//--- 
   return false;
  }
//+------------------------------------------------------------------+
//| Set volume & price data                                          |
//+------------------------------------------------------------------+
bool CBookRecord::DataSet(const long _vol,const double _pr,const uint _len)
  {
   if(CheckPointer(this.m_price)==POINTER_DYNAMIC)
      if(this.m_price.SetString(OBJPROP_TEXT,DoubleToString(_pr,_Digits)))
         if(CheckPointer(this.m_vol)==POINTER_DYNAMIC)
            if(this.m_vol.SetString(OBJPROP_TEXT,this.StringVolumeFormat(_vol)))
               if(this.m_rect.X_Size(_len))
                  return true;
//---
   return false;
  }
//+------------------------------------------------------------------+
//| Get volume & price data                                          |
//+------------------------------------------------------------------+
bool CBookRecord::DataGet(long &_vol,double &_pr) const
  {
   string pr_str,vol_str;
   if(CheckPointer(this.m_price)==POINTER_DYNAMIC)
      if(this.m_price.GetString(OBJPROP_TEXT,0,pr_str))
         if(CheckPointer(this.m_vol)==POINTER_DYNAMIC)
            if(this.m_vol.GetString(OBJPROP_TEXT,0,vol_str))
              {
               _pr=StringToDouble(pr_str);
               _vol=StringToInteger(vol_str);
               return true;
              }

//---
   return false;
  }
//+------------------------------------------------------------------+
//| Book bars class                                                  |
//+------------------------------------------------------------------+
class CBookBarsPanel
  {
private:
   //--- Data members
   CArrayObj         m_obj_arr;
   uint              m_arr_size;
   //---
   uint              m_width;
   uint              m_height;

   //--- Methods
public:
   void              CBookBarsPanel(const uint _arr_size);
   void             ~CBookBarsPanel(void){};
   //---
   bool              Init(const uint _width,const uint _height);
   void              Deinit(void){this.m_obj_arr.Clear();};
   void              Refresh(const MqlBookInfo &_bookArray[]);
  };
//+------------------------------------------------------------------+
//| Parameter constructor                                            |
//+------------------------------------------------------------------+
void CBookBarsPanel::CBookBarsPanel(const uint _arr_size)
  {
   this.m_arr_size=_arr_size;
  }
//+------------------------------------------------------------------+
//| Initialization                                                   |
//+------------------------------------------------------------------+
bool CBookBarsPanel::Init(const uint _width,const uint _height)
  {
//--- panel size
   this.m_width=_width;
   this.m_height=_height;

//--- allocate memory
   if(this.m_obj_arr.Reserve(this.m_arr_size))
     {
      //--- the memory management flag 
      this.m_obj_arr.FreeMode(true);
      //--- panel label
      CChartObjectRectLabel *ptr_rect_label=new CChartObjectRectLabel;
      if(CheckPointer(ptr_rect_label)==POINTER_DYNAMIC)
         if(ptr_rect_label.Create(0,"Panel",0,15,15,this.m_width,this.m_height))
            if(ptr_rect_label.BorderType(BORDER_RAISED))
               if(this.m_obj_arr.Add(ptr_rect_label))
                 {
                  //--- bar label 
                  uint curr_x=this.m_width/5;
                  uint curr_y=35;
                  uint mid_idx=this.m_arr_size/2-1;
                  for(uint idx=0;idx<this.m_arr_size;idx++)
                    {
                     color rec_color=(idx<(mid_idx+1))?clrRed:clrGreen;
                     //---
                     CBookRecord *ptr_record=new CBookRecord;
                     if(CheckPointer(ptr_record)==POINTER_DYNAMIC)
                        if(ptr_record.Create(IntegerToString(idx+1),rec_color,curr_x+15,
                           curr_y,curr_x*3,10))
                           if(this.m_obj_arr.Add(ptr_record))
                              curr_y+=(idx==mid_idx)?24:13;
                    }
                 }
     }

//---
   return this.m_obj_arr.Total()==(this.m_arr_size+1);
  }
//+------------------------------------------------------------------+
//| Refresh                                                          |
//+------------------------------------------------------------------+
void CBookBarsPanel::Refresh(const MqlBookInfo &_bookArray[])
  {
   int arr_size=ArraySize(_bookArray);
//---
   long book_vols[];
   if(ArrayResize(book_vols,arr_size)==arr_size)
     {
      //--- parse the book array
      for(int idx=0;idx<arr_size;idx++)
         book_vols[idx]=_bookArray[idx].volume;
     }
//---
   int idx_max=ArrayMaximum(book_vols);
   if(idx_max>-1)
     {
      long max_vol=book_vols[idx_max];
      if(max_vol>0)
        {
         uint curr_x=this.m_width/5;
         //---
         for(int idx=0;idx<arr_size;idx++)
           {
            CBookRecord *ptr_rec=this.m_obj_arr.At(idx+1);
            if(ptr_rec!=NULL)
              {
               double coeff=MathRound((book_vols[idx]*100.)/max_vol);
               uint length=(uint)(MathRound(3*curr_x*coeff/100.));
               double curr_pr=_bookArray[idx].price;
               //---
               ptr_rec.DataSet(book_vols[idx],curr_pr,length);
              }
           }
         //--- force to redraw
         ChartRedraw();
        }
     }
  }
//+------------------------------------------------------------------+
//| Format a volume value and return a string                        |
//+------------------------------------------------------------------+
string CBookRecord::StringVolumeFormat(const long _vol)
  {
   string vol_str=NULL;
   string prefix=NULL;
   int digs=0;
//---
   double log10_val=MathLog10(_vol);
   double temp_vol=(double)_vol;
//---
   if(log10_val>=3. && log10_val<6.)
     {
      prefix="K";
      temp_vol/=1e3;
      digs=2;
     }
   else if(log10_val>=6. && log10_val<9.)
     {
      prefix="M";
      temp_vol/=1e6;
      digs=2;
     }
   else if(log10_val>=9. && log10_val<12.)
     {
      prefix="B";
      temp_vol/=1e9;
      digs=2;
     }
//---
   string temp_vol_str=DoubleToString(temp_vol,digs);
   vol_str=prefix+temp_vol_str;
//---
   return vol_str;
  }
//+------------------------------------------------------------------+
