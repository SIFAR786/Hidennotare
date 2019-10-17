VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "LinkedList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'-----------------------------------------------------------------------------------------------------
'
' [Hidennotare] v2
'
' Copyright (c) 2019 Yasuhiro Watanabe
' https://github.com/RelaxTools/Hidennotare
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
'>### LinkedList �N���X
'>
'>**Remarks**
'>
'>- Collection ���x�[�X�Ɏ������Ă��邪�A�Y����0����Ȃ̂Œ��ӁB
'>- �s�r���̒ǉ��A�폜�ɋ����ł����A�Y�����ɂ�郉���_���A�N�Z�X�̎ア�ł��B
'>- �ʏ�g�p���郁�\�b�h�͂قƂ�� IList �C���^�[�t�F�C�X���ɂ���̂� IList �̕ϐ��ɑ�����Ďg�����ƂɂȂ�܂��B
'>- ICursor �C���^�[�t�F�[�X�ɑΉ����Ă��葼�� ICursor I/F �Ɠ��l�Ƀ��[�v�\�B
'>**���̃N���X�� Static�N���X(Attribute VB_PredeclaredId = True) �ł��B**
'>
'>**Collection �� LinkedList �Ƃ̔�r**
'>
'>|No.|Property/Method|Collection|LinkedList(�{�N���X)|
'>|---|---|---|---|
'>|1|Add|�Z|Add��Insert�ɕ���|
'>|2|Item|�Z|�Z|
'>|3|Remove|�Z|RemoveAt|
'>|4|Count|�Z|�Z|
'>|5|Sort|�~|�Z|
'>|6|ToArray|�~|�Z|
'>|7|ToCollection|�~|�Z|
'>|8|ToString|�~|�Z|
'>
'>**Implements**
'>* IList
'>* ICursor
'>* INewInstance
'>
'>**Sample**
'>```
'> intUbound = LinkedList.TryUBound(aray)
'>
'> Dim list As IList
'> Set list = New LinkedList
'>
'> Dim list As IList
'> Set list = LinkedList.CreateObject(�R���N�V����)
'>
'> Dim list As IList
'> Set list = LinkedList.CreateObject(�P�����z��)
'>```
'>**Dependent**
'>
'>* ICursor
'>* IList
'>* INewInstance
'>
'>**History**
'>
'>|Date|Version|Note|
'>|---|---|---|
'>|2019-08-08|Ver.1.0.0|�V�K�쐬|
'>
'-----------------------------------------------------------------------------------------------------
Option Explicit
Implements ICursor
Implements IList
Implements INewInstance

Private mCol As Collection
Private mIndex As Long
'--------------------------------------------------------------
' Initialize
'--------------------------------------------------------------
Private Sub Class_Initialize()
    Set mCol = New Collection
    mIndex = 0
End Sub
'--------------------------------------------------------------
' Terminate
'--------------------------------------------------------------
Private Sub Class_Terminate()
    Set mCol = Nothing
End Sub
'>---
'>#### �R���X�g���N�^(1) Collection
'>
'>**Syntax**
'>
'>```
'>Set ret = LinkedList.CreateObject(collection)
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|collection|�K�{|Collection|���������R���N�V������LinkedList�̏����l�Ƃ��Đݒ�|
'>
'>**Return Value**
'>
'>|Name|Data type|Description|
'>---|---|---
'>|ret|Object|�V�����C���X�^���X(LinkedList)|
'>
'>**Remarks**
'>
'>�R���N�V�������� LinkedList �𐶐�����ꍇ
'>
'>**Example**
'>
'>* None
'>
'>**See also**
'>
'>* None
'>
'>---
'>#### �R���X�g���N�^(2) Array
'>
'>**Syntax**
'>
'>```
'>Set ret = LinkedList.CreateObject(Array)
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|Array|�K�{|�z��|�z�������LinkedList�̏����l�Ƃ��Đݒ�|
'>
'>**Return Value**
'>
'>|Name|Data type|Description|
'>---|---|---
'>|ret|Object|�V�����C���X�^���X(LinkedList)|
'>
'>**Remarks**
'>
'>�z�񂩂� LinkedList �𐶐�����ꍇ
'>
'>**Example**
'>
'>* None
'>
'>**See also**
'>
'>* None
'>
Public Function CreateObject(ParamArray Args() As Variant) As IList

    Dim cnt As Long
    Dim lngValue As Long
    Dim lngMin As Long
    Dim lngMax As Long
    Dim lngCount As Long
    Dim var As Variant
    Dim v As Variant
    Dim i As Long
    
    var = Args
    
    lngMin = 0
    lngMax = -1
    
    Dim IL As IList
    
    If Core.TryLBound(var, lngValue) Then
        lngMin = lngValue
    End If
    
    If Core.TryUBound(var, lngValue) Then
        lngMax = lngValue
    End If
    
    lngCount = lngMax + 1

    Set IL = New LinkedList
    IL.Clear
    
    Select Case lngCount
        Case 0
        Case 1
        
            Select Case True
                
                '�R���N�V��������̕ϊ�
                Case TypeOf Args(0) Is Collection
                    
                    IL.Clear
                    For Each v In Args(0)
                        IL.Add v
                    Next
                
                '�P�����z�񂩂�̕ϊ�
                Case IsArray(Args(0))
                
                    For Each v In Args(0)
                        IL.Add v
                    Next
                
                Case Else
                
                    IL.Add Args(0)
            
            End Select
            
        Case Else
            
            For i = lngMin To lngMax
                IL.Add Args(i)
            Next
    
    End Select

    Set CreateObject = IL

End Function

'>---
'>#### Clear(IList I/F)
'>
'>**Syntax**
'>
'>```
'>expression.Clear
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|expression|�K�{|IList I/F|IList I/F�̃C���X�^���X|
'>
'>**Return Value**
'>
'>* None
'>
'>**Remarks**
'>
'>IList I/F �̃��\�b�h�ł��B<br>
'>LinkedList�̑S���ڂ��N���A���܂��B
'>
'>**Example**
'>
'>* None
'>
'>**See also**
'>
'>* IList
'>
Private Sub IList_Clear()

    Set mCol = New Collection
    mIndex = 0
    
End Sub
'>---
'>#### Add(IList I/F)
'>
'>**Syntax**
'>
'>```
'>expression.Add(var)
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|expression|�K�{|IList|IList I/F �̃C���X�^���X|
'>|var|�K�{|Variant|�ǉ�����ϐ����w�肵�܂��B|
'>
'>**Return Value**
'>
'>* None
'>
'>**Remarks**
'>
'>IList I/F �̃��\�b�h�ł��B<br>
'>LinkedList �ɍ��ڂ�ǉ�����B
'>
'>**Example**
'>
'>* None
'>
'>**See also**
'>
'>* IList
'>
Private Sub IList_Add(obj As Variant)
    
    mCol.Add obj

End Sub
'>---
'>#### Insert(IList I/F)
'>
'>**Syntax**
'>
'>```
'>expression.Insert(index, var)
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|expression|�K�{|IList|IList I/F �̃C���X�^���X|
'>|index|�K�{|long|�ǉ�����ʒu���w�肵�܂��B|
'>|var|�K�{|Variant|�ǉ�����ϐ����w�肵�܂��B|
'>
'>**Return Value**
'>
'>* None
'>
'>**Remarks**
'>
'>IList I/F �̃��\�b�h�ł��B<br>
'>LinkedList �̎w��ʒu�ɍ��ڂ�ǉ�����B
'>
'>**Example**
'>
'>* None
'>
'>**See also**
'>
'>* IList
'>
Private Sub IList_Insert(idx As Long, v As Variant)

    If idx < 0 Or idx >= mCol.Count Then
        Err.Raise 512 + 1, TypeName(Me) & ".Insert", "IndexOutOfRangeException"
    End If
    
    mCol.Add v, , idx + 1

End Sub
'--------------------------------------------------------------
' For Each �p
'--------------------------------------------------------------
Private Function IList_NewEnum() As stdole.IUnknown
    Set IList_NewEnum = mCol.[_NewEnum]
End Function
'>---
'>#### Count(IList I/F)
'>
'>**Syntax**
'>
'>```
'>var = expression.Count
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|expression|�K�{|IList|IList I/F �̃C���X�^���X|
'>
'>**Return Value**
'>
'>|Name|Data type|Description|
'>---|---|---
'>|var|Long|LinkedList�̗v�f����ԋp|
'>
'>**Remarks**
'>
'>IList I/F �̃v���p�e�B�ł��B<br>
'>LinkedList �v�f����ԋp
'>
'>**Example**
'>
'>* None
'>
'>**See also**
'>
'>* IList
'>
Private Property Get IList_Count() As Long
    IList_Count = mCol.Count
End Property
'>---
'>#### Item(IList I/F)
'>
'>**Syntax**
'>
'>```
'>var = expression.Item(idx)
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|expression|�K�{|IList|IList I/F �̃C���X�^���X|
'>|idx|�K�{|IList|Long|�擾���鍀�ڂ̈ʒu���w�肵�܂��B|
'>
'>**Return Value**
'>
'>|Name|Data type|Description|
'>---|---|---
'>|var|Variant|LinkedList �̎w��ʒu�̍���|
'>
'>**Remarks**
'>
'>IList I/F �̃v���p�e�B�ł��B<br>
'>LinkedList �̎w��ʒu�̍��ڂ��擾
'>
'>**Example**
'>
'>* None
'>
'>**See also**
'>
'>* IList
'>
Private Property Get IList_Item(idx As Long) As Variant
    
    If idx < 0 Or idx >= mCol.Count Then
        Err.Raise 512 + 1, TypeName(Me) & ".Item", "IndexOutOfRangeException"
    End If

    Core.SetVar(IList_Item) = mCol.Item(idx + 1)
    
End Property
'>---
'>#### RemoveAt(IList I/F)
'>
'>**Syntax**
'>
'>```
'>expression.RemoveAt(idx)
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|expression|�K�{|IList|IList I/F �̃C���X�^���X|
'>|idx|�K�{|IList|Long|�폜���鍀�ڂ̈ʒu���w�肵�܂��B|
'>
'>**Return Value**
'>
'>* None
'>
'>**Remarks**
'>
'>IList I/F �̃��\�b�h�ł��B<br>
'>LinkedList �̎w��ʒu�̍��ڂ��폜
'>
'>**Example**
'>
'>* None
'>
'>**See also**
'>
'>* IList
'>
Private Sub IList_RemoveAt(idx As Long)
    
    If idx < 0 Or idx >= mCol.Count Then
        Err.Raise 512 + 1, TypeName(Me) & ".RemoveAt", "IndexOutOfRangeException"
    End If
    
    mCol.Remove idx + 1
End Sub
'>---
'>#### Sort(IList I/F)
'>
'>**Syntax**
'>
'>```
'>expression.Sort([cp = Nothing])
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|expression|�K�{|IList|IList I/F �̃C���X�^���X|
'>|CP|�ȗ���|IComparer|�\�[�g�������w�肵�܂��B�ȗ�����BinaryCompare�ł��B|
'>
'>**Return Value**
'>
'>* None
'>
'>**Remarks**
'>
'>IList I/F �̃��\�b�h�ł��B<br>
'>LinkedList �̎w��ʒu�̍��ڂ��폜
'>
'>**Example**
'>
'>* None
'>
'>**See also**
'>
'>* IList
'>
Private Sub IList_Sort(Optional ByVal CP As IComparer = Nothing)

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
'>---
'>#### ToArray(IList I/F)
'>
'>**Syntax**
'>
'>```
'>var = expression.ToArray()
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|expression|�K�{|IList|IList I/F �̃C���X�^���X|
'>
'>**Return Value**
'>
'>|Name|Data type|Description|
'>---|---|---
'>|var|Variant|�z���ԋp|
'>
'>**Remarks**
'>
'>IList I/F �̃��\�b�h�ł��B<br>
'>LinkedList ���P�`�Q�����z��ɕϊ�
'>
'>**Example**
'>
'>* None
'>
'>**See also**
'>
'>* IList
'>
Private Function IList_ToArray() As Variant

    Dim v As Variant
    Dim s As Variant
    Dim lngRow As Long
    Dim lngCol As Long
    Dim i As Long
    Dim j As Long
    Dim result As Variant
    Dim lst As IList
    
    result = Array()
    
    lngRow = mCol.Count
    lngCol = 0
    
    Set lst = Me
    
    'Dictionary or LinkedList �̂Q������z��
    For Each v In lst
        If Core.IsDictionary(v) Or Core.IsList(v) Then
            If lngCol < v.Count Then
                lngCol = v.Count
            End If
        End If
    Next

    Select Case True
        Case lngRow = 0
    
            IList_ToArray = Empty

        '1D�̏ꍇ
        Case lngRow > 0 And lngCol = 0
        
            ReDim result(0 To lngRow - 1)
        
            For i = 0 To lst.Count - 1
                Core.SetVar(result(i)) = lst(i)
            Next
    
            IList_ToArray = result
        
        '2D�̏ꍇ
        Case lngRow > 0 And lngCol > 0
        
            ReDim result(0 To lngRow - 1, 0 To lngCol - 1)
        
            For i = 0 To lst.Count - 1
            
                Select Case True
                    'List�n�̏ꍇ
                    Case Core.IsList(lst(i))
                        For j = 0 To lst(i).Count - 1
                            Core.SetVar(result(i, j)) = lst(i)(j)
                        Next
                    
                    'Dictionary�n�̏ꍇ
                    Case Core.IsDictionary(lst(i))
                        Dim dic As Object
                        Dim Key As Variant
                        
                        Set dic = lst(i)
                        
                        j = 0
                        For Each Key In dic.Keys
                            Core.SetVar(result(i, j)) = dic.Item(Key)
                            j = j + 1
                        Next
                
                End Select
                
            Next
    
            IList_ToArray = result
    End Select
    
End Function
'>---
'>#### ToCollection(IList I/F)
'>
'>**Syntax**
'>
'>```
'>var = expression.ToCollection()
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|expression|�K�{|IList|IList I/F �̃C���X�^���X|
'>
'>**Return Value**
'>
'>|Name|Data type|Description|
'>---|---|---
'>|var|Collection|Collection��ԋp|
'>
'>**Remarks**
'>
'>IList I/F �̃��\�b�h�ł��B<br>
'>LinkedList ��Collection�ɕϊ�
'>
'>**Example**
'>
'>* None
'>
'>**See also**
'>
'>* IList
'>
Private Function IList_ToCollection() As Collection
    
    Set IList_ToCollection = mCol

End Function
'>---
'>#### ToString(IList I/F)
'>
'>**Syntax**
'>
'>```
'>var = expression.ToString()
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|expression|�K�{|IList|IList I/F �̃C���X�^���X|
'>
'>**Return Value**
'>
'>|Name|Data type|Description|
'>---|---|---
'>|var|String|JSON�������ԋp|
'>
'>**Remarks**
'>
'>IList I/F �̃��\�b�h�ł��B<br>
'>LinkedList ��JSON�ɕϊ�
'>
'>**Example**
'>
'>* None
'>
'>**See also**
'>
'>* IList
'>
Private Function IList_ToString() As String

    Dim v As Variant
    Dim SB As StringBuilder
    Set SB = New StringBuilder
    
    For Each v In mCol
    
        Select Case True
            Case IsObject(v)
                
                SB.Append v.ToString
            
            Case IsEmpty(v)
                
                SB.Append "null"
            
            Case Else
                Select Case VarType(v)
                    
                    Case vbBoolean
        
                        SB.Append LCase(CStr(v))
        
                    Case vbString
                    
                        SB.Append """" & Escape(v) & """"
                    
#If Win64 Then
                    Case vbByte, vbInteger, vbLong, vbSingle, vbDouble, vbCurrency, vbDecimal, vbLongLong
#Else
                    Case vbByte, vbInteger, vbLong, vbSingle, vbDouble, vbCurrency, vbDecimal
#End If
                        SB.Append CStr(v)
        
                    Case Else
        
                        '�G���[
                        Err.Raise 512 + 1, TypeName(Me) & ".ToString", "don't cast type (" & TypeName(v) & ")"
        
                End Select
        End Select
        
    Next

    IList_ToString = SB.ToString(", ", "[", "]")

End Function
'>---
'>#### GetCursor(IList I/F)
'>
'>**Syntax**
'>
'>```
'>Set var = expression.GetCursor()
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|expression|�K�{|IList|IList I/F ���w�肵�܂��B|
'>
'>**Return Value**
'>
'>|Name|Data type|Description|
'>---|---|---
'>|var|ICursor|ICursor I/F ��ԋp|
'>
'>**Remarks**
'>
'>IList I/F �̃��\�b�h�ł��B<br>
'>ICursor �C���^�[�t�F�[�X���擾
'>
'>**Example**
'>
'>* None
'>
'>**See also**
'>
'>* IList
'>* ICursor
'>
Private Property Get IList_GetCursor() As ICursor
    Set IList_GetCursor = Me
End Property
'>---
'>#### Eof(ICursor I/F)
'>
'>**Syntax**
'>
'>```
'>var = expression.Eof()
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|expression|�K�{|ICursor|ICursor I/F ���w�肵�܂��B|
'>
'>**Return Value**
'>
'>|Name|Data type|Description|
'>---|---|---
'>|var|Boolean|�J�[�\�����I��:True / �J�[�\�����I�����Ă��Ȃ�:False|
'>
'>**Remarks**
'>
'>ICursor I/F �̃v���p�e�B�ł��B<br>
'>ICursor �� Eof �v���p�e�B���擾�B�J�[�\���̏I�������o���܂��B
'>
'>**Example**
'>
'>* None
'>
'>**See also**
'>
'>* ICursor
'>
Private Property Get ICursor_Eof() As Boolean
    ICursor_Eof = mIndex >= mCol.Count
End Property
'>---
'>#### Item(ICursor I/F)
'>
'>**Syntax**
'>
'>```
'>var = expression.Item()
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|expression|�K�{|ICursor|ICursor I/F ���w�肵�܂��B|
'>
'>**Return Value**
'>
'>|Name|Data type|Description|
'>---|---|---
'>|var|Variant|�J�[�\���ʒu�̓��e���擾���܂��B|
'>
'>**Remarks**
'>
'>ICursor I/F �̃v���p�e�B�ł��B<br>
'>ICursor �� Item �v���p�e�B���擾�B���ݍs�̓��e���擾���܂��B
'>
'>**Example**
'>
'>* None
'>
'>**See also**
'>
'>* ICursor
'>
Private Property Get ICursor_Item(Optional ByVal opt As Variant) As Variant
    
    If mIndex >= mCol.Count Then
        Core.SetVar(ICursor_Item) = mCol(mCol.Count)
    Else
        Core.SetVar(ICursor_Item) = mCol.Item(mIndex + 1)
    End If
    
End Property
'>---
'>#### MoveFirst(ICursor I/F)
'>
'>**Syntax**
'>
'>```
'>expression.MoveFirst()
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|expression|�K�{|ICursor|ICursor I/F ���w�肵�܂��B|
'>
'>**Return Value**
'>
'>* None
'>
'>**Remarks**
'>
'>ICursor I/F �̃��\�b�h�ł��B<br>
'>�J�[�\���ʒu�̏��������s���܂��B
'>
'>**Example**
'>
'>* None
'>
'>**See also**
'>
'>* ICursor
'>
Private Sub ICursor_MoveFirst()
    mIndex = 0
End Sub
'>---
'>#### MoveNext(ICursor I/F)
'>
'>**Syntax**
'>
'>```
'>expression.MoveNext()
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|expression|�K�{|ICursor|ICursor I/F ���w�肵�܂��B|
'>
'>**Return Value**
'>
'>* None
'>
'>**Remarks**
'>
'>ICursor I/F �̃��\�b�h�ł��B<br>
'>�J�[�\���ʒu�����Ɉړ����܂��B
'>
'>**Example**
'>
'>* None
'>
'>**See also**
'>
'>* ICursor
'>
Private Sub ICursor_MoveNext()

    mIndex = mIndex + 1
    If mIndex > mCol.Count Then
        mIndex = mCol.Count
    End If

End Sub
'>---
'>#### NewInstance(INewInstance I/F)
'>
'>**Syntax**
'>
'>```
'>Set var = expression.NewInstance()
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|expression|�K�{|ICursor|INewInstance I/F ���w�肵�܂��B|
'>
'>**Return Value**
'>
'>|Name|Data type|Description|
'>---|---|---
'>|var|Object|�V����LinkedList�̃C���X�^���X(IList I/F)|
'>
'>**Remarks**
'>
'>INewInstance I/F �̃��\�b�h�ł��B<br>
'>�V�����C���X�^���X(IList I/F)�𐶐����ĕԋp���܂��B
'>
'>**Example**
'>
'>* None
'>
'>**See also**
'>
'>* IList
'>* INewInstance
'>
Private Function INewInstance_NewInstance() As Object

    Dim lst As IList
    
    Set lst = New LinkedList
    
    Set INewInstance_NewInstance = lst

End Function
Private Function Escape(ByVal v As String) As String

    Dim strChr As String
    Dim SB As StringBuilder
    Dim i As Long
    
    Set SB = New StringBuilder
    
    For i = 1 To Len(v)
        
        strChr = Mid$(v, i, 1)
        
        Select Case AscW(strChr)
            Case &H0 To &H7, &HB, &HE To &H1F, &H7F
                SB.Append "\u" & Hex$(AscW(strChr))
            Case &H8
                SB.Append "\b"
            Case &H9
                SB.Append "\t"
            Case &HA
                SB.Append "\n"
            Case &HC
                SB.Append "\f"
            Case &HD
                SB.Append "\r"
            Case &H22
                SB.Append "\"""
            Case &H2F
                SB.Append "\/"
            Case &H5C
                SB.Append "\\"
            Case Else
                SB.Append strChr
        End Select

    Next
    
    Escape = SB.ToString

End Function
'>---
'>#### CopyToListbox(LinkedList)
'>
'>**Syntax**
'>
'>```
'>LinkedList.CopyToListbox objList
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|objList|�K�{|Object|copy���� ListBox or ComboBox ���w��|
'>
'>**Return Value**
'>
'>* None
'>
'>**Remarks**
'>
'>ListBox/ComboBox �փR�s�[<br>
'>LinkedList�̓��e��ListBox/ComboBox�ɃR�s�[����B<br>
'>ListBox/ComboBox��Tag��LinkedList�̃��R�[�h��Ή��Â���t�B�[���h�����X�g�i�J���}��؂�j���K�{�B<br>
'>���R�[�h�Ɏg�p����I�u�W�F�N�g�� INewInstance �� ICompatibleProperty �� Implements �����N���X�ł��邱�ƁB
'>
'>**Example**
'>
'>```
'>    '����̓R�[�h�ł͂Ȃ��v���p�e�B�E�B���h�E�Őݒ肵�Ă��ǂ�
'>    lstFavorite.Tag = "No,Name,Address"
'>
'>    LinkedList.CopyToListbox lstFavorite
'>
'>```
'>
'>**See also**
'>
'>* LinkedList.ParseFromListbox
'>* Dictionary
'>* INewInstance
'>* ICompatibleProperty
'>
Public Sub CopyToListbox(objList As Object)

    Dim ary As IList
    Dim objRec As Object
    Dim Fields As Variant
    Dim v As Variant

    'Tag�Ƀt�B�[���h��񂪖����ꍇ
    If objList.Tag = "" Then
        Err.Raise 512 + 1, TypeName(Me) & ".CopyToListbox", "Item name is not set in tag"
    End If

    '�z��ɕϊ�
    Fields = Split(objList.Tag, ",")

    '1�����ڂ�LinkedList�Œ�
    Set ary = Me

    '���X�g�{�b�N�X�̃N���A
    objList.Clear

    Dim i As Long
    Dim j As Long
    i = 0
    For Each objRec In ary
        j = 0
        objList.AddItem
        For Each v In Fields

            '�ݒ肳��Ă���t�B�[���h�̂݃R�s�[����B
            If v <> "" Then
                objList.List(i, j) = CoreEx.CastICompatibleProperty(objRec).GetProperty(v)
            End If
            j = j + 1
        Next
        i = i + 1
    Next

End Sub
'>---
'>#### CopyToListObject(LinkedList)
'>
'>**Syntax**
'>
'>```
'>LinkedList.CopyToListObject objList
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|objList|�K�{|Object|copy���� ListBox or ComboBox ���w��|
'>
'>**Return Value**
'>
'>* None
'>
'>**Remarks**
'>
'>ListObject(�e�[�u���@�\)�փR�s�[<br>
'>LinkedList�̓��e��Listobject�ɃR�s�[����B<br>
'>Listobject��LinkedList�̃��R�[�h��Ή��Â���񖼂��K�{�B<br>
'>���R�[�h�Ɏg�p����I�u�W�F�N�g�� INewInstance �� ICompatibleProperty �� Implements �����N���X�ł��邱�ƁB
'>
'>**Example**
'>
'>```
'>Sub LinkedList_ParseFromListObject_Sample()
'>
'>    Dim lst As IList
'>    Dim dic As IDictionary
'>    Dim Key As Variant
'>
'>    Set lst = LinkedList.ParseFromListObject(ActiveSheet.ListObjects(1))
'>
'>    For Each dic In lst
'>
'>        For Each Key In dic.Keys
'>
'>            Debug.Print dic.Item(Key)
'>
'>        Next
'>
'>    Next
'>
'>    Dim a As LinkedList
'>
'>    Set a = lst
'>
'>    a.CopyToListObject ActiveSheet.ListObjects(2)
'>
'>End Sub
'>```
'>
'>**See also**
'>
'>* LinkedList.ParseFromListbox
'>* Dictionary
'>* INewInstance
'>* ICompatibleProperty
'>
Public Sub CopyToListObject(LO As ListObject)

    Dim lst As IList
    Dim objRec As Object
    Dim Fields As Variant
    Dim v As Variant

    '1�����ڂ�LinkedList�Œ�
    Set lst = Me

    '���X�g�I�u�W�F�N�g�̃N���A
    If Not LO.DataBodyRange Is Nothing Then
        LO.DataBodyRange.ClearContents
        LO.DataBodyRange.Delete
    End If
    
    Dim i As Long
    Dim j As Long
    
    i = 1
    For Each objRec In lst
        
        LO.ListRows.Add
        For j = 1 To LO.HeaderRowRange.Columns.Count

            LO.DataBodyRange.Cells(i, j).Value = CoreEx.CastICompatibleProperty(objRec).GetProperty(LO.HeaderRowRange(, j).Value)
        
        Next
        i = i + 1
    Next

End Sub
'>---
'>#### CopyToRange(LinkedList)
'>
'>**Syntax**
'>
'>```
'>LinkedList.CopyToRange objct
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|object|�K�{|Range|copy����V�[�g�͈̔�(Range)�̍�����w��|
'>
'>**Return Value**
'>
'>* None
'>
'>**Remarks**
'>
'>LinkedList���V�[�g�֓\��t����<br>
'>�w�肳�ꂽRange���N�_��LinkedList�̓��e��\��t����<br>
'>Listobject��LinkedList�̃��R�[�h��Ή��Â���񖼂��K�{�B<br>
'>���R�[�h�Ɏg�p����I�u�W�F�N�g�� INewInstance �� ICompatibleProperty �� Implements �����N���X�ł��邱�ƁB
'>
'>**Example**
'>
'>* None
'>
'>**See also**
'>
'>* LinkedList.ParseFromListbox
'>* Dictionary
'>* INewInstance
'>* ICompatibleProperty
'>
Public Sub CopyToRange(TopLeft As Range)

    Dim v As Variant
    Dim lngRow As Long
    Dim lngCol As Long
    
    v = IList_ToArray
    
    If Not Core.TryUBound(v, lngRow, 1) Then
        Exit Sub
    End If
    If Not Core.TryUBound(v, lngCol, 2) Then
        Exit Sub
    End If

    TopLeft.resize(lngRow + 1, lngCol + 1).Value = v

End Sub
'>---
'>#### GetIList(LinkedList)
'>
'>**Syntax**
'>
'>```
'> Set obj = LinkedList.GetIList()
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|object|�K�{|Object|IList I/F �ɑΉ�����N���X|
'>
'>**Return Value**
'>
'>|Name|Data type|Description|
'>---|---|---
'>|obj|IList|���݂̃C���X�^���X(IList I/F)|
'>
'>**Remarks**
'>
'>IList I/F ���擾����B
'>
'>**Example**
'>
'>* None
'>
'>**See also**
'>
'>* IList
'>
Public Function GetIList() As IList
    Set GetIList = Me
End Function
