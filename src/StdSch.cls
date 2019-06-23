VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "StdSch"
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
' 2018-12-16 Ver.1.0.0 �����񌟍�
'-----------------------------------------------------------------------------------------------------
Option Explicit
'--------------------------------------------------------------
'  ������̌��� True:�}�b�`/False:�A���}�b�`
'--------------------------------------------------------------
Function Test(ByVal strText As String, ByVal strExp As String, Optional ByVal blnIgnoreCase As Boolean = False, Optional ByVal blnMatchByte As Boolean = False, Optional ByVal blnWhole As Boolean = False) As Boolean

    Dim strCmp1 As String
    Dim strCmp2 As String
    
    strCmp1 = strText
    strCmp2 = strExp

    If blnIgnoreCase Then
        strCmp1 = UCase(strCmp1)
        strCmp2 = UCase(strCmp2)
    End If

    If blnMatchByte Then
        strCmp1 = StrConv(strCmp1, vbNarrow)
        strCmp2 = StrConv(strCmp2, vbNarrow)
    End If

    If blnWhole Then
        Test = (strCmp1 = strCmp2)
    Else
        Test = (InStr(strCmp1, strCmp2) > 0)
    End If

End Function
'--------------------------------------------------------------
'  ������̒u��
'--------------------------------------------------------------
Function Replace(ByVal strText As String, ByVal strExp As String, ByVal strReplace As String, Optional ByVal blnIgnoreCase As Boolean = False, Optional ByVal blnMatchByte As Boolean = False, Optional ByVal blnWhole As Boolean = False) As String
    
    Dim col As Collection
    Dim bean As MatchBean
    Dim i As Long
    Dim strL As String
    Dim strR As String
    Dim strBuf As String

    '����
    Set col = Me.Execute(strText, strExp, blnIgnoreCase, blnMatchByte, blnWhole)
    
    strBuf = strText
    '�u�������Index�������̂ŋt���ɏ���
    For i = col.Count To 1 Step -1
    
        Set bean = col(i)
    
        strL = Mid$(strBuf, 1, bean.Index - 1)
        strR = Mid$(strBuf, bean.Index + bean.Length)

        strBuf = strL & strReplace & strR
    
    Next
    
    Replace = strBuf
    
End Function

'--------------------------------------------------------------
'  �ʏ팟�� Collection��ԋp
'--------------------------------------------------------------
Public Function Execute(ByVal strText As String, ByVal strExp As String, Optional ByVal blnIgnoreCase As Boolean = False, Optional ByVal blnMatchByte As Boolean = False, Optional ByVal blnWhole As Boolean = False) As Collection

    Dim col As Collection
    Dim lngPos As Long
    Dim r As MatchBean
    Dim strResult As String
    
    Set col = New Collection
    
    Dim strCmp1 As String
    Dim strCmp2 As String
    
    strCmp1 = strText
    strCmp2 = strExp

    If blnIgnoreCase Then
        strCmp1 = UCase(strCmp1)
        strCmp2 = UCase(strCmp2)
    End If

    If blnMatchByte Then
        strCmp1 = StrConv(strCmp1, vbNarrow)
        strCmp2 = StrConv(strCmp2, vbNarrow)
    End If
    
    If blnWhole Then
    
        If strCmp1 = strCmp2 Then
            col.Add Constructor(New MatchBean, 1, Len(strCmp1), strCmp1)
        End If
    
    Else
    
        '�p�^�[�����󔒂̏ꍇ�A�S��v�Ƃ���B
        If strCmp2 = "" Then
            col.Add Constructor(New MatchBean, 1, 0, strCmp1)
        Else
    
            lngPos = InStr(strCmp1, strCmp2)
            
            Do Until lngPos = 0
                
                strResult = Mid$(strText, lngPos, Len(strExp))
                
                col.Add Constructor(New MatchBean, lngPos, Len(strResult), strResult)
            
                lngPos = InStr(lngPos + 1, strCmp1, strCmp2)
            Loop
        End If
    End If
    
    Set Execute = col

End Function
'--------------------------------------------------------------
'  ������̃`�F�b�N True:�G���[/False:����
'  ���K�\���Ƃ̌݊����̂���
'--------------------------------------------------------------
Function Check(ByVal strExp As String)
    Check = False
End Function
'--------------------------------------------------------------
'�@Shape��Replace(�����ێ�Ver)
'--------------------------------------------------------------
Sub ReplaceShape(ByRef sh As Shape, ByVal strExp As String, ByVal strReplace As String, Optional ByVal blnIgnoreCase As Boolean = False, Optional ByVal blnMatchByte As Boolean = False, Optional ByVal blnWhole As Boolean = False)

    Dim col As Collection
    Dim bean As MatchBean
    Dim i As Long

    With sh.TextFrame2.TextRange

        '����
        Set col = Me.Execute(.Text, strExp, blnIgnoreCase, blnMatchByte, blnWhole)
        
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
Sub ReplaceRange(ByRef r As Range, ByVal strExp As String, ByVal strReplace As String, Optional ByVal blnIgnoreCase As Boolean = False, Optional ByVal blnMatchByte As Boolean = False, Optional ByVal blnWhole As Boolean = False)

    Dim col As Collection
    Dim bean As MatchBean
    Dim i As Long

    With r

        '����
        Set col = Me.Execute(.Value, strExp, blnIgnoreCase, blnMatchByte, blnWhole)
        
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

