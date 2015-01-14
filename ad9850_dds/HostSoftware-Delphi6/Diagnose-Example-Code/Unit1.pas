unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, LibUSB, ComCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button4: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ListBox1: TListBox;
    StatusBar1: TStatusBar;
    Button2: TButton;
    E0: TEdit;
    E1: TEdit;
    E2: TEdit;
    E3: TEdit;
    E4: TEdit;
    ELen: TEdit;
    E7: TEdit;
    E6: TEdit;
    E5: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Button3: TButton;
    Edit4: TEdit;
    Label6: TLabel;
    LBusy: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

type
 TPString = array [0..255] of Char;

const
USBDEV_SHARED_VENDOR  =  $16C0;  (* VOTI *)
USBDEV_SHARED_PRODUCT =  $05DC;  (* Obdev's free shared PID *)
(* Use obdev's generic shared VID/PID pair and follow the rules outlined
 * in firmware/usbdrv/USBID-License.txt.
 *)

(* Command declarations *)
PSCMD_ECHO = 0;
PSCMD_GET  = 1;
PSCMD_ON   = 2;
PSCMD_OFF  = 3;
DDS_TEST   = 4;


{$R *.dfm}

procedure usb_showinfo;

  procedure print_endpoint(endpoint: usb_endpoint_descriptor);
  begin
    Form1.ListBox1.AddItem('      bEndpointAddress: '+ IntToHex(endpoint.bEndpointAddress,2)+ 'h',nil);
    Form1.ListBox1.AddItem('      bEndpointAddress: '+ IntToHex(endpoint.bEndpointAddress,2)+ 'h',nil);
    Form1.ListBox1.AddItem('      bmAttributes:     '+ IntToHex(endpoint.bmAttributes, 2)+ 'h',nil);
    Form1.ListBox1.AddItem('      wMaxPacketSize:   '+ IntToStr(endpoint.wMaxPacketSize),nil);
    Form1.ListBox1.AddItem('      bInterval:        '+ IntToStr(Cardinal(endpoint.bInterval)),nil);
    Form1.ListBox1.AddItem('      bRefresh:         '+ IntToStr(Cardinal(endpoint.bRefresh)),nil);
    Form1.ListBox1.AddItem('      bSynchAddress:    '+ IntToStr(Cardinal(endpoint.bSynchAddress)),nil);
  end;

  procedure print_altsetting(iinterface: usb_interface_descriptor);
  var
    I: integer;
  begin
    Form1.ListBox1.AddItem('    bInterfaceNumber:   '+ IntToStr(Cardinal(iinterface.bInterfaceNumber)),nil);
    Form1.ListBox1.AddItem('    bAlternateSetting:  '+ IntToStr(Cardinal(iinterface.bAlternateSetting)),nil);
    Form1.ListBox1.AddItem('    bNumEndpoints:      '+ IntToStr(Cardinal(iinterface.bNumEndpoints)),nil);
    Form1.ListBox1.AddItem('    bInterfaceClass:    '+ IntToStr(Cardinal(iinterface.bInterfaceClass)),nil);
    Form1.ListBox1.AddItem('    bInterfaceSubClass: '+ IntToStr(Cardinal(iinterface.bInterfaceSubClass)),nil);
    Form1.ListBox1.AddItem('    bInterfaceProtocol: '+ IntToStr(Cardinal(iinterface.bInterfaceProtocol)),nil);
    Form1.ListBox1.AddItem('    iInterface:         '+ IntToStr(Cardinal(iinterface.iInterface)),nil);

    for I := 0 to iinterface.bNumEndpoints-1 do
      begin
        print_endpoint(iinterface.endpoint[I]);
      end;
  end;

  procedure print_interface(iinterface: usb_interface);
  var
    I: integer;
  begin
    for I := 0 to iinterface.num_altsetting-1 do
      begin
        print_altsetting(iinterface.altsetting[I]);
      end;
  end;

  procedure print_configuration(config: usb_config_descriptor);
  var
    I: integer;
  begin
    Form1.ListBox1.AddItem('  wTotalLength:         '+ inttostr(config.wTotalLength),nil);
    Form1.ListBox1.AddItem('  bNumInterfaces:       '+ inttostr(cardinal(config.bNumInterfaces)),nil);
    Form1.ListBox1.AddItem('  bConfigurationValue:  '+ inttostr(cardinal(config.bConfigurationValue)),nil);
    Form1.ListBox1.AddItem('  iConfiguration:       '+ inttostr(cardinal(config.iConfiguration)),nil);
    Form1.ListBox1.AddItem('  bmAttributes:         '+ IntToHex(config.bmAttributes, 2)+ 'h',nil);
    Form1.ListBox1.AddItem('  MaxPower:             '+ inttostr(cardinal(config.MaxPower)),nil);

  for I := 0 to config.bNumInterfaces-1 do
    begin
      print_interface(config.iinterface[I]);
    end;
  end;

var
  bus: pusb_bus;
  dev: pusb_device;
  udev: pusb_dev_handle;
  ret,
  I: integer;
  S: array [0..255] of char;
begin
  usb_init; // Initialize libusb


  usb_find_busses; // Finds all USB busses on system
  usb_find_devices; // Find all devices on all USB devices
  bus := usb_get_busses; // Return the list of USB busses found
  Form1.ListBox1.AddItem('bus/device  idVendor/idProduct',nil);
  while Assigned(bus) do
    begin
      dev := bus^.devices;
      while Assigned(dev) do
        begin
          Form1.ListBox1.AddItem(
                  string(bus^.dirname)+ '/'+string( dev^.filename)+
                  '     '+
                  '0x' + IntToHex(dev^.descriptor.idVendor, 4)+
                  '/'+
                  '0x' + IntToHex(dev^.descriptor.idProduct, 4),nil);


          udev := usb_open(dev);
          if Assigned(udev) then
            begin
              if dev^.descriptor.iManufacturer > 0 then
                begin
                  ret := usb_get_string_simple(udev, dev^.descriptor.iManufacturer, S, sizeof(S));
                  if (ret > 0) then
                    begin
                      Form1.ListBox1.AddItem('- Manufacturer : '+ S,nil);
                    end
                    else
                    begin
                      Form1.ListBox1.AddItem('- Unable to fetch manufacturer string',nil);
                    end;
                end;

              if (dev^.descriptor.iProduct > 0) then
                begin
                  ret := usb_get_string_simple(udev, dev^.descriptor.iProduct, S, sizeof(S));
                  if (ret > 0) then
                    begin
                      Form1.ListBox1.AddItem('- Product      : '+ S,nil);
                    end
                    else
                    begin
                      Form1.ListBox1.AddItem('- Unable to fetch product string',nil);
                    end;
                end;

              if (dev^.descriptor.iSerialNumber > 0) then
                begin
                  ret := usb_get_string_simple(udev, dev^.descriptor.iSerialNumber, S, sizeof(S));
                  if (ret > 0) then
                    begin
                      Form1.ListBox1.AddItem('- Serial Number: '+ S,nil);
                    end
                    else
                    begin
                      Form1.ListBox1.AddItem('- Unable to fetch serial number string',nil);
                    end;
                end;

              usb_close(udev);
            end;

          if not assigned(dev^.config) then
            begin
              Form1.ListBox1.AddItem('  Couldn''t retrieve descriptors',nil);
              continue;
            end;

          for I := 0 to dev^.descriptor.bNumConfigurations-1 do
            begin
              print_configuration(dev^.config[i]);
            end;

          dev := dev^.next;
        end;

      bus := bus^.next;
    end;
end;

//////////////////////////////////////////////////////////////

function usbGetStringAscii(handle: pusb_dev_handle; index: Integer;langid: Integer;var buf: TPString;buflen: Integer ): integer;
var
 buffer: array [0..255] of char;
 rval, i: Integer;
begin
    rval := usb_control_msg(handle, USB_ENDPOINT_IN, USB_REQ_GET_DESCRIPTOR, (USB_DT_STRING shl 8) + index, langid, buffer, sizeof(buffer), 1000);
    result:=rval;
    if rval < 0 then exit;
    result:=0;
    if buffer[1] <> char(USB_DT_STRING) then Exit;
    if BYTE(buffer[0]) < rval then
        rval := BYTE(buffer[0]);

    rval:= rval div 2;
    (* lossy conversion to ISO Latin1 *)
    for i := 1 to rval-1 do
      begin
        if i > buflen then  (* destination buffer overflow *)
            break;
        buf[i-1] := buffer[2 * i];
        if buffer[2 * i + 1] <> #0 then (* outside of ISO Latin1 range *)
            buf[i-1] := char('?');
      end;
    buf[i-1] := #0;
    Result := i-1;
end;

(* DDS uses the free shared default VID/PID. If you want to see an
 * example device lookup where an individually reserved PID is used, see our
 * RemoteSensor reference implementation.
 *)

const
  USB_ERROR_NOTFOUND = 1;
  USB_ERROR_ACCESS   = 2;
  USB_ERROR_IO       = 3;


function usbOpenDevice(var device: Pusb_dev_handle; vendor: Integer; vendorName: pchar ;product: Integer; productName: pchar):  Integer;
const
{$J+}
   didUsbInit: integer = 0; //not a true constant but a static variable
{$J-}
var
  bus: Pusb_bus;
  dev: Pusb_device;
  handle: Pusb_dev_handle;
  errorCode: integer;
  S: TPstring;
  len: Integer;
begin
handle:=nil;
errorCode := USB_ERROR_NOTFOUND;
    if didUsbInit=0 then
      begin
        didUsbInit := 1;
        usb_init;
      end;
    usb_find_busses;
    usb_find_devices;
    bus := usb_get_busses;
    While assigned(bus) do
      begin
        dev := bus^.devices;
        while assigned(dev) do
          begin
            if(dev.descriptor.idVendor = vendor) and (dev.descriptor.idProduct = product) then
              begin
                handle := usb_open(dev); (* we need to open the device in order to query strings *)
                if not assigned(handle) then
                  begin
                    errorCode := USB_ERROR_ACCESS;
                    raise Exception.Create('Warning: cannot open USB device '+usb_strerror());
                    continue;
                  end;
                if (vendorName = nil) and (productName = nil) then break; (* name does not matter *)
                (* now check whether the names match: *)
                len := usbGetStringAscii(handle, dev.descriptor.iManufacturer, $0409,S, sizeof(S));
                if (len < 0) then
                  begin
                    errorCode := USB_ERROR_IO;
                    raise Exception.Create('Warning: cannot query manufacturer for device: '+usb_strerror());
                  end
                 else
                  begin
                    errorCode := USB_ERROR_NOTFOUND;
                    (* fprintf(stderr, "seen device from vendor ->%s<-\n", string); *)
                    if StrPas(S)=vendorName then
                      begin
                        len := usbGetStringAscii(handle, dev.descriptor.iProduct, $0409,S, sizeof(S));
                        if (len < 0) then
                          begin
                            errorCode := USB_ERROR_IO;
                            raise Exception.Create('Warning: cannot query product for device: '+usb_strerror());
                          end
                         else
                          begin
                            errorCode := USB_ERROR_NOTFOUND;
                            (* fprintf(stderr, "seen product ->%s<-\n", string); *)
                            if StrPas(S)=productName then
                                break;
                          end;  //if len
                      end; //if string_
                  end;  //if len<0
                usb_close(handle);
                handle := nil;
              end;  //if dev descriptor
            dev := dev.next;
          end;  //while assigned(dev)
        if handle<>nil then break;
        bus := bus.next;
      end;  //while assigned(bus)
    if (handle <> nil) then
      begin
        errorCode := 0;
        device := handle;
      end;
Result := errorCode;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
ListBox1.Clear;
usb_showinfo;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  handle: Pusb_dev_handle;
  buffer: array[0..3] of char;
  request, value, index: integer;
  retval: string;
  i: integer;
begin
buffer[0]:=#0;
buffer[1]:=#0;
buffer[2]:=#0;
request:=strtoint('$'+Edit1.Text);
value:=strtoint('$'+edit2.Text);
index:=strtoint('$'+edit3.Text);
usb_init();
if (usbOpenDevice(handle, USBDEV_SHARED_VENDOR, 'www.obdev.at', USBDEV_SHARED_PRODUCT, 'DG8SAQ-DDS') <> 0) then
  begin
    raise Exception.Create(Format(
       'Could not find USB device "DG8SAQ-DDS" with vid=$%x and pid=$%x !',
          [USBDEV_SHARED_VENDOR, USBDEV_SHARED_PRODUCT]));
        exit;
    end;
value:=usb_control_msg(handle, USB_TYPE_VENDOR or USB_RECIP_DEVICE or USB_ENDPOINT_IN, request, value, index, buffer, sizeof(buffer), 5000);
usb_close(handle);
retval:='';
Label3.Caption:='USB transfer return value = '
                +inttoHex(BYTE(buffer[0])+256*BYTE(buffer[1])+256*256*BYTE(buffer[2]),2)+' Hex';
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
Label3.Caption:='USB transfer return value = ';
E0.Text:='02';
E1.Text:='00';
E2.Text:='00';
E3.Text:='00';
E4.Text:='00';
E5.Text:='00';
E6.Text:='00';
E7.Text:='00';
Elen.Text:='01';

end;

procedure TForm1.Button2Click(Sender: TObject);
var
  handle: Pusb_dev_handle;
  buffer: array[0..7] of char;
  request, value, index,len: integer;
begin
buffer[0]:=char(strtoint('$'+E0.Text));
buffer[1]:=char(strtoint('$'+E1.Text));
buffer[2]:=char(strtoint('$'+E2.Text));
buffer[3]:=char(strtoint('$'+E3.Text));
buffer[4]:=char(strtoint('$'+E4.Text));
buffer[5]:=char(strtoint('$'+E5.Text));
buffer[6]:=char(strtoint('$'+E6.Text));
buffer[7]:=char(strtoint('$'+E7.Text));
len:=strtoint('$'+Elen.Text);
request:=strtoint('$'+Edit1.Text);
value:=strtoint('$'+edit2.Text);
index:=strtoint('$'+edit3.Text);
usb_init();
if (usbOpenDevice(handle, USBDEV_SHARED_VENDOR, 'www.obdev.at', USBDEV_SHARED_PRODUCT, 'DG8SAQ-DDS') <> 0) then
  begin
    raise Exception.Create(Format(
       'Could not find USB device "DG8SAQ-DDS" with vid=$%x and pid=$%x !',
          [USBDEV_SHARED_VENDOR, USBDEV_SHARED_PRODUCT]));
        exit;
    end;
value:=usb_control_msg(handle, USB_TYPE_VENDOR or USB_RECIP_DEVICE or USB_ENDPOINT_OUT, request, value, index, buffer, len, 5000);
usb_close(handle);
Label3.Caption:='USB transfer return value = '+inttoHex(BYTE(buffer[0])+256*BYTE(buffer[1]),2)+' Hex';
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  handle: Pusb_dev_handle;
  buffer: array[0..1] of char;
  request, value, index, i, n: integer;
begin
LBusy.Caption:='busy';
form1.repaint;
n:=strtoint(Edit4.Text);
form1.Enabled:=false;
buffer[0]:=#5;
buffer[1]:=#5;
request:=strtoint('$'+Edit1.Text);
value:=strtoint('$'+edit2.Text);
index:=strtoint('$'+edit3.Text);
usb_init();
if (usbOpenDevice(handle, USBDEV_SHARED_VENDOR, 'www.obdev.at', USBDEV_SHARED_PRODUCT, 'DG8SAQ-DDS') <> 0) then
  begin
    raise Exception.Create(Format(
       'Could not find USB device "DG8SAQ-DDS" with vid=$%x and pid=$%x !',
          [USBDEV_SHARED_VENDOR, USBDEV_SHARED_PRODUCT]));
        exit;
    end;
for i:=1 to n do
  begin
    usb_control_msg(handle, USB_TYPE_VENDOR or USB_RECIP_DEVICE or USB_ENDPOINT_IN, request, value, index, buffer, sizeof(buffer), 5000);
    value:=not value;
  end;
usb_close(handle);
Label3.Caption:='USB transfer return value = '+inttoHex(BYTE(buffer[0])+256*BYTE(buffer[1]),2)+' Hex';
form1.Enabled:=true;
LBusy.Caption:='done';
end;

end.
