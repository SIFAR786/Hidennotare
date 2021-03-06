VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "MCsv"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
'-----------------------------------------------------------------------------------------------------
'
' [MLangBuilder] v1
'
' Copyright (c) 2019 Yasuhiro Watanabe
' https://github.com/RelaxTools/MFunctionCreater
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
'>### MCsv クラス
'>
'>**Remarks**
'>
'>MCsv<br>
'>Power Query M Language Csv Class<br>
'>M言語をVBAで組み立てる際に便利なクラス<br>
'>
'>**Dependent**
'>
'>* StringBuilder
'>* MTable
'>
'>**History**
'>
'>|Date|Version|Note|
'>|---|---|---|
'>|2019-01-01|Ver.1.0.0|新規作成|
'>
'-----------------------------------------------------------------------------------------------------
Option Explicit
'>---
'>#### Document(MCsv)
'>
'>**Syntax**
'>
'>```
'>Set var = expression.Document(source, [opt])
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|expression|必須|MCsv|MCsvインスタンスを指定|
'>|source|必須|String|データソースを指定|
'>|opt|必須|String|オプション文字列を指定|
'>
'>**Return Value**
'>
'>|Name|Data type|Description|
'>---|---|---
'>|var|MTable|テーブルオブジェクト|
'>
'>**Remarks**
'>
'>Documentメソッド<br>
'>
'>**See also**
'>
'>* None
'>
Public Function Document(f As String, Optional m As Variant) As MTable

    Dim strMFunc As String
    
    If IsMissing(m) Then
        strMFunc = ""
    Else
        If TypeOf m Is MRecord Then
            strMFunc = ", " & m.ToString()
        Else
            strMFunc = ", " & CStr(m)
        End If
    End If
    
    Set Document = MTable.CreateObject(GetClassName & "Document(" & f & strMFunc & ")")

End Function
'---------------------------------------
' クラス名取得
'---------------------------------------
Private Function GetClassName() As String
    GetClassName = Mid$(TypeName(Me), 2) & "."
End Function
