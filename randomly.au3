#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=randompick.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Res_Fileversion=1.0.0.1
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=p
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include "array.au3"
Global $winstring, $winclip, $length, $winners
Start()
Work()
WinStringAdd()
ToolTip("Working: " & UBound($winners) & " of " & $numberofwinners)
MsgBox(0, "Winners", $winstring)
ClipPut($winclip)
Exit

Func Start()
	Global $rawdata = InputBox("Randomly", "Who is participating?" & @CRLF & "" & @CRLF & "Use ; or , to separate Participants." & @CRLF & "(Using the Default Value will random from 1 to 151)", "!151", "", 300, 160)
	If @error Then Exit
	If $rawdata = "!151" Then
		_CreateArray("151")
		$length = 151
	Else
		ClipPut($rawdata)
		Global $moddata = StringSplit($rawdata, ",;", 2)
		$length = UBound($moddata)
	EndIf
	Global $multiwin = MsgBox(3, "Randomly", "Can a Participant win more than once?")
	If @error Then Exit
	If $multiwin = 2 Then Exit
	Global $numberofwinners = InputBox("Randomly", "How many winners?", "1")
	If @error Then Exit
	While $numberofwinners > $length
		If $multiwin = 6 Then ExitLoop ;6 = yes, 7 = no
		$numberofwinners = InputBox("Error", "Requested more winners than Available.", "1")
		If @error Then Exit
	WEnd
EndFunc   ;==>Start

Func Work()
	ToolTip("Working: 1 of " & $numberofwinners)
	$winners = RandomOrg($numberofwinners, $length)
	If $length > 1 Then
		If $numberofwinners > 1 Then
			If $multiwin = 7 Then
				$winners = _ArrayUnique($winners)
				_ArrayDelete($winners, 0)
				Local $tmplength
				ConsoleWrite("NumberofCurrentWinners: " & UBound($winners) & @LF)
				While Not (UBound($winners) = $numberofwinners)
					If UBound($winners) > $numberofwinners Then
						$tmplength = UBound($winners) - $numberofwinners
						_ArrayDelete($winners, $tmplength)
					Else
						$tmplength = $numberofwinners - UBound($winners)
						_ArrayInsert($winners, 0, RandomOrg(1, $length))
						If @error Then ConsoleWriteError("Error: " & @error & @LF)
					EndIf
					$winners = _ArrayUnique($winners)
					_ArrayDelete($winners, 0)
					ToolTip("Working: " & UBound($winners) & " of " & $numberofwinners)
				WEnd
			EndIf
		EndIf
	EndIf
EndFunc   ;==>Work

Func _CreateArray($imax)
	Local $tmparray
	For $i = 1 To $imax
		$tmparray &= $i & ","
	Next
	Global $moddata = StringSplit($tmparray, ",", 2)
EndFunc   ;==>_CreateArray

Func RandomOrg($rNumber, $rMax, $rMin = 1)
	ConsoleWriteError("Randoming " & $rNumber & " Numbers." & @LF)
	If $rNumber = 1 Then
		Local $array = BinaryToString(StringTrimRight(InetRead("https://www.random.org/integers/?num=" & $rNumber & "&min=" & $rMin & "&max=" & $rMax & "&col=1&base=10&format=plain&rnd=new", 1), 2))
	Else
		Local $array = StringSplit(BinaryToString(StringTrimRight(InetRead("https://www.random.org/integers/?num=" & $rNumber & "&min=" & $rMin & "&max=" & $rMax & "&col=1&base=10&format=plain&rnd=new", 1), 2)), @LF, 2)
	EndIf
	Return $array
EndFunc   ;==>RandomOrg

Func WinStringAdd()
	If $numberofwinners = 1 Then
		Local $j = $winners
		$winstring = $moddata[$j] & "." & @LF
	Else
		For $i = 1 To $numberofwinners
			Local $j = $winners[$i - 1]
			$winstring &= $moddata[$j - 1] & "." & @LF
			If Not ($i = $numberofwinners) Then
				$winclip &= $moddata[$j - 1] & ", "
			Else
				$winclip &= $moddata[$j - 1]
			EndIf
		Next
	EndIf
EndFunc   ;==>WinStringAdd
;;Credits

;Coder: BetaLeaf (Jeff Savage)
;Icon: Icon made by "http://www.freepik.com" from "http://www.flaticon.com". www.flaticon.com is licensed under "http://creativecommons.org/licenses/by/3.0/"
