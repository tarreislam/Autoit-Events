#include "Event.au3"

; Subscribe listeners
_Event_Listen(UserCreatedEvent, SendWelcomeMail)
_Event_Listen(UserCreatedEvent, RegisterNewsLetter)

; Fire event
_Event(UserCreatedEvent, @UserName, "tarre.islam@gmail.com")

Func UserCreatedEvent(Const ByRef $oEvent, $name, $email)
	; via $oEvent you can pass data to its listeners
	$oEvent.add("name", $name)
	$oEvent.add("email", $email)
	$oEvent.add("id", 1)
EndFunc   ;==>UserCreatedEvent

Func SendWelcomeMail(Const $oEvent)
	MsgBox(64, "Welcome mail sent", "Welcome mail sent to " & $oEvent.item("name") & " with email " & $oEvent.item("email"))
EndFunc   ;==>SendWelcomeMail

Func RegisterNewsLetter(Const $oEvent)
	MsgBox(64, "News letter registred", "News letter bound to user id " & $oEvent.item("id"))
EndFunc   ;==>RegisterNewsLetter
