����duilib���裺
1����������DuilibExportĿ¼��Ŀ¼�µ��ļ���  duilib�����£���DirectUIlib.cpp��DirectUIlib.h����ԭduilib�����С�
2���޸�ԭDuilib��
   UIMarkup.h ��72 
   private: // �滻Ϊpublic
    CMarkupNode();
    CMarkupNode(CMarkup* pOwner, int iPos);
3���޸�UIControl.cpp��UIControl.h
UIControl.h
��� struct TDelphiMethod {
       LPVOID Code;
       LPVOID Data;
     }

  ��CEventSource OnPostPaint;��������
private:
	TDelphiMethod m_DoEventCallback;
	TDelphiMethod m_DoPaintCallback;
����������ӳ�ʼ������
 
	m_DoEventCallback = { NULL, NULL };
	m_DoPaintCallback = { NULL, NULL };

UIControl.cpp
  ��void CControlUI::Event(TEventUI& event)�����

  if (m_DoEventCallback.Code != NULL && m_DoEventCallback.Data != NULL)
	((void(*)(LPVOID, CControlUI*, TEventUI&))m_DoEventCallback.Code)(m_DoEventCallback.Data, this, event);

  ��void CControlUI::Paint(HDC hDC, const RECT& rcPaint)�������
	if (m_DoPaintCallback.Data != NULL && m_DoPaintCallback.Code != NULL)
		((void(*)(LPVOID, CControlUI*, HDC, const RECT&))m_DoPaintCallback.Code)(m_DoPaintCallback.Data, this, hDC, rcPaint);

4����UIlib.h�м���#include "DuilibExport/UIMenu.h"
	
5����������ѡ����Unicode���Ƕ��ֽڼ����̡�


--------------------duilib������Ϣ,�Դ�����ʾ��ǰDuilib for Delphi��ʹ�õ��ĸ��汾----------------------
�汾: 04377abca3858e65def0d094d3476879cfef2123
����: wangchyz <wangchyz@gmail.com>
����: 2016/2/19 10:07:45
��Ϣ:
Merge pull request #65 from wgy0323/master

Update UIGifAnim.cpp �޸Ŀؼ�֧����ʾ��ͨͼƬ
----
���޸�: DuiLib/Control/UIGifAnim.cpp







