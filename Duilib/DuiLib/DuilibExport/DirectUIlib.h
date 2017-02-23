//*******************************************************************
//
//       ���ߣ�ying32
//       QQ  ��1444386932
//       E-mail��1444386932@qq.com
//       ����Ԫ��CppConvert�����Զ�������2015-11-28 16:29:02
//       ��Ȩ���� (C) 2015-2015 ying32 All Rights Reserved
//
//*******************************************************************
#ifndef _DIRECTUILIB_H
#define _DIRECTUILIB_H

#include "../UIlib.h"

#define DIRECTUILIB_API extern "C" __declspec(dllexport)

namespace DuiLib
{

	// ��ͨwin�ı�׼�ؼ�
	class CNativeControlUI : public CControlUI
	{
	private:
		void UpdateWindowParent(HWND hWd);
	public:
		CNativeControlUI(HWND hWnd = NULL);
		~CNativeControlUI();
		void SetInternVisible(bool bVisible = true);
		void SetVisible(bool bVisible = true);
		void SetPos(RECT rc, bool bNeedInvalidate);
		LPCTSTR GetClass() const;
		CDuiString GetText() const;
		void SetText(LPCTSTR pstrText);
		void SetNativeHandle(HWND hWd);
	    void SetFocus();
	    void DoEvent(TEventUI& event);
		UINT GetControlFlags() const;
	protected:
		HWND m_hWnd;
	};

	// Delphi��VCL�ؼ�
	class CVCLControlUI: public CControlUI {
	private:
		// �Ƿ���duilib�ͷ�vcl�ؼ�
		bool m_bisFree;
		LPVOID m_lpObject;
		HWND m_hWnd;
	public:
		CVCLControlUI(LPVOID lpObject = NULL, bool bisFree = true);
		~CVCLControlUI();
		void SetInternVisible(bool bVisible = true);
		void SetVisible(bool bVisible = true);
		void SetPos(RECT rc, bool bNeedInvalidate);
		LPCTSTR GetClass() const;
		LPVOID GetVclObject();
		void SetVclObject(LPVOID lpObject);
		bool GetIsFree();
		void SetIsFree(bool bisFree);
	    bool IsFocused() const;
        void SetFocus();
		void DoEvent(TEventUI& event);
		UINT GetControlFlags() const;
	};

}

#endif

