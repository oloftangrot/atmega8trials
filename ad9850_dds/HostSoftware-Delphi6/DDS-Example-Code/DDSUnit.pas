(* DDS Controller Demo by Tom Baier DG8SAQ
 * Copyright (c) 2007 Tom Baier <dg8saq@darc.de>
 * LIBUSB-WIN32, Generic Windows USB Library
 * Copyright (c) 2002-2004 Stephan Meyer <ste_meyer@web.de>
 * Copyright (c) 2000-2004 Johannes Erdfelt <johannes@erdfelt.com>
 *
 * LIBUSB-WIN32 translation
 * Copyright (c) 2004 Yvo Nelemans <ynlmns@xs4all.nl>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *)


unit DDSUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, LibUSB, StdCtrls, ComCtrls, Math;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    ListBox1: TListBox;
    Label2: TLabel;
    Button7: TButton;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Button8: TButton;
    Label6: TLabel;
    procedure Edit1Exit(Sender: TObject);
    procedure SetDDS();
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure Button8Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  mult: array[0..2] of double=(1,1e3,1e6);
  lpt1: integer=$378;

var
  Form1: TForm1;
  freq:  double=0;
  phase: Byte=0;    {9850:0 9851:1 for clock*6}
  clock: double=160000000;

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


procedure SendUSBControlMessage(direction: BYTE; request, value, index, buflen: integer;var buffer: array of char);
var
  handle: Pusb_dev_handle;
  i: integer;
begin
usb_init();
if (usbOpenDevice(handle, USBDEV_SHARED_VENDOR, 'www.obdev.at', USBDEV_SHARED_PRODUCT, 'DG8SAQ-DDS') <> 0) then
  begin
    raise Exception.Create(Format(
       'Could not find USB device "DG8SAQ-DDS" with vid=$%x and pid=$%x !',
          [USBDEV_SHARED_VENDOR, USBDEV_SHARED_PRODUCT]));
        exit;
    end;
usb_control_msg(handle, USB_TYPE_VENDOR or USB_RECIP_DEVICE or direction, request, value, index, buffer, sizeof(buffer), 5000);
usb_close(handle);
end;

const
//data directions
USB2PC = USB_ENDPOINT_IN;   //use this if you expect to receive data from the USB device
PC2USB = USB_ENDPOINT_OUT;  //use this for SEND_DDS

//commands
ECHO = 0;       //echo value
DDR  = 1;       //set AVR port direction registers
                //value LO = DDRA
                //value HI = DDRB
                //index LO = DDRD
READ_PINS = 2;  //read AVR PINA, PINB, PIND registers
READ_PORTS = 3; //read AVR PORTA, PORTB, PORTC registers
WRITE_PORTS = 4;//set AVR ports
                //value LO = PORTA
                //value HI = PORTB
                //index LO = PORTD
SEND_DDS    = 5;//send data to DDS
UPDATE_DDS  = 6;//update DDS data

//////////////////////end of USB setup and diagnosis////////////////////////////////////////



procedure TForm1.SetDDS;
var
   data: array [0..4] of char;
   dds: cardinal absolute data;
begin
 dds:=Round(Power(2,32)*freq/clock);    //DDS FTW
 data[4]:=#0;                           //DDS phase and multiplier info
                                        //needed one chunk transmission only
// send data in one chunk like this:
// SendUSBControlMessage(PC2USB,SEND_DDS, UPDATE_DDS, 0, 5, data);

// send data in two chunks like this:
SendUSBControlMessage(PC2USB,SEND_DDS, 0         , 0, 4, data); // first send 4 bytes DDS FTW
data[0]:=#0; //then send DDS phase and multiplier info byte next + update DDS
SendUSBControlMessage(PC2USB,SEND_DDS, UPDATE_DDS, 0, 1, data);
end;

procedure TForm1.Edit1Exit(Sender: TObject);
begin
  try
    freq:=StrToFloat(Edit1.Text)*mult[ComboBox1.ItemIndex];
    Label1.Caption:='f = '+FloatToStr(freq)+' Hz';
    SetDDS;
  except
    on E: EConvertError do
         begin
         Edit1.SetFocus;
         beep;
         end;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
freq:=(StrToFloat(Edit1.Text)*mult[ComboBox1.ItemIndex]+1000000)/mult[ComboBox1.ItemIndex];
Edit1.Text:=FloatToStr(freq);
Form1.Edit1Exit(Sender);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
freq:=(StrToFloat(Edit1.Text)*mult[ComboBox1.ItemIndex]-1000000)/mult[ComboBox1.ItemIndex];
if (freq < 0) then freq:=0;
Edit1.Text:=FloatToStr(freq);
Form1.Edit1Exit(Sender);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
freq:=(StrToFloat(Edit1.Text)*mult[ComboBox1.ItemIndex]+1000)/mult[ComboBox1.ItemIndex];
Edit1.Text:=FloatToStr(freq);
Form1.Edit1Exit(Sender);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
freq:=(StrToFloat(Edit1.Text)*mult[ComboBox1.ItemIndex]-1000)/mult[ComboBox1.ItemIndex];
if (freq < 0) then freq:=0;
Edit1.Text:=FloatToStr(freq);
Form1.Edit1Exit(Sender);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
freq:=(StrToFloat(Edit1.Text)*mult[ComboBox1.ItemIndex]+1)/mult[ComboBox1.ItemIndex];
Edit1.Text:=FloatToStr(freq);
Form1.Edit1Exit(Sender);
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
freq:=(StrToFloat(Edit1.Text)*mult[ComboBox1.ItemIndex]-1)/mult[ComboBox1.ItemIndex];
if (freq < 0) then freq:=0;
Edit1.Text:=FloatToStr(freq);
Form1.Edit1Exit(Sender);
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
var f: double;
begin
f:=freq/mult[ComboBox1.ItemIndex];
Edit1.Text:=FloatToStr(f);
Form1.Edit1Exit(Sender);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
ListBox1.Clear;
usb_showinfo;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
FormCreate(self);
end;

procedure TForm1.Edit2Exit(Sender: TObject);
begin
  try
    clock:=StrToFloat(Edit2.Text)*1e6;
    SetDDS;
  except
    on E: EConvertError do
         begin
         Edit2.SetFocus;
         beep;
         end;
  end;
end;

procedure TForm1.Button8Click(Sender: TObject);
var
   data: array [0..2] of char; //AVR sends back max 3 bytes
begin
SendUSBControlMessage(USB2PC,ECHO, $1234, 0, 0, data);
Label6.Caption:='Received WORD = '+inttohex(BYTE(data[0])+256*BYTE(data[1]),2);
end;

end.
