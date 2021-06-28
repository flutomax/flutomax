{ This program is free software. You are allowed to redistribute this
  software and making the software available for download or
  making this software part of a software CD compilation.
  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the author be held liable for any
  damages arising from the use of this software.

  © Copyright 2013-2021 Vasily Makarov
}

unit uFlute;

{$i NativeDraw.inc}

interface

uses
  System.SysUtils, System.Types, System.Classes, System.UITypes, FMX.Graphics,
  FMX.Types, FMX.Graphics.Native;

const
  MAX_HOLES = 10;

  DEF_OUTDIAM = 20.0;
  DEF_WINDLEN = 30.0;
  DEF_EMBLEN = 5.6;
  DEF_EMBWIDTH = 11.2;
  DEF_EMBDIAM = 10.0;
  DEF_EMBTHIN = 2.9;
  DEF_WALTHIN = 1.0;
  DEF_ENDEFAC = 0.5;
  DEF_VSOUND = 345310; // 345310 mm/s = 345.31  m/s
  DEF_A4 = 440.0;
  DEF_FILENAME = 'Unnamed.fmx';
  APPNAME = 'FlutoMAX Lite';

type

  EFlutoMAXException = class(Exception);
  TID = packed array[0..3] of UTF8Char;

  TFract = packed record
    Int,
    Frac: Byte;
  end;

  TToneScale = record
    Name: string;
    Tones: array[0..MAX_HOLES - 1] of integer;
    Holes: array[0..MAX_HOLES] of double;
  end;

  TStroy = record
    Name: string;
    Coeffs: array[0..11] of double;
  end;

  TFMXHeader = packed record
    ID: TID;
    Version: Word;
    FileSize: Cardinal;
  end;

  TNotifiabledObject = class
  private
    fUpdateCount: Integer;
    fOnChange: TNotifyEvent;
  protected
    procedure DoChange; virtual;
  public
    constructor Create; virtual;
    procedure BeginUpdate; virtual;
    procedure EndUpdate; virtual;
    property OnChange: TNotifyEvent read fOnChange write fOnChange;
  end;

  THole = class(TNotifiabledObject)
  private
    fIndex: Integer;
    fNote: string;
    fEnabled: Boolean;
    fIsThumbHole: Boolean;
    fFreq: Double;
    fFreq0: Double;
    fDiff: Integer;
    fDiam: Double;
    fDist: Double;
    fFact: Double;
    procedure SetIndex(const Value: Integer);
    procedure SetEnabled(const Value: Boolean);
    procedure SetIsThumbHole(const Value: Boolean);
    procedure SetFreq(const Value: Double);
    procedure SetDiff(const Value: Integer);
    procedure SetDiam(const Value: Double);
  public
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream; const version: Word);
  published
    property Index: integer read fIndex write SetIndex;
    property Note: string read fNote;
    property Enabled: Boolean read fEnabled write SetEnabled;
    property IsThumbHole: Boolean read fIsThumbHole write SetIsThumbHole;
    property Freq: Double read fFreq write SetFreq;
    property Freq0: Double read fFreq0;
    property Diff: Integer read fDiff write SetDiff;
    property Diam: Double read fDiam write SetDiam;
    property Dist: Double read fDist;
    property Fact: Double read fFact;
  end;

  THoles = array[0..MAX_HOLES] of THole;

  TFlute = class(TNotifiabledObject)
  private
    fHoles: THoles;
    fHolesCount: Byte;
    fKeyNote: Byte;
    fScale: Byte;
    fIntonation: Byte;
    fAlgorithm: Byte;
    fCaption: string;
    fType: Byte;
    fOuterDiameter: Double;
    fWallThickness: Double;
    fWindwayLength: Double;
    fEmbLength: Double;
    fEmbWidth: Double;
    fEmbThickness: Double;
    fEmbCorr: Double;
    fBore: Double;
    fVSound: Double;
    fEndEfFactor: Double;
    fToLabLength: Double;
    fTotalLength: Double;
    fChanged: Boolean;
    fFilename: string;
    function EndCorrection: double;
    function EmbouchureCorrection: double;
    function ClosedCorrection(const n: integer): double;
    function EffectiveThickness(const n: integer): double;
    function CutoffFrequency(const n: integer): double;
    procedure CalcHoles;
    procedure CalcLabium;
    procedure CalcFreqency;
    procedure CalcQuadratic;
    procedure CalcCutoffFrequency;
    procedure CalcRelitavyDistance;
    procedure UpdateType;
    procedure SetHolesCount(const Value: Byte);
    procedure SetKeyNote(const Value: Byte);
    procedure SetScale(const Value: Byte);
    procedure SetIntonation(const Value: Byte);
    procedure SetAlgorithm(const Value: Byte);
    procedure SetCaption(const Value: string);
    procedure SetType(const Value: Byte);
    procedure SetOuterDiameter(const Value: Double);
    procedure SetWallThickness(const Value: Double);
    procedure SetWindwayLength(const Value: Double);
    procedure SetEmbLength(const Value: Double);
    procedure SetEmbWidth(const Value: Double);
    procedure SetEmbThickness(const Value: Double);
    procedure HoleChange(Sender: TObject);
    function GetHole(index: integer): THole;
  protected
    procedure DoChange; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Reset;
    procedure Calc;
    procedure SaveToFile(const aFileName: string);
    procedure LoadFromFile(const aFileName: string);
    procedure BeginUpdate; override;
    procedure EndUpdate; override;
    procedure RenderBitmap(bmp: Tbitmap; BitmapScale: Single);
    property Hole[index: integer]: THole read GetHole; default;
    property Changed: Boolean read fChanged;
    property Filename: string read fFilename;
  published
    property HolesCount: Byte read fHolesCount write SetHolesCount;
    property KeyNote: Byte read fKeyNote write SetKeyNote;
    property Scale: Byte read fScale write SetScale;
    property Intonation: Byte read fIntonation write SetIntonation;
    property Algorithm: Byte read fAlgorithm write SetAlgorithm;
    property Caption: string read fCaption write SetCaption;
    property &Type: Byte read fType write SetType;
    property OuterDiameter: Double read fOuterDiameter write SetOuterDiameter;
    property WallThickness: Double read fWallThickness write SetWallThickness;
    property WindwayLength: Double read fWindwayLength write SetWindwayLength;
    property EmbLength: Double read fEmbLength write SetEmbLength;
    property EmbWidth: Double read fEmbWidth write SetEmbWidth;
    property EmbThickness: Double read fEmbThickness write SetEmbThickness;
  end;

var

  ArrowShape: integer = 2;
  ArrowSize: integer = 0;
  ArrowAngle: double = 45;
  TitleFontSize: double = 13;
  SizesFontSize: double = 10.5;
  FootherFontSize: double = 9.5;

const

  FID: TID = '¤FMX';
  FMX_VERSION16 = 16;  // 1.5.16
  FMX_VERSION20 = 20;  // 1.5.20
  FMX_VERSION22 = 22;  // 1.6.48
  FMX_VERSION24 = 24;  // 1.7.50
  FMX_VERSION26 = 26;  // 1.8.54

  ROOT_12 = 1.0594630943593;

  NOTE_NAMES: array[0..11] of string = ('C','C#','D','D#','E','F','F#','G','G#','A','A#','B');

  ToneScales: array[0..8] of TToneScale = (
  (Name: 'Мажорная гамма'; Tones: (2,2,1,2,2,2,1,2,2,1); Holes: (0,0.54,0.57,0.36,0.43,0.46,0.39,0.34,0.30,0.34,0.34)),
  (Name: 'Натуральный Минор'; Tones: (2,1,2,2,1,2,2,2,1,2); Holes: (0,0.55,0.34,0.46,0.55,0.34,0.43,0.34,0.34,0.34,0.34)),
  (Name: 'Мелодический Минор'; Tones: (2,1,2,2,2,2,1,2,1,2); Holes: (0,0.57,0.36,0.55,0.43,0.46,0.5,0.34,0.34,0.34,0.34)),
  (Name: 'Гармонический Минор'; Tones: (2,1,2,2,1,3,1,2,1,2); Holes: (0,0.55,0.34,0.44,0.5,0.34,0.57,0.34,0.34,0.34,0.34)),
  (Name: 'NAF/Пимак'; Tones: (3,2,2,1,2,2,2,3,2,2); Holes: (0,0.34,0.39,0.55,0.30,0.43,0.39,0.34,0.34,0.34,0.34)),
  (Name: 'Агава Раба'; Tones: (1,3,1,2,1,2,2,1,3,1); Holes: (0,0.27,0.57,0.30,0.39,0.27,0.43,0.34,0.34,0.34,0.34)),
  (Name: 'Блюзовая гамма'; Tones: (2,1,2,1,1,3,2,2,1,2); Holes: (0,0.39,0.27,0.30,0.27,0.27,0.43,0.43,0.34,0.34,0.34)),
  (Name: 'Медитативная';  Tones: (1,2,1,4,2,1,1,1,2,1); Holes: (0,0.27,0.44,0.27,0.5,0.36,0.34,0.34,0.34,0.34,0.34)),
  (Name: 'Мажорная пентатоника'; Tones: (2,2,3,2,3,2,2,3,2,3); Holes: (0,0.54,0.57,0.55,0.43,0.46,0.39,0.34,0.30,0.34,0.34))
  );

  Stroys: array[0..4] of TStroy = (
  (Name: 'Хроматический'; Coeffs: (1,1.059463094,1.122462048,1.189207115,1.259921050,1.334839854,1.414213562,1.498307077,1.587401052,1.681792831,1.781797436,1.887748625)),
  (Name: 'Натуральный'; Coeffs: (1,16/15,9/8,6/5,5/4,4/3,45/32,3/2,8/5,5/3,16/9,15/8)),
  (Name: 'Пифагорейский'; Coeffs: (1,256/243,9/8,32/27,81/64,4/3,1024/729,3/2,128/81,27/16,16/9,243/128)),
  (Name: 'Среднетоновый'; Coeffs: (1,1.044907,1.118034,1.196279,1.25,1.33748,1.397542,1.495348,1.6,1.67185,1.788854,1.869186)),
  (Name: 'Традициональный'; Coeffs: (1,1.060717,1.123790,1.190614,1.254890,1.333333,1.4142811,1.49838,1.585444,1.679720,1.779601,1.866066)));



implementation

uses
  Math, Math.Vectors;

function FloatToFract(const a: Double): TFract; inline;
begin
  Assert((a >= 0) and (a < 256),'Недопустимый диапазон значения переменной (0..256)');
  result.Int := Round(Int(a));
  result.Frac := Round(Frac(a) * 10);
end;

function FractToFloat(const a: TFract): Double; inline;
begin
  FractToFloat := a.Int + a.Frac * 0.1;
end;

function WriteFloatToStream(Stream: TStream; const d: double): NativeInt;
var
  t: TFract;
begin
  t := FloatToFract(d);
  result := Stream.Write(t, sizeof(t));
end;

function ReadFloatFromStream(Stream: TStream; var d: double): NativeInt;
var
  t: TFract;
begin
  result := Stream.Read(t, sizeof(t));
  d := FractToFloat(t);
end;


function FreqToNote(const f: double): string;
var
  midi, note, okt: integer;
begin
  if f = 0 then
    exit;
  midi := Round(69 + 12 * log2(f / DEF_A4));
  okt := 8 - Floor((131 - midi) / 12);
  note := midi - 12 * (okt + 2);
  Result := Format('%s%d', [NOTE_NAMES[note], okt + 1]);
end;

function CentsDiff(const f: double): integer;
var
  cv: double;
begin
  if f = 0 then
    exit(0);
  cv := 12 * 1.442741049 * Ln(f / DEF_A4);
  cv := 100 * (cv - Round(cv));
  Result := Round(cv);
end;

function ShiftFreq(const f: double; const cents: integer): double;
begin
  Result := f;
  if cents = 0 then
    exit;
  Result := f * power(2, cents / 1200);
end;

{ TNotifiabledObject }

constructor TNotifiabledObject.Create;
begin
  fUpdateCount := 0;
end;

procedure TNotifiabledObject.DoChange;
begin
  if (fUpdateCount = 0) and Assigned(fOnChange) then
    fOnChange(Self);
end;

procedure TNotifiabledObject.BeginUpdate;
begin
  Inc(fUpdateCount);
end;

procedure TNotifiabledObject.EndUpdate;
begin
  Assert(FUpdateCount > 0, 'Unpaired TNotifiabledObject.EndUpdate');
  Dec(fUpdateCount);
end;


{ THole }

procedure THole.SetEnabled(const Value: Boolean);
begin
  if fEnabled = Value then
    exit;
  fEnabled := Value;
  DoChange;
end;

procedure THole.SetIndex(const Value: integer);
begin
  if fIndex = Value then
    exit;
  fIndex := Value;
  DoChange;
end;

procedure THole.SetIsThumbHole(const Value: Boolean);
begin
  if fIsThumbHole = Value then
    exit;
  fIsThumbHole := Value;
  DoChange;
end;

procedure THole.SetFreq(const Value: Double);
begin
  if fFreq = Value then
    exit;
  fFreq := Value;
  fDiff := CentsDiff(fFreq);
  DoChange;
end;

procedure THole.SetDiff(const Value: Integer);
begin
  if fDiff = Value then
    exit;
  fDiff := Value;
  fFreq := ShiftFreq(fFreq0, fDiff);
  DoChange;
end;

procedure THole.SetDiam(const Value: Double);
begin
  if fDiam = Value then
    exit;
  fDiam := Value;
  DoChange;
end;

procedure THole.LoadFromStream(Stream: TStream; const version: Word);
var
  n: byte;
begin
  Stream.ReadData(n);
  SetLength(fNote, n div 2);
  if n > 0 then
    Stream.Read(fNote[1], n);
  if version >= FMX_VERSION20 then
    Stream.ReadData(fEnabled);
  Stream.ReadData(fFreq);
  Stream.ReadData(fFreq0);
  Stream.ReadData(fDiff);
  ReadFloatFromStream(Stream, fDiam);
  if version = FMX_VERSION16 then
    fEnabled := fDiam > 0;
  Stream.ReadData(fDist);
  ReadFloatFromStream(Stream, fFact);
end;

procedure THole.SaveToStream(Stream: TStream);
var
  n: byte;
begin
  n := Length(fNote) * sizeof(Char);
  Stream.WriteData(n);
  if n > 0 then
    Stream.Write(fNote[1], n);
  Stream.WriteData(fEnabled);
  Stream.WriteData(fFreq);
  Stream.WriteData(fFreq0);
  Stream.WriteData(fDiff);
  WriteFloatToStream(Stream, fDiam);
  Stream.WriteData(fDist);
  WriteFloatToStream(Stream, fFact);
end;


{ TFlute }

constructor TFlute.Create;
var
  i: integer;
begin
  inherited Create;
  for i := 0 to MAX_HOLES do
  begin
    fHoles[i] := THole.Create;
    fHoles[i].Index := i;
    fHoles[i].OnChange := HoleChange;
  end;
  Reset;
end;

destructor TFlute.Destroy;
var
  i: integer;
begin
  for i := 0 to MAX_HOLES do
    FreeAndNil(fHoles[i]);
  inherited;
end;

procedure TFlute.BeginUpdate;
var
  i: integer;
begin
  for i := 0 to MAX_HOLES do
    fHoles[i].BeginUpdate;
  inherited;
end;

procedure TFlute.EndUpdate;
var
  i: integer;
begin
  for i := 0 to MAX_HOLES do
    fHoles[i].EndUpdate;
  inherited;
end;

procedure TFlute.DoChange;
begin
  if (fUpdateCount = 0) then
    fChanged := true;
  inherited DoChange;
end;

procedure TFlute.HoleChange(Sender: TObject);
begin
  DoChange;
end;

function TFlute.GetHole(index: integer): THole;
begin
  index := EnsureRange(index, 0, MAX_HOLES);
  result := fHoles[index];
end;

procedure TFlute.Reset;
var
  i: integer;
begin
  fHolesCount := 6;
  fKeyNote := 29;
  fScale := 0;
  fIntonation := 0;
  fAlgorithm := 0;
  fCaption := 'Флейта, тональность: %s (%.3f Гц)';
  fType := 0;
  fOuterDiameter := DEF_OUTDIAM;
  fWallThickness := DEF_WALTHIN;
  fWindwayLength := DEF_WINDLEN;
  fEmbLength := DEF_EMBLEN;
  fEmbWidth := DEF_EMBWIDTH;
  fEmbThickness := DEF_EMBTHIN;
  fEndEfFactor := DEF_ENDEFAC;
  fBore := fOuterDiameter - 2 * fWallThickness;
  fVSound := DEF_VSOUND;
  fChanged := false;
  fFilename := 'Unnamed.fmx';
  for i := 0 to MAX_HOLES do
    fHoles[i].fEnabled := true;
  CalcFreqency;
  CalcLabium;
  CalcHoles;
end;

procedure TFlute.SaveToFile(const aFileName: string);
var
  f: TFileStream;
  h: TFMXHeader;
  i: integer;
  v: double;
  n: byte;
begin
  h.ID := FID;
  h.Version := FMX_VERSION26;
  f := TFileStream.Create(aFileName, fmCreate);
  try
    f.Write(h, SizeOf(h));
    f.WriteData(fHolesCount);
    f.WriteData(fKeyNote);
    f.WriteData(fScale);
    f.WriteData(fIntonation);
    f.WriteData(fAlgorithm);
    // !!! VSound write to file in m/sec units !!!
    v := fVSound / 1000;
    f.WriteData(v);
    f.WriteData(fEndEfFactor);
    n := Length(fCaption);
    f.WriteData(n);
    if n > 0 then
      f.Write(PChar(fCaption)^, n * SizeOf(Char));
    f.WriteData(fType);
    WriteFloatToStream(f, fOuterDiameter);
    WriteFloatToStream(f, fWallThickness);
    WriteFloatToStream(f, fWindwayLength);
    WriteFloatToStream(f, fEmbLength);
    WriteFloatToStream(f, fEmbWidth);
    WriteFloatToStream(f, fEmbThickness);

    for i := 0 to fHolesCount do
      fHoles[i].SaveToStream(f);

    h.FileSize := f.Size;
    f.Seek(0, 0);
    f.Write(h, SizeOf(h));
  finally
    f.Free;
  end;
  fChanged := false;
  fFilename := aFileName;
end;

procedure TFlute.LoadFromFile(const aFileName: string);
const
  BAD_FILE = 'Файл испорчен.';
var
  f: TFileStream;
  h: TFMXHeader;
  i: integer;
  n: byte;
  m: Longint;
begin
  f := TFileStream.Create(aFileName, fmOpenRead or fmShareDenyNone);
  try
    m := f.Read(h, SizeOf(h));
    if m <> SizeOf(h) then
      raise EFlutoMAXException.Create(BAD_FILE);
    if h.ID <> FID then
      raise EFlutoMAXException.Create('Файл не является расчётом FlutoMAX либо испорчен.');
    if h.FileSize <> f.Size then
      raise EFlutoMAXException.Create(BAD_FILE);
    if h.Version > FMX_VERSION26 then
      raise EFlutoMAXException.Create('Файл был создан в более новой версии FlutoMAX.');
    Reset;
    f.ReadData(fHolesCount);
    if not (fHolesCount in [0..10]) then
      raise EFlutoMAXException.Create(BAD_FILE);
    f.ReadData(fKeyNote);
    if not (fKeyNote in [0..50]) then
      raise EFlutoMAXException.Create(BAD_FILE);
    f.ReadData(fScale);
    if not (fScale in [Low(ToneScales)..High(ToneScales)]) then
      raise EFlutoMAXException.Create(BAD_FILE);
    f.ReadData(fIntonation);
    if not (fIntonation in [Low(Stroys)..High(Stroys)]) then
      raise EFlutoMAXException.Create(BAD_FILE);
    if h.Version >= FMX_VERSION22 then
    begin
      f.ReadData(fAlgorithm);
      if not (fAlgorithm in [0..3]) then
        raise EFlutoMAXException.Create(BAD_FILE);
      // !!! VSound writed in file in m/sec units !!!
      f.ReadData(fVSound);
      fVSound := fVSound * 1000;
      f.ReadData(fEndEfFactor);
    end;
    if h.Version >= FMX_VERSION24 then
    begin
      f.ReadData(n);
      SetLength(fCaption, n);
      f.Read(PChar(fCaption)^, n * Sizeof(Char));
      f.ReadData(fType);
    end;
    ReadFloatFromStream(f, fOuterDiameter);
    ReadFloatFromStream(f, fWallThickness);
    ReadFloatFromStream(f, fWindwayLength);
    ReadFloatFromStream(f, fEmbLength);
    ReadFloatFromStream(f, fEmbWidth);
    ReadFloatFromStream(f, fEmbThickness);

    if h.Version >= FMX_VERSION22 then
    begin
      for i := 0 to fHolesCount do
        fHoles[i].LoadFromStream(f, h.Version);
    end else begin
      for i := 0 to fHolesCount do
        fHoles[6 - i].LoadFromStream(f, h.Version);
    end;

  finally
    f.Free;
  end;
  fChanged := false;
  fFilename := aFileName;
end;

procedure TFlute.UpdateType;
begin
  case fType of
    0:
    begin
      fAlgorithm := 0;
      fEmbLength := DEF_EMBLEN;
      fEmbWidth := DEF_EMBWIDTH;
      fWindwayLength := DEF_WINDLEN;
    end;
    1:
    begin
      fAlgorithm := 1;
      fEmbLength := DEF_EMBDIAM;
      fEmbWidth := DEF_EMBDIAM;
      fWindwayLength := DEF_WINDLEN;
    end;
    2:
    begin
      fAlgorithm := 0;
      fEmbLength := DEF_EMBLEN;
      fEmbWidth := DEF_EMBWIDTH;
      fWindwayLength := 0;
    end;
  end;
  CalcLabium;
  CalcHoles;
end;

procedure TFlute.SetHolesCount(const Value: Byte);
begin
  if fHolesCount = Value then
    exit;
  fHolesCount := Value;
  CalcFreqency;
  CalcHoles;
  DoChange;
end;

procedure TFlute.SetKeyNote(const Value: Byte);
begin
  if fKeyNote = Value then
    exit;
  fKeyNote := Value;
  CalcFreqency;
  DoChange;
end;

procedure TFlute.SetScale(const Value: Byte);
begin
  if fScale = Value then
    exit;
  fScale := Value;
  CalcFreqency;
  CalcHoles;
  DoChange;
end;

procedure TFlute.SetIntonation(const Value: Byte);
begin
  if fIntonation = Value then
    exit;
  fIntonation := Value;
  DoChange;
end;

procedure TFlute.SetAlgorithm(const Value: Byte);
begin
  if fAlgorithm = Value then
    exit;
  fAlgorithm := Value;
  DoChange;
end;

procedure TFlute.SetCaption(const Value: string);
begin
  if fCaption = Value then
    exit;
  fCaption := Value;
  DoChange;
end;

procedure TFlute.SetType(const Value: Byte);
begin
  if fType = Value then
    exit;
  fType := Value;
  UpdateType;
  DoChange;
end;

procedure TFlute.SetOuterDiameter(const Value: Double);
begin
  if fOuterDiameter = Value then
    exit;
  fOuterDiameter := Value;
  CalcLabium;
  CalcHoles;
  DoChange;
end;

procedure TFlute.SetWallThickness(const Value: Double);
begin
  if fWallThickness = Value then
    exit;
  fWallThickness := Value;
  DoChange;
end;

procedure TFlute.SetWindwayLength(const Value: Double);
begin
  if fWindwayLength = Value then
    exit;
  fWindwayLength := Value;
  DoChange;
end;

procedure TFlute.SetEmbLength(const Value: Double);
begin
  if fEmbLength = Value then
    exit;
  fEmbLength := Value;
  DoChange;
end;

procedure TFlute.SetEmbWidth(const Value: Double);
begin
  if fEmbWidth = Value then
    exit;
  fEmbWidth := Value;
  DoChange;
end;

procedure TFlute.SetEmbThickness(const Value: Double);
begin
  if fEmbThickness = Value then
    exit;
  fEmbThickness := Value;
  DoChange;
end;

procedure TFlute.CalcHoles;
var
  i: integer;
begin
  for i := 0 to MAX_HOLES do
  begin
    fHoles[i].fDiam := Round(2 * fBore * ToneScales[fScale].Holes[i]) / 2;
  end;
end;

procedure TFlute.CalcLabium;
const
  X: double = 10 / 18;
begin
  //if not AutoCalc then exit;
  fBore := fOuterDiameter - 2 * fWallThickness;
  fEmbThickness := Round(10 * fBore * 0.16) / 10;
  if fType = 1 then
  begin
    fEmbLength := Round(10 * fBore * X) / 10;
    fEmbWidth := fEmbLength;
  end
  else
  begin
    fEmbLength := Round(10 * fBore * 0.31) / 10;
    fEmbWidth := Round(10 * fBore * 0.62) / 10;
  end;
end;

procedure TFlute.CalcFreqency;
var
  i, k, n, x: integer;
  f: double;
begin
  n := fKeyNote;
  f := 0.25 * DEF_A4 * IntPower(2, n div 12) * Stroys[0].Coeffs[n mod 12];
  fHoles[0].fFreq := f;
  fHoles[0].fFreq0 := f;
  fHoles[0].fNote := FreqToNote(f);
  fHoles[0].fDiff := CentsDiff(f);
  k := 0;
  x := 0;
  for i := 1 to fHolesCount do
  begin
    x := ToneScales[fScale].Tones[i - 1];
    Inc(k, x);
    x := n + k;
    f := 0.25 * DEF_A4 * IntPower(2, x div 12) * Stroys[fIntonation].Coeffs[x mod 12];
    fHoles[i].fFreq := f;
    fHoles[i].fNote := FreqToNote(f);
    fHoles[i].fFreq0 := 0.25 * DEF_A4 * IntPower(2, x div 12) * Stroys[0].Coeffs[x mod 12];
    fHoles[i].fDiff := CentsDiff(f);
  end;
end;

function TFlute.EndCorrection: double;
begin
  if (fEmbLength = 0) or (fEmbWidth = 0) then
    exit(0);
  case fAlgorithm of
    0: Result := fEndEfFactor * fBore;
    2: Result := (fEndEfFactor + 0.06) * fBore;
    else Result := 1.2266 * fEndEfFactor * fBore / 2;
  end;
end;

function TFlute.EmbouchureCorrection: double;
var
  b, d: double;
begin
  if (fEmbLength = 0) or (fEmbWidth = 0) then
    exit(0);
  case fAlgorithm of
    1: // Flutomat
    begin
      d := (fEmbLength + fEmbWidth) / 2;
      Result := fBore / d;
      Result := Result * Result;
      Result := Result * 10.84 * fWallThickness * d;
      Result := Result / (fBore + (2 * fWallThickness));
    end;
    3: // TWCalc
    begin
      b := fEmbLength * fEmbWidth * 2 * PI;
      d := Sqrt(b / PI);
      Result := ((PI * fBore * fBore * 0.25) / b) * (fEmbThickness + 1.5 * d);
    end;
    else // HBracker, FlutoMAX
    begin
      b := (fBore * fBore) / (fEmbLength * fEmbWidth);
      d := (fEmbLength + fEmbWidth) / 2;
      Result := b * (fEmbThickness + 0.3 * d);
    end;
  end;
end;

function TFlute.ClosedCorrection(const n: integer): double;
var
  p: double;
begin
  p := fHoles[n].Diam / fBore;
  p := p * p;
  Result := 0.25 * fWallThickness * p;
end;

function TFlute.EffectiveThickness(const n: integer): double;
var
  Chimney: double;
begin
  Chimney := IfThen(fAlgorithm = 3, 0.6133, 0.75);
  Result := fWallThickness + (Chimney * fHoles[n].Diam);
end;

procedure TFlute.CalcQuadratic;
var
  i, n, holeNum: integer;
  xEnd, len, ratio,
  php, a, b, c, z: double;
begin
  n := fHolesCount;
  if (fHoles[0].Freq = 0) then
    exit;
  fBore := fOuterDiameter - 2 * fWallThickness;
  xEnd := fVsound / (2 * fHoles[0].Freq);
  xEnd := xEnd - EndCorrection();
  for i := 1 to n do
    if fHoles[i].Enabled then
      xEnd := xEnd - ClosedCorrection(i);

  fHoles[0].fDist := xEnd;
  if fHolesCount = 0 then
    exit;     // калюка

  len := fVsound / (2 * fHoles[1].Freq);
  for i := 2 to n do
    if fHoles[i].Enabled then
      len := len - ClosedCorrection(i);
  a := fHoles[1].Diam / fBore;
  a := a * a;
  if (fHoles[1].Diam = 0) or (not fHoles[1].Enabled) then
    fHoles[1].fDist := xEnd
  else
  begin
    b := -(xEnd + len) * a;
    c := (xEnd * len) * a;
    c := c + EffectiveThickness(1) * (len - xEnd);
    z := (b * b) - (4 * a * c);
    if z < 0 then
      z := Abs(z);
    fHoles[1].fDist := (-b - Sqrt(z)) / (2 * a);
  end;
  // find subsequent finger hole locations
  for holeNum := 2 to n do
  begin
    if (fHoles[holeNum].Diam = 0) or (not fHoles[holeNum].Enabled) then
    begin
      fHoles[holeNum].fDist := fHoles[holeNum - 1].Dist;
      continue;
    end;
    //final Hole hole = whistle.hole[holeNum];
    len := fVsound / (2 * fHoles[holeNum].Freq);
    for i := holeNum + 1 to n do
      if fHoles[i].Enabled then
        len := len - ClosedCorrection(i);
    a := 2;
    ratio := fBore / fHoles[holeNum].Diam;
    ratio := ratio * ratio * EffectiveThickness(holeNum);
    php := fHoles[holeNum - 1].Dist;
    if fHoles[holeNum - 1].IsThumbHole then
      php := fHoles[holeNum - 2].Dist;
    b := -php - (3 * len);
    b := b + ratio;
    c := len - ratio;
    c := c * php;
    c := c + len * len;
    z := (b * b) - (4 * a * c);
    if z < 0 then
      z := Abs(z);
    fHoles[holeNum].fDist := (-b - Sqrt(z)) / (2 * a);
  end;
end;

function TFlute.CutoffFrequency(const n: integer): double;
var
  php, dist, sqrtTerm, ratio: double;
begin
  Result := 0;
  if fHoles[n].Diam = 0 then
    exit;
  php := fHoles[n - 1].Dist;
  if fHoles[n - 1].isThumbHole then
    php := fHoles[n - 2].Dist;
  dist := php - fHoles[n].Dist;
  if dist < 0 then
    dist := 0;
  sqrtTerm := Sqrt(EffectiveThickness(n) * dist);
  if sqrtTerm = 0 then
    exit;
  ratio := fVsound / (2 * PI);
  ratio := ratio * (fHoles[n].Diam / fBore);
  Result := ratio / sqrtTerm;
end;

procedure TFlute.CalcRelitavyDistance;
var
  i: integer;
begin
  //fromEnd = hole.whistle.hole[0].position - hole.position;
  for i := 1 to fHolesCount do
    fHoles[i].fDist := fHoles[0].Dist - fHoles[i].Dist;
end;

procedure TFlute.CalcCutoffFrequency;
var
  i: integer;
begin
  fEmbCorr := EmbouchureCorrection;
  fToLabLength := RoundTo(fHoles[0].Dist - fEmbCorr, -1);
  fTotalLength := fWindwayLength + fToLabLength;
  for i := 1 to fHolesCount do
    fHoles[i].fFact := CutoffFrequency(i) / fHoles[i].Freq;
end;

procedure TFlute.Calc;
begin
  CalcQuadratic;
  CalcCutoffFrequency;
  CalcRelitavyDistance;
end;

///// Rendering

type
  TArrowHeadParams = array[0..3] of single;
  TArrowPts = array[0..4] of TPointF;

var
  ArrowHeads: array[0..15] of TArrowHeadParams;

procedure BuildArrowsHeads;
const
  InitShapes: array[0..3] of TArrowHeadParams =
    ((0, 0.8, 0.5, 0), (0, 1, 0.3, 0), (0, 0.7, 0.3, 0.3), (0, 0, 0.3, 1));
var
  i, j, k, m: integer;
begin
  k := 0;
  for i := 0 to 3 do
  begin
    for j := 6 to 9 do
    begin
      for m := 0 to 3 do
        ArrowHeads[k, m] := j * InitShapes[i, m];
      Inc(k);
    end;
  end;
end;

procedure MakeArrow(const p: TArrowHeadParams; out a: TArrowPts; const Flip: boolean);
begin
  FillChar(a, sizeof(a), 0);
  a[1].Y := -p[2];
  a[3].Y := p[2];
  if Flip then
  begin
    a[0].X := p[0];
    a[1].X := -(p[1] + p[3]);
    a[2].X := -p[1];
    a[3].X := -(p[1] + p[3]);
    a[4].X := p[0];
  end
  else
  begin
    a[0].X := -p[0];
    a[1].X := p[1] + p[3];
    a[2].X := p[1];
    a[3].X := p[1] + p[3];
    a[4].X := -p[0];
  end;
end;

function ArrowShapeWidth: double;
var
  i: integer;
begin
  i := ArrowShape * 4 + ArrowSize;
  Result := ArrowHeads[i, 1] + ArrowHeads[i, 3];
end;

procedure SizeLine(c: TCanvas; const x1, y1, x2, y2, s, dl, dr: double;
  const vert, flip, pf: boolean);
var
  p: TPathData;
  m, sm: TMatrix;
  i, shn: Integer;
  tw, th: single;
  z: double;
  r: TRectF;
  a: TArrowPts;
  t: string;
begin
  if pf then
    t := 'ø';
  t := t + FloatToStr(RoundTo(s, -1));
  tw := c.TextWidth(t);
  th := c.TextHeight(t);
  z := 2 * ArrowShapeWidth;
  p := TPathData.Create;
  try
    // Arrow
    shn := ArrowShape * 4 + ArrowSize;
    m := TMatrix.CreateRotation(ArcTan2(y2 - y1, x2 - x1));
    m.m31 := m.m31 + x1;
    m.m32 := m.m32 + y1;
    p.MoveTo(PointF(ArrowHeads[shn, 0], 0));
    if dl > 0 then
    begin
      p.MoveTo(PointF(0, 0));
      p.LineTo(PointF(-dl, 0));
    end;
    MakeArrow(ArrowHeads[shn], a, flip);
    p.MoveTo(a[0]);
    for i := 1 to 4 do
      p.LineTo(a[i]);
    p.ApplyMatrix(m);
    c.FillPath(p, 1);
    c.DrawPath(p, 1);

    p.Clear;
    m := TMatrix.CreateRotation(ArcTan2(y1 - y2, x1 - x2));
    m.m31 := m.m31 + x2;
    m.m32 := m.m32 + y2;
    p.MoveTo(PointF(ArrowHeads[shn, 0], 0));
    if dr > 0 then
    begin
      p.MoveTo(PointF(0, 0));
      p.LineTo(PointF(-(dr + tw), 0));
    end;
    MakeArrow(ArrowHeads[shn], a, flip);
    p.MoveTo(a[0]);
    for i := 1 to 4 do
      p.LineTo(a[i]);

    p.ApplyMatrix(m);
    c.FillPath(p, 1);
    c.DrawPath(p, 1);
    if vert then
    begin
      sm := c.Matrix;
      m := TMatrix.CreateRotation(ArcTan2(y1 - y2, x1 - x2));
      m.m31 := m.m31 + (x2 - th);
      m.m32 := m.m32 + (y2 + dr + tw);
      m := m * sm;
      c.SetMatrix(m);
      r.Create(0, -1, tw + 1, th);
      c.FillText(r, t, false, 1, [], TTextAlign.Center);
      c.SetMatrix(sm);
    end
    else
    begin
      if flip then
      begin
        r.Create(x2 + z, y1 - th, x2 + z + tw, y1);
        c.DrawLine(PointF(x1 - z, y1), PointF(x1, y1), 1);
        c.DrawLine(PointF(x2, y1), PointF(r.Right, y2), 1);
      end
      else
        r.Create(x1, y1 - th - 1, x2 + 1, y1);
      c.FillText(r, t, false, 1, [], TTextAlign.Center);
    end;
  finally
    p.Free;
  end;
  c.DrawLine(PointF(x1, y1), PointF(x2, y2), 1);
end;

procedure VSizeLine(c: TCanvas; const x, y1, y2, s, ls: double;
  const flip: boolean = false; const pf: boolean = false);
var
  a: double;
begin
  a := ArrowShapeWidth;
  SizeLine(c, x, y1, x, y2, s, a + 6, a + 6 + ls, true, flip, pf);
end;

procedure HSizeLine(c: TCanvas; const x1, x2, y, s: double;
  const flip: boolean = false);
begin
  SizeLine(c, x1, y, x2, y, s, 0, 0, false, flip, false);
end;

procedure ThinLine(c: TCanvas; const x, y, e, s: double);
var
  a, Xw, R, tw: double;
  t: string;
  rc: TRectF;
begin
  t := 's' + FloatToStr(RoundTo(s, -1));
  tw := c.TextWidth(t);
  a := DegToRad(ArrowAngle);
  Xw := e / Tan(a);
  R := (ArrowSize + 6) * 0.33;
  c.DrawLine(PointF(x + Xw + tw, y - e), PointF(x + Xw, y - e), 1);
  c.DrawLine(PointF(x + Xw, y - e), PointF(x, y), 1);
  rc.Create(x - r, y - r, x + r, y + r);
  c.FillEllipse(rc, 1);
  rc := RectF(x + Xw, y - (e + c.TextHeight(t)) - 1, x + Xw + tw + 1, y - e);
  c.FillText(rc, t, false, 1, [], TTextAlign.Center);
end;

procedure DiamLine(c: TCanvas; const x, y, d, e, s: double);
var
  a, Xw, r, tw, sn, cs, dx, dy,
  x1, x2, y1, y2, x3, y3, z: double;
  i, shn: Integer;
  ah: TArrowPts;
  p: TPathData;
  m: TMatrix;
  t: string;
  rc: TRectF;
begin
  t := 'ø' + FloatToStr(RoundTo(s, -1));
  shn := ArrowShape * 4 + ArrowSize;
  tw := c.TextWidth(t);
  r := d * 0.5;
  z := 2 * ArrowShapeWidth + r;
  a := DegToRad(ArrowAngle);
  Xw := e / Tan(a);
  SinCos(a, sn, cs);
  dx := cs * r;
  dy := sn * r;
  x1 := x + dx;
  x2 := x - dx;
  x3 := x - cs * z;
  y1 := y - dy;
  y2 := y + dy;
  y3 := y + sn * z;
  c.DrawLine(PointF(x + Xw + tw, y - e), PointF(x + Xw, y - e), 1);
  c.DrawLine(PointF(x + Xw, y - e), PointF(x3, y3), 1);
  rc.Create(x + Xw, y - (e + c.TextHeight(t)) - 1, x + Xw + tw + 1, y - e);
  c.FillText(rc, t, false, 1, [], TTextAlign.Center);
  p := TPathData.Create;
  try
    m := TMatrix.CreateRotation(ArcTan2(y1 - y2, x1 - x2));
    m.m31 := m.m31 + x1;
    m.m32 := m.m32 + y1;
    MakeArrow(ArrowHeads[shn], ah, false);
    p.MoveTo(ah[0]);
    for i := 1 to 4 do
      p.LineTo(ah[i]);
    p.ApplyMatrix(m);
    c.FillPath(p, 1);
    c.DrawPath(p, 1);
    p.Clear;
    m := TMatrix.CreateRotation(ArcTan2(y2 - y1, x2 - x1));
    m.m31 := m.m31 + x2;
    m.m32 := m.m32 + y2;
    MakeArrow(ArrowHeads[shn], ah, false);
    p.MoveTo(ah[0]);
    for i := 1 to 4 do
      p.LineTo(ah[i]);
    p.ApplyMatrix(m);
    c.FillPath(p, 1);
    c.DrawPath(p, 1);
  finally
    p.Free;
  end;
end;

procedure TFlute.RenderBitmap(bmp: Tbitmap; BitmapScale: Single);
const
  MARGIN = 16.5;
  HDR_H = 40;
  D_MAX = 50;
var
  dh, ft, wmax, r, rl, d, k, x, y, y1, y2, bfw, bfh,
  gx, gy, xc, yc, yt, x0, xh, xt, h, w: double;
  i: integer;
  rc: TRectF;
  s: string;
begin
  case fHolesCount of
    10: dh := 16;
    9: dh := 18;
    8: dh := 20;
    7: dh := 22;
    6: dh := 24;
    else
      dh := 26;
  end;
  bfw := bmp.Width / BitmapScale;
  bfh := bmp.Height / BitmapScale;
  wmax := bfw - 2 * MARGIN;
  x0 := fWindwayLength;
  rl := fToLabLength + x0;
  k := wmax / rl;
  d := fOuterDiameter;
  gx := k * rl;
  gy := k * d;
  if gy > D_MAX then
  begin
    k := D_MAX / d;
    gx := k * rl;
    gy := k * d;
  end;
  x := MARGIN;
  ft := MARGIN + HDR_H;
  bmp.Clear(TAlphaColors.White);
  bmp.Canvas.BeginScene;

  {$IFDEF UseNativeDraw}bmp.Canvas.NativeDraw(RectF(0, 0, bfw, bfh),
  procedure
  var i: Integer;
  begin
  {$ENDIF}
    // draw title
    bmp.Canvas.Fill.Color := TAlphaColors.Black;
    bmp.Canvas.Font.Size := TitleFontSize;
    bmp.Canvas.Font.Style := [TFontStyle.fsBold, TFontStyle.fsItalic];
    s := Format(fCaption, [FreqToNote(fHoles[0].Freq), fHoles[0].Freq]);
    rc.Create(MARGIN - 2, MARGIN - 2, bfw - MARGIN, ft);
    bmp.Canvas.FillText(rc, s, false, 1, [], TTextAlign.Leading, TTextAlign.Leading);

    // draw flute body
    bmp.Canvas.Font.Size := SizesFontSize;
    bmp.Canvas.Font.Style := [];
    bmp.Canvas.Fill.Color := $FFBFBFBF;
    bmp.Canvas.Stroke.Color := TAlphaColors.Black;
    bmp.Canvas.Stroke.Thickness := 1.5;
    rc.Create(x, ft, x + gx, ft + gy);
    bmp.Canvas.FillRect(rc, 0, 0, [], 1);
    bmp.Canvas.DrawRect(rc, 0, 0, [], 1);
    yc := ft + gy * 0.5;
    h := fEmbWidth * 0.5 * k;
    xc := x + x0 * k;

    // draw flute labium
    case fType of
      0:
      begin
        bmp.Canvas.Stroke.Thickness := 1.0;
        bmp.Canvas.DrawArc(PointF(xc + fEmbLength * k, yc), PointF(fEmbLength * k, fEmbWidth * k * 0.5), -90, 180, 1);
        xh := xc + fEmbLength * k;
        y1 := yc - h;
        y2 := yc + h;
        bmp.Canvas.Fill.Color := TAlphaColors.White;
        rc.Create(xc, y1, xh, y2);
        bmp.Canvas.FillRect(rc, 0, 0, [], 1);
        bmp.Canvas.DrawRect(rc, 0, 0, [], 1);
        bmp.Canvas.Stroke.SetCustomDash([3, 3], 1.5);
        bmp.Canvas.Stroke.Thickness := 0.8;
        // windway
        bmp.Canvas.DrawLine(PointF(x, y1), PointF(xc, y1), 1);
        bmp.Canvas.DrawLine(PointF(x, y2), PointF(xc, y2), 1);
      end;

      1:
      begin
        bmp.Canvas.Stroke.Thickness := 1.0;
        xh := xc + fEmbLength * k;
        y1 := yc - h;
        y2 := yc + h;
        r := fEmbLength * k * 0.5;
        rc.Create(xc, yc - r, xc + r * 2, yc + r);
        bmp.Canvas.Fill.Color := TAlphaColors.White;
        bmp.Canvas.FillEllipse(rc, 1);
        bmp.Canvas.DrawEllipse(rc, 1);
      end;

      2:
      begin
        bmp.Canvas.Stroke.Thickness := 1.0;
        xh := xc + fEmbLength * k;
        y1 := yc - h;
        y2 := yc + h;
        bmp.Canvas.Fill.Color := TAlphaColors.White;
        bmp.Canvas.FillArc(PointF(xc, yc), PointF(fEmbLength * k, fEmbWidth * k * 0.5), -90, 180, 1);
        bmp.Canvas.DrawArc(PointF(xc, yc), PointF(fEmbLength * k, fEmbWidth * k * 0.5), -90, 180, 1);
      end;
    end;

    // draw finger holes
    bmp.Canvas.Stroke.SetCustomDash([], 0);
    bmp.Canvas.Stroke.Thickness := 1.0;
    bmp.Canvas.Fill.Color := TAlphaColors.White;

    for i := 1 to fHolesCount do
    begin
      if not fHoles[i].Enabled then
        continue;
      r := fHoles[i].Diam * 0.5 * k;
      xt := x + k * (rl - fHoles[i].Dist);
      rc.Create(xt - r, yc - r, xt + r, yc + r);
      bmp.Canvas.FillEllipse(rc, 1);
      bmp.Canvas.DrawEllipse(rc, 1);
    end;

    // draw emb length size lines
    bmp.Canvas.Stroke.Thickness := 0.8;
    case fType of
      0:
      begin
        bmp.Canvas.DrawLine(PointF(xh, y1), PointF(xh + 25, y1), 1);
        bmp.Canvas.DrawLine(PointF(xh, y2), PointF(xh + 25, y2), 1);
      end;
      2:
      begin
        bmp.Canvas.DrawLine(PointF(xc, y1), PointF(xh + 25, y1), 1);
        bmp.Canvas.DrawLine(PointF(xc, y2), PointF(xh + 25, y2), 1);
      end;
    end;

    // draw diam & emb width
    bmp.Canvas.Fill.Color := TAlphaColors.Black;
    case fType of
      0, 2:
      begin
        VSizeLine(bmp.Canvas, xh + 20, y1, y2, fEmbWidth, ft + gy - y2, true, false);
        VSizeLine(bmp.Canvas, xh + 40, ft, ft + gy, fOuterDiameter, 0, true, true);
         yt := (yc + y2) * 0.5 - yc;
        ThinLine(bmp.Canvas, xh + 60, yc - yt, gy * 0.5 + 8 - yt, fWallThickness);
      end;
      1:
      begin
        VSizeLine(bmp.Canvas, xh + 65, ft, ft + gy, 0, fOuterDiameter, true);
        yt := (yc + y2) * 0.5 - yc;
        ThinLine(bmp.Canvas, xh + 80, yc - yt, gy * 0.5 + 8 - yt, fWallThickness);
      end;
    end;

    // draw holes diametrs
    y := ft + gy + 0.5;
    for i := 1 to fHolesCount do
    begin
      if not fHoles[i].Enabled then
        continue;
      y := y + dh;
      xh := x + k * (rl - fHoles[i].Dist);
      HSizeLine(bmp.Canvas, xh, x + gx, y, fHoles[i].Dist);
      bmp.Canvas.DrawLine(PointF(xh, y + 4), PointF(xh, ft + gy * 0.5), 1);
      DiamLine(bmp.Canvas, xh, yc, fHoles[i].Diam * k, gy * 0.5 + 8, fHoles[i].Diam);
    end;

    if y < 132.5 then
      y := 132.5;
    // draw emb length
    xh := xc + fEmbLength * k;
    case fType of
      0:
      begin
        HSizeLine(bmp.Canvas, xc, xh, y, fEmbLength, true);
        bmp.Canvas.DrawLine(PointF(xh, y + 4), PointF(xh, y1), 1);
      end;
      2:
      begin
        HSizeLine(bmp.Canvas, xc, xh, y, fEmbLength, true);
        bmp.Canvas.DrawLine(PointF(xh, y + 4), PointF(xh, y1), 1);
      end;
    end;

    y := y + dh;
    case fType of
      0:
      begin
        if rl <> fToLabLength then
        begin
          HSizeLine(bmp.Canvas, xc, x + gx, y, fToLabLength);
          bmp.Canvas.DrawLine(PointF(xc, y + 4), PointF(xc, y1), 1);
          y := y + dh;
        end;
      end;
      1:
      begin
        if rl <> fToLabLength then
        begin
          r := fEmbLength * k * 0.5;
          HSizeLine(bmp.Canvas, xc + r, x + gx, y, fToLabLength - fEmbLength * 0.5);
          bmp.Canvas.DrawLine(PointF(xc + r, y + 4), PointF(xc + r, yc), 1);
          DiamLine(bmp.Canvas, xc + r, yc, fEmbLength * k, gy * 0.5 + 8, fEmbLength);
          y := y + dh;
        end;
      end;
    end;

    // main size lines
    bmp.Canvas.DrawLine(PointF(x, ft), PointF(x, y + 4), 1);
    bmp.Canvas.DrawLine(PointF(x + gx, ft), PointF(x + gx, y + 4), 1);
    HSizeLine(bmp.Canvas, x, x + gx, y, rl);

    // draw foother
    bmp.Canvas.Fill.Color := TAlphaColors.Black;
    bmp.Canvas.Font.Size := FootherFontSize;
    bmp.Canvas.Font.Style := [];
    s := 'FlutoMAX Flute Designer Lite 2.0';
    rc.Create(MARGIN, bfh - MARGIN + 2, bfw - MARGIN, bfh - 2);
    bmp.Canvas.FillText(rc, s, false, 1, [], TTextAlign.Trailing, TTextAlign.Center);
    {$IFDEF UseNativeDraw}
  end);
  {$ENDIF}
  // finish
  bmp.Canvas.EndScene;
end;

initialization
  BuildArrowsHeads;


end.

