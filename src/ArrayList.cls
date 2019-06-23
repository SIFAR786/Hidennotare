VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ArrayList"
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
'  ArrayList �N���X
'-----------------------------------------------------------------------------------------------------
Option Explicit
Implements IConstructor
Implements ICursor

Private mCol As Collection
Private v() As Variant
Private mIndex As Long
'--------------------------------------------------------------
'  Initialize
'--------------------------------------------------------------
Private Sub Class_Initialize()
    Set mCol = New Collection
    mIndex = 0
End Sub
'--------------------------------------------------------------
'  Terminate
'--------------------------------------------------------------
Private Sub Class_Terminate()
    Set mCol = Nothing
End Sub
'--------------------------------------------------------------
'  �R���X�g���N�^
'--------------------------------------------------------------
Private Function IConstructor_Instancing(ByRef Args As Collection) As Object

    Dim v As Variant
    Dim i As Long
    
    Select Case Args.Count
        
        '�����Ȃ�
        Case 0
        
        '�����P��
        Case 1
            Select Case True
                
                '�R���N�V��������̕ϊ�
                Case TypeOf Args(1) Is Collection
                    Me.Clear
                    Set mCol = Args(1)
                
                '�P�����z�񂩂�̕ϊ�
                Case IsArray(Args(1))
                    Me.Clear
                    For i = LBound(Args(1)) To UBound(Args(1))
                        mCol.Add Args(1)(i)
                    Next
                Case Else
                    '�G���[
                    Exit Function
            End Select
        
        '��������̒ǉ�
        Case Else
            Me.Clear
            For Each v In Args
                mCol.Add v
            Next
    End Select
    
    Set IConstructor_Instancing = Me
    
End Function
'--------------------------------------------------------------
'  ArrayList ����S�Ă̍��ڂ��폜����B
'--------------------------------------------------------------
Public Sub Clear()

    Set mCol = New Collection
    mIndex = 0
    
End Sub
'--------------------------------------------------------------
'  ArrayList �ɍ��ڂ�ǉ�����B
'--------------------------------------------------------------
Public Sub Add(obj As Variant)
    
    mCol.Add obj

End Sub
'--------------------------------------------------------------
'  ArrayList �̎w��ʒu�ɍ��ڂ�ǉ�����B
'--------------------------------------------------------------
Public Sub Insert(Idx As Long, v As Variant)

    If Idx < 0 Or Idx >= mCol.Count Then
        Err.Raise vbObjectError + 512 + 1, , "IndexOutOfRangeException"
    End If
    
    mCol.Add v, , Idx + 1

End Sub
'--------------------------------------------------------------
'  For Each �p
'--------------------------------------------------------------
Public Function NewEnum() As stdole.IUnknown
Attribute NewEnum.VB_UserMemId = -4
    Set NewEnum = mCol.[_NewEnum]
End Function
'--------------------------------------------------------------
'  ArrayList �v�f����ԋp
'--------------------------------------------------------------
Public Property Get Count() As Long
    Count = mCol.Count
End Property
'--------------------------------------------------------------
'  ArrayList �̎w��ʒu�̍��ڂ��擾
'--------------------------------------------------------------
Public Property Get Item(Idx As Long) As Variant
Attribute Item.VB_UserMemId = 0
    
    If Idx < 0 Or Idx >= mCol.Count Then
        Err.Raise vbObjectError + 512 + 1, , "IndexOutOfRangeException"
    End If
        
    If VBA.IsObject(mCol.Item(Idx + 1)) Then
        Set Item = mCol.Item(Idx + 1)
    Else
        Item = mCol.Item(Idx + 1)
    End If
    
End Property
'--------------------------------------------------------------
'  ArrayList �̎w��ʒu�̍��ڂ��폜
'--------------------------------------------------------------
Public Sub RemoveAt(Idx As Long)
    
    If Idx < 0 Or Idx >= mCol.Count Then
        Err.Raise vbObjectError + 512 + 1, , "IndexOutOfRangeException"
    End If
    
    mCol.Remove Idx + 1
End Sub
'--------------------------------------------------------------
'  ArrayList �̃\�[�g
'--------------------------------------------------------------
Public Sub Sort(Optional ByVal CP As IComparer = Nothing)

    Dim i As Long
    Dim j As Long
    Dim col2 As Collection
    Dim blnFind As Boolean
    
    If CP Is Nothing Then
        'Interface�����ʂ̃N���X�Ȃ̂�Default��r�Ƃ��ė��p
        Set CP = New IComparer
    End If
    
    'Collection����Ȃ�Ȃɂ����Ȃ�
    If mCol Is Nothing Then
        Exit Sub
    End If

    'Collection�̗v�f�����O�܂��͂P�̏ꍇ�\�[�g�s�v
    If mCol.Count <= 1 Then
        Exit Sub
    End If
    
    Set col2 = New Collection
    
    For i = 1 To mCol.Count
        If col2.Count = 0 Then
            col2.Add mCol(i)
        Else
            blnFind = False
            For j = col2.Count To 1 Step -1
    
                '�t�@�C���̕����傫�������ꍇ�A���̌�ɑ}���B
                If CP.Compare(mCol(i), col2(j)) >= 0 Then
                    col2.Add mCol(i), , , j
                    blnFind = True
                    Exit For
                End If
            Next
            If Not blnFind Then
                col2.Add mCol(i), , 1
            End If
        End If
    
    Next
    
    Set mCol = col2
    Set col2 = Nothing

End Sub
'--------------------------------------------------------------
'  ArrayList ���P�����z��ɕϊ�
'--------------------------------------------------------------
Public Function ToArray() As Variant

    Dim c As Variant
    Dim i As Long
    
    ReDim v(0 To mCol.Count)
    
    For i = 0 To mCol.Count - 1

        If IsObject(mCol(i + 1)) Then
            Set v(i) = mCol(i + 1)
        Else
            Let v(i) = mCol(i + 1)
        End If
        
    Next

    ToArray = v
    
End Function
'--------------------------------------------------------------
'  ArrayList ��Collection�ɕϊ�
'--------------------------------------------------------------
Public Function ToCollection() As Collection
    
    Set ToCollection = mCol

End Function
'--------------------------------------------------------------
'  ArrayList ��JSON�ɕϊ�
'--------------------------------------------------------------
Public Function ToString() As String

    Dim v As Variant
    Dim sb As StringBuilder
    Set sb = New StringBuilder
    
    For Each v In mCol
    
        Select Case True
            Case IsObject(v)

                sb.Append v.ToString

            Case IsEmpty(v)

                sb.Append "null"
            
            Case VarType(v) = vbBoolean

                sb.Append LCase(CStr(v))

            Case Else

                sb.Append Escape(v)

        End Select
    
    Next

    ToString = "[" & sb.ToJoin(", ") & "]"

End Function
'---------------------------------------------------------------------
' ���䕶���ϊ�
'---------------------------------------------------------------------
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
'  ArrayList �� ICursor �C���^�[�t�F�[�X���擾
'--------------------------------------------------------------
Public Property Get GetCursor() As ICursor
    Set GetCursor = Me
End Property
'--------------------------------------------------------------
'  ICursor �� Eof �v���p�e�B���擾
'--------------------------------------------------------------
Private Property Get ICursor_Eof() As Boolean
    ICursor_Eof = mIndex >= mCol.Count
End Property
'--------------------------------------------------------------
'  ICursor �� Item �v���p�e�B���擾
'--------------------------------------------------------------
Private Property Get ICursor_Item(Optional ByVal opt As Variant) As Variant
    
    If mIndex >= mCol.Count Then
        ICursor_Item = mCol(mCol.Count)
    Else
        ICursor_Item = mCol(mIndex + 1)
    End If
    
End Property
'--------------------------------------------------------------
'  ICursor �� PreviousItem �v���p�e�B���擾
'--------------------------------------------------------------
Private Property Get ICursor_PreviousItem(Optional ByVal opt As Variant) As Variant
    
    If mIndex <= 0 Then
        Err.Raise vbObjectError + 512 + 1, , "IndexOutOfRangeException"
    Else
        ICursor_PreviousItem = mCol(mIndex)
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
    If mIndex > mCol.Count Then
        mIndex = mCol.Count
    End If

End Sub
