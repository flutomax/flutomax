{ This program is free software. You are allowed to redistribute this
  software and making the software available for download or
  making this software part of a software CD compilation.
  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the author be held liable for any
  damages arising from the use of this software.

  © Copyright 2013-2021 Vasily Makarov
}

unit uURL;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
{$IF Defined(IOS)}
  macapi.helpers, iOSapi.Foundation, FMX.helpers.iOS;
{$ELSEIF Defined(ANDROID)}
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.Net,
  Androidapi.JNI.App,
  Androidapi.helpers;
{$ELSEIF Defined(MACOS)}
  Posix.Stdlib;
{$ELSEIF Defined(MSWINDOWS)}
  Winapi.ShellAPI, Winapi.Windows;
{$ENDIF}

type
  TUrlOpen = class
    class procedure Open(URL: string);
  end;

implementation

class procedure TUrlOpen.Open(URL: string);
{$IF Defined(ANDROID)}
var
  Intent: JIntent;
{$ENDIF}
begin
{$IF Defined(ANDROID)}
  Intent := TJIntent.Create;
  Intent.setAction(TJIntent.JavaClass.ACTION_VIEW);
  Intent.setData(StrToJURI(URL));
  tandroidhelper.Activity.startActivity(Intent);
{$ELSEIF Defined(MSWINDOWS)}
  ShellExecute(0, 'open', PWideChar(URL), nil, nil, SW_SHOWNORMAL);
{$ELSEIF Defined(IOS)}
  SharedApplication.OpenURL(StrToNSUrl(URL));
{$ELSEIF Defined(MACOS)}
  _system(PAnsiChar('open ' + AnsiString(URL)));
{$ENDIF}
end;

end.
