VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Clipboard"
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
'   Lang.cls
'   Registry.cls
'-----------------------------------------------------------------------------------------------------
' 2018-12-16 Ver.1.0.0 �V�K�쐬
' 2018-12-18 Ver.1.0.1 GetClipText ����� 4096�o�C�g��P�p
' 2018-12-19 Ver.1.0.2 GetClipText �� CF_UNICODETEXT �ɕύX
'                      SetClipText  �� CF_UNICODETEXT �ɕύX
'                      GetFileNameFromCli��Unicode�Ή�
'                      SetCopyClipText��Unicode�Ή�
'-----------------------------------------------------------------------------------------------------
Option Explicit

'�N���b�v�{�[�h�֐�
Private Declare PtrSafe Function OpenClipboard Lib "user32" (ByVal hWnd As LongPtr) As Long
Private Declare PtrSafe Function CloseClipboard Lib "user32" () As Long
Private Declare PtrSafe Function EmptyClipboard Lib "user32" () As Long
Private Declare PtrSafe Function GetClipboardData Lib "user32" (ByVal wFormat As Long) As LongPtr
Private Declare PtrSafe Function SetClipboardData Lib "user32" (ByVal wFormat As Long, ByVal hMem As LongPtr) As LongPtr
Private Declare PtrSafe Function IsClipboardFormatAvailable Lib "user32.dll" (ByVal wFormat As Long) As Long
Private Declare PtrSafe Function RegisterClipboardFormat Lib "user32" Alias "RegisterClipboardFormatA" (ByVal lpString As String) As Long
Private Declare PtrSafe Function DragQueryFileW Lib "shell32.dll" (ByVal hDrop As LongPtr, ByVal UINT As Long, ByVal lpszFile As LongPtr, ByVal ch As Long) As Long

'�O���[�o���q�[�v�֐�
Private Declare PtrSafe Function GlobalAlloc Lib "kernel32" (ByVal wFlags As Long, ByVal dwBytes As LongPtr) As LongPtr
Private Declare PtrSafe Function GlobalLock Lib "kernel32" (ByVal hMem As LongPtr) As LongPtr
Private Declare PtrSafe Function GlobalUnlock Lib "kernel32" (ByVal hMem As LongPtr) As Long
Private Declare PtrSafe Function GlobalSize Lib "kernel32" (ByVal hMem As LongPtr) As LongPtr

'���̑��֐�
Private Declare PtrSafe Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (destination As Any, source As Any, ByVal Length As LongPtr)
Private Declare PtrSafe Function OleCreatePictureIndirect Lib "oleaut32" (ByRef lpPictDesc As PICTDESC, ByRef RefIID As GUID, ByVal fPictureOwnsHandle As LongPtr, ByRef IPic As IPicture) As Long
Private Declare PtrSafe Function CopyImage Lib "user32" (ByVal handle As LongPtr, ByVal un1 As Long, ByVal n1 As Long, ByVal n2 As Long, ByVal un2 As Long) As LongPtr
Private Declare PtrSafe Sub Sleep Lib "kernel32" (ByVal ms As LongPtr)

Private Type POINTAPI
    X As Long
    Y As Long
End Type

Private Type DROPFILES
    pFiles As Long
    pt As POINTAPI
    fNC As Long
    fWide As Long
End Type

Private Type PICTDESC
    cbSizeofStruct As Long
    picType        As Long
    hImage         As LongPtr
    Option1        As LongPtr
    Option2        As LongPtr
End Type
Private Type GUID
    Data1          As Long
    Data2          As Integer
    Data3          As Integer
    Data4(7)       As Byte
End Type

Private Const CF_TEXT As Long = 1
Private Const CF_HDROP As Long = 15
Private Const CF_BITMAP      As Long = 2
Private Const CF_PALETTE     As Long = 9
Private Const CF_UNICODETEXT As Long = 13

Private Const CC_RGBINIT = &H1                '�F�̃f�t�H���g�l��ݒ�
Private Const CC_LFULLOPEN = &H2              '�F�̍쐬���s��������\��
Private Const CC_PREVENTFULLOPEN = &H4        '�F�̍쐬�{�^���𖳌��ɂ���
Private Const CC_SHOWHELP = &H8               '�w���v�{�^����\��

Private Const IMAGE_BITMAP As Long = 0
Private Const LR_COPYRETURNORG As Long = &H4
'**
' �R�s�[�A�h���X�̎擾
'**
Private Function getObjectLink() As String

    Dim p As LongPtr
    Dim hMem As LongPtr
    Dim lngDataLen As LongPtr
    Dim lngRet As LongPtr

    Const MAXSIZE = 4096
    Dim MyString As String
    Dim size As Long
    Dim data() As Byte
    Dim i As Long
  
    '�N���b�v�{�[�h���I�[�v��
    If OpenClipboard(0&) <> 0 Then
    
        hMem = GetClipboardData(RegisterClipboardFormat("ObjectLink"))
        
        If hMem <> 0 Then
        
            size = CLng(GlobalSize(hMem))
            p = GlobalLock(hMem)
            
            If p <> 0 Then
                
                ReDim data(0 To size - 1)
                Call CopyMemory(data(0), ByVal p, size)
                
                Call GlobalUnlock(hMem)
                
                For i = 0 To size - 1
                    If data(i) = 0 Then
                        data(i) = &H9
                    End If
                Next i
                MyString = StrConv(data(), vbUnicode)
                
            End If
        
        End If
        
        CloseClipboard
    
    End If
    
    getObjectLink = MyString

End Function
'--------------------------------------------------------------
'�N���b�v�{�[�h���N���A����
'--------------------------------------------------------------
Public Sub ClearClipboard()

    If OpenClipboard(0&) <> 0 Then
        Call EmptyClipboard
        Call CloseClipboard
    End If

End Sub
'----------------------------------------------------------------------
' �N���b�v�{�[�h�̃r�b�g�}�b�v�f�[�^���� Picture �I�u�W�F�N�g���쐬
'----------------------------------------------------------------------
Public Function CreatePictureFromClipboard(o As Object) As StdPicture
  
    Dim hImg      As LongPtr
    Dim hPalette As LongPtr
    Dim hCopy As LongPtr
    
    Dim uPictDesc As PICTDESC
    Dim uGUID     As GUID
    
    Set CreatePictureFromClipboard = Nothing
  
    On Error GoTo e
    
    '�N���b�v�{�[�h�̕ۑ�
    If OpenClipboard(0&) <> 0 Then
        Call EmptyClipboard
        Call CloseClipboard
    End If
    
    '�w��V�F�C�v���r�b�g�}�b�v�ŃN���b�v�{�[�h�ɓ\��t��
10  o.CopyPicture Appearance:=xlScreen, Format:=xlBitmap

    Call CopyClipboardSleep
        
    If IsClipboardFormatAvailable(CF_BITMAP) <> 0 Then
    
        If OpenClipboard(0&) <> 0 Then
            
            hImg = GetClipboardData(CF_BITMAP)
        
            If hImg <> 0 Then
          
                hCopy = CopyImage(hImg, IMAGE_BITMAP, 0, 0, LR_COPYRETURNORG)
                
                With uPictDesc
                    .cbSizeofStruct = Len(uPictDesc)
                    .picType = 1
                    .hImage = hCopy
                    .Option1 = 0&
                End With
                
                With uGUID
                    .Data1 = &H20400
                    .Data4(0) = &HC0
                    .Data4(7) = &H46
                End With
                
                Call OleCreatePictureIndirect(uPictDesc, uGUID, True, CreatePictureFromClipboard)
            
                Call EmptyClipboard
                
            End If
            
            Call CloseClipboard
        End If
        
    End If
    
    '�N���b�v�{�[�h�̕���
    Exit Function
e:
    If Erl = 10 Then
        Resume
    End If
    
End Function
'--------------------------------------------------------------
'�@�N���b�v�{�[�h����t�@�C�������擾
'--------------------------------------------------------------
Public Function GetCopyClipText() As String

    Dim hData As LongPtr
    Dim files As Long
    Dim i As Long
    Dim strFilePath As String
    Dim ret As String
    
    If OpenClipboard(0) <> 0 Then
   
        hData = GetClipboardData(CF_HDROP)
        
        If Not IsNull(hData) Then
            
            '�t�@�C���̐����擾
            files = DragQueryFileW(hData, -1, 0, 0)
            For i = 0 To files - 1 Step 1
                
                '�T�C�Y���擾
                Dim lngSize As Long
                lngSize = DragQueryFileW(hData, i, 0, 0)
                
                'DragQueryFileW�̕ԋp����T�C�Y�͏I�[���܂܂Ȃ�
                strFilePath = String$(lngSize + 1, vbNullChar)
                
                lngSize = DragQueryFileW(hData, i, StrPtr(strFilePath), Len(strFilePath))
                
                If i = 0 Then
                    ret = Left$(strFilePath, lngSize)
                Else
                    ret = ret & vbCrLf & Left$(strFilePath, lngSize)
                End If
            Next
        End If
        Call CloseClipboard
    
    End If
    
    GetCopyClipText = ret
    
End Function
'�N���b�v�{�[�h�Ƀe�L�X�g�f�[�^���������ރv���V�[�W��
Public Sub SetClipText(ByVal strData As String)

  Dim p As LongPtr
  Dim hMem As LongPtr
  Dim lngDataLen As LongPtr
  Dim blnErrflg As Boolean
  Const GMEM_MOVEABLE = 2

  blnErrflg = True
  
  '�N���b�v�{�[�h���I�[�v��
  If OpenClipboard(0&) <> 0 Then
  
    '�N���b�v�{�[�h����ɂ���
    If EmptyClipboard() <> 0 Then
    
        '�I�[������t��
        strData = strData & vbNullChar
    
        '�O���[�o���������ɏ������ޗ̈���m�ۂ��Ă��̃n���h�����擾
        lngDataLen = LenB(strData)
        
        hMem = GlobalAlloc(GMEM_MOVEABLE, lngDataLen)
        
        If hMem <> 0 Then
      
            '�O���[�o�������������b�N���Ă��̃|�C���^���擾
            p = GlobalLock(hMem)
            
            If p <> 0 Then
        
                '�������ރe�L�X�g���O���[�o���������ɃR�s�[
                Call CopyMemory(ByVal p, ByVal StrPtr(strData), lngDataLen)
                
                '�O���[�o���������u���b�N�̃��b�N������
                Call GlobalUnlock(hMem)
                
                If SetClipboardData(CF_UNICODETEXT, hMem) <> 0 Then
                    blnErrflg = False
                End If

            End If
        End If
    End If
    '�N���b�v�{�[�h���N���[�Y(�����Windows�ɐ��䂪
    '�߂�Ȃ������ɂł�����葬�₩�ɍs��)
    Call CloseClipboard
  End If

  If blnErrflg Then Message.Error "�N���b�v�{�[�h�ɏ�񂪏������߂܂���"

End Sub
'�N���b�v�{�[�h����e�L�X�g�f�[�^���擾����v���V�[�W��(Unicode�Ή�)
Public Function GetClipText() As String

    Dim p As LongPtr
    Dim hMem As LongPtr
    Dim lngDataLen As LongPtr
    Dim lngRet As LongPtr
    Dim bytBuf() As Byte

    Dim MyString As String
    Dim blnUnicode As Boolean
  
    blnUnicode = False
    
    '�N���b�v�{�[�h���I�[�v��
    If OpenClipboard(0&) <> 0 Then
    
        hMem = GetClipboardData(CF_UNICODETEXT)
        If hMem <> 0 Then
        
            p = GlobalLock(hMem)
            
            If p <> 0 Then
            
                lngDataLen = GlobalSize(hMem)
                ReDim bytBuf(0 To CLng(lngDataLen - 1))
                
                Call CopyMemory(bytBuf(0), ByVal p, lngDataLen)
                
                Call GlobalUnlock(hMem)
                
                MyString = bytBuf
                MyString = Mid$(MyString, 1, InStr(MyString, vbNullChar) - 1)
            
            End If
        
        End If
        
        lngRet = CloseClipboard()
    
    End If
    
    GetClipText = MyString

End Function

'�N���b�v�{�[�h�Ƀt�@�C���R�s�[�����������ރv���V�[�W��
Public Sub SetCopyClipText(strBuf() As String)

    Dim p As LongPtr
    Dim hMem As LongPtr
    Dim lngDataLen As LongPtr

    Dim blnErrflg As Boolean
    Const GMEM_MOVEABLE = 2
    
    Dim df As DROPFILES
    
    Dim strData As String
    Dim i As Long
    strData = ""
    For i = LBound(strBuf) To UBound(strBuf)
        strData = strData & strBuf(i) & vbNullChar
    Next
    strData = strData & vbNullChar

    blnErrflg = True
  
    '�N���b�v�{�[�h���I�[�v��
    If OpenClipboard(0&) <> 0 Then
  
        '�N���b�v�{�[�h����ɂ���
        If EmptyClipboard() <> 0 Then
    
            '�O���[�o���������ɏ������ޗ̈���m�ۂ��Ă��̃n���h�����擾
            lngDataLen = LenB(strData) + LenB(df)
            
            hMem = GlobalAlloc(GMEM_MOVEABLE, lngDataLen)
            
            If hMem <> 0 Then
            
                '�O���[�o�������������b�N���Ă��̃|�C���^���擾
                p = GlobalLock(hMem)
                
                If p <> 0 Then
                
                    df.pFiles = LenB(df)
                    df.fWide = True 'UNICODE
            
                    '�������ރe�L�X�g���O���[�o���������ɃR�s�[
                    CopyMemory ByVal p, df, LenB(df)
                    CopyMemory ByVal (p + LenB(df)), ByVal StrPtr(strData), LenB(strData)
                    
                    '�N���b�v�{�[�h�Ƀ������u���b�N�̃f�[�^����������
                    If SetClipboardData(CF_HDROP, hMem) <> 0 Then
                        blnErrflg = False
                    End If
                
                    '�O���[�o���������u���b�N�̃��b�N������
                    Call GlobalUnlock(hMem)
                    
                End If
                
            End If
            
            
            '�e�L�X�g���ꏏ�ɏ�������ł���
            strData = ""
            For i = LBound(strBuf) To UBound(strBuf)
                strData = strData & strBuf(i) & vbCrLf
            Next
            strData = strData & vbNullChar
            
            '�O���[�o���������ɏ������ޗ̈���m�ۂ��Ă��̃n���h�����擾
            lngDataLen = LenB(strData)
            
            hMem = GlobalAlloc(GMEM_MOVEABLE, lngDataLen)
            
            If hMem <> 0 Then
            
                '�O���[�o�������������b�N���Ă��̃|�C���^���擾
                p = GlobalLock(hMem)
                
                If p <> 0 Then
            
                    '�������ރe�L�X�g���O���[�o���������ɃR�s�[
                    Call CopyMemory(ByVal p, ByVal StrPtr(strData), lngDataLen)
                    
                    '�O���[�o���������u���b�N�̃��b�N������
                    Call GlobalUnlock(hMem)
    
                    If SetClipboardData(CF_UNICODETEXT, hMem) <> 0 Then
                        blnErrflg = False
                    End If

                End If
            End If
            
        End If
        
        '�N���b�v�{�[�h���N���[�Y(�����Windows�ɐ��䂪
        '�߂�Ȃ������ɂł�����葬�₩�ɍs��)
        Call CloseClipboard
    End If
    
    If blnErrflg Then Message.Error "�N���b�v�{�[�h�ɏ�񂪏������߂܂���"

End Sub
'------------------------------------------------------------------------------------------------------------------------
' CopyPicture��Java�A�v����N���b�v�{�[�h�c�[���ȂǂŎ��s����΍�
'------------------------------------------------------------------------------------------------------------------------
Public Sub CopyClipboardSleep()
    DoEvents
    Sleep Val(Registry.GetSetting("Option", "ClipboardSleep", 0))
End Sub
