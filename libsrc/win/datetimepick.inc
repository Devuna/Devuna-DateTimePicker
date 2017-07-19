! ================================================================================
!                           Devuna Date Time Picker Class
! ================================================================================
! Notice : Copyright (C) 2017, Devuna
!          Distributed under the MIT License (https://opensource.org/licenses/MIT)
!
!    This file is part of Devuna-DateTimePicker (https://github.com/Devuna/Devuna-DateTimePicker)
!
!    Devuna-DateTimePicker is free software: you can redistribute it and/or modify
!    it under the terms of the MIT License as published by
!    the Open Source Initiative.
!
!    Devuna-DateTimePicker is distributed in the hope that it will be useful,
!    but WITHOUT ANY WARRANTY; without even the implied warranty of
!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!    MIT License for more details.
!
!    You should have received a copy of the MIT License
!    along with Devuna-DateTimePicker.  If not, see <https://opensource.org/licenses/MIT>.
! ================================================================================

!********************************************************************************
! Source module name:  datetimepick.inc
! Release Version:     DateTimePicker Version 2017.02.02
!
! Copyright (c) 2001-2017 Devuna, Inc.  All Rights Reserved.
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

 OMIT('_EndOfInclude_', _DateTimePickClassPresent_)
_DateTimePickClassPresent_ EQUATE(1)

 INCLUDE('svapi.inc'),ONCE

HANDLE                  EQUATE(UNSIGNED)
HWND                    EQUATE(UNSIGNED)
UINT                    EQUATE(UNSIGNED)
WPARAM                  EQUATE(UINT)
LPARAM                  EQUATE(LONG)
LRESULT                 EQUATE(LONG)
DWORD                   EQUATE(ULONG)
COLORREF                EQUATE(LONG)

NM_RELEASEDCAPTURE      EQUATE(NM_FIRST-16)

H_MAX                   EQUATE(0FFFFFFFFH + 1)
MCN_FIRST               EQUATE(H_MAX - 750)
MCN_LAST                EQUATE(MCN_FIRST + 9)
!MCN_LAST                EQUATE(H_MAX - 759)
MCN_SELECT              EQUATE(MCN_FIRST + 4)
DTN_FIRST               EQUATE(H_MAX - 760)
DTN_LAST                EQUATE(DTN_FIRST + 39)
!DTN_LAST                EQUATE(H_MAX - 799)
DTN_DATETIMECHANGE      EQUATE(DTN_FIRST + 1) ! the systemtime has changed
DTN_USERSTRING          EQUATE(DTN_FIRST + 2) ! the user has entered a string
DTN_USERSTRINGW         EQUATE(DTN_FIRST + 15) ! the user has entered a string
DTN_WMKEYDOWN           EQUATE(DTN_FIRST + 3) ! modify keydown on app format field (X)
DTN_FORMAT              EQUATE(DTN_FIRST + 4) ! query display for app format field (X)
DTN_FORMATQUERY         EQUATE(DTN_FIRST + 5) ! query formatting info for app format field (X)
DTN_DROPDOWN            EQUATE(DTN_FIRST + 6) ! MonthCal has dropped down
DTN_CLOSEUP             EQUATE(DTN_FIRST + 7) ! MonthCal is popping up

!Format Equates
DTPLONGDATE             EQUATE(0)   ! Long Date Format (for example "Friday, Nov 14, 1972").
DTPSHORTDATE            EQUATE(1)   ! Short Date Format (for example "11/14/72").
DTPTIME                 EQUATE(2)   ! Time Format (for example "5:31:47 PM").
DTPCUSTOM               EQUATE(3)   ! Custom format.

!iColor Equates for use with SetColor method
MCSC_BACKGROUND         EQUATE(0)
MCSC_TEXT               EQUATE(1)
MCSC_TITLEBK            EQUATE(2)
MCSC_TITLETEXT          EQUATE(3)
MCSC_MONTHBK            EQUATE(4)
MCSC_TRAILINGTEXT       EQUATE(5)

!GetDateTime Return Codes
GDT_ERROR               EQUATE(-1)
GDT_VALID               EQUATE(0)
GDT_NONE                EQUATE(1)

!GetDateTimeRange Return Codes
GDTR_MIN                EQUATE(00001h)
GDTR_MAX                EQUATE(00002h)


DTPicker  CLASS,TYPE,MODULE('DATETIMEPICK.CLW'),LINK('DATETIMEPICK.CLW') !,_ABCLinkMode_),DLL(_ABCDllMode_)

!Private properties
Left                    LONG
Top                     LONG
Width                   LONG
Height                  LONG
hNewFont                UNSIGNED
lNewColor               LONG


!Protected properties
AppCanParse             BOOL
CustomFormat            CSTRING(81)
DateTimePickerHwnd      UNSIGNED
DisplayFormat           LONG
UpDown                  BOOL
RightAlign              BOOL
ShowNone                BOOL
Visible                 BOOL
hwndFollows             UNSIGNED
bFocus                  BOOL
lEvent                  LONG

!Public Properties
pHwndMonthCal           LONG

!Methods
Init                    PROCEDURE()
Kill                    PROCEDURE()

CreateDTPicker          PROCEDURE(LONG Left,LONG Top,LONG Width,LONG Height,UNSIGNED Handle,BOOL bFocus=FALSE),SHORT,PROC
Refresh                 PROCEDURE()

Disable                 PROCEDURE()
Enable                  PROCEDURE()

GetSelection            PROCEDURE(<*? pDateValue>,<*? pTimeValue>),ULONG,PROC
SetSelection            PROCEDURE(<? pDateValue>,<? pTimeValue>),BOOL,PROC
ClearSelection          PROCEDURE(),BOOL,PROC

GetRange                PROCEDURE(<*? pMinDateValue>,<*? pMinTimeValue>,<*? pMaxDateValue>,<*? pMaxTimeValue>),ULONG,PROC
SetRange                PROCEDURE(<? pMinDateValue>,<? pMinTimeValue>,<? pMaxDateValue>,<? pMaxTimeValue>),BOOL,PROC

GetColor                        PROCEDURE(LONG iColor),LONG
GetBackgroundColor              PROCEDURE(),LONG
GetCalendarBackColor            PROCEDURE(),LONG
GetCalendarForeColor            PROCEDURE(),LONG
GetCalendarTitleBackColor       PROCEDURE(),LONG
GetCalendarTitleForeColor       PROCEDURE(),LONG
GetCalendarTrailingForeColor    PROCEDURE(),LONG

SetColor                        PROCEDURE(LONG iColor, LONG clr),LONG,PROC
SetBackgroundColor              PROCEDURE(LONG clr),LONG,PROC
SetCalendarBackColor            PROCEDURE(LONG clr),LONG,PROC
SetCalendarForeColor            PROCEDURE(LONG clr),LONG,PROC
SetCalendarTitleBackColor       PROCEDURE(LONG clr),LONG,PROC
SetCalendarTitleForeColor       PROCEDURE(LONG clr),LONG,PROC
SetCalendarTrailingForeColor    PROCEDURE(LONG clr),LONG,PROC

SetFormat               PROCEDURE(LONG lFormat),BOOL,PROC
SetFont                 PROCEDURE(*CSTRING szTypeface, LONG lFontSize, LONG lFontStyle),UNSIGNED,PROC
SetFont                 PROCEDURE(UNSIGNED hfont, BOOL fRedraw),UNSIGNED,PROC
SetMCFont               PROCEDURE(*CSTRING szTypeface, LONG lFontSize, LONG lFontColor, LONG lFontStyle),UNSIGNED,PROC
SetMCFont               PROCEDURE(UNSIGNED hfont, BOOL fRedraw),UNSIGNED,PROC

!Set Property functions
SetAppCanParse          PROCEDURE(BOOL bFlag),BOOL,PROC
SetCustomFormat         PROCEDURE(*CSTRING szCustomFormat),PROC
SetDisplayFormat        PROCEDURE(LONG lFormat),LONG,PROC
SetRightAlign           PROCEDURE(BOOL bFlag),BOOL,PROC
SetShowNone             PROCEDURE(BOOL bFlag),BOOL,PROC
SetUpDown               PROCEDURE(BOOL bFlag),BOOL,PROC
SetVisible              PROCEDURE(BOOL bFlag),BOOL,PROC
SetPosition             PROCEDURE(LONG x,LONG y,LONG cx,LONG cy),BOOL,PROC

!Utility Functions
GetHwnd                 PROCEDURE(),UNSIGNED
GetMonthCal             PROCEDURE(),UNSIGNED

LongToSystemTime        PROCEDURE(LONG t, *tagSYSTEMTIME systime)
SystemTimeToLong        PROCEDURE(tagSYSTEMTIME systime),LONG

!Notification Functions
SetMonthCalHwnd         PROCEDURE(LONG pHwnd)
GetEvent                PROCEDURE(),LONG
SetEvent                PROCEDURE(LONG lEvent),LONG,PROC
Notify                  PROCEDURE(HWND hWnd, WPARAM wParam, UINT nmCode)
               END
!_EndOfInclude_

