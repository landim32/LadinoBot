//+------------------------------------------------------------------+
//|                                                       winreg.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#include <WinAPI\windef.mqh>
#include <WinAPI\winnt.mqh>

//---
struct VALENTW
  {
   PVOID             ve_valuename;
   uint              ve_valuelen;
   uchar             offset1[4];
   PVOID             ve_valueptr;
   uint              ve_type;
   uchar             offset2[4];
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#import "advapi32.dll"
int     AbortSystemShutdownW(string machine_name);
uint    CheckForHiberboot(uchar &hiberboot,uchar clear_flag);
uint    InitiateShutdownW(string machine_name,string message,uint grace_period,uint shutdown_flags,uint reason);
int     InitiateSystemShutdownExW(string machine_name,string message,uint timeout,int force_apps_closed,int reboot_after_shutdown,uint reason);
int     InitiateSystemShutdownW(string machine_name,string message,uint timeout,int force_apps_closed,int reboot_after_shutdown);
long    RegCloseKey(HANDLE key);
long    RegConnectRegistryExW(const string machine_name,HANDLE key,ulong Flags,HANDLE &result);
long    RegConnectRegistryW(const string machine_name,HANDLE key,HANDLE &result);
long    RegCopyTreeW(HANDLE key_src,const string sub_key,HANDLE key_dest);
long    RegCreateKeyExW(HANDLE key,const string sub_key,PVOID reserved,string class_name,uint options,uint desired,PVOID security_attributes,HANDLE &result,uint &disposition);
long    RegCreateKeyTransactedW(HANDLE key,const string sub_key,PVOID reserved,string class_name,uint options,uint desired,PVOID security_attributes,HANDLE &result,uint &disposition,HANDLE transaction,PVOID extended_parameter);
long    RegCreateKeyW(HANDLE key,const string sub_key,HANDLE &result);
long    RegDeleteKeyExW(HANDLE key,const string sub_key,uint desired,PVOID reserved);
long    RegDeleteKeyTransactedW(HANDLE key,const string sub_key,uint desired,PVOID reserved,HANDLE transaction,PVOID extended_parameter);
long    RegDeleteKeyValueW(HANDLE key,const string sub_key,const string value_name);
long    RegDeleteKeyW(HANDLE key,const string sub_key);
long    RegDeleteTreeW(HANDLE key,const string sub_key);
long    RegDeleteValueW(HANDLE key,const string value_name);
long    RegDisablePredefinedCache(void);
long    RegDisablePredefinedCacheEx(void);
long    RegDisableReflectionKey(HANDLE base);
long    RegEnableReflectionKey(HANDLE base);
long    RegEnumKeyExW(HANDLE key,uint index,ushort &name[],uint &name_size,PVOID reserved,ushort &class_name[],uint &class_size,FILETIME &last_write_time);
long    RegEnumKeyW(HANDLE key,uint index,ushort &name[],uint &name_size);
long    RegEnumValueW(HANDLE key,uint index,ushort &value_name[],uint &value_name_size,PVOID reserved,uint &type,uchar &data[],uint &data_size);
long    RegFlushKey(HANDLE key);
long    RegGetKeySecurity(HANDLE key,uint SecurityInformation,SECURITY_DESCRIPTOR &security_descriptor,uint &security_descriptor_size);
long    RegGetValueW(HANDLE key,const string sub_key,const string value,uint flags,uint &type,uchar &data[],uint &data_size);
long    RegLoadAppKeyW(const string file,HANDLE &result,uint desired,uint options,PVOID reserved);
long    RegLoadKeyW(HANDLE key,const string sub_key,const string file);
long    RegLoadMUIStringW(HANDLE key,const string value,ushort &out_buf[],uint &out_buf_size,uint &data,uint flags,const string directory);
long    RegNotifyChangeKeyValue(HANDLE key,int watch_subtree,uint notify_filter,HANDLE event,int asynchronous);
long    RegOpenCurrentUser(uint desired,HANDLE &result);
long    RegOpenKeyExW(HANDLE key,const string sub_key,uint options,uint desired,HANDLE &result);
long    RegOpenKeyTransactedW(HANDLE key,const string sub_key,uint options,uint desired,HANDLE &result,HANDLE transaction,PVOID extended_paremeter);
long    RegOpenKeyW(HANDLE key,const string sub_key,HANDLE &result);
long    RegOpenUserClassesRoot(HANDLE token,uint options,uint desired,HANDLE &result);
long    RegOverridePredefKey(HANDLE key,HANDLE new_key);
long    RegQueryInfoKeyW(HANDLE key,string class_name,uint &class_size,PVOID reserved,uint &sub_keys,uint &max_sub_key_len,uint &max_class_len,uint &values,uint &max_value_name_len,uint &max_value_len,uint &security_descriptor,FILETIME &last_write_time);
long    RegQueryMultipleValuesW(HANDLE key,VALENTW &val_list[],uint num_vals,ushort &value_buf[],uint &totsize);
long    RegQueryReflectionKey(HANDLE base,int &is_reflection_disabled);
long    RegQueryValueExW(HANDLE key,const string value_name,PVOID reserved,uint &type,uchar &data[],uint &data_size);
long    RegQueryValueW(HANDLE key,const string sub_key,uchar &data[],uint &data_size);
long    RegRenameKey(HANDLE key,const string sub_key_name,const string new_key_name);
long    RegReplaceKeyW(HANDLE key,const string sub_key,const string new_file,const string old_file);
long    RegRestoreKeyW(HANDLE key,const string file,uint flags);
long    RegSaveKeyExW(HANDLE key,const string file,PVOID security_attributes,uint flags);
long    RegSaveKeyW(HANDLE key,const string file,PVOID security_attributes);
long    RegSetKeySecurity(HANDLE key,uint SecurityInformation,SECURITY_DESCRIPTOR &security_descriptor);
long    RegSetKeyValueW(HANDLE key,const string sub_key,const string value_name,uint type,const uchar &data[],uint data);
long    RegSetValueExW(HANDLE key,const string value_name,PVOID reserved,uint type,const uchar &data[],uint data_size);
long    RegSetValueW(HANDLE key,const string sub_key,uint type,const ushort &data[],uint data_size);
long    RegUnLoadKeyW(HANDLE key,const string sub_key);
#import
//+------------------------------------------------------------------+