VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Message"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'-----------------------------------------------------------------------------------------------------
'
' [HecatonCheir] v1
'
' Copyright (c) 2019 Yasuhiro Watanabe
' https://github.com/RelaxTools/HecatonCheir
' author:relaxtools@opensquare.net
'
' The MIT License (MIT)
'
' Permission is hereby granted, free of charge, to any person obtaining a copy
' of this software and associated documentation files (the "Software"), to deal
' in the Software without restriction, including without limitation the rights
' to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
' copies of the Software, and to permit persons to whom the Software is
' furnished to do so, subject to the following conditions:
'
' The above copyright notice and this permission notice shall be included in all
' copies or substantial portions of the Software.
'
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
' IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
' FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
' AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
' LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
' OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
' SOFTWARE.
'
'-----------------------------------------------------------------------------------------------------
' ���̃N���X�� Static�N���X(Attribute VB_PredeclaredId = True) �ł��B
'-----------------------------------------------------------------------------------------------------
' 2018-12-16 Ver.1.0.0 ����/�v���[�X�z���_/�G�X�P�[�v�Ή�
'-----------------------------------------------------------------------------------------------------
Option Explicit

Private mLang As Object
'---------------------------------------
' ����T�|�[�g
'---------------------------------------
Public Property Set LangSupport(v As Object)
    Set mLang = v
End Property
'---------------------------------------
' ��񃁃b�Z�[�W
'---------------------------------------
Public Sub Information(ByVal strMsg As String, ParamArray p())
    VBA.MsgBox PrivatePlaceHolder(strMsg, p), vbOKOnly + vbInformation, Title
End Sub
'---------------------------------------
' �x�����b�Z�[�W
'---------------------------------------
Public Sub Error(ByVal strMsg As String, ParamArray p())
    VBA.MsgBox PrivatePlaceHolder(strMsg, p), vbOKOnly + vbExclamation, Title
End Sub
'---------------------------------------
' �ُ�I�����b�Z�[�W
'---------------------------------------
Public Sub Critical(ByVal strMsg As String, ParamArray p())
    VBA.MsgBox PrivatePlaceHolder(strMsg, p), vbOKOnly + vbCritical, Title
End Sub
'---------------------------------------
' �������b�Z�[�W
'---------------------------------------
Public Function Question(ByVal strMsg As String, ParamArray p()) As Boolean
    Question = VBA.MsgBox(PrivatePlaceHolder(strMsg, p), vbOKCancel + vbQuestion, Title) <> vbOK
End Function
'---------------------------------------
' �v���[�X�z���_�ϊ�
'---------------------------------------
Public Function PlaceHolder(ByVal strMsg As String, ParamArray p()) As String
    PlaceHolder = PrivatePlaceHolder(strMsg, p)
End Function
'---------------------------------------
' �X�e�[�^�X�o�[���b�Z�[�W
'---------------------------------------
Public Sub StatusBar(ByVal strMsg As String, ParamArray p())
    Application.StatusBar = PrivatePlaceHolder(strMsg, p)
    DoEvents
End Sub
'---------------------------------------
' �X�e�[�^�X�o�[�N���A
'---------------------------------------
Public Sub StatusBarClear()
    Application.StatusBar = False
    DoEvents
End Sub
'---------------------------------------
' �v���[�X�z���_�ϊ�
'---------------------------------------
Private Function PrivatePlaceHolder(ByVal strMsg As String, ByVal p As Variant) As String
    
    '�|��
    If Not mLang Is Nothing Then
        strMsg = mLang.Trunslate(strMsg)
    Else
        strMsg = Escape(strMsg)
    End If
    
    If UBound(p) >= 0 Then
        Dim i As Long
        For i = 0 To UBound(p)
            strMsg = Replace(strMsg, "{" & CStr(i) & "}", p(i))
        Next
    End If

    PrivatePlaceHolder = strMsg

End Function
' �A�v���P�[�V�������擾
Private Property Get Title() As String
    Title = ThisWorkbook.BuiltinDocumentProperties("Title").Value
End Property
' ������̃G�X�P�[�v
Private Function Escape(ByVal v As String) As String

    v = Replace(v, "\\", "\")
    v = Replace(v, "\n", vbLf)
    v = Replace(v, "\r", vbCr)
    v = Replace(v, "\t", vbTab)
    
    Escape = v
    
End Function