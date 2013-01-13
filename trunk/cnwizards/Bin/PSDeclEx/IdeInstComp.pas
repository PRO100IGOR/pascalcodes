{******************************************************************************}
{                       CnPack For Delphi/C++Builder                           }
{                     �й����Լ��Ŀ���Դ�������������                         }
{                   (C)Copyright 2001-2011 CnPack ������                       }
{                   ------------------------------------                       }
{                                                                              }
{            ���������ǿ�Դ��������������������� CnPack �ķ���Э������        }
{        �ĺ����·�����һ����                                                }
{                                                                              }
{            ������һ��������Ŀ����ϣ�������ã���û���κε���������û��        }
{        �ʺ��ض�Ŀ�Ķ������ĵ���������ϸ���������� CnPack ����Э�顣        }
{                                                                              }
{            ��Ӧ���Ѿ��Ϳ�����һ���յ�һ�� CnPack ����Э��ĸ��������        }
{        ��û�У��ɷ������ǵ���վ��                                            }
{                                                                              }
{            ��վ��ַ��http://www.cnpack.org                                   }
{            �����ʼ���master@cnpack.org                                       }
{                                                                              }
{******************************************************************************}

unit IdeInstComp;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��ڽű���ʹ�õ� IdeInstComp ��Ԫ����
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע��
* ����ƽ̨��PWinXP SP2 + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7
* �� �� ����
* ��Ԫ��ʶ��$Id: IdeInstComp.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2006.12.30 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

{$R-,H+,X+}

// ���ű��� uses �б���ָ���� IdeInstComp ʱ���ű�����ʹ���� IDE �а�װ�����������
// ����û���� PSDecl Ŀ¼�µ������ļ����г��������ֻ�ܷ����� published �����ԡ�

// ����û���ر������ĵ�Ԫ�� Windows, Classes������Ҫ uses ����ʹ�������������ݣ�
// ������� uses ���ǣ��� IDE ����༭���б༭�ű�ʱ������ʹ�� IDE �Ĵ����Զ���ɡ�
// ���� IdeInstComp ֱ�ӵ��룬����Ϊ�� IDE ��װ�˺ܶ��ʱ��������ٶȿ��ܽ���

{ Example:

program Test;

uses
  Windows, SysUtils, IdeInstComp; // uses IdeInstComp is needed.

var
  DB: TDataBase;    // TDataBase is not imported by script engine expressly.
  Timer: TCnTimer;  // TCnTimer is a 3rd component (in CnPack) installed in IDE.

begin
  DB := TDataBase.Create(nil);
  try
    DB.AliasName := 'Test';  // You can access published properties only!!!
  finally
    DB.Free;
  end;

  Timer := TCnTimer.Create(nil);
  try
    Timer.Enabled := True;
  finally
    Timer.Free;
  end;
end.

}

interface

implementation

end.
