program DDS;

uses
  Forms,
  Dialogs,
  SysUtils,
  DDSUnit in 'DDSUnit.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  DecimalSeparator:='.';
  Application.CreateForm(TForm1, Form1);
  Try Form1.SetDDS except MessageDlg('Could not find USB device "DG8SAQ-DDS"',
                mtInformation,[mbOk], 0) end;
  Application.Run;
end.
