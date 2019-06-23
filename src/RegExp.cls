VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "RegExp"
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
' �ˑ����W���[��
'   MatchBean.cls
'-----------------------------------------------------------------------------------------------------
' 2018-12-16 Ver.1.0.0 CreateObject���Ȃ��Ă��g���鐳�K�\��
'-----------------------------------------------------------------------------------------------------
Option Explicit

Private RE As Object

Private Sub Class_Initialize()
    Set RE = CreateObject("VBScript.RegExp")
End Sub
Private Sub Class_Terminate()
    Set RE = Nothing
End Sub
Public Property Get GetInstance() As Object
    Set GetInstance = RE
End Property
'--------------------------------------------------------------
'  ���K�\���̌��� True:�}�b�`/False:�A���}�b�`
'--------------------------------------------------------------
Function Test(ByVal strText As String, ByVal strExp As String, Optional ByVal blnIgnoreCase As Boolean = False) As Boolean

    With RE
        .Pattern = strExp
        .IgnoreCase = blnIgnoreCase
        .Global = False '�P�ł��}�b�`����ΏI��
        Test = .Test(strText)
    End With

End Function
'--------------------------------------------------------------
'  ���K�\���̒u��
'--------------------------------------------------------------
Function Replace(ByVal strText As String, ByVal strExp As String, ByVal strReplace As String, Optional ByVal blnIgnoreCase As Boolean = False) As String

    strReplace = Escape(strReplace)
    
    With RE
        .Pattern = strExp
        .IgnoreCase = blnIgnoreCase
        .Global = True '�S�̂�����
        Replace = .Replace(strText, strReplace)
    End With

End Function
'--------------------------------------------------------------
'  ���K�\������ Collection��ԋp
'--------------------------------------------------------------
Function Execute(ByVal strText As String, ByVal strExp As String, Optional ByVal blnIgnoreCase As Boolean = False) As Collection

    Dim col As Collection
    Dim matches As Object
    Dim m As Object
    Dim r As MatchBean
    
    Set col = New Collection

    With RE
        
        .Pattern = strExp
        .IgnoreCase = blnIgnoreCase
        .Global = True  '�S�̂�����
        
        Set matches = .Execute(strText)
    
    End With
        
    For Each m In matches
    
        'FirstIndex��0����Ȃ̂�+1
        col.Add Constructor(New MatchBean, m.FirstIndex + 1, m.Length, m.Value)
    
    Next
        
    Set Execute = col
    
End Function
'--------------------------------------------------------------
'  ���K�\���̃`�F�b�N True:�G���[/False:����
'  ���K�\�������[�U�ɓ��͂�����ꍇ�Ɏg�p
'--------------------------------------------------------------
Function Check(ByVal strExp As String)

    On Error GoTo e
    
    Check = True

    With RE
        .Pattern = strExp
        .IgnoreCase = False
        .Global = False
        .Execute ""
    End With
    
    Check = False
    
    Exit Function
e:

End Function
''--------------------------------------------------------------
'�@Shape��Replace(�����ێ�Ver)
'--------------------------------------------------------------
Sub ReplaceShape(ByRef sh As Shape, ByVal strExp As String, ByVal strReplace As String, Optional ByVal blnIgnoreCase As Boolean = False)

    Dim col As Collection
    Dim bean As MatchBean
    Dim i As Long

    With sh.TextFrame2.TextRange

        '����
        Set col = Me.Execute(.Text, strExp, blnIgnoreCase)

        '�u�������Index�������̂ŋt���ɏ���
        For i = col.Count To 1 Step -1

            Set bean = col(i)

            Call .Characters(bean.Index, bean.Length).Delete

            If strReplace <> "" Then
                Call .Characters(bean.Index, 0).InsertAfter(strReplace)
            End If

        Next

    End With

End Sub
'--------------------------------------------------------------
'�@Range��Replace(�����ێ�Ver)
'--------------------------------------------------------------
Sub ReplaceRange(ByRef r As Range, ByVal strExp As String, ByVal strReplace As String, Optional ByVal blnIgnoreCase As Boolean = False)

    Dim col As Collection
    Dim bean As MatchBean
    Dim i As Long

    With r

        '����
        Set col = Me.Execute(.Value, strExp, blnIgnoreCase)

        '�u�������Index�������̂ŋt���ɏ���
        For i = col.Count To 1 Step -1

            Set bean = col(i)

            Call .Characters(bean.Index, bean.Length).Delete

            If strReplace <> "" Then
                Call .Characters(bean.Index, 0).Insert(strReplace)
            End If

        Next

    End With

End Sub

'----------------------------------------------------------------------------------
'�@������̃G�X�P�[�v
'----------------------------------------------------------------------------------
Private Function Escape(ByVal v As String) As String

    Dim sb As StringBuilder
    
    Set sb = New StringBuilder
    
    sb.Append v
    sb.Replace "\\", "\"
    sb.Replace "\n", vbLf
    sb.Replace "\r", vbCr
    sb.Replace "\t", vbTab
    
    Escape = sb.ToString
    
End Function