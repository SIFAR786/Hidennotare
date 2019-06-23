VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "SheetCursor"
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
' �V�[�g�ǂݍ��݃N���X(Cursor)
'-----------------------------------------------------------------------------------------------------
Option Explicit
Implements IConstructor
Implements ICursor

'���[�N�V�[�g
Private mWS As Worksheet

'�������J�[�\��
Private mStartRow As Long
Private mEofCol As Variant
Private mRow As Long

'�E�����J�[�\��
Private mStartCol As Variant
Private mEofRow As Long
Private mCol As Variant

'EOF������
Private mEofStr As String

'�J�[�\���̌���
Enum SheetCursorConstants
    DirectionDown = 0           '�������J�[�\��
    DirectionRight = 1          '�E�����J�[�\��
End Enum
Private mDirection As SheetCursorConstants
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
        mDirection = SheetCursorConstants.DirectionDown 'Default������
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
            
            If mDirection = DirectionDown Then
                mRow = CLng(Args(START_NUM))
                mStartRow = mRow
                mEofCol = Args(EOF_NUM)
            Else
                '�w�肪���l�Ȃ炻�̂܂܁B�A���t�@�x�b�g�Ȃ��ϊ�
                If IsNumeric(Args(START_NUM)) Then
                    mCol = Args(START_NUM)
                Else
                    mCol = mWS.Columns(Args(START_NUM)).Column
                End If
                
                mStartCol = mCol
                
                mEofRow = CLng(Args(EOF_NUM))
            
            End If
        Else
            Exit Function
        End If
    End If
    
    If mDirection = DirectionDown Then
        SkipHiddenRow
    Else
        SkipHiddenCol
    End If
    
    Set IConstructor_Instancing = Me

End Function
'------------------------------------------------------
' �f�X�g���N�^
'------------------------------------------------------
Private Sub Class_Terminate()
    Set mWS = Nothing
End Sub
'------------------------------------------------------
' ��\���s���X�L�b�v
'------------------------------------------------------
Private Sub SkipHiddenRow()
    Do Until Not mWS.Rows(mRow).Hidden Or ICursor_Eof
        mRow = mRow + 1
    Loop
End Sub
'------------------------------------------------------
' ��\������X�L�b�v
'------------------------------------------------------
Private Sub SkipHiddenCol()
    Do Until Not mWS.Columns(mCol).Hidden Or ICursor_Eof
        mCol = mCol + 1
    Loop
End Sub
'--------------------------------------------------------------
' ICursor �C���^�[�t�F�[�X���擾
'--------------------------------------------------------------
Public Property Get GetCursor() As ICursor
    Set GetCursor = Me
End Property
'------------------------------------------------------
' �I������
'------------------------------------------------------
Private Property Get ICursor_Eof() As Boolean
    If mDirection = DirectionDown Then
        ICursor_Eof = (mWS.Cells(mRow, mEofCol).Value = mEofStr)
    Else
        ICursor_Eof = (mWS.Cells(mEofRow, mCol).Value = mEofStr)
    End If
End Property
'------------------------------------------------------
' �Z���擾�i�K��̃v���p�e�B�Ȃ̂ŏȗ��\�L�j
'------------------------------------------------------
Private Property Get ICursor_Item(Optional ByVal opt As Variant) As Variant
    If mDirection = DirectionDown Then
        Set ICursor_Item = mWS.Cells(mRow, opt)
    Else
        Set ICursor_Item = mWS.Cells(opt, mCol)
    End If
End Property
'------------------------------------------------------
' �O�̃Z���擾
'------------------------------------------------------
Private Property Get ICursor_PreviousItem(Optional ByVal opt As Variant) As Variant
    If mDirection = DirectionDown Then
        Set ICursor_PreviousItem = mWS.Cells(mRow - 1, opt)
    Else
        Set ICursor_PreviousItem = mWS.Cells(opt, mCol - 1)
    End If
End Property
'------------------------------------------------------
' �ŏ��̍s�Ɉړ�
'------------------------------------------------------
Private Sub ICursor_MoveFirst()
    If mDirection = DirectionDown Then
        mRow = mStartRow
        SkipHiddenRow
    Else
        mCol = mStartCol
        SkipHiddenCol
    End If
End Sub
'------------------------------------------------------
' ���s�擾
'------------------------------------------------------
Private Sub ICursor_MoveNext()
    If mDirection = DirectionDown Then
        mRow = mRow + 1
        SkipHiddenRow
    Else
        mCol = mCol + 1
        SkipHiddenCol
    End If
End Sub