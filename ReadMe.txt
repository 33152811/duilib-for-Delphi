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
  if (m_DelphiSelf != NULL && m_DoPaintCallback != NULL)
    ((void(*)(LPVOID, CControlUI*, HDC, const RECT&))m_DoPaintCallback)(m_DelphiSelf, this, hDC, rcPaint);
	
4����������ѡ����Unicode���Ƕ��ֽڼ����̡�


--------------------duilib������Ϣ,�Դ�����ʾ��ǰDuilib for Delphi��ʹ�õ��ĸ��汾----------------------

�汾: 3407f2391225c4798f473c4fb2ac89d4453ecd18
����: wangchyz <wangchyz@gmail.com>
����: 2015/12/21 15:43:35
��Ϣ:
����qqdemo����Դ
----
���޸�: QQDemo/res/QQRes.zip





