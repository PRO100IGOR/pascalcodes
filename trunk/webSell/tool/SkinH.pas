//*******************************************************************************
// NOTES
// ---------------
// This is a part of the SkinSharp(Skin#) Library
// Copyright (C) 2009 http://www.skinsharp.com
// All rights reserved.
//*******************************************************************************

unit SkinH;

interface

uses
  Windows;

const
  SkinH_DLL = 'SkinH_DL.dll';

{
	 	����:	���س���ǰĿ¼�µ��ļ���skinh.sheƤ�����л���
	 	����ֵ:	�ɹ�����0, ʧ�ܷ��ط�0
}
function SkinH_Attach: Integer; stdcall; external SkinH_DLL;

{
		����:	����ָ��·����Ƥ�����л���
    ����:
          strSkinFile,	//Ƥ���ļ�·��
					strPassword		//Ƥ����Կ

		����ֵ: �ɹ�����0, ʧ�ܷ��ط�0
}
function SkinH_AttachEx(strSkin,strPwd:PChar):Integer; stdcall; external SkinH_DLL;

{
    ����:	����ָ��·����Ƥ�����л�����ָ����Ӧ��ɫ�������Ͷȣ�����,�ɹ�����0,ʧ�ܷ��ط�0
    ����:
          strSkin,       //Ƥ���ļ�·��
          strPwd,        //Ƥ����Կ
          nHue,          //ɫ����  ȡֵ��Χ-180-180,Ĭ��ֵ0
          nSat,          //���Ͷȣ�ȡֵ��Χ-100-100,Ĭ��ֵ0
          nBri           //���ȣ�  ȡֵ��Χ-100-100,Ĭ��ֵ0
          
    ����ֵ: �ɹ�����0, ʧ�ܷ��ط�0
}
function SkinH_AttachExt(strSkin,strPwd:PChar; nHue:Integer=0; nSat:Integer=0; nBri:Integer=0):Integer; stdcall; external SkinH_DLL;

{
		����:	����ָ����Դ���л�����ָ����Ӧ��ɫ�������Ͷȣ�����
    ����:
						pShe,			  //��ԴƤ������ָ��
            dwSize,			//��ԴƤ�����ݳ���
            strPassword,//Ƥ����Կ
            nHue,				//ɫ����	ȡֵ��Χ-180-180, Ĭ��ֵ0
            nSat,				//���Ͷȣ�ȡֵ��Χ-100-100, Ĭ��ֵ0
            nBri				//���ȣ�	ȡֵ��Χ-100-100, Ĭ��ֵ0

    ����ֵ: �ɹ�����0, ʧ�ܷ��ط�0
}
function SkinH_AttachRes(pShe:Byte; nSize:Integer; strPwd:PChar; nHue:Integer=0; nSat:Integer=0; nBri:Integer=0):Integer; stdcall; external SkinH_DLL;

{
		����:	ж�ػ���
		����ֵ: �ɹ�����0, ʧ�ܷ��ط�0
}
function SkinH_Detach:Integer; stdcall; external SkinH_DLL;

{
		����:	ж��ָ������Ĵ�����߿ؼ���Ƥ��
    ����:
          hWnd				//ָ��ж��Ƥ���Ĵ����ؼ��ľ��

		����ֵ: �ɹ�����0, ʧ�ܷ��ط�0
}
function SkinH_DetachEx(hWnd:HWND):Integer; stdcall; external SkinH_DLL;

{
		����:	����ָ�������͸����

    ����:
          hWnd,				//����ľ��
          nAlpha			//͸����

    ����ֵ: �ɹ�����0, ʧ�ܷ��ط�0
}
function SkinH_SetWindowAlpha(hWnd:HWND; nAlpha:Integer):Integer; stdcall; external SkinH_DLL;

{
		����:	���ò˵�͸����
		����:
    			nAlpha				//�˵�͸���ȣ�ȡֵ��Χ 0 - 255

    ����ֵ: �ɹ�����0, ʧ�ܷ��ط�0
}
function SkinH_SetMenuAlpha(nAlpha:Integer):Integer; stdcall; external SkinH_DLL;

{
		����:	��ȡָ�����ڻ�ؼ���nX,nY������ɫֵ
		����:
          hWnd,				//ָ�������ؼ��ľ��
					nX,					//������
					nY					//������

    ����ֵ: �ɹ�����0, ʧ�ܷ��ط�0
}
function SkinH_GetColor(hWnd:HWND; nPosX,nPosY:Integer):TColorRef; stdcall; external SkinH_DLL;

{
		����:	������ǰƤ����ɫ�������Ͷȣ�����
		����:
          nHue,				//ɫ����	ȡֵ��Χ0-360, Ĭ��ֵ0
					nSat,				//���Ͷȣ�	ȡֵ��Χ0-256, Ĭ��ֵ0
					nBri				//���ȣ�	ȡֵ��Χ0-256, Ĭ��ֵ0

    ����ֵ: �ɹ�����0, ʧ�ܷ��ط�0
}
function SkinH_AdjustHSV(nHue,nSat,nBri:Integer):Integer; stdcall; external SkinH_DLL;

{
		����:	ָ������Ϳؼ��Ļ�������
    ����:
          hWnd,				//ָ�������ؼ��ľ��
          nType				//��������

    ����ֵ: �ɹ�����0, ʧ�ܷ��ط�0
}
function SkinH_Map(hWnd:HWND;nType:Integer):Integer; stdcall; external SkinH_DLL;

{
		����:	�������������б�ؼ�����ʱ���ظ�����Ӱ��ִ��Ч������
		����:
          hWnd,				//ָ�������ؼ��ľ��
					bUpdate		  //1Ϊ�������ƣ�0Ϊ��������

    ����ֵ: �ɹ�����0, ʧ�ܷ��ط�0
}
function SkinH_LockUpdate(hWnd:HWND; nLocked:Integer):Integer; stdcall; external SkinH_DLL;


{
		����:	����Aero��Ч
    ����:
				  bAero				//1Ϊ������Ч,0Ϊ�ر���Ч

    ����ֵ: �ɹ�����0, ʧ�ܷ��ط�0
}
function SkinH_SetAero(hWnd:HWND):Integer; stdcall; external SkinH_DLL;

{
		����:	���ÿؼ��ı���ɫ(Ŀǰ���Ե�ѡ��, ��ѡ��, �������Ч)
		����:
          hWnd,				//�ؼ����
					nRed,				//��ɫ����
					nGreen,			//��ɫ����
					nBlue				//��ɫ����

    ����ֵ: �ɹ�����0, ʧ�ܷ��ط�0
}
function SkinH_SetBackColor(hWnd:HWND; nRed,nGreen,nBlue:Integer):Integer; stdcall; external SkinH_DLL;

{
		����:	���ÿؼ����ı���ɫɫ(Ŀǰ���Ե�ѡ��,��ѡ��,�������Ч)
		����:
    			hWnd,				//�ؼ����
					nRed,				//��ɫ����
					nGreen,			//��ɫ����
					nBlue				//��ɫ����

    ����ֵ: �ɹ�����0, ʧ�ܷ��ط�0
}
function SkinH_SetForeColor(hWnd:HWND; nRed,nGreen,nBlue:Integer):Integer; stdcall; external SkinH_DLL;

{
		����:	���ô����Ƿ�����ƶ�
    ����:
				  hWnd,				//���ھ��
					bMovable		//0Ϊ�����ƶ�, 1Ϊ���ƶ�

    ����ֵ: �ɹ�����0, ʧ�ܷ��ط�0	
}
function SkinH_SetWindowMovable(hWnd:HWND;bMove:Boolean):Integer; stdcall; external SkinH_DLL;

{
		����:	����Aero��Ч����
		����:
    		  nAlpha,				//͸����,   0-255, Ĭ��ֵ0
					nShwDark,			//����,     0-255, Ĭ��ֵ0
					nShwSharp,		//���,	    0-255, Ĭ��ֵ0
					nShwSize,			//��Ӱ��С, 2-19,  Ĭ��ֵ2
					nX,					  //ˮƽƫ��, 0-25,  Ĭ��ֵ0 (Ŀǰ��֧��)
					nY,					  //��ֱƫ��, 0-25,  Ĭ��ֵ0 (Ŀǰ��֧��)
					nRed,				  //��ɫ����, 0-255, Ĭ��ֵ -1
					nGreen,				//��ɫ����, 0-255, Ĭ��ֵ -1
					nBlue				  //��ɫ����, 0-255, Ĭ��ֵ -1

		����ֵ: �ɹ�����0, ʧ�ܷ��ط�0	
}
function SkinH_AdjustAero(nAlpha:Integer=0; nShwDark:Integer=0; nShwSharp:Integer=0; nShwSize:Integer=2; nX:Integer=0; nY:Integer=0; nRed:Integer=-1; nGreen:Integer=-1; nBlue:Integer=-1):Integer; stdcall; external SkinH_DLL;

{
		����:	����ָ���豸�����ĵ�Ԫ��
		����ֵ: �ɹ�����0, ʧ�ܷ��ط�0	
    ����:
					hDtDC,				//Ŀ���豸������
					left,				  //���Ͻ�ˮƽ����
					top,				  //���ϽǴ�ֱ����
					right,				//���½�ˮƽ����
					bottom,				//���½Ǵ�ֱ����
					nMRect				//Ԫ��id
}
function SkinH_NineBlt(hDtDC:HDC; left,top,right,bottom,nMRect:Integer):Integer; stdcall; external SkinH_DLL;


{
�������

SRET_OK             0 �����ɹ�
SRET_ERROR          1 ����ʧ��
SRET_ERROR_FILE     2 �ļ�����ʧ��
SRET_ERROR_PARAM    3 ��������
SRET_ERROR_CREATE   4 ����Ƥ��ʧ��
SRET_ERROR_FORMAT   5 Ƥ����ʽ����
SRET_ERROR_VERSION  6 Ƥ���汾����
SRET_ERROR_PASSWORD 7 Ƥ���������
SRET_ERROR_INVALID  8 ��Ȩʧ��
}


implementation

end.
