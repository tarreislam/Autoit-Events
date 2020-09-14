#include "Event.au3"

Global Const $tests = [Test_Add_Listeners, Test_Remove_Events, Test_Fire_event_and_order]

For $i = 0 To UBound($tests) -1
	Local $test = $tests[$i]
	Local $name = FuncName($test)

	If Not $test() Then
		ConsoleWrite("! Test " & $name & " Failed" & @LF)
	Else
		ConsoleWrite("+ Test " & $name & " Succeded!" & @LF)
	EndIf
Next

Func Test_Add_Listeners()
	_Event_RemoveAll()

	; Shellow
	assertTrue(_Event_GetAll().count() == 0)
	_Event_Listen(__TestEvent, __TestListener)
	assertTrue(_Event_GetAll().count() == 1)

	; Duplicate listeners should be ignored and errors should be thrown
	_Event_Listen(__TestEvent, __TestListener)
	assertTrue(@error == 1)
	; Same event new listener should be fine!
	_Event_Listen(__TestEvent, __TestListener2)
	assertTrue(@error == 0)

	Return True
EndFunc

Func Test_Remove_Events()
	_Event_RemoveAll()

	; Add two different events and bind to same listener
	_Event_Listen(__TestEvent, __TestListener)
	_Event_Listen(__TestEvent2, __TestListener)
	; Now we should have 2 events
	assertTrue(_Event_GetAll().count() == 2)
	; Remove one of the events and all its listeners
	_Event_Remove(__TestEvent)
	; Now only 1 event should be present
	assertTrue(@error == 0)
	assertTrue(_Event_GetAll().count() == 1)
	; Re-add event and add a secind listneer
	_Event_Listen(__TestEvent, __TestListener)
	_Event_Listen(__TestEvent, __TestListener2)
	; Now we should have 2 events and 1 event should have 2 listeners
	assertTrue(_Event_GetAll().count() == 2)
	assertTrue(_Event_GetAll().item('__TESTEVENT').count() == 2)
	; Remove single listener
	_Event_RemoveListener(__TestEvent, __TestListener2)
	assertTrue(@error == 0)
	; Now the __TESTEVENT should only have 1 listener
	assertTrue(_Event_GetAll().item('__TESTEVENT').count() == 1)

	Return True
EndFunc

Func Test_Fire_event_and_order()
	Global $magicVar = False

	; Register events
	_Event_Listen(__TestEvent, __TestListener4)
	_Event_Listen(__TestEvent, __TestListener3)
	; Fire event
	_Event(__TestEvent)
	assertTrue($magicVar == 1)
	; Remove re-register and re-fire
	_Event_RemoveAll()
	_Event_Listen(__TestEvent, __TestListener3)
	_Event_Listen(__TestEvent, __TestListener4)
	_Event(__TestEvent)
	assertTrue($magicVar == 2)

	Return True
EndFunc

Func assertTrue($val, Const $ln = @ScriptLineNumber)
	If $val == True Then Return
	ConsoleWrite("! Failed asserting that " & $val & " is  True on line " & $ln & @LF)
	Exit
EndFunc



#Region internals
Func __TestEvent(Const $oEvent)
EndFunc

Func __TestEvent2(Const $oEvent)
EndFunc


Func __TestListener(Const $oEvent)

EndFunc

Func __TestListener2(Const $oEvent)

EndFunc

Func __TestListener3(Const $oEvent)
	$magicVar = 1
EndFunc

Func __TestListener4(Const $oEvent)
	$magicVar = 2
EndFunc
#EndRegion