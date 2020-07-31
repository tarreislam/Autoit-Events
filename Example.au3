#include "Event.au3"

_Event(__Event_CB_UserCreated, @IPAddress1)

Func __Event_CB_UserCreated(Const ByRef $oEvent)
	; Register listeners for event
	$oEvent.add("listeners", 'SendWelcomeMail,RegisterNewsLetter')

	; add whatever you want
	$oEvent.add("name", @UserName)
	; Payload cannot be overridden
	$oEvent.add("payload", "This wont be used")

EndFunc


Func __Event_CB_UserCreated_SendWelcomeMail(Const $oEvent)
	MsgBox(0,0,$oEvent.item("name"))

EndFunc


Func __Event_CB_UserCreated_RegisterNewsLetter(Const $oEvent)
	MsgBox(0,0,$oEvent.item("payload"))
EndFunc

