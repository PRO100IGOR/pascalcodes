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

unit CnCodeFormatRules;
{* |<PRE>
================================================================================
* ������ƣ�CnPack �����ʽ��ר��
* ��Ԫ���ƣ������ʽ������
* ��Ԫ���ߣ�CnPack������
* ��    ע���õ�Ԫʵ�ִ����ʽ������
* ����ƽ̨��Win2003 + Delphi 5.0
* ���ݲ��ԣ�not test yet
* �� �� ����not test hell
* ��Ԫ��ʶ��$Id: CnCodeFormatRules.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2003.12.16 V0.1
*               ������Ŀǰ���� �����ո�����������ǰ��ո������ؼ��ִ�Сд �����á�
                ������δʵ�֡�
================================================================================
|</PRE>}

interface

type
  TCnCodeStyle = (fsNone);

  TKeywordStyle = (ksLowerCaseKeyword, ksUpperCaseKeyword, ksPascalKeyword);

  TCnCodeStyles = set of TCnCodeStyle;

  TCnPascalCodeFormatRule = record
    ContinueAfterError: Boolean;
    CodeStyle: TCnCodeStyles;
    KeywordStyle: TKeywordStyle;
    TabSpaceCount: Byte;
    SpaceBeforeOperator: Byte;
    SpaceAfterOperator: Byte;
    SpaceBeforeASM: Byte;
    SpaceTabASMKeyword: Byte;
    WrapWidth: Integer;
  end;

const
  CnPascalCodeForVCLRule: TCnPascalCodeFormatRule =
  (
    ContinueAfterError: False;
    CodeStyle: [];
    KeywordStyle: ksLowerCaseKeyword;
    TabSpaceCount: 2;
    SpaceBeforeOperator: 1;
    SpaceAfterOperator: 1;
    SpaceBeforeASM: 8;
    SpaceTabASMKeyword: 8;
    WrapWidth: 80;
  );

var
  CnPascalCodeForRule: TCnPascalCodeFormatRule;

implementation

initialization
  // Default Setting
  CnPascalCodeForRule := CnPascalCodeForVCLRule;

end.
