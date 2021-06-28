{ This program is free software. You are allowed to redistribute this
  software and making the software available for download or
  making this software part of a software CD compilation.
  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the author be held liable for any
  damages arising from the use of this software.

  © Copyright 2013-2021 Vasily Makarov
}

unit uFrFileSelector;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Permissions,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListBox, FMX.Edit, System.ImageList, FMX.ImgList, FMX.Layouts,
  FMX.Controls.Presentation;

type
  TFrFileSelector = class(TFrame)
    lbFileSys: TListBox;
    liFs: TImageList;
    procedure lbFileSysItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
  private
    fPath: string;
    fRoot: string;
    fFileName: string;
    fPermissionRead: string;
    fPermissionWrite: string;
    fOnItemClick: TCustomListBox.TItemClickEvent;
    function CD(AFolder: string): boolean;
    function GetParentFolder(const folder: string): string;
    procedure AddListItem(aList: array of string; const isFolder: Boolean);
    procedure TakePermissionResult(Sender: TObject; const APermissions: TArray<string>; const AGrantResults: TArray<TPermissionStatus>);
  public
    const DIR_PARENT = '..';
    constructor Create(AOwner: TComponent); override;
    procedure Refresh;
    property FileName: string read fFileName write fFileName;
    property Root: string read fRoot;
    property OnItemClick: TCustomListBox.TItemClickEvent read fOnItemClick write fOnItemClick;
  end;

implementation

{$R *.fmx}

uses
{$IFDEF ANDROID}
  FMX.Platform.Android,
  Androidapi.Helpers,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.Os,
{$ENDIF}
  System.IOUtils,
  System.StrUtils,
  System.Generics.Collections,
  Generics.Defaults,
  FMX.DialogService;

const
  msg_no_share = 'Нет доступа к общим документам для чтения/записи расчётов FlutoMAX Lite. Будет использовано закрытое хранилище, которое будет удалено при деинсталяции программы.';

function CompareLowerStr(const Left, Right: string): Integer;
begin
  Result := CompareStr(AnsiLowerCase(Left), AnsiLowerCase(Right));
end;

{ TFrFileSelector }

constructor TFrFileSelector.Create(AOwner: TComponent);
begin
  inherited;
{$IFDEF ANDROID}
  fPermissionRead := JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE);
  fPermissionWrite := JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE);
  PermissionsService.RequestPermissions([fPermissionRead, fPermissionWrite], TakePermissionResult);
{$ELSE}
  fRoot := ExcludeTrailingBackslash(TPath.GetSharedDocumentsPath)
{$ENDIF}
end;

procedure TFrFileSelector.TakePermissionResult(Sender: TObject;
  const APermissions: TArray<string>;
  const AGrantResults: TArray<TPermissionStatus>);
begin
  if (Length(AGrantResults) = 2) and (AGrantResults[0] = TPermissionStatus.Granted) and (AGrantResults[1] = TPermissionStatus.Granted) then
    fRoot := ExcludeTrailingBackslash(TPath.GetSharedDocumentsPath)
  else
  begin
    fRoot := ExcludeTrailingBackslash(TPath.GetDocumentsPath);
    TDialogService.ShowMessage(msg_no_share);
  end;
end;

procedure TFrFileSelector.AddListItem(aList: array of string;
  const isFolder: Boolean);
var
  BitmapFolder, BitmapFile: TBitmap;
  size: TSizeF;
  i: Integer;
  item: TListBoxItem;
begin
  size.cx := 48; size.cy := 48;
  BitmapFolder := liFs.Bitmap(size, 0);
  BitmapFile := liFs.Bitmap(size, 1);
  lbFileSys.BeginUpdate;
  try
    for i := 0 to Length(aList) - 1 do
    begin
      item := TListBoxItem.Create(lbFileSys);
      if isFolder then begin
        if Assigned(BitmapFolder) then
          item.ItemData.Bitmap.Assign(BitmapFolder);
        item.ItemData.Accessory := TListBoxItemData.TAccessory.aMore;
      end else begin
        if Assigned(BitmapFile) then
          item.ItemData.Bitmap.Assign(BitmapFile);
      end;

      if aList[i] = DIR_PARENT then
      begin
        item.ItemData.Text := DIR_PARENT;
        item.ItemData.Detail := GetParentFolder(fPath);
      end else begin
        item.ItemData.Text := ExtractFileName(aList[i]);
        item.ItemData.Detail := aList[i];
      end;

      item.Tag := Ord(isFolder);
      lbFileSys.AddObject(item);
    end;
  finally
    lbFileSys.EndUpdate;
  end;
end;

function TFrFileSelector.CD(AFolder: string): boolean;
var
  LParent: string;
  LDirs, LFiles: TStringDynArray;
begin
  lbFileSys.Clear;
  //pnlDirectoryNotExist.Visible := False;
  if (AFolder <> EmptyStr) and (AFolder <> TPath.DirectorySeparatorChar) and (AFolder[AFolder.Length - 1] <> TPath.DirectorySeparatorChar) then
    AFolder := AFolder + TPath.DirectorySeparatorChar;
  fPath := AFolder;

  { http://stackoverflow.com/questions/20318875/how-to-show-the-availble-files-in-android-memory-with-firemonkey }
  if not TDirectory.Exists(AFolder, True) then
    begin
      //lblDirectoryNotExist.Text := 'Directory ' + AFolder + ' does not exist.';
      //pnlDirectoryNotExist.Visible := True;
      Exit(false);
    end;

  LParent := GetParentFolder(AFolder);

  if (LParent <> AFolder) and (not LParent.IsEmpty) then
    AddListItem([DIR_PARENT], true);

  LDirs := TDirectory.GetDirectories(AFolder, '*');
  // Сортируем папки
  TArray.Sort<string>(LDirs, TComparer<string>.Construct(CompareLowerStr));
  // Заполняем Листбокс списком отсортированных папок
  AddListItem(LDirs, true);

  // Get all files. Non-Windows systems don't typically care about
  // extensions, so we just use a single '*' as a mask.
  LFiles := TDirectory.GetFiles(AFolder, '*.fmx');
  TArray.Sort<string>(LFiles, TComparer<string>.Construct(CompareLowerStr));
  AddListItem(LFiles, false);
  Result := true;
end;

function TFrFileSelector.GetParentFolder(const folder: string): string;
begin
  if (folder.Length <= fRoot.Length) then
    Exit(EmptyStr);
  result := TDirectory.GetParent(ExcludeTrailingBackslash(folder));
  if (result.Length < fRoot.Length) then
    Exit(EmptyStr);
end;

procedure TFrFileSelector.lbFileSysItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  if Item.Tag = 1 then
  begin
    fPath := Item.ItemData.Detail;
    if TDirectory.Exists(fPath) then
      CD(fPath)
    else begin
      lbFileSys.Items.Delete(Item.Index);
      TDialogService.MessageDialog('Папка не найдена!', TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOk], TMsgDlgBtn.mbOk, 0, nil);
    end;
  end
  else
  begin
    FileName := Item.ItemData.Detail;
  end;
  if Assigned(fOnItemClick) then
    fOnItemClick(Sender, Item);
end;

procedure TFrFileSelector.Refresh;
begin
  CD(fRoot);
end;


end.
