#!region Copyright and License
#! ================================================================================
#!                         Devuna Date Time Picker Template
#! ================================================================================
#! Notice : Copyright (C) 2017, Devuna
#!          Distributed under the MIT License (https://opensource.org/licenses/MIT)
#!
#!    This file is part of Devuna-DateTimePicker (https://github.com/Devuna/Devuna-DateTimePicker)
#!
#!    Devuna-DateTimePicker is free software: you can redistribute it and/or modify
#!    it under the terms of the MIT License as published by
#!    the Open Source Initiative.
#!
#!    Devuna-DateTimePicker is distributed in the hope that it will be useful,
#!    but WITHOUT ANY WARRANTY; without even the implied warranty of
#!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#!    MIT License for more details.
#!
#!    You should have received a copy of the MIT License
#!    along with Devuna-DateTimePicker.  If not, see <https://opensource.org/licenses/MIT>.
#! ================================================================================
#!endRegion
#!
#TEMPLATE(KCR_DateTimePicker,'Devuna DateTimePicker ABC Templates'),FAMILY('ABC')
#HELP('DTPICKER.HLP')
#!
#!
#INCLUDE('DateTimePicker.tpw')                     #! DateTimePicker
#!
#!
#!-----------------------------------------------------------------------------------------------------------
#!The following template code is derived from "The Clarion Handy Tools" created by Gus Creces.
#!Used with permission.  Look for "The Clarion Handy Tools" at www.cwhandy.com
#!-----------------------------------------------------------------------------------------------------------
#SYSTEM
 #TAB('Devuna DateTimePicker Templates')
  #INSERT  (%SysHead)
  #BOXED   ('About Devuna DateTimePicker Templates'),AT(5)
    #DISPLAY (''),AT(15)
    #DISPLAY ('This template 1s free software:                                       '),AT(15)
    #DISPLAY ('You can redistribute it and/or modify it under the terms of the GNU   '),AT(15)
    #DISPLAY ('General Public License as published by the Free Software Foundation,  '),AT(15)
    #DISPLAY (''),AT(15)
    #DISPLAY ('This template is distributed in the hope that they will be useful     '),AT(15)
    #DISPLAY ('but WITHOUT ANY WARRANTY; without even the implied warranty           '),AT(15)
    #DISPLAY ('of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.'),AT(15)
    #DISPLAY (''),AT(15)
    #DISPLAY ('See the MIT License for more details.'),AT(15)
    #DISPLAY ('http://www.gnu.org/licenses/'),AT(15)
    #DISPLAY ('Copyright 2017 Devuna'),AT(15)
  #ENDBOXED
 #ENDTAB

#!-----------------------------------------------------------------------------------------------------------
#GROUP (%MakeHeadHiddenPrompts)
  #PROMPT('',@S50),%TplName
  #PROMPT('',@S100),%TplDescription
#!-----------------------------------------------------------------------------------------------------------
#GROUP   (%MakeHead,%xTplName,%xTplDescription)
  #SET (%TplName,%xTplName)
  #SET (%TplDescription,%xTplDescription)
#!
#!-----------------------------------------------------------------------------------------------------------
#GROUP   (%Head)
  #IMAGE   ('DateTimePicker.ico'), AT(,,175,26)
  #DISPLAY (%TplName),AT(40,3)
  #DISPLAY ('(C)1994-2017 Devuna'),AT(40,12)
  #DISPLAY ('')
#!
#!-----------------------------------------------------------------------------------------------------------
#GROUP   (%SysHead)
  #IMAGE   ('DateTimePicker.ico'), AT(,4,175,26)
  #DISPLAY ('DateTimePicker.tpl'),AT(40,4)
  #DISPLAY ('Devuna DateTimePicker Templates'),AT(40,14)
  #DISPLAY ('for Clarion ABC Template Applications'),AT(40,24)
  #DISPLAY ('')
#!
#!-----------------------------------------------------------------------------------------------------------
#GROUP(%EmbedStart)
#?!-----------------------------------------------------------------------------------------------------------
#?! DateTimePicker.tpl   (C)1994-2017 Devuna
#?! Template: (%TplName - %TplDescription)
#IF (%EmbedID)
#?! Embed:    (%EmbedID) (%EmbedDescription) (%EmbedParameters)
#ENDIF
#?!-----------------------------------------------------------------------------------------------------------
#!
#!----------------------------------------------------------------------------------------------------------
#GROUP(%EmbedEnd)
#?!-----------------------------------------------------------------------------------------------------------
#!End of derived work.  Thanks Gus!
#!-----------------------------------------------------------------------------------------------------------
