;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;; Minimalist Course Clear
;;        by
;;  	    Lui37
;;
;; edits by wiiqwertyuiop
;;       
;;

incsrc course_clear_defs.asm

if read1($00FFD5) == $23
	sa1rom
	!SA1 = 1
	!f = $000000
	!base2 = $6000
else
	!SA1 = 0
	!f = $800000
	!base2 = $0000
endif

macro define_sprite_table(name, addr, addr_sa1)
	if !SA1 == 0
		!<name> = <addr>
	else
		!<name> = <addr_sa1>
	endif
endmacro

%define_sprite_table("D8", $D8, $3216)
%define_sprite_table("E4", $E4, $322C)
%define_sprite_table("14D4", $14D4, $3258)
%define_sprite_table("14E0", $14E0, $326E)
%define_sprite_table("163E", $163E, $33FA)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Code
;;

org $0083ED ; NMI hijack so layers don't get disabled after you beat a boss
  BRA $04
  
org $00AF2D
	if !enable_scorecard
		LDA #$09
		STA $3E
		JSL $05CBFF|!f
	else
		BRA + : NOP #6 : +
	endif

  LDA $13
  AND #$03
  BNE +
  LDA $1495|!base2
  CMP #$40
  BCS +
  JSR $AFA3 ; Needed for bosses
  SEP #$30
+
  RTS

ReznorFix:
  LDA $13C6|!base2
  BNE +
  DEC $13C6|!base2
  LDA #!BossWait
  JML Back
+
  JML Return

after_peace_hijack:
	DEC $1492|!base2
	BNE .end
	if !enable_circle
		LDA #$F0
	else
		LDA #!time_after_peace
  endif
	STA $1433|!base2
	if !enable_circle_sound
		LDA.b #!CircleSFX		; read if AMK changed it
		STA $1DFB|!base2
	endif
.end	RTS
  
org $00C9B7
	JMP after_peace_hijack
	NOP #2 

org $00C9C2
	if !enable_circle
		JSR $CA44
	else
		DEC $1433|!base2
	endif
	
org $00C9DF				; fade out THEN load overworld
	LDY #$0B
	
org $00C9F8				; don't mess with brightness/mosaic
	BRA + : NOP #4 : +

org $00C944
	if !enable_scorecard
		JSL $05CBFF|!f
	else
		BRA + : NOP #2 : +
	endif
	
  LDY #!FreezeSprites ; Freeze sprites

;;;;;;;;;;;;;;;;;;;;;;;;;

org $01FB28
  LDA #!BossWait

org $038097
  LDA #!BossWait

org $03C7A1
  LDA #!BossWait

org $03CE94
  LDA #!BossWait

;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Fix Reznor


org $0398DE
if !FreezeSprites
  DEC $13C6|!base2
  LDA #!BossWait
else
  JML ReznorFix
  NOP
endif
 
Back: 
  STA $1493|!base2            ; Set time before return to overworld
  LDA #!BossClear             ; \ 
  STA $1DFB|!base2            ; / Play sound effect 
Return:

