#cs
	Copyright (c) 2020 TarreTarreTarre <tarre.islam@gmail.com>
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
#ce
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w 7
#include-once


; #FUNCTION# ====================================================================================================================
; Name ..........: _Event
; Description ...: A simple event dispatcher, inspired from Laravel's observer events
; Syntax ........: _Event(Const $sEventName[, $payload = Null])
; Parameters ....: $sEventName          - [const] a user defined function.
;                  $payload             - [optional] mixed value. Default is Null.
; Return values .: True if no error occured. @error 1 = $sEventName is not a valid function callback, @error 2 = One or more listeners failed to be invoked
; Author ........: TarreTarreTarre
; Modified ......:
; Remarks .......: If @error = 2, @extended will display how many events failed
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Event(Const $sEventName, Const $payload = Null)

	If Not IsFunc($sEventName) Then Return SetError(1, 0, False)

	; Define empty object and the string name of our event
	Local Const $oEvent = ObjCreate("Scripting.Dictionary")
	Local Const $sFuncName = FuncName($sEventName)

	; Invoke user defined event
	$sEventName($oEvent)

	; Override payload
	If $oEvent.exists("payload") Then $oEvent.remove("payload")
	$oEvent.add("payload", $payload)

	; Look for listeners
	Local Const $aListeners = StringSplit($oEvent.item("listeners"), ",")

	; define failiure counter
	Local $nFailures = 0

	; Loop thru all event listener
	For $i = 1 To $aListeners[0]

		; Define listener callback string
		Local $sListenerFuncName = $sFuncName & "_" & $aListeners[$i]

		; Invoke event listener
		Call($sListenerFuncName, $oEvent)

		; Report errors
		If @error == 0xDEAD And @extended == 0xBEEF Then
			$nFailures += 1
		EndIf
	Next

	; Destruct event object
	$oEvent.removeAll()

	; report any failures
	If $nFailures > 0 Then Return SetError(2, $nFailures, False)

	Return True
EndFunc   ;==>_Event
