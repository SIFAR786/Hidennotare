VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "SheetIterator"
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
' �V�[�g�ǂݍ��݃N���X(Iterator)
'-----------------------------------------------------------------------------------------------------
Option Explicit
Implements IConstructor
Implements IIterator

'���[�N�V�[�g
Private mWS As Worksheet

'�������J�[�\��
Private mStartRow As Long
Private mEofCol As Variant

'�E�����J�[�\��
Private mStartCol As Long
Private mEofRow As Variant

'�ێ��p�R���N�V����
Private mEnum As Collection

'EOF������
Private mEofStr As String

'�J�[�\���̌���
Enum SheetIteratorConstants
    DirectionDown = 0           '�������J�[�\��
    DirectionRight = 1          '�E�����J�[�\��
End Enum
Private mDirection As SheetIteratorConstants

'------------------------------------------------------
' �R���X�g���N�^
'------------------------------------------------------
Private Function IConstructor_Instancing(ByRef Args As Collection) As Object

    Const WORK_SHEET As Long = 1  '�����P�@Worksheet �I�u�W�F�N�g
    Const START_NUM As Long = 2   '�����Q�@�J�n�s or ��
    Const EOF_NUM As Long = 3     '�����R�@�I���𔻒肷��s or ��
    Const DIRECTION As Long = 4   '�����S�@��������:�� or �E(default:��)
    Const EOF_STR As Long = 5     '�����T�@�I���𔻒肷�镶����(default:""�j
    
    '�����̐����R�`�T�ȊO�̓G���[
    Select Case Args.Count
        Case 3 To 5
        Case Else
            Exit Function
    End Select
    
    '�J�[�\�������̎w��
    If Args.Count >= DIRECTION Then
        mDirection = Args(DIRECTION)
    Else
        mDirection = SheetIteratorConstants.DirectionDown 'Default������
    End If
    
    'EOF������̎w��
    If Args.Count >= EOF_STR Then
        mEofStr = Args(EOF_STR)
    Else
        mEofStr = "" 'Default�󕶎���
    End If
    
    If Args.Count >= EOF_NUM Then
        
        If TypeOf Args(WORK_SHEET) Is Worksheet Then
            
            Set mWS = Args(WORK_SHEET)
            
            If mDirection = SheetIteratorConstants.DirectionDown Then
                mStartRow = CLng(Args(START_NUM))
                mEofCol = Args(EOF_NUM)
            Else
                '�w�肪���l�Ȃ炻�̂܂܁B�A���t�@�x�b�g�Ȃ��ϊ�
                If IsNumeric(Args(START_NUM)) Then
                    mStartCol = Args(START_NUM)
                Else
                    mStartCol = mWS.Columns(Args(START_NUM)).Column
                End If
                mEofRow = CLng(Args(EOF_NUM))
            End If
        
        Else
            Exit Function
        End If
    End If
    
    Set mEnum = New Collection

    Dim lngCnt As Long

    If mDirection = SheetIteratorConstants.DirectionDown Then
        lngCnt = mStartRow
        Do Until mWS.Cells(lngCnt, mEofCol).Value = mEofStr
            If Not mWS.Rows(lngCnt).Hidden Then
                mEnum.Add mWS.Rows(lngCnt).Columns
            End If
            lngCnt = lngCnt + 1
        Loop
    Else
        lngCnt = mStartCol
        Do Until mWS.Cells(mEofRow, lngCnt).Value = mEofStr
            If Not mWS.Columns(lngCnt).Hidden Then
                mEnum.Add mWS.Columns(lngCnt).Rows
            End If
            lngCnt = lngCnt + 1
        Loop
    End If
    
    Set IConstructor_Instancing = Me

End Function
'------------------------------------------------------
' �f�X�g���N�^
'------------------------------------------------------
Private Sub Class_Terminate()
    Set mEnum = Nothing
End Sub
'--------------------------------------------------------------
' IIterator �C���^�[�t�F�[�X���擾
'--------------------------------------------------------------
Public Property Get GetIterator() As IIterator
    Set GetIterator = Me
End Property
'--------------------------------------------------------------
' For Each �p IUnknown �C���^�t�F�[�X�̕ԋp
'--------------------------------------------------------------
Private Function IIterator_NewEnum() As stdole.IEnumVARIANT
   Set IIterator_NewEnum = mEnum.[_NewEnum]
End Function