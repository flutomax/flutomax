{ This program is free software. You are allowed to redistribute this
  software and making the software available for download or
  making this software part of a software CD compilation.
  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the author be held liable for any
  damages arising from the use of this software.

  © Copyright 2013-2021 Vasily Makarov
}

unit uFrmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, System.Actions, FMX.ActnList,
  FMX.StdCtrls, FMX.TabControl, FMX.ListBox, FMX.Layouts, uFrFileSelector,
  FMX.Controls.Presentation, FMX.Effects, FMX.StdActns, System.ImageList,
  FMX.ImgList, FMX.Ani, FMX.Edit, FMX.EditBox, FMX.NumberBox, uFlute,
  System.Rtti, FMX.Graphics, FMX.Grid.Style, FMX.Grid, FMX.ScrollBox,
  FMX.Objects, FMX.MediaLibrary.Actions, FMX.TextLayout, FMX.Menus, FMX.Memo,
  Web.HTTPApp, Web.HTTPProd;

type
  TFrmMain = class(TForm)
    TabMain: TTabControl;
    TiMain: TTabItem;
    AclMain: TActionList;
    LbxMenu: TListBox;
    TbMain: TToolBar;
    BtnMenu: TSpeedButton;
    LblTitle: TLabel;
    LbiNew: TListBoxItem;
    LbiOpen: TListBoxItem;
    PnlMain: TPanel;
    LbiSave: TListBoxItem;
    LbiExit: TListBoxItem;
    ShadowEffect1: TShadowEffect;
    CmdSaveFmxAs: TAction;
    DlgSaveFmx: TSaveDialog;
    DlgOpenFmx: TOpenDialog;
    ImlMain: TImageList;
    TiFileSelector: TTabItem;
    CmdNew: TAction;
    CmdOpenFmx: TAction;
    CmdExportImg: TAction;
    PnlFileSelector: TPanel;
    TbBottom: TToolBar;
    BtnFSOk: TButton;
    BtnFSCancel: TButton;
    LbxParams: TListBox;
    ToolBar1: TToolBar;
    BtnCalc: TButton;
    LbhCommonParams: TListBoxGroupHeader;
    LbiHolesCount: TListBoxItem;
    EdHolesCount: TNumberBox;
    FloatAnimation7: TFloatAnimation;
    LbiFluteType: TListBoxItem;
    СbFluteType: TComboBox;
    LbiKeynote: TListBoxItem;
    CbKeynote: TComboBox;
    LbiScale: TListBoxItem;
    CbScale: TComboBox;
    LbiIntonation: TListBoxItem;
    CbIntonation: TComboBox;
    LbhAdditionParams: TListBoxGroupHeader;
    LbiAlgorithm: TListBoxItem;
    CbAlgorithm: TComboBox;
    LbiCaption: TListBoxItem;
    EdCaption: TEdit;
    LbhSizes: TListBoxGroupHeader;
    LbiOuterDiameter: TListBoxItem;
    EdOuterDiameter: TNumberBox;
    FloatAnimation1: TFloatAnimation;
    LbiWallThickness: TListBoxItem;
    EdWallThickness: TNumberBox;
    FloatAnimation2: TFloatAnimation;
    LbiWindwayLength: TListBoxItem;
    EdWindwayLength: TNumberBox;
    FloatAnimation3: TFloatAnimation;
    LbiEmbLength: TListBoxItem;
    EdEmbLength: TNumberBox;
    FloatAnimation4: TFloatAnimation;
    LbiEmbWidth: TListBoxItem;
    EdEmbWidth: TNumberBox;
    FloatAnimation5: TFloatAnimation;
    LbiEmbThickness: TListBoxItem;
    EdEmbThickness: TNumberBox;
    FloatAnimation6: TFloatAnimation;
    CmdCalc: TAction;
    CmdSaveFmx: TAction;
    TrConfirm: TTimer;
    LbiSaveFmxAs: TListBoxItem;
    BtnHelp: TSpeedButton;
    FrFileSelector1: TFrFileSelector;
    CmdExit: TAction;
    CmdBack: TAction;
    TiResult: TTabItem;
    PnlResult: TPanel;
    ToolBar2: TToolBar;
    BtnResultOk: TButton;
    BtnResultView: TButton;
    SgResult: TStringGrid;
    ScNote: TStringColumn;
    FcFrequencyHz: TFloatColumn;
    FcHoleDiameter: TFloatColumn;
    CcPlayholeNumber: TCheckColumn;
    FcDeltaCent: TIntegerColumn;
    FcDistance: TFloatColumn;
    FcCutoffFactor: TFloatColumn;
    Img: TImage;
    TiHelp: TTabItem;
    CmdShare: TShowShareSheetAction;
    DlgExport: TSaveDialog;
    StyleBook1: TStyleBook;
    PmMain: TPopupMenu;
    MiNew: TMenuItem;
    MiOpen: TMenuItem;
    MiSave: TMenuItem;
    MiSaveAs: TMenuItem;
    MiExit: TMenuItem;
    MenuItem1: TMenuItem;
    PnlHelp: TPanel;
    ToolBar3: TToolBar;
    BtnHelpOK: TButton;
    BtnDonate: TButton;
    LbInfo: TListBox;
    LbiInfoHdr: TListBoxItem;
    LbiInfoText: TListBoxItem;
    LbiInfoUrl1: TListBoxItem;
    LbUrl1: TLabel;
    ListBoxItem1: TListBoxItem;
    LbUrl2: TLabel;
    LbiCopyRight: TListBoxItem;
    PpInfo: TPageProducer;
    procedure MenuItemClick(Sender: TObject);
    procedure BtnMenuClick(Sender: TObject);
    procedure CmdSaveFmxAsExecute(Sender: TObject);
    procedure CmdOpenFmxExecute(Sender: TObject);
    procedure BtnFSOkClick(Sender: TObject);
    procedure BtnFSCancelClick(Sender: TObject);
    procedure CmdCalcExecute(Sender: TObject);
    procedure СbFluteTypeChange(Sender: TObject);
    procedure CmdSaveFmxUpdate(Sender: TObject);
    procedure CmdSaveFmxExecute(Sender: TObject);
    procedure EdHolesCountChange(Sender: TObject);
    procedure CbKeynoteChange(Sender: TObject);
    procedure CbScaleChange(Sender: TObject);
    procedure CbIntonationChange(Sender: TObject);
    procedure CbAlgorithmChange(Sender: TObject);
    procedure EdOuterDiameterChange(Sender: TObject);
    procedure EdWallThicknessChange(Sender: TObject);
    procedure EdWindwayLengthChange(Sender: TObject);
    procedure EdEmbLengthChange(Sender: TObject);
    procedure EdEmbWidthChange(Sender: TObject);
    procedure EdEmbThicknessChange(Sender: TObject);
    procedure CmdNewExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TrConfirmTimer(Sender: TObject);
    procedure CmdExitExecute(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure CmdBackExecute(Sender: TObject);
    procedure CmdBackUpdate(Sender: TObject);
    procedure EdCaptionChange(Sender: TObject);
    procedure BtnResultOkClick(Sender: TObject);
    procedure SgResultCellClick(const Column: TColumn; const Row: Integer);
    procedure SgResultDrawColumnCell(Sender: TObject; const Canvas: TCanvas;
      const Column: TColumn; const Bounds: TRectF; const Row: Integer;
      const Value: TValue; const State: TGridDrawStates);
    procedure SgResultSelectCell(Sender: TObject; const ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure SgResultEditingDone(Sender: TObject; const ACol, ARow: Integer);
    procedure BtnHelpClick(Sender: TObject);
    procedure CmdExportImgExecute(Sender: TObject);
    procedure CmdShareBeforeExecute(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure LbUrl1Click(Sender: TObject);
    procedure BtnDonateClick(Sender: TObject);
    procedure TabMainChange(Sender: TObject);
    procedure LbiInfoTextApplyStyleLookup(Sender: TObject);
  private
    fFlute: TFlute;
    fBitmapScale: single;
    fTmpFileName: string;
    function CheckFileSaved(Sender: TObject): boolean;
    procedure UpdateCaption;
    procedure UpdateMenuItems;
    procedure UpdateParamControls;
    procedure DisplayResult;
    procedure NewFmx;
    procedure LoadFmx(const aFilename: string);
    procedure SaveFmx(const aFilename: string);
    procedure TrySaveFmx(const aFilename: string);
    procedure SetActiveTab(const Value: TTabItem);
    procedure FileSelectorItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);
    procedure ConfirmSaveEvent(Sender: TObject; const AResult: TModalResult);
    procedure ConfirmRevriteEvent(Sender: TObject; const AResult: TModalResult);
    procedure AppException(Sender: TObject; E: Exception);
    procedure FluteChange(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Single); override;
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.fmx}
{$R *.SmXhdpiPh.fmx ANDROID}
{$R *.NmXhdpiPh.fmx ANDROID}

uses
  Math, System.IOUtils, FMX.Platform, FMX.DialogService.Async, uURL;

{ TfrmMain }


constructor TFrmMain.Create(AOwner: TComponent);
var
  srv: IFMXScreenService;
begin
  inherited;
  Application.OnException := AppException;
  FrFileSelector1.OnItemClick := FileSelectorItemClick;
  LbxMenu.Visible := false;
  TabMain.ActiveTab := TiMain;
  fFlute := TFlute.Create;
  fFlute.OnChange := FluteChange;
  fBitmapScale := IfThen(TPlatformServices.Current.SupportsPlatformService(IFMXScreenService, IInterface(srv)),
    srv.GetScreenScale, 1);
  Img.Bitmap.SetSize(Ceil(600 * fBitmapScale), Ceil(316 * fBitmapScale));
  LbiInfoText.Text := PpInfo.HTMLDoc.Text;
  LbiInfoText.VertTextAlign := TTextAlign.Leading;

{$IFDEF ANDROID}
  LbiInfoText.Font.Size := 18;
  LbiCopyRight.Font.Size := 13;
{$ENDIF}

  NewFmx;
end;

destructor TFrmMain.Destroy;
begin
  FreeAndNil(fFlute);
  inherited;
end;

procedure TFrmMain.CmdExitExecute(Sender: TObject);
begin
{$IFDEF ANDROID}
  //MainActivity.finishAndRemoveTask;
  Application.Terminate;
{$ELSE}
  Close;
{$ENDIF}
end;

procedure TFrmMain.CmdBackExecute(Sender: TObject);
begin
  SetActiveTab(TiMain);
end;

procedure TFrmMain.CmdBackUpdate(Sender: TObject);
begin
  CmdBack.Enabled := TabMain.TabIndex > 0;
end;

procedure TFrmMain.AppException(Sender: TObject; E: Exception);
begin
  TDialogServiceAsync.MessageDialog('Ошибка: ' + e.Message, TMsgDlgType.mtError,
  [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, 0);
end;


procedure TFrmMain.SetActiveTab(const Value: TTabItem);
var
  d: TTabTransitionDirection;
begin
  if TabMain.TabIndex < Value.Index then
    d := TTabTransitionDirection.Normal
  else
    d := TTabTransitionDirection.Reversed;
  TabMain.SetActiveTabWithTransition(Value, TTabTransition.ttSlide, d);
end;

procedure TFrmMain.BtnFSCancelClick(Sender: TObject);
begin
  SetActiveTab(TiMain);
end;

procedure TFrmMain.BtnMenuClick(Sender: TObject);
var
  p: TPointF;
begin
{$IF Defined(MSWINDOWS) or Defined(MACOS)}
  p.X := BtnMenu.Position.X;
  p.Y := BtnMenu.Position.Y + BtnMenu.Size.Height + 1;
  p := ClientToScreen(p);
  PmMain.Popup(p.X, p.Y);
  exit;
{$ENDIF}
  UpdateMenuItems;
  LbxMenu.Visible := not LbxMenu.Visible;
  if LbxMenu.Visible then
  begin
    LbxMenu.BringToFront;
    LbxMenu.ItemIndex := -1; // Make sure no menu items are selected
    LbxMenu.ApplyStyleLookup;
    LbxMenu.RealignContent;
  end;
end;

procedure TFrmMain.UpdateCaption;
const
  CH: array[boolean] of string = ('', '*');
begin
  Caption := Format('%s%s - [%s]', [CH[fFlute.Changed], APPNAME, ExtractFileName(fFlute.Filename)]);
end;

procedure TFrmMain.UpdateMenuItems;
begin
  // Enable/disable menu items here
  CmdSaveFmx.Update;
  LbiSave.Enabled := CmdSaveFmx.Enabled;
end;

procedure TFrmMain.MenuItemClick(Sender: TObject);
var
  Item: TListBoxItem;
begin
  LbxMenu.Visible := false;
  Invalidate;
  Application.ProcessMessages;
  Item := TListBoxItem(Sender);
  // The Click event still fires, even if the item is disabled :-/
  if Item.Enabled then
    case Item.Tag of
      0: CmdExit.Execute;
      1: CmdNew.Execute;
      2: CmdOpenFmx.Execute;
      3: CmdSaveFmx.Execute;
      4: CmdSaveFmxAs.Execute;
    end;
end;

procedure TFrmMain.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Single);
var
  obj: IControl;
begin
  obj := ObjectAtPoint(ClientToScreen(PointF(X, Y)));
  if Assigned(obj) then
  begin
    if not ((obj.GetObject = LbxMenu) or (obj.GetObject = BtnMenu)) and LbxMenu.Visible then
      LbxMenu.Visible := false;
  end;
  inherited;
end;

procedure TFrmMain.FileSelectorItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  BtnFSOk.Enabled := (Item.Tag = 0);
end;

procedure TFrmMain.FluteChange(Sender: TObject);
begin
  CmdSaveFmx.Update;
  UpdateCaption;
end;

procedure TFrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := CheckFileSaved(CmdExit);
end;

procedure TFrmMain.FormDeactivate(Sender: TObject);
begin
  LbxMenu.Visible := false;
end;

procedure TFrmMain.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  if Key = vkHardwareBack then
  begin
    Key := 0;
    if not CmdBack.Execute then
    begin
      TDialogServiceAsync.MessageDialog('Выйти из приложения?', TMsgDlgType.mtConfirmation,
        mbYesNo, TMsgDlgBtn.mbYes, 0,
        procedure(const AResult: TModalResult)
        begin
          if AResult = mrYes then
            Application.Terminate;
        end
      );
    end;
  end;
end;



procedure TFrmMain.BtnFSOkClick(Sender: TObject);
begin
  SetActiveTab(TiMain);
  LoadFmx(FrFileSelector1.FileName);
end;

procedure TFrmMain.CmdOpenFmxExecute(Sender: TObject);
begin
  if not CheckFileSaved(CmdOpenFmx) then
    exit;
  {$IFDEF ANDROID}
  BtnFSOk.Enabled := false;
  FrFileSelector1.FileName := '';
  FrFileSelector1.Refresh;
  SetActiveTab(TiFileSelector);
  {$ELSE}
  if not DlgOpenFmx.Execute then
    exit;
  SetActiveTab(TiMain);
  LoadFmx(DlgOpenFmx.FileName);
  {$ENDIF}
end;


procedure TFrmMain.TrySaveFmx(const aFilename: string);
begin
  // fileexists checks
  if FileExists(aFilename) then
  begin
    fTmpFileName := aFilename;
    TDialogServiceAsync.MessageDialog(
    Format('Файл "%s" существует. Заменить?', [ExtractFileName(aFilename)]),
    TMsgDlgType.mtConfirmation, mbYesNo, TMsgDlgBtn.mbNo, 0, ConfirmRevriteEvent);
    exit;
  end;

 SaveFmx(aFilename);
end;

procedure TFrmMain.CmdSaveFmxAsExecute(Sender: TObject);
begin
{$IFDEF ANDROID}
  TDialogServiceAsync.InputQuery('Сохранить расчёт как', ['Введите имя файла без расширения'],
    [TPath.GetFileNameWithoutExtension(fFlute.Filename)],
    procedure(const AResult: TModalResult; const AValues: array of string)
    begin
      if (AResult = mrOk) and (AValues[0].Trim <> '') then
      begin
        TrySaveFmx(TPath.Combine(FrFileSelector1.Root, TPath.ChangeExtension(AValues[0], '.fmx')));
      end;
    end
  );
{$ELSE}
  if FileExists(fFlute.Filename) then
    DlgSaveFmx.InitialDir := ExtractFilePath(fFlute.Filename);
  DlgSaveFmx.FileName := ExtractFileName(fFlute.Filename);
  if not DlgSaveFmx.Execute then
    exit;
  SaveFmx(DlgSaveFmx.FileName);
{$ENDIF}
end;

procedure TFrmMain.CmdSaveFmxExecute(Sender: TObject);
begin
  if not FileExists(fFlute.Filename) then
  begin
    CmdSaveFmxAs.Execute;
    exit;
  end;
  SaveFmx(fFlute.Filename);
end;

procedure TFrmMain.CmdSaveFmxUpdate(Sender: TObject);
begin
  CmdSaveFmx.Enabled := fFlute.Changed;
end;

procedure TFrmMain.CmdNewExecute(Sender: TObject);
begin
  if CheckFileSaved(CmdNew) then
    NewFmx;
end;

procedure TFrmMain.NewFmx;
begin
  SetActiveTab(TiMain);
  fFlute.Reset;
  fFlute.BeginUpdate;
  try
    UpdateParamControls;
  finally
    fFlute.EndUpdate;
  end;
  UpdateCaption;
end;

procedure TFrmMain.ConfirmRevriteEvent(Sender: TObject;
  const AResult: TModalResult);
begin
  if AResult = mrYes then
    SaveFmx(fTmpFileName);
end;

procedure TFrmMain.ConfirmSaveEvent(Sender: TObject; const AResult: TModalResult);
begin
  if AResult = mrCancel then
    exit;
  TrConfirm.Tag := NativeInt(AResult);
  TrConfirm.TagObject := Sender;
  TrConfirm.Enabled := true;
end;

procedure TFrmMain.TabMainChange(Sender: TObject);
begin
  LblTitle.Text := TabMain.ActiveTab.Text;
end;

procedure TFrmMain.TrConfirmTimer(Sender: TObject);
begin
  TrConfirm.Enabled := false;
  case TrConfirm.Tag of
    mrCancel: exit;
    mrYes:
    begin
      CmdSaveFmx.Execute;
      if fFlute.Changed then
        exit;
    end;
  end;
  fFlute.Reset;
  if TrConfirm.TagObject is TCustomAction then
    (TrConfirm.TagObject as TCustomAction).Execute;
end;

function TFrmMain.CheckFileSaved(Sender: TObject): boolean;
begin
  if not fFlute.Changed then
    Exit(true);
  TDialogServiceAsync.MessageDialog(
    Format('Сохранить изменения в файле "%s"?', [ExtractFileName(fFlute.Filename)]),
    TMsgDlgType.mtConfirmation, mbYesNoCancel, TMsgDlgBtn.mbYes, 0,
    ConfirmSaveEvent, Sender);
  Result := false;
end;

procedure TFrmMain.SaveFmx(const aFilename: string);
begin
  fFlute.SaveToFile(aFilename);
  CmdSaveFmx.Update;
  UpdateCaption;
end;

procedure TFrmMain.UpdateParamControls;
begin
  СbFluteType.ItemIndex := fFlute.&Type;
  EdHolesCount.Value := fFlute.HolesCount;
  CbKeynote.ItemIndex := fFlute.KeyNote;
  CbScale.ItemIndex := fFlute.Scale;
  CbIntonation.ItemIndex := fFlute.Intonation;
  CbAlgorithm.ItemIndex := fFlute.Algorithm;
  EdCaption.Text := fFlute.Caption;
  EdOuterDiameter.Value := fFlute.OuterDiameter;
  EdWallThickness.Value := fFlute.WallThickness;
  EdWindwayLength.Value := fFlute.WindwayLength;
  EdEmbLength.Value := fFlute.EmbLength;
  EdEmbWidth.Value := fFlute.EmbWidth;
  EdEmbThickness.Value := fFlute.EmbThickness;
  // by type
  LbiWindwayLength.Visible := fFlute.&Type < 2;
  LbiEmbWidth.Visible := fFlute.&Type <> 1;
  LbiEmbThickness.Visible := fFlute.&Type <> 1;
  LbiEmbThickness.Enabled := fFlute.Algorithm <> 1;

  case fFlute.&Type of
    0:
    begin
      LbiWindwayLength.Text := 'Длина виндвэйя, мм:';
      LbiEmbLength.Text := 'Длина окна лабиума, мм:';
    end;
    1:
    begin
      LbiWindwayLength.Text := 'Длина до амбушюра, мм:';
      LbiEmbLength.Text := 'Диаметр амбушюра, мм:';
    end;
    2:
    begin
      LbiEmbLength.Text := 'Длина окна лабиума, мм:';
    end;
  end;
end;

procedure TFrmMain.LoadFmx(const aFilename: string);
begin
  fFlute.LoadFromFile(aFilename);
  fFlute.BeginUpdate;
  try
    UpdateParamControls;
  finally
    fFlute.EndUpdate;
  end;
  UpdateCaption;
end;

procedure TFrmMain.СbFluteTypeChange(Sender: TObject);
begin
  fFlute.&Type := СbFluteType.ItemIndex;
  UpdateParamControls;
end;

procedure TFrmMain.EdHolesCountChange(Sender: TObject);
begin
  fFlute.HolesCount := Trunc(EdHolesCount.Value);
end;

procedure TFrmMain.CbKeynoteChange(Sender: TObject);
begin
  fFlute.KeyNote := CbKeynote.ItemIndex;
end;

procedure TFrmMain.CbScaleChange(Sender: TObject);
begin
  fFlute.Scale := CbScale.ItemIndex;
end;

procedure TFrmMain.CbIntonationChange(Sender: TObject);
begin
  fFlute.Intonation := CbIntonation.ItemIndex;
end;

procedure TFrmMain.CbAlgorithmChange(Sender: TObject);
begin
  fFlute.Algorithm := CbAlgorithm.ItemIndex;
  UpdateParamControls;
end;

procedure TFrmMain.EdCaptionChange(Sender: TObject);
begin
  fFlute.Caption := EdCaption.Text;
end;

procedure TFrmMain.EdOuterDiameterChange(Sender: TObject);
begin
  fFlute.OuterDiameter := EdOuterDiameter.Value;
end;

procedure TFrmMain.EdWallThicknessChange(Sender: TObject);
begin
  fFlute.WallThickness := EdWallThickness.Value;
end;

procedure TFrmMain.EdWindwayLengthChange(Sender: TObject);
begin
  fFlute.WindwayLength := EdWindwayLength.Value;
end;

procedure TFrmMain.EdEmbLengthChange(Sender: TObject);
begin
  fFlute.EmbLength := EdEmbLength.Value;
end;

procedure TFrmMain.EdEmbWidthChange(Sender: TObject);
begin
  fFlute.EmbWidth := EdEmbWidth.Value;
end;

procedure TFrmMain.EdEmbThicknessChange(Sender: TObject);
begin
  fFlute.EmbThickness := EdEmbThickness.Value;
end;

procedure TFrmMain.CmdCalcExecute(Sender: TObject);
begin
  fFlute.Calc;
  DisplayResult;
  SetActiveTab(TiResult);
end;

procedure TFrmMain.DisplayResult;
var
  i, n: integer;
begin
  SgResult.RowCount := fFlute.HolesCount + 1;
{$IFDEF ANDROID}
  SgResult.Height := (SgResult.RowHeight + 1) * (SgResult.RowCount + 1) + 10;
{$ENDIF}

  n := fFlute.HolesCount;
  for i := 1 to n do
  begin
    SgResult.Cells[0, n - i] := BoolToStr(fFlute[i].Enabled, true);
    SgResult.Cells[1, n - i] := fFlute[i].Note;
    SgResult.Cells[2, n - i] := Format('%.3f', [fFlute[i].Freq]);
    SgResult.Cells[3, n - i] := IntToStr(fFlute[i].Diff);
    if fFlute[i].Enabled then
    begin
      SgResult.Cells[4, n - i] := Format('%.1f', [fFlute[i].Diam]);
      SgResult.Cells[5, n - i] := Format('%.1f', [fFlute[i].Dist]);
      SgResult.Cells[6, n - i] := Format('%.1f', [fFlute[i].Fact]);
    end else
    begin
      SgResult.Cells[4, n - i] := '';
      SgResult.Cells[5, n - i] := '';
      SgResult.Cells[6, n - i] := '';
    end;
  end;
  SgResult.Cells[0, n] := '0 (Все закрыты)';
  SgResult.Cells[1, n] := fFlute[0].Note;
  SgResult.Cells[2, n] := Format('%.3f', [fFlute[0].Freq]);
  SgResult.Cells[3, n] := IntToStr(fFlute[0].Diff);
  SgResult.Cells[4, n] := '';
  SgResult.Cells[5, n] := '';
  SgResult.Cells[6, n] := '';
  fFlute.RenderBitmap(Img.Bitmap, fBitmapScale);
end;

procedure TFrmMain.SgResultCellClick(const Column: TColumn; const Row: Integer);
var
  h: THole;
begin
  if (Column.Index = 0) and (fFlute.HolesCount > Row) then
  begin
    h := fFlute[fFlute.HolesCount - Row];
    h.Enabled := not h.Enabled;
    SgResult.Cells[0, Row] := BoolToStr(h.Enabled, true);
    fFlute.Calc;
    DisplayResult;
  end;
end;


procedure TFrmMain.SgResultDrawColumnCell(Sender: TObject;
  const Canvas: TCanvas; const Column: TColumn; const Bounds: TRectF;
  const Row: Integer; const Value: TValue; const State: TGridDrawStates);
var
  r: TRectF;
begin
  if (Column.Index = 0) then
  begin
    r := Bounds;
    r.Left := 20;
    Canvas.Fill.Color := SgResult.TextSettings.FontColor;
    if fFlute.HolesCount = Row then
      Canvas.FillText(r, '0 (Все закрыты)', false, 1, [], TTextAlign.Leading)
    else
      Canvas.FillText(r, IntToStr(fFlute.HolesCount - Row), false, 1, [], TTextAlign.Leading);
  end;
end;

procedure TFrmMain.SgResultSelectCell(Sender: TObject; const ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  CanSelect := (ARow < fFlute.HolesCount) or ((ARow = fFlute.HolesCount) and (ACol in [1..3]));
end;

procedure TFrmMain.SgResultEditingDone(Sender: TObject; const ACol,
  ARow: Integer);
var
  n: integer;
begin
  if not (ACol in [2..4]) then
    exit;
  n := fFlute.HolesCount - ARow;
  case ACol of
    2: fFlute[n].Freq := StrToFloatDEF(SgResult.Cells[ACol, ARow], fFlute[n].Freq);
    3: fFlute[n].Diff := StrToIntDef(SgResult.Cells[ACol, ARow], fFlute[n].Diff);
    4: fFlute[n].Diam := StrToFloatDEF(SgResult.Cells[ACol, ARow], fFlute[n].Diam);
  end;
  fFlute.Calc;
  DisplayResult;
end;

procedure TFrmMain.BtnHelpClick(Sender: TObject);
begin
  SetActiveTab(TiHelp);
end;

procedure TFrmMain.CmdShareBeforeExecute(Sender: TObject);
begin
  CmdShare.Bitmap.Assign(Img.Bitmap);
end;

procedure TFrmMain.CmdExportImgExecute(Sender: TObject);
var
  s: string;
begin
{$IFDEF ANDROID}
  CmdShare.ExecuteTarget(Sender);
{$ELSE}
  if FileExists(fFlute.Filename) then
    DlgExport.InitialDir := ExtractFilePath(fFlute.Filename);
  DlgExport.FileName := ExtractFileName(ChangeFileExt(fFlute.Filename, '.png'));
  if not DlgExport.Execute then
    exit;
  s := DlgExport.FileName;
  Img.Bitmap.SaveToFile(s);
{$ENDIF}
end;


procedure TFrmMain.BtnResultOkClick(Sender: TObject);
begin
  SetActiveTab(TiMain);
end;

procedure TFrmMain.LbUrl1Click(Sender: TObject);
begin
  TUrlOpen.Open(TLabel(Sender).Text);
end;

procedure TFrmMain.BtnDonateClick(Sender: TObject);
begin
  TUrlOpen.Open('http://stone-voices.ru/donation');
end;


procedure TFrmMain.LbiInfoTextApplyStyleLookup(Sender: TObject);
var
  fTextLyout: TTextLayout;
begin
  LbiInfoText.StyledSettings := LbiInfoText.StyledSettings - [TStyledSetting.Size];
  {$IFDEF MSWINDOWS}
  LbiInfoText.Font.Size := 13;
  {$ELSE}
  LbiInfoText.Font.Size := 16;
  {$ENDIF}
  fTextLyout := TTextLayoutManager.DefaultTextLayout.Create;
  try
    fTextLyout.BeginUpdate;
    try
      fTextLyout.Text := LbiInfoText.Text;
      fTextLyout.MaxSize := TPointF.Create(LbiInfoText.Width, 9999);
      fTextLyout.WordWrap := true;
      fTextLyout.Font := LbiInfoText.Font;
      fTextLyout.HorizontalAlign := TTextAlign.Leading;
      fTextLyout.VerticalAlign := TTextAlign.Leading;
      fTextLyout.Padding := LbiInfoText.Padding;
    finally
      fTextLyout.EndUpdate;
    end;
    LbiInfoText.Height := fTextLyout.Height + 4;
  finally
    fTextLyout.Free;
  end;
end;

end.
