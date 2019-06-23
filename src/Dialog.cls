VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Dialog"
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
'   �Ȃ�
'-----------------------------------------------------------------------------------------------------
' 2018-12-16 Ver.1.0.0 �V�K�쐬
'-----------------------------------------------------------------------------------------------------
Option Explicit
'--------------------------------------------------------------
'�@�J���[�_�C�A���O�\��
'--------------------------------------------------------------
Public Function ShowColorDialog(lngDefColor As Long) As Boolean

    Dim lngBackColor As Long
    Dim lngRed As Long
    Dim lngGreen As Long
    Dim lngBlue As Long
    Dim strColor As String
    
    ShowColorDialog = False
    
    strColor = Right$("000000" & Hex(lngDefColor), 6)
    lngRed = CLng("&H" & Mid$(strColor, 5, 2))
    lngGreen = CLng("&H" & Mid$(strColor, 3, 2))
    lngBlue = CLng("&H" & Mid$(strColor, 1, 2))
    
    If ActiveWorkbook Is Nothing Then
        Exit Function
    End If
    
    lngBackColor = ActiveWorkbook.Colors(1)
    If Application.Dialogs(xlDialogEditColor).Show(1, lngRed, lngGreen, lngBlue) Then
        lngDefColor = ActiveWorkbook.Colors(1)
        ActiveWorkbook.Colors(1) = lngBackColor
        ShowColorDialog = True
    End If

End Function
'-------------------------------------------
' �t�H���_�I��
'-------------------------------------------
Public Function ShowFolderDialog(ByRef strFile As String) As Boolean
    
    ShowFolderDialog = False
    
    With Application.FileDialog(msoFileDialogFolderPicker)
        If strFile <> "" Then
            .InitialFileName = strFile
        End If
        If .Show Then
            ShowFolderDialog = True
            strFile = .SelectedItems(1)
        End If
    End With

End Function
'-------------------------------------------
' �t�@�C���I��
'-------------------------------------------
Public Function ShowFileDialog(ByRef strFile As String, Optional ByVal varFilter As Variant) As Boolean
    
    Dim v As Variant
    
    ShowFileDialog = False
    
    With Application.FileDialog(msoFileDialogFilePicker)
        
        If strFile <> "" Then
            .InitialFileName = strFile
        End If
        
        .Filters.Clear
        
        If Not IsArray(varFilter) Then
            varFilter = Array(varFilter)
        End If
        
        For Each v In varFilter
            If InStr(v, "|") > 0 Then
            
                Dim s As Variant
                
                s = Split(v, "|")
                .Filters.Add CStr(s(0)), CStr(s(1))
            Else
                .Filters.Add "", CStr(v)
            End If
        Next
        
'        .Filters.Add "���ׂẴt�@�C��", "*.*"
       
       '�����I���t�B���^�̐ݒ�
        .FilterIndex = 1
       
       '�����t�@�C���I���̋���
        .AllowMultiSelect = False
       
       '�^�C�g���o�[�̕\��������̐ݒ�
        .Title = "�t�@�C���I��"
       
       '�{�^���̕\��������̐ݒ�
        .ButtonName = "�Q��"
        
        If .Show Then
            ShowFileDialog = True
            strFile = .SelectedItems(1)
        End If
    End With

End Function
