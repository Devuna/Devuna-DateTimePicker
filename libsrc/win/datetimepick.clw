!region Copyright and License
! ================================================================================
!                           Devuna Date Time Picker Class
! ================================================================================
! Notice : Copyright (C) 2017, Devuna
!          Distributed under LGPLv3 (http://www.gnu.org/licenses/lgpl.html)
!
!    This file is part of Devuna-DateTimePicker (https://github.com/Devuna/Devuna-DateTimePicker)
!
!    Devuna-DateTimePicker is free software: you can redistribute it and/or modify
!    it under the terms of the GNU General Public License as published by
!    the Free Software Foundation, either version 3 of the License, or
!    (at your option) any later version.
!
!    Devuna-DateTimePicker is distributed in the hope that it will be useful,
!    but WITHOUT ANY WARRANTY; without even the implied warranty of
!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!    GNU General Public License for more details.
!
!    You should have received a copy of the GNU General Public License
!    along with Devuna-DateTimePicker.  If not, see <http://www.gnu.org/licenses/>.
! ================================================================================
!endRegion

!********************************************************************************
! Source module name:  datetimepick.clw
! Release Version:     DateTimePicker Version 2017.02.02
!
!Version 2017.02.02
!rebuild for Clarion 10.0.12463
!
!Version 2005.10.09
!rebuild for Clarion 10
!
!Version 2005.10.09
!compatible with clarion version 6.2.9048
!********************************************************************************
 MEMBER

 INCLUDE('DATETIMEPICK.INC'),ONCE

 MAP
    MCWindowProc(HWND hWnd, UINT wMsg, WPARAM wParam, LPARAM lParam),LONG,PASCAL
    MODULE('API')
     CallWindowProc(ULONG,HWND,UINT,WPARAM,LPARAM),LONG,PASCAL,NAME('CallWindowProcA')
     CreateFont(SIGNED,SIGNED,SIGNED,SIGNED,SIGNED,DWORD,DWORD,DWORD,DWORD,DWORD,DWORD,DWORD,DWORD,ULONG),UNSIGNED,PASCAL,RAW,NAME('CreateFontA')
     CreatePen(SIGNED,SIGNED,COLORREF),HANDLE,PASCAL
     CreateWindowEx(DWORD,*CSTRING,*CSTRING,DWORD,SIGNED,SIGNED,SIGNED,SIGNED,HWND,HANDLE,HANDLE,ULONG),HWND,PASCAL,RAW,NAME('CreateWindowExA')
     DeleteObject(UNSIGNED),BOOL,PASCAL,PROC
     DestroyWindow(HWND),BOOL,PASCAL,PROC
     EnableWindow(HWND,BOOL),BOOL,PASCAL,PROC
     GetDC(HWND),HANDLE,PASCAL
     GetDeviceCaps(HANDLE,SIGNED),SIGNED,PASCAL
     GetLocaleInfo(ULONG,ULONG,*CSTRING,SIGNED),SIGNED,PASCAL,RAW,NAME('GetLocaleInfoA'),PROC
     GetParent(HWND),HWND,PASCAL
     GetWindowLong(HWND,SHORT),LONG,RAW,PASCAL,NAME('GetWindowLongA')
     keybd_event(BYTE,BYTE,DWORD,DWORD),PASCAL
     MoveWindow(HWND, SIGNED, SIGNED, SIGNED, SIGNED, BOOL),BOOL, PASCAL, PROC, NAME('MoveWindow')
     MulDiv(SIGNED,SIGNED,SIGNED),SIGNED,PASCAL
     ReleaseDC(HWND,HANDLE),SIGNED,PASCAL,PROC
     SelectObject(HANDLE, HANDLE),HANDLE,PASCAL,PROC
     SendMessage(HWND,UNSIGNED,WPARAM,LPARAM),LRESULT, PASCAL, PROC, NAME('SendMessageA')
     SetFocus(HWND),HWND,PASCAL,PROC
     SetTextColor(HWND,COLORREF),COLORREF,PASCAL,PROC
     SetWindowLong(HWND,SHORT,LONG),LONG,RAW,PASCAL,NAME('SetWindowLongA'),PROC
     SetWindowPos(HWND,HWND,SIGNED,SIGNED,SIGNED,SIGNED,UNSIGNED),BOOL,RAW,PASCAL,PROC
     ShowWindow(HWND,SIGNED),BOOL,PASCAL,NAME('ShowWindow'),PROC
   END
   MODULE('CMDDLG')
     InitCommonControlsEx(*tagInitCommonControlsEx),BOOL,PASCAL,RAW,PROC
   END
   MODULE('CLIB')
     memcpy(ulong,ulong,unsigned),name('_memcpy')
   END
 END

DTM_FIRST               EQUATE(01000h)
DTM_GETSYSTEMTIME       EQUATE(DTM_FIRST + 1)
DTM_SETSYSTEMTIME       EQUATE(DTM_FIRST + 2)
DTM_GETRANGE            EQUATE(DTM_FIRST + 3)
DTM_SETRANGE            EQUATE(DTM_FIRST + 4)
DTM_SETFORMAT           EQUATE(DTM_FIRST + 5)
DTM_SETMCCOLOR          EQUATE(DTM_FIRST + 6)
DTM_GETMCCOLOR          EQUATE(DTM_FIRST + 7)
DTM_GETMONTHCAL         EQUATE(DTM_FIRST + 8)
DTM_SETMCFONT           EQUATE(DTM_FIRST + 9)
DTM_GETMCFONT           EQUATE(DTM_FIRST + 10)

DTS_UPDOWN              EQUATE(00001h) ! use UPDOWN instead of MONTHCAL
DTS_SHOWNONE            EQUATE(00002h) ! allow a NONE selection
DTS_SHORTDATEFORMAT     EQUATE(00000h) ! use the short date format (app must forward WM_WININICHANGE messages)
DTS_LONGDATEFORMAT      EQUATE(00004h) ! use the long date format (app must forward WM_WININICHANGE messages)
DTS_TIMEFORMAT          EQUATE(00009h) ! use the time format (app must forward WM_WININICHANGE messages)
DTS_APPCANPARSE         EQUATE(00010h) ! allow user entered strings (app MUST respond to DTN_USERSTRING)
DTS_RIGHTALIGN          EQUATE(00020h) ! right-align popup instead of left-align it

tagNMHDR    GROUP,TYPE
hwndFrom        UNSIGNED
idFrom          UNSIGNED
nmcode          UNSIGNED    ! NM_ code
            END

tagSIZE GROUP,TYPE
cx       SIGNED
cy       SIGNED
        END

tagSYSTEMTIME   GROUP,TYPE              !System time struct
wYear            USHORT
wMonth           USHORT
wDayOfWeek       USHORT
wDay             USHORT
wHour            USHORT
wMinute          USHORT
wSecond          USHORT
wMilliseconds    USHORT
                END

tagNMDATETIMECHANGE GROUP,TYPE
nmhdr                   LIKE(tagNMHDR)
dwFlags                 ULONG               ! GDT_VALID or GDT_NONE
st                      LIKE(tagSYSTEMTIME)    ! valid iff dwFlags==GDT_VALID
                    END

tagNMDATETIMESTRING GROUP,TYPE
nmhdr                   LIKE(tagNMHDR)
pszUserString           ULONG               ! string user entered
st                      LIKE(tagSYSTEMTIME)    ! app fills this in
dwFlags                 ULONG               ! GDT_VALID or GDT_NONE
                    END

tagNMDATETIMEWMKEYDOWN  GROUP,TYPE
nmhdr                       LIKE(tagNMHDR)
nVirtKey                    SIGNED              ! virtual key code of WM_KEYDOWN which MODIFIES an X field
pszFormat                   ULONG              ! format substring
st                          LIKE(tagSYSTEMTIME)    ! current systemtime, app should modify based on key
                        END

tagNMDATETIMEFORMAT GROUP,TYPE
nmhdr                   LIKE(tagNMHDR)
pszFormat               ULONG               ! format substring
st                      LIKE(tagSYSTEMTIME)    ! current systemtime
pszDisplay              ULONG               ! string to display
szDisplay               CSTRING(64)         ! buffer pszDisplay originally points at
                    END

tagNMDATETIMEFORMATQUERY    GROUP,TYPE
nmhdr                           LIKE(tagNMHDR)
pszFormat                       ULONG          ! format substring
szMax                           LIKE(tagSIZE)  ! max bounding rectangle app will use for this format string
                            END

WM_COMMNOTIFY       EQUATE(44H)
 
ICC_DATE_CLASSES    EQUATE(100H)

tagInitCommonControlsEx GROUP,TYPE
lngSize                     LONG
lngICC                      LONG
                        END

DATETIMEPICK_CLASSA     EQUATE('SysDateTimePick32')

CW_USEDEFAULT           EQUATE(080000000h)

!  Default System and User IDs for language and locale.
LANG_SYSTEM_DEFAULT    EQUATE(2)
LANG_USER_DEFAULT      EQUATE(1)

LOCALE_SYSTEM_DEFAULT  EQUATE(LANG_SYSTEM_DEFAULT)
LOCALE_USER_DEFAULT    EQUATE(LANG_USER_DEFAULT)

!  Locale Types.
!  These types are used for the GetLocaleInfoA NLS API routine.

LOCALE_NOUSEROVERRIDE   EQUATE(080000000h)  ! OR in to avoid user override

LOCALE_ILANGUAGE            EQUATE(00001h)  ! language id 
LOCALE_SLANGUAGE            EQUATE(00002h)  ! localized name of language 
LOCALE_SENGLANGUAGE         EQUATE(01001h)  ! English name of language 
LOCALE_SABBREVLANGNAME      EQUATE(00003h)  ! abbreviated language name 
LOCALE_SNATIVELANGNAME      EQUATE(00004h)  ! native name of language 
LOCALE_ICOUNTRY             EQUATE(00005h)  ! country code 
LOCALE_SCOUNTRY             EQUATE(00006h)  ! localized name of country   
LOCALE_SENGCOUNTRY          EQUATE(01002h)  ! English name of country   
LOCALE_SABBREVCTRYNAME      EQUATE(00007h)  ! abbreviated country name 
LOCALE_SNATIVECTRYNAME      EQUATE(00008h)  ! native name of country   
LOCALE_IDEFAULTLANGUAGE     EQUATE(00009h)  ! default language id 
LOCALE_IDEFAULTCOUNTRY      EQUATE(0000Ah)  ! default country code 
LOCALE_IDEFAULTCODEPAGE     EQUATE(0000Bh)  ! default oem code page 
LOCALE_IDEFAULTANSICODEPAGE EQUATE(01004h)  ! default ansi code page 
                                            
LOCALE_SLIST                EQUATE(0000Ch)  ! list item separator 
LOCALE_IMEASURE             EQUATE(0000Dh)  ! 0 = metric, 1 = US 
                                            
LOCALE_SDECIMAL             EQUATE(0000Eh)  ! decimal separator 
LOCALE_STHOUSAND            EQUATE(0000Fh)  ! thousand separator 
LOCALE_SGROUPING            EQUATE(00010h)  ! digit grouping 
LOCALE_IDIGITS              EQUATE(00011h)  ! number of fractional digits 
LOCALE_ILZERO               EQUATE(00012h)  ! leading zeros for decimal 
LOCALE_INEGNUMBER           EQUATE(01010h)  ! negative number mode 
LOCALE_SNATIVEDIGITS        EQUATE(00013h)  ! native ascii 0-9 
                                            
LOCALE_SCURRENCY            EQUATE(00014h)  ! local monetary symbol 
LOCALE_SINTLSYMBOL          EQUATE(00015h)  ! intl monetary symbol 
LOCALE_SMONDECIMALSEP       EQUATE(00016h)  ! monetary decimal separator 
LOCALE_SMONTHOUSANDSEP      EQUATE(00017h)  ! monetary thousand separator 
LOCALE_SMONGROUPING         EQUATE(00018h)  ! monetary grouping 
LOCALE_ICURRDIGITS          EQUATE(00019h)  ! # local monetary digits 
LOCALE_IINTLCURRDIGITS      EQUATE(0001Ah)  ! # intl monetary digits 
LOCALE_ICURRENCY            EQUATE(0001Bh)  ! positive currency mode 
LOCALE_INEGCURR             EQUATE(0001Ch)  ! negative currency mode 
                                            
LOCALE_SDATE                EQUATE(0001Dh)  ! date separator 
LOCALE_STIME                EQUATE(0001Eh)  ! time separator 
LOCALE_SSHORTDATE           EQUATE(0001Fh)  ! short date-time separator 
LOCALE_SLONGDATE            EQUATE(00020h)  ! long date-time separator 
LOCALE_STIMEFORMAT          EQUATE(01003h)  ! time format string 
LOCALE_IDATE                EQUATE(00021h)  ! short date format ordering 
LOCALE_ILDATE               EQUATE(00022h)  ! long date format ordering 
LOCALE_ITIME                EQUATE(00023h)  ! time format specifier 
LOCALE_ITIMEMARKPOSN        EQUATE(01005h)  ! time marker position 
LOCALE_ICENTURY             EQUATE(00024h)  ! century format specifier 
LOCALE_ITLZERO              EQUATE(00025h)  ! leading zeros in time field 
LOCALE_IDAYLZERO            EQUATE(00026h)  ! leading zeros in day field 
LOCALE_IMONLZERO            EQUATE(00027h)  ! leading zeros in month field 
LOCALE_S1159                EQUATE(00028h)  ! AM designator 
LOCALE_S2359                EQUATE(00029h)  ! PM designator 

LOCALE_ICALENDARTYPE        EQUATE(01009h)  ! type of calendar specifier 
LOCALE_IOPTIONALCALENDAR    EQUATE(0100Bh)  ! additional calendar types specifier 

LOCALE_IFIRSTDAYOFWEEK      EQUATE(0100Ch)  ! first day of week specifier 
LOCALE_IFIRSTWEEKOFYEAR     EQUATE(0100Dh)  ! first week of year specifier 
                                            
LOCALE_SDAYNAME1            EQUATE(0002Ah)  ! long name for Monday 
LOCALE_SDAYNAME2            EQUATE(0002Bh)  ! long name for Tuesday 
LOCALE_SDAYNAME3            EQUATE(0002Ch)  ! long name for Wednesday 
LOCALE_SDAYNAME4            EQUATE(0002Dh)  ! long name for Thursday 
LOCALE_SDAYNAME5            EQUATE(0002Eh)  ! long name for Friday 
LOCALE_SDAYNAME6            EQUATE(0002Fh)  ! long name for Saturday 
LOCALE_SDAYNAME7            EQUATE(00030h)  ! long name for Sunday 
LOCALE_SABBREVDAYNAME1      EQUATE(00031h)  ! abbreviated name for Monday    
LOCALE_SABBREVDAYNAME2      EQUATE(00032h)  ! abbreviated name for Tuesday   
LOCALE_SABBREVDAYNAME3      EQUATE(00033h)  ! abbreviated name for Wednesday 
LOCALE_SABBREVDAYNAME4      EQUATE(00034h)  ! abbreviated name for Thursday  
LOCALE_SABBREVDAYNAME5      EQUATE(00035h)  ! abbreviated name for Friday    
LOCALE_SABBREVDAYNAME6      EQUATE(00036h)  ! abbreviated name for Saturday  
LOCALE_SABBREVDAYNAME7      EQUATE(00037h)  ! abbreviated name for Sunday    
LOCALE_SMONTHNAME1          EQUATE(00038h)  ! long name for January 
LOCALE_SMONTHNAME2          EQUATE(00039h)  ! long name for February 
LOCALE_SMONTHNAME3          EQUATE(0003Ah)  ! long name for March 
LOCALE_SMONTHNAME4          EQUATE(0003Bh)  ! long name for April 
LOCALE_SMONTHNAME5          EQUATE(0003Ch)  ! long name for May 
LOCALE_SMONTHNAME6          EQUATE(0003Dh)  ! long name for June 
LOCALE_SMONTHNAME7          EQUATE(0003Eh)  ! long name for July 
LOCALE_SMONTHNAME8          EQUATE(0003Fh)  ! long name for August 
LOCALE_SMONTHNAME9          EQUATE(00040h)  ! long name for September 
LOCALE_SMONTHNAME10         EQUATE(00041h)  ! long name for October 
LOCALE_SMONTHNAME11         EQUATE(00042h)  ! long name for November 
LOCALE_SMONTHNAME12         EQUATE(00043h)  ! long name for December 
LOCALE_SMONTHNAME13         EQUATE(0100Eh)  ! long name for 13th month (if exists) 
LOCALE_SABBREVMONTHNAME1    EQUATE(00044h)  ! abbreviated name for January 
LOCALE_SABBREVMONTHNAME2    EQUATE(00045h)  ! abbreviated name for February 
LOCALE_SABBREVMONTHNAME3    EQUATE(00046h)  ! abbreviated name for March 
LOCALE_SABBREVMONTHNAME4    EQUATE(00047h)  ! abbreviated name for April 
LOCALE_SABBREVMONTHNAME5    EQUATE(00048h)  ! abbreviated name for May 
LOCALE_SABBREVMONTHNAME6    EQUATE(00049h)  ! abbreviated name for June 
LOCALE_SABBREVMONTHNAME7    EQUATE(0004Ah)  ! abbreviated name for July 
LOCALE_SABBREVMONTHNAME8    EQUATE(0004Bh)  ! abbreviated name for August 
LOCALE_SABBREVMONTHNAME9    EQUATE(0004Ch)  ! abbreviated name for September 
LOCALE_SABBREVMONTHNAME10   EQUATE(0004Dh)  ! abbreviated name for October 
LOCALE_SABBREVMONTHNAME11   EQUATE(0004Eh)  ! abbreviated name for November 
LOCALE_SABBREVMONTHNAME12   EQUATE(0004Fh)  ! abbreviated name for December 
LOCALE_SABBREVMONTHNAME13   EQUATE(0100Fh)  ! abbreviated name for 13th month (if exists) 
                                            
LOCALE_SPOSITIVESIGN        EQUATE(00050h)  ! positive sign 
LOCALE_SNEGATIVESIGN        EQUATE(00051h)  ! negative sign 
LOCALE_IPOSSIGNPOSN         EQUATE(00052h)  ! positive sign position 
LOCALE_INEGSIGNPOSN         EQUATE(00053h)  ! negative sign position 
LOCALE_IPOSSYMPRECEDES      EQUATE(00054h)  ! mon sym precedes pos amt 
LOCALE_IPOSSEPBYSPACE       EQUATE(00055h)  ! mon sym sep by space from pos  
LOCALE_INEGSYMPRECEDES      EQUATE(00056h)  ! mon sym precedes neg amt 
LOCALE_INEGSEPBYSPACE       EQUATE(00057h)  ! mon sym sep by space from neg

DEFAULT_PITCH       EQUATE(0)

LOGPIXELSY          EQUATE(90)          ! Logical pixels/inch in Y
MCS_NOTODAYCIRCLE   EQUATE(00008h)
MCS_NOTODAY         EQUATE(00010h)

hNewMCFont                  UNSIGNED(0)
lNewMCColor                 LONG(0)
lBackgroundColor            LONG
lCalendarBackColor          LONG
lCalendarForeColor          LONG
lCalendarTitleBackColor     LONG
lCalendarTitleForeColor     LONG
lCalendarTrailingForeColor  LONG

OriginalWndProc ULONG

!========================================================================================
!========================================================================================
DTPicker.Init             PROCEDURE()
iccex  LIKE(tagInitCommonControlsEx)
  CODE
  iccex.lngSize = SIZE(iccex)
  iccex.lngICC  = ICC_DATE_CLASSES
  t# = InitCommonControlsEx(iccex)
  !
  ! Initialize member variables
  !
  SELF.pHwndMonthCal = 0
  SELF.DateTimePickerHwnd = 0
  SELF.AppCanParse   = FALSE
  SELF.CustomFormat  = ''
  SELF.DisplayFormat = DTPSHORTDATE
  SELF.RightAlign    = FALSE
  SELF.ShowNone      = FALSE
  SELF.UpDown        = FALSE
  SELF.Visible       = TRUE


DTPicker.Kill       PROCEDURE()
I   LONG
J   LONG
  CODE
  IF SELF.DateTimePickerHwnd <> 0 THEN
     DestroyWindow(SELF.DateTimePickerHwnd)
  END

  !Free up any fonts we may have created
  IF hNewMCFont
     DeleteObject(hNewMCFont)
     hNewMCFont = 0
  END

!========================================================================================
DTPicker.CreateDTPicker   PROCEDURE(LONG Left,LONG Top,LONG Width,LONG Height,UNSIGNED ControlId,BOOL bFocus)
NullString    CSTRING(3)
WorkCSTRING   CSTRING(40)
ControlStyle  LONG

  CODE
  IF 0{PROP:ClientHandle} = 0 THEN
    RETURN FALSE
  END

  IF ~Width THEN Width = 200.
  IF ~Height THEN Height = 10.

  NullString = ''
  WorkCSTRING = 'SysDateTimePick32'

  ControlStyle = WS_CHILD+WS_VISIBLE+WS_TABSTOP

  IF SELF.AppCanParse
     ControlStyle = BOR(ControlStyle,DTS_APPCANPARSE)
  END

  CASE SELF.DisplayFormat
    OF DTPLONGDATE
       ControlStyle = BOR(ControlStyle,DTS_LONGDATEFORMAT)
    OF DTPSHORTDATE
       ControlStyle = BOR(ControlStyle,DTS_SHORTDATEFORMAT)
    OF DTPTIME
       ControlStyle = BOR(ControlStyle,DTS_TIMEFORMAT)
    OF DTPCUSTOM
       !SetFormat after creating control
  END

  IF SELF.DisplayFormat <> DTPTIME
     IF SELF.ShowNone
        ControlStyle = BOR(ControlStyle,DTS_SHOWNONE)
     END
     IF SELF.UpDown
        ControlStyle = BOR(ControlStyle,DTS_UPDOWN)
     END
     IF SELF.RightAlign
        ControlStyle = BOR(ControlStyle,DTS_RIGHTALIGN)
     END
  END

  SELF.hwndFollows = ControlID{prop:handle}

  SELF.DateTimePickerHwnd = CreateWindowEX(0, WorkCSTRING, NullString,          |
                                     ControlStyle, Left, Top, Width, Height,    |
                                     0{PROP:ClientHandle}, ControlID,           |
                                     SYSTEM{PROP:AppInstance}, 0)

  SetWindowLong(SELF.DateTimePickerHwnd,GWL_USERDATA,ADDRESS(SELF))

  IF SELF.hwndFollows
     SetWindowPos(SELF.DateTimePickerHwnd,SELF.hwndFollows,0,0,0,0,SWP_NOMOVE+SWP_NOSIZE)
  END

  IF SELF.Visible
     ShowWindow(SELF.DateTimePickerHwnd, SW_SHOWNORMAL)
  ELSE
     ShowWindow(SELF.DateTimePickerHwnd, SW_HIDE)
  END

  SELF.left   = left
  SELF.Top    = Top
  SELF.Width  = Width
  SELF.Height = Height

  IF SELF.DisplayFormat = DTPCUSTOM
     SELF.SetFormat(DTPCUSTOM)
  END

  SELF.bFocus = bFocus
  IF SELF.bFocus
     SetFocus(SELF.DateTimePickerHwnd)
  END

  RETURN(TRUE)
   

DTPicker.Refresh  PROCEDURE()
systime     LIKE(tagSYSTEMTIME)
bSetTime    BOOL(FALSE)
  CODE
  IF SELF.DateTimePickerHwnd
     lBackgroundColor = SELF.GetBackgroundColor()
     lCalendarBackColor = SELF.GetCalendarBackColor()
     lCalendarForeColor = SELF.GetCalendarForeColor()
     lCalendarTitleBackColor = SELF.GetCalendarTitleBackColor()
     lCalendarTitleForeColor = SELF.GetCalendarTitleForeColor()
     lCalendarTrailingForeColor = SELF.GetCalendarTrailingForeColor()
     SendMessage(SELF.DateTimePickerHwnd, DTM_GETSYSTEMTIME, 0, ADDRESS(systime))
     DestroyWindow(SELF.DateTimePickerHwnd)
     SELF.DateTimePickerHwnd = 0
     bSetTime = TRUE
  END

  SELF.CreateDTPicker(SELF.left, SELF.top, SELF.width, SELF.height, SELF.hwndFollows, FALSE)

  !Refresh the Colors
  SELF.SetBackgroundColor(lBackgroundColor)
  SELF.SetCalendarBackColor(lCalendarBackColor)
  SELF.SetCalendarForeColor(lCalendarForeColor)
  SELF.SetCalendarTitleBackColor(lCalendarTitleBackColor)
  SELF.SetCalendarTitleForeColor(lCalendarTitleForeColor)
  SELF.SetCalendarTrailingForeColor(lCalendarTrailingForeColor)

  !Refresh the Font if necessary
  IF hNewMCFont
     SELF.SetMCFont(hNewMCFont,TRUE)
  END

  IF bSetTime
     SendMessage(SELF.DateTimePickerHwnd, DTM_SETSYSTEMTIME, 0, ADDRESS(systime))
  END
  RETURN

!========================================================================================
DTPicker.Disable    PROCEDURE()
  CODE
!  SetWindowLong(SELF.GetHwnd(),GWL_STYLE,BOR(GetWindowLong(SELF.GetHwnd(),GWL_STYLE),WS_DISABLED))
  EnableWindow(SELF.GetHwnd(),FALSE)

!========================================================================================
DTPicker.Enable     PROCEDURE()
  CODE
!  SetWindowLong(SELF.GetHwnd(),GWL_STYLE,BAND(GetWindowLong(SELF.GetHwnd(),GWL_STYLE),0F7FFFFFFh))
  EnableWindow(SELF.GetHwnd(),TRUE)

!========================================================================================
DTPicker.GetSelection  PROCEDURE(<*? pDateValue>, <*? pTimeValue>)
systime     LIKE(tagSYSTEMTIME)
dwResult    ULONG
lDateValue  LONG
lTimeValue  LONG
  CODE
  dwResult = SendMessage(SELF.DateTimePickerHwnd, DTM_GETSYSTEMTIME, 0, ADDRESS(systime))
  CASE dwResult
  OF GDT_VALID
     IF ~OMITTED(2)
        lDateValue = DATE(systime.wMonth,systime.wDay,systime.wYear)
        pDateValue = lDateValue
     END
     IF ~OMITTED(3)
        lTimeValue = SELF.SystemTimeToLong(systime)
        pTimeValue = lTimeValue
     END
  OF GDT_NONE
     IF ~OMITTED(2)
        CLEAR(lDateValue)
        pDateValue = lDateValue
     END
     IF ~OMITTED(3)
        CLEAR(lTimeValue)
        pTimeValue = lTimeValue
     END
  END
  RETURN(dwResult)


DTPicker.SetSelection PROCEDURE(<? pDateValue>, <? pTimeValue>)
systime     LIKE(tagSYSTEMTIME)
bResult     BOOL
lDateValue  LONG
lTimeValue  LONG
flag        LONG
  CODE
  CLEAR(systime)
  flag = GDT_NONE
  IF OMITTED(2)
     IF ~SELF.ShowNone
        systime.wMonth = MONTH(TODAY())
        systime.wDay   = DAY(TODAY())
        systime.wYear  = YEAR(TODAY())
        flag = GDT_VALID
     END
  ELSE
     lDateValue = pDateValue
     IF lDateValue = 0
        IF ~SELF.ShowNone
           systime.wMonth = MONTH(TODAY())
           systime.wDay   = DAY(TODAY())
           systime.wYear  = YEAR(TODAY())
           flag = GDT_VALID
        END
     ELSE
        systime.wMonth = MONTH(lDateValue)
        systime.wDay   = DAY(lDateValue)
        systime.wYear  = YEAR(lDateValue)
        flag = GDT_VALID
     END
  END
  IF OMITTED(3)
     IF ~SELF.ShowNone
        SELF.LongToSystemTime(CLOCK(),systime)
        flag = GDT_VALID
     END
  ELSE
     lTimeValue = pTimeValue
     IF lTimeValue = 0
        IF ~SELF.ShowNone
           SELF.LongToSystemTime(CLOCK(),systime)
           flag = GDT_VALID
        END
     ELSE
        SELF.LongToSystemTime(lTimeValue,systime)
        flag = GDT_VALID
     END
  END
  IF flag = GDT_VALID
     bResult = SendMessage(SELF.DateTimePickerHwnd, DTM_SETSYSTEMTIME, GDT_VALID, ADDRESS(systime))
  ELSE
     bResult = SELF.ClearSelection()
  END
  RETURN(bResult)


DTPicker.ClearSelection   PROCEDURE()
bResult     BOOL
  CODE
  bResult = SendMessage(SELF.DateTimePickerHwnd, DTM_SETSYSTEMTIME, GDT_NONE, 0)
  RETURN(bResult)


!========================================================================================
DTPicker.GetRange   PROCEDURE(<*? pMinDateValue>,<*? pMinTimeValue>,<*? pMaxDateValue>,<*? pMaxTimeValue>)
dwResult        ULONG
SysTimeArray    GROUP
SysTimeMin          LIKE(tagSYSTEMTIME)
SysTimeMax          LIKE(tagSYSTEMTIME)
                END
lMinDateValue   LONG
lMinTimeValue   LONG
lMaxDateValue   LONG
lMaxTimeValue   LONG
  CODE
  dwResult = SendMessage(SELF.DateTimePickerHwnd, DTM_GETRANGE, 0, ADDRESS(SysTimeArray))
  IF BAND(dwResult,GDTR_MIN)    !Minimum Value Set
     IF NOT OMITTED(2)
        lMinDateValue = DATE(SysTimeArray.SysTimeMin.wMonth,SysTimeArray.SysTimeMin.wDay,SysTimeArray.SysTimeMin.wYear)
        pMinDateValue = lMinDateValue
     END
     IF NOT OMITTED(3)
        lMinTimeValue = SELF.SystemTimeToLong(SysTimeArray.SysTimeMin)
        pMinTimeValue = lMinTimeValue
     END
  END
  IF BAND(dwResult,GDTR_MAX)    !Maximum Value Set
     IF NOT OMITTED(4)
        lMaxDateValue = DATE(SysTimeArray.SysTimeMax.wMonth,SysTimeArray.SysTimeMax.wDay,SysTimeArray.SysTimeMax.wYear)
        pMaxDateValue = lMaxDateValue
     END
     IF NOT OMITTED(5)
        lMaxTimeValue = SELF.SystemTimeToLong(SysTimeArray.SysTimeMax)
        pMaxTimeValue = lMaxTimeValue
     END
  END
  RETURN(dwResult)


DTPicker.SetRange   PROCEDURE(<? pMinDateValue>,<? pMinTimeValue>,<? pMaxDateValue>,<? pMaxTimeValue>)
dwResult        ULONG
bResult         BOOL
MinValueFlag    LONG
MaxValueFlag    LONG
SysTimeArray    GROUP
SysTimeMin          LIKE(tagSYSTEMTIME)
SysTimeMax          LIKE(tagSYSTEMTIME)
                END
lMinDateValue   LONG
lMinTimeValue   LONG
lMaxDateValue   LONG
lMaxTimeValue   LONG
  CODE
  SendMessage(SELF.DateTimePickerHwnd, DTM_GETRANGE, 0, ADDRESS(SysTimeArray))

  IF NOT OMITTED(2) THEN ! lMinDateValue exists
     lMinDateValue = pMinDateValue
     MinValueFlag = GDTR_MIN
     SysTimeArray.SysTimeMin.wMonth = MONTH(lMinDateValue)
     SysTimeArray.SysTimeMin.wDay   = DAY(lMinDateValue)
     SysTimeArray.SysTimeMin.wYear  = YEAR(lMinDateValue)
  END

  IF NOT OMITTED(3) THEN ! lMinTimeValue exists
     lMinTimeValue = pMinTimeValue
     MinValueFlag = GDTR_MIN
     SELF.LongToSystemTime(lMinTimeValue, SysTimeArray.SysTimeMin)
  END

  IF NOT OMITTED(4) THEN ! lMaxDateValue exists
     lMaxDateValue = pMaxDateValue
     MaxValueFlag = GDTR_MAX
     SysTimeArray.SysTimeMax.wMonth = MONTH(lMaxDateValue)
     SysTimeArray.SysTimeMax.wDay   = DAY(lMaxDateValue)
     SysTimeArray.SysTimeMax.wYear  = YEAR(lMaxDateValue)
  END

  IF NOT OMITTED(5) THEN ! lMaxTimeValue exists
     lMaxTimeValue = pMaxTimeValue
     MaxValueFlag = GDTR_MAX
     SELF.LongToSystemTime(lMaxTimeValue, SysTimeArray.SysTimeMax)
  END

  bResult = SendMessage(SELF.DateTimePickerHwnd, DTM_SETRANGE, BOR(MinValueFlag,MaxValueFlag), ADDRESS(SysTimeArray))
  RETURN(bResult)


!========================================================================================
!========================================================================================
DTPicker.GetColor PROCEDURE(iColor)
  CODE
  RETURN(SendMessage(SELF.DateTimePickerHwnd, DTM_GETMCCOLOR, iColor, 0))


DTPicker.GetBackgroundColor     PROCEDURE()
  CODE
  RETURN(SELF.GetColor(MCSC_BACKGROUND))


DTPicker.GetCalendarBackColor    PROCEDURE()
  CODE
  RETURN(SELF.GetColor(MCSC_MONTHBK))


DTPicker.GetCalendarForeColor    PROCEDURE()
  CODE
  RETURN(SELF.GetColor(MCSC_TEXT))


DTPicker.GetCalendarTitleBackColor  PROCEDURE()
  CODE
  RETURN(SELF.GetColor(MCSC_TITLEBK))


DTPicker.GetCalendarTitleForeColor  PROCEDURE()
  CODE
  RETURN(SELF.GetColor(MCSC_TITLETEXT))


DTPicker.GetCalendarTrailingForeColor PROCEDURE()
  CODE
  RETURN(SELF.GetColor(MCSC_TRAILINGTEXT))


!========================================================================================
!========================================================================================
DTPicker.SetColor PROCEDURE(iColor, clr)
OldColor    LONG
  CODE
  OldColor = SendMessage(SELF.DateTimePickerHwnd, DTM_GETMCCOLOR, iColor, 0)
  SendMessage(SELF.DateTimePickerHwnd, DTM_SETMCCOLOR, iColor, clr)
  RETURN(OldColor)


DTPicker.SetBackgroundColor     PROCEDURE(LONG clr)
  CODE
  RETURN(SELF.SetColor(MCSC_BACKGROUND, clr))


DTPicker.SetCalendarBackColor    PROCEDURE(LONG clr)
  CODE
  RETURN(SELF.SetColor(MCSC_MONTHBK, clr))


DTPicker.SetCalendarForeColor    PROCEDURE(LONG clr)
  CODE
  RETURN(SELF.SetColor(MCSC_TEXT, clr))


DTPicker.SetCalendarTitleBackColor  PROCEDURE(LONG clr)
  CODE
  RETURN(SELF.SetColor(MCSC_TITLEBK, clr))


DTPicker.SetCalendarTitleForeColor  PROCEDURE(LONG clr)
  CODE
  RETURN(SELF.SetColor(MCSC_TITLETEXT, clr))


DTPicker.SetCalendarTrailingForeColor PROCEDURE(LONG clr)
  CODE
  RETURN(SELF.SetColor(MCSC_TRAILINGTEXT, clr))


!========================================================================================
!========================================================================================
DTPicker.SetFormat  PROCEDURE(LONG lFormat)
bResult     BOOL
szBuffer    CSTRING(64)
lpFormat    LONG
  CODE
  IF INRANGE(lFormat,DTPLONGDATE,DTPCUSTOM)
     SELF.DisplayFormat = lFormat
     CASE SELF.DisplayFormat
     OF DTPLONGDATE
        GetLocaleInfo(LOCALE_USER_DEFAULT,LOCALE_SLONGDATE,szBuffer,SIZE(szBuffer))
        lpFormat = ADDRESS(szBuffer)
     OF DTPSHORTDATE
        GetLocaleInfo(LOCALE_USER_DEFAULT,LOCALE_SSHORTDATE,szBuffer,SIZE(szBuffer))
        lpFormat = ADDRESS(szBuffer)
     OF DTPTIME
        GetLocaleInfo(LOCALE_USER_DEFAULT,LOCALE_STIMEFORMAT,szBuffer,SIZE(szBuffer))
        lpFormat = ADDRESS(szBuffer)
     OF DTPCUSTOM
        IF SELF.CustomFormat
           lpFormat = ADDRESS(SELF.CustomFormat)
        ELSE
           lpFormat = 0
        END
     END
     bResult = SendMessage(SELF.DateTimePickerHwnd, DTM_SETFORMAT, 0, lpFormat)
     RETURN(bResult)
  ELSE
     RETURN(0)
  END

DTPicker.SetFont  PROCEDURE(*CSTRING szTypeface, LONG lFontSize, LONG lFontStyle)
nHeight     SIGNED
hDC         UNSIGNED
defaultFace CSTRING('MS Sans Serif')
lpszFace    ULONG
  CODE
  IF SELF.hNewFont
     DeleteObject(SELF.hNewFont)
     SELF.hNewFont = 0
     SELF.lNewColor = 0
  END

  IF szTypeFace
     lpszFace = ADDRESS(szTypeFace)
  ELSE
     lpszFace = ADDRESS(defaultFace)
  END

  IF ~lFontSize
     lFontSize = 8
  END
  hDC = GetDC(SELF.DateTimePickerHwnd)
  nHeight = -MulDiv( lFontSize, GetDeviceCaps(hDC, LOGPIXELSY), 72 )
  ReleaseDC(SELF.DateTimePickerHwnd,hDC)

  SELF.hNewFont = CreateFont(nHeight, 0, 0, 0,                                          |
                     BAND(lFontStyle,FONT:weight),                                      |
                     CHOOSE(BAND(lFontStyle,FONT:Italic)=FONT:Italic,TRUE,FALSE),       |
                     CHOOSE(BAND(lFontStyle,FONT:Underline)=FONT:Underline,TRUE,FALSE), |
                     CHOOSE(BAND(lFontStyle,FONT:Strikeout)=FONT:Strikeout,TRUE,FALSE), |
                     SYSTEM{PROP:CharSet},                                              |
                     OUT_DEFAULT_PRECIS,                                                |
                     CLIP_DEFAULT_PRECIS,                                               |
                     DEFAULT_QUALITY,                                                   |
                     DEFAULT_PITCH + FF_DONTCARE,                                       |
                     lpszFace)
  IF SELF.hNewFont
     RETURN(SELF.SetFont(SELF.hNewFont,TRUE))
  ELSE
     RETURN(0)
  END


DTPicker.SetFont    PROCEDURE(UNSIGNED hfont, BOOL fRedraw)
OldFont   UNSIGNED
  CODE
  OldFont = SendMessage(SELF.DateTimePickerHwnd, WM_GETFONT, 0, 0)
  SendMessage(SELF.DateTimePickerHwnd, WM_SETFONT, hfont, fRedraw)
  RETURN(OldFont)


DTPicker.SetMCFont  PROCEDURE(*CSTRING szTypeface, LONG lFontSize, LONG lFontColor, LONG lFontStyle)
nHeight     SIGNED
hDC         UNSIGNED
defaultFace CSTRING('MS Sans Serif')
lpszFace    ULONG
  CODE
  IF hNewMCFont
     DeleteObject(hNewMCFont)
     hNewMCFont = 0
     lNewMCColor = 0
  END

  IF szTypeFace
     lpszFace = ADDRESS(szTypeFace)
  ELSE
     lpszFace = ADDRESS(defaultFace)
  END

  IF ~lFontSize
     lFontSize = 8
  END
  hDC = GetDC(0{PROP:ClientHandle})
  nHeight = -MulDiv( lFontSize, GetDeviceCaps(hDC, LOGPIXELSY), 72 )
  ReleaseDC(0{PROP:ClientHandle},hDC)

  hNewMCFont = CreateFont(nHeight, 0, 0, 0,                                             |
                     BAND(lFontStyle,FONT:weight),                                      |
                     CHOOSE(BAND(lFontStyle,FONT:Italic)=FONT:Italic,TRUE,FALSE),       |
                     CHOOSE(BAND(lFontStyle,FONT:Underline)=FONT:Underline,TRUE,FALSE), |
                     CHOOSE(BAND(lFontStyle,FONT:Strikeout)=FONT:Strikeout,TRUE,FALSE), |
                     SYSTEM{PROP:CharSet},                                              |
                     OUT_DEFAULT_PRECIS,                                                |
                     CLIP_DEFAULT_PRECIS,                                               |
                     DEFAULT_QUALITY,                                                   |
                     DEFAULT_PITCH + FF_DONTCARE,                                       |
                     lpszFace)
  IF hNewMCFont
     lNewMCColor = lFontColor
     SELF.SetCalendarForeColor(lFontColor)
     RETURN(SELF.SetMCFont(hNewMCFont,TRUE))
  ELSE
     RETURN(0)
  END


DTPicker.SetMCFont    PROCEDURE(UNSIGNED hfont, BOOL fRedraw)
OldFont   UNSIGNED
  CODE
  OldFont = SendMessage(SELF.DateTimePickerHwnd, DTM_GETMCFONT, 0, 0)
  SendMessage(SELF.DateTimePickerHwnd, DTM_SETMCFONT, hfont, fRedraw)
  RETURN(OldFont)


!Methods to Set Class Properties=======================================
DTPicker.SetAppCanParse   PROCEDURE(BOOL bFlag)
bResult BOOL
  CODE
  bResult = SELF.AppCanParse
  SELF.AppCanParse = bFlag
  RETURN(bResult)


DTPicker.SetCustomFormat  PROCEDURE(*CSTRING szCustomFormat)
  CODE
  SELF.CustomFormat = szCustomFormat
  RETURN


DTPicker.SetDisplayFormat   PROCEDURE(LONG lFormat)
lResult LONG
  CODE
  IF INRANGE(lFormat,DTPLONGDATE,DTPCUSTOM)
     lResult = SELF.DisplayFormat
     SELF.DisplayFormat = lFormat
     RETURN(lResult)
  ELSE
     RETURN(-1)
  END


DTPicker.SetRightAlign    PROCEDURE(BOOL bFlag)
bResult BOOL
  CODE
  bResult = SELF.RightAlign
  SELF.RightAlign = bFlag
  RETURN(bResult)


DTPicker.SetShowNone      PROCEDURE(BOOL bFlag)
bResult BOOL
  CODE
  bResult = SELF.ShowNone
  SELF.ShowNone = bFlag
  RETURN(bResult)


DTPicker.SetUpDown        PROCEDURE(BOOL bFlag)
bResult BOOL
  CODE
  bResult = SELF.UpDown
  SELF.UpDown = bFlag
  RETURN(bResult)


DTPicker.SetVisible PROCEDURE(BOOL bFlag)
bResult BOOL
  CODE
  bResult = SELF.Visible
  SELF.Visible = bFlag
  CASE bFlag
  OF TRUE
     ShowWindow(SELF.DateTimePickerHwnd, SW_SHOW)
  OF FALSE
     ShowWindow(SELF.DateTimePickerHwnd, SW_HIDE)
  END
  RETURN(bResult)


DTPicker.SetPosition PROCEDURE(LONG X,LONG Y,LONG CX,LONG CY)
bReturn bool,auto

  CODE
  SELF.Left = X
  SELF.Top = Y
  SELF.Width = CX
  SELF.Height = CY
  IF SELF.visible
    bReturn = SetWindowPos(self.DateTimePickerHwnd,0,SELF.Left,SELF.Top,SELF.Width,SELF.Height,SWP_NOZORDER+SWP_SHOWWINDOW)
  ELSE
    bReturn = SetWindowPos(self.DateTimePickerHwnd,0,SELF.Left,SELF.Top,SELF.Width,SELF.Height,SWP_NOZORDER+SWP_HIDEWINDOW)
  END
  RETURN(bReturn)


!Utility Functions=====================================================
DTPicker.GetHwnd    PROCEDURE()
   CODE
   RETURN(SELF.DateTimePickerHwnd)


! HWND DateTime_GetMonthCal(HWND hdp)
! returns the HWND of the MonthCal popup window. Only valid
! between DTN_DROPDOWN and DTN_CLOSEUP notifications.
DTPicker.GetMonthCal    PROCEDURE()
hWndResult  UNSIGNED
  CODE
  hWndResult = SendMessage(SELF.DateTimePickerHwnd, DTM_GETMONTHCAL, 0, 0)
  RETURN(hWndResult)


DTPicker.LongToSystemTime   PROCEDURE(LONG lClock, *tagSYSTEMTIME systime)
t   LONG
  CODE
  t = lClock
  t -= 1
  systime.wHour = INT(t/(100*60*60))
  t = t%(100*60*60)
  systime.wMinute = INT(t/(100*60))
  t = t%(100*60)
  systime.wSecond = INT(t/100)
  t = t%100
  systime.wMilliseconds = t * 10


DTPicker.SystemTimeToLong   PROCEDURE(tagSYSTEMTIME systime)
t   LONG
  CODE
  t = (systime.wHour   * (100*60*60)) |
    + (systime.wMinute * (100*60))    |
    + (systime.wSecond * 100)         |
    + (systime.wMilliseconds/10)      |
    + 1
  RETURN(t)

DTPicker.SetMonthCalHwnd    PROCEDURE(LONG pHwnd)
  CODE
  SELF.pHwndMonthCal = pHwnd
  RETURN

DTPicker.GetEvent   PROCEDURE()
  CODE
  RETURN(SELF.lEvent)

DTPicker.SetEvent   PROCEDURE(LONG lEvent)
lOldEvent   LONG
  CODE
  lOldEvent = SELF.lEvent
  SELF.lEvent = lEvent
  RETURN(lOldEvent)

DTPicker.Notify     PROCEDURE(HWND hWnd, WPARAM wParam, UINT nmCode)
MC              HWND
  CODE
  CASE nmcode
  OF DTN_DROPDOWN
     MC = SELF.GetMonthCal()
     memcpy(SELF.pHwndMonthCal,ADDRESS(MC),SIZE(MC))
     !OriginalWndProc = SetWindowLong(MC,GWL_WNDPROC,ADDRESS(MCWindowProc))
     SetWindowLong(MC,GWL_USERDATA,GetParent(GetParent(SELF.DateTimePickerHwnd)))
     UNLOCKTHREAD()
  OF DTN_CLOSEUP
     MC = 0
     memcpy(SELF.pHwndMonthCal,ADDRESS(MC),SIZE(MC))
     !SetWindowLong(MC,GWL_WNDPROC,OriginalWndProc)
     IF ~THREADLOCKED()
        LOCKTHREAD()
     END
  OF DTN_DATETIMECHANGE
     IF ~THREADLOCKED()
        LOCKTHREAD()
     END
     POST(SELF.lEvent,,THREAD())
  END
  RETURN

MCWindowProc PROCEDURE(HWND hWnd, UINT wMsg, WPARAM wParam, LPARAM lParam)
DTP &DTPicker
  CODE
  CASE wMSG
  OF WM_DESTROY
  END
  RETURN(CallWindowProc(OriginalWndProc,hWnd,wMsg,wParam,lParam))

