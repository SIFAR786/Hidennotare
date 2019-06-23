VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Dictionary"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
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
'  Dictionary ���b�p�[�N���X (�Q�Ɛݒ�͂������Ȃ����ǃC���e���Z���X�������킪�܂܃N���X�j
'-----------------------------------------------------------------------------------------------------
Option Explicit
Implements ICursor

Public Enum CompareMethod
    BinaryCompare = 0
    TextCompare = 1
    DatabaseCompare = 2
End Enum

Private mDic As Object
Private mIndex As Long
'--------------------------------------------------------------
'  Initialize
'--------------------------------------------------------------
Private Sub Class_Initialize()
    Set mDic = CreateObject("Scripting.Dictionary")
    mIndex = 0
End Sub
'--------------------------------------------------------------
'  Terminate
'--------------------------------------------------------------
Private Sub Class_Terminate()
    Set mDic = Nothing
End Sub
'--------------------------------------------------------------
'  ���ڂ̒ǉ�
'--------------------------------------------------------------
Public Function Add(ByVal KeyValue As String, obj As Variant)
    mDic.Add KeyValue, obj
End Function
'--------------------------------------------------------------
'  ���ڂ̑��݃`�F�b�N
'--------------------------------------------------------------
Public Function Exists(ByVal KeyValue As String) As Boolean
    Exists = mDic.Exists(KeyValue)
End Function
'--------------------------------------------------------------
'  �L�[���X�g�擾
'--------------------------------------------------------------
Public Function keys() As Variant
    keys = mDic.keys
End Function
'--------------------------------------------------------------
'  �\�[�g�ς݃L�[���X�g�擾
'--------------------------------------------------------------
Public Function SortedKeys(Optional ByRef CP As IComparer = Nothing) As Variant
    SortedKeys = Sort(CP)
End Function
'--------------------------------------------------------------
'  �l���X�g�擾
'--------------------------------------------------------------
Public Function Items() As Variant
    Items = mDic.Items
End Function
Public Property Get CompareMode() As CompareMethod
    CompareMode = mDic.CompareMode
End Property
Public Property Let CompareMode(Mode As CompareMethod)
    mDic.CompareMode = Mode
End Property
Public Property Get Count() As Long
    Count = mDic.Count
End Property
'--------------------------------------------------------------
'  �l�擾
'--------------------------------------------------------------
Public Property Get Item(ByVal KeyValue As String) As Variant
Attribute Item.VB_UserMemId = 0
    If VBA.IsObject(mDic.Item(KeyValue)) Then
        Set Item = mDic.Item(KeyValue)
    Else
        Item = mDic.Item(KeyValue)
    End If
End Property
'--------------------------------------------------------------
'  �l�ݒ�
'--------------------------------------------------------------
Public Property Let Item(ByVal KeyValue As String, NewItem As Variant)
    mDic.Item(KeyValue) = NewItem
End Property
'--------------------------------------------------------------
'  �l�ݒ�(�I�u�W�F�N�g)
'--------------------------------------------------------------
Public Property Set Item(ByVal KeyValue As String, NewItem As Variant)
    Set mDic.Item(KeyValue) = NewItem
End Property
'--------------------------------------------------------------
'  �L�[�ݒ�
'--------------------------------------------------------------
Public Property Let key(ByVal OldKey As String, NewKey As Variant)
    mDic.key(OldKey) = NewKey
End Property
'--------------------------------------------------------------
'  �폜
'--------------------------------------------------------------
Public Sub Remove(ByVal KeyValue As String)
    mDic.Remove KeyValue
End Sub
'--------------------------------------------------------------
'  �S�A�C�e���폜
'--------------------------------------------------------------
Public Sub RemoveAll()
    
    mDic.RemoveAll
    mIndex = 0

End Sub
'--------------------------------------------------------------
'  �L�[�̃\�[�g
'--------------------------------------------------------------
Private Function Sort(ByVal CP As IComparer) As Variant

    Dim i As Long
    Dim j As Long
    Dim n As Long
    Dim wk As String
    Dim strKey As Variant
    
    If CP Is Nothing Then
        Set CP = New IComparer
    End If
    
    strKey = mDic.keys

    '�v�f��
    n = UBound(strKey) - LBound(strKey) + 1
    
    '�\�[�g�s�v
    If n <= 1 Then
        GoTo e
    End If

    '�}���\�[�g
    For i = 1 To n - 1

        wk = strKey(i)
        
        Dim lngCmp As Long
        
        lngCmp = CP.Compare(strKey(i - 1), wk)

        If lngCmp > 0 Then

            j = i

            Do

                strKey(j) = strKey(j - 1)

                j = j - 1

                If j = 0 Then
                    Exit Do
                End If

                lngCmp = CP.Compare(strKey(j - 1), wk)
            
            Loop While lngCmp > 0
            
            strKey(j) = wk

        End If
    Next

e:
    Sort = strKey

End Function
'--------------------------------------------------------------
'  �V���A���C�Y��(JSON)
'--------------------------------------------------------------
Public Function ToString() As String

    Dim Item  As Variant
    Dim KeyValue As Variant
    
    Dim v  As Variant
    
    Dim sb As StringBuilder
    Set sb = New StringBuilder
    
    For Each KeyValue In mDic.keys
    
        If VBA.IsObject(mDic.Item(KeyValue)) Then
            Set v = mDic.Item(KeyValue)
        Else
            v = mDic.Item(KeyValue)
        End If
    
        Select Case True
            
            Case IsObject(v)
                
                sb.Append """" & KeyValue & """:" & v.ToString
            
            Case IsEmpty(v)

                sb.Append """" & KeyValue & """:" & "null"

            Case VarType(v) = vbBoolean

                sb.Append """" & KeyValue & """:" & LCase(CStr(v))

            Case Else

                sb.Append """" & KeyValue & """:" & Escape(v)

        End Select
    
    Next

    ToString = "{" & sb.ToJoin(", ") & "}"

End Function
' ���䕶���ϊ�
Private Function Escape(ByVal v As String) As String

    Dim strChr As String
    Dim sb As StringBuilder
    Dim i As Long
    
    Set sb = New StringBuilder
    
    For i = 1 To Len(v)
        
        strChr = Mid$(v, i, 1)
        
        Select Case Unicode(strChr)
            Case &H0 To &H7, &HB, &HE To &H1F, &H7F
                sb.Append "\u" & Hex$(Unicode(strChr))
            Case &H8
                sb.Append "\b"
            Case &H9
                sb.Append "\t"
            Case &HA
                sb.Append "\n"
            Case &HC
                sb.Append "\f"
            Case &HD
                sb.Append "\r"
            Case &H22
                sb.Append "\"""
            Case &H2F
                sb.Append "\/"
            Case &H5C
                sb.Append "\\"
            Case Else
                sb.Append strChr
        End Select

    Next
    
    '�{����JSON����Ȃ炱����UTF8�ϊ�
    Escape = """" & sb.ToString & """"

End Function
'Unicode
Private Function Unicode(ByVal strBuf As String) As Long
    Dim bytBuf() As Byte
    
    If Len(strBuf) <> 0 Then
        bytBuf = strBuf
        Unicode = CLng(bytBuf(1)) * &H100 + bytBuf(0)
    End If
End Function
'--------------------------------------------------------------
'  ICursor �� ICursor �C���^�[�t�F�[�X���擾
'--------------------------------------------------------------
Public Property Get GetCursor() As ICursor
    Set GetCursor = Me
End Property
'--------------------------------------------------------------
'  ICursor �� Eof �v���p�e�B���擾
'--------------------------------------------------------------
Private Property Get ICursor_Eof() As Boolean
    ICursor_Eof = mIndex > mDic.Count - 1
End Property
'--------------------------------------------------------------
'  ICursor �� Item �v���p�e�B���擾
'--------------------------------------------------------------
Private Property Get ICursor_Item(Optional ByVal opt As Variant) As Variant
    Dim v As Variant
    
    v = Me.SortedKeys
    
    If mIndex > mDic.Count - 1 Then
        ICursor_Item = v(mDic.Count - 1)
    Else
        ICursor_Item = v(mIndex)
    End If

End Property
'--------------------------------------------------------------
'  ICursor �� PreviousItem �v���p�e�B���擾
'--------------------------------------------------------------
Private Property Get ICursor_PreviousItem(Optional ByVal opt As Variant) As Variant
    
    Dim v As Variant
    
    v = Me.SortedKeys
    
    If mIndex < 0 Then
        Err.Raise vbObjectError + 512 + 1, , "IndexOutOfRangeException"
    Else
        ICursor_PreviousItem = v(mIndex - 1)
    End If

End Property
'--------------------------------------------------------------
'  ICursor �� �J�[�\���ʒu��������
'--------------------------------------------------------------
Private Sub ICursor_MoveFirst()
    mIndex = 0
End Sub
'--------------------------------------------------------------
'  ICursor �� �J�[�\���ʒu�����Ɉړ�
'--------------------------------------------------------------
Private Sub ICursor_MoveNext()

    mIndex = mIndex + 1
    If mIndex > mDic.Count Then
        mIndex = mDic.Count
    End If

End Sub
