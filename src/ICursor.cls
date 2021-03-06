VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ICursor"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
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
'>### ICursor インターフェイス
'>
'>**Remarks**
'>
'>SheetCursor, TableCursor, CharCursor等 Cursor 系の動作を定義したインターフェイス
'>
'>**Definition**
'>
'>```
'>Public Property Get Eof() As Boolean
'>Public Sub MoveFirst()
'>Public Sub MoveNext()
'>Public Property Get Item(Optional ByVal opt As Variant) As Variant
'>    'Attribute Item.VB_UserMemId = 0
'>```
'>
'>**Sample**
'>```
'>Dim IC as ICursor
'>
'>Set IC = TableCursor.CreateObject(WS.ListObjects(1))
'>
'>Do Until IC.Eof
'>
'>    Debug.Print IC
'>
'>    IC.MoveNext
'>Loop
'>```
'>
'-----------------------------------------------------------------------------------------------------
Option Explicit

Public Property Get Eof() As Boolean: End Property

Public Sub MoveFirst(): End Sub

Public Sub MoveNext(): End Sub

Public Property Get Item(Optional ByVal opt As Variant) As Variant
Attribute Item.VB_UserMemId = 0
    'Attribute Item.VB_UserMemId = 0
End Property
