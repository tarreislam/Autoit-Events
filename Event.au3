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

Global Const $g__Event_Listeners = ObjCreate("Scripting.Dictionary")

; #FUNCTION# ====================================================================================================================
; Name ..........: _Event
; Description ...: Dispatch an event with up to 6 params
; Syntax ........: _Event(Const $callableEvent[, $p1 = Default[, $p2 = Default[, $p3 = Default[, $p4 = Default[, $p5 = Default[,
;                  $p6 = Default]]]]]])
; Parameters ....: $callableEvent          - [const] an unknown value.
;                  $p1                  - [optional] a pointer value. Default is Default.
;                  $p2                  - [optional] a pointer value. Default is Default.
;                  $p3                  - [optional] a pointer value. Default is Default.
;                  $p4                  - [optional] a pointer value. Default is Default.
;                  $p5                  - [optional] a pointer value. Default is Default.
;                  $p6                  - [optional] a pointer value. Default is Default.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......: _Event_Listen
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Event(Const $callableEvent, Const $p1 = Default, Const $p2 = Default, Const $p3 = Default, Const $p4 = Default, Const $p5 = Default, Const $p6 = Default)

	Local Const $oObj = ObjCreate("Scripting.Dictionary")
	Local Const $sEventName = FuncName($callableEvent)

	; Invoke event
	Switch @NumParams - 1 ; -1 to exclude eventName
		Case 0
			$callableEvent($oObj)
		Case 1
			$callableEvent($oObj, $p1)
		Case 2
			$callableEvent($oObj, $p1, $p2)
		Case 3
			$callableEvent($oObj, $p1, $p2, $p3)
		Case 4
			$callableEvent($oObj, $p1, $p2, $p3, $p4)
		Case 5
			$callableEvent($oObj, $p1, $p2, $p3, $p4, $p5)
		Case 6
			$callableEvent($oObj, $p1, $p2, $p3, $p4, $p5, $p6)
	EndSwitch

	; Get listeners for the given event
	Local Const $listeners = $g__Event_Listeners.item($sEventName).items()

	; Invoke the listener with our ScriptingDictionary
	For $listener In $listeners
		Call($listener, $oObj)
	Next


EndFunc   ;==>_Event


; #FUNCTION# ====================================================================================================================
; Name ..........: _Event_Listen
; Description ...: Subscribe an listener to a given event
; Syntax ........: _Event_Listen(Const $callableEvent, Const $callableListener)
; Parameters ....: $callableEvent       - [const] an unknown value.
;                  $callableListener    - [const] an unknown value.
; Return values .: None
; Author ........: TarreTarreTarre
; Modified ......:
; Remarks .......:
; Related .......: _Event_Remove, _Event_RemoveAll
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Event_Listen(Const $callableEvent, Const $callableListener)

	Local Const $eventName = FuncName($callableEvent)
	Local Const $listenerName = FuncName($callableListener)

	Local $object

	; Look for storage
	If $g__Event_Listeners.exists($eventName) Then
		$object = $g__Event_Listeners.item($eventName)
	Else
		$object = ObjCreate("Scripting.Dictionary")
		$g__Event_Listeners.add($eventName, $object)
	EndIf

	; Add event listener to object (If not added)
	If Not $object.exists($listenerName) Then
		$object.add($listenerName, $listenerName)
	EndIf

EndFunc   ;==>_Event_Listen

; #FUNCTION# ====================================================================================================================
; Name ..........: _Event_RemoveAll
; Description ...: Remove all events and their respective listeners
; Syntax ........: _Event_RemoveAll()
; Parameters ....:
; Return values .: None
; Author ........: TarreTarreTarre
; Modified ......:
; Remarks .......:
; Related .......: _Event_Listen, _Event_Remove
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Event_RemoveAll()
	$g__Event_Listeners.removeAll()
EndFunc   ;==>_Event_RemoveAll

; #FUNCTION# ====================================================================================================================
; Name ..........: _Event_Remove
; Description ...: Remove a specified event with all its listeners
; Syntax ........: _Event_Remove(Const $callableEvent)
; Parameters ....: $callableEvent       - [const] an unknown value.
; Return values .: None
; Author ........: TarreTarre
; Modified ......:
; Remarks .......:
; Related .......: _Event_Listen, _Event_RemoveAll
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Event_Remove(Const $callableEvent)
	Local Const $eventName = FuncName($callableEvent)

	If $g__Event_Listeners.exists($eventName) Then
		$g__Event_Listeners.remove($eventName)
	EndIf

EndFunc   ;==>_Event_Remove
