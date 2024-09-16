;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Flutter Jump
;;Original by Scepile3
;;Modification by UltimateYoshiMaster and MarioFanGamer
;;UberASM conversion by MarioFanGamer
;;

incsrc "../../../shared/freeram.asm"
incsrc "../../../shared/characters.asm"



!FlutterAnimation = 1	; Change this to 0 to disable the flutter animation

init:
    LDA #$00 : STA !fluttertimer
    LDA #$01 : STA !fluttercharge
    RTL


Reset:	;Stop the flutter jump
    LDA #$00
	STA !fluttertimer
	STA !FC
.Return:
	RTL   

main:
    JSL always

active:
	LDA $9D
    ORA $13d4|!addr   ; pause
    BEQ +
	RTL
    +

	LDA $187A|!addr
	BNE Reset
	
	if !FlutterAnimation
		LDA !fluttertimer
		BEQ .NotFluttering
		AND #$03
		CMP #$03
		BNE +
		LDA #$01
	+	LDY $148F|!addr
		BEQ +
		CLC : ADC #$07
		BRA .Store
	+	LDY $72
		CPY #$0C
		BNE .Store
		CLC : ADC #$04
	.Store
		STA $13E0|!addr
	.NotFluttering
	endif


    LDA $77     	;(in order)Doesn't work if not in air, swimming, climbing, or on yoshi
    AND #$04		;On the ground?
    ORA $71			;Controllable
    ORA $75			;Swimming?
    ORA $74			;Climbing?
	ORA $1407|!addr	;Gliding with the cape
	ORA $1891|!addr
	;Add more checks if you don't want Mario to flutter
    BNE .Reset		;Exit
    LDA $1499|!addr  ;temperarily stops when facing screen
    BNE .Return
    
.NoReturn:
	LDA !fluttertimer
	BEQ .NoFlutter	;If the player isn't flutter jumping then don't apply its effects
    
    ;;; Do the flutter
        LDA !FC
		DEC A		;boost more
        STA !FC
		STA $7D		;apply boost
        LDA !fluttertimer	;decrement flutter jump counter
        DEC A
        STA !fluttertimer
        
.NoFlutter:    ;;; not fluttering, decrement the cooldown timer

	LDA !player : CMP #!daisy : BNE .Return ; Daisy only

	LDA $18       ;change these two lines to alter which button you want to press. controller values are in the RAM section of smwcentral.net
	AND #$80
	BEQ .Return

    ; activate flutter

	STZ $140D|!addr     ;remove this line if you don't want to allow mario to flutter while spin jumping (without this, mario spin flutters)
	LDA !fluttercharge		;Are we resting?
	BEQ .Return
    DEC A
    STA !fluttercharge
	LDA #$16	;How long to flutter jump
	STA !fluttertimer
	LDA #$F8	;Starting Y speed for flutter jump
	STA !FC
	LDA #$09     ;What sound to play		(list of sounds at http://www.smwcentral.net/?p=thread&id=6665)
	STA $1DF9|!addr	;Sound Bank to use

	BRA .Return
.Reset:	;Stop the flutter jump
    LDA #$00
	STA !fluttertimer
	STA !FC
.Return:
	RTL   

clear:
    lda #$00      ; clear princess float/flutter timer on change
    sta !fluttertimer
    RTL
    
;; we always want to refresh charges even if the character 
;; is inactive

always:
    LDA $72
    beq .refresh
    
    LDA $75
    BNE .refresh
    
	LDA !enemybouncetrigger : BNE .refresh

    RTL
    
.refresh
    lda #$01
    STA !fluttercharge
    LDA #$00
    sta !fluttertimer
    
    RTL