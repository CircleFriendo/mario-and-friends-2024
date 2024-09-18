;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Find Platform Sprite - by dtothefourth
;
; This patch makes it so that whenever a sprite sets $1471
; to indicate Mario is standing on it, it also saves its
; slot number to a Free RAM address so that other code can
; easily find which sprite Mario is standing on
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

if read1($00FFD5) == $23	;sa-1 compatibility
  sa1rom
  !sa1 = 1
  !addr = $6000
  !BankB = $000000
else
  !sa1 = 0
  !addr = $0000
  !BankB = $800000
endif

;The sprite slot from X of the current sprite will be saved here (check that $1471 is non-zero still before using)
!Platform = $1696|!addr ; FreeRAM

org $01B47A
	autoclean JSL Store1
	NOP

org $01B87D
	autoclean JSL Store1
	NOP

org $029154
	autoclean JSL Store1
	NOP

org $02EE70
	autoclean JSL Store1
	NOP

org $0387EA
	autoclean JSL Store1
	NOP

org $038CCC
	autoclean JSL Store1
	NOP

org $01E67E
	autoclean JSL Store2
	NOP

org $02CFC9
	autoclean JSL Store2
	NOP

org $01CA34
	autoclean JSL Store3
	NOP

freecode

Store1:
	TXA
	STA !Platform
	LDA #$01
	STA $1471|!addr
	RTL

Store2:
	TXA
	STA !Platform
	LDA #$02
	STA $1471|!addr
	RTL

Store3:
	TXA
	STA !Platform
	LDA #$03
	STA $1471|!addr
	RTL	