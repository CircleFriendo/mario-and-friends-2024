incsrc "../../../shared/freeram.asm"
incsrc "../../../shared/characters.asm"

!propeltime = $10
!propelspeed = $C6


!riding_yoshi = $187A


init:

    LDA #$00
    STA !propeltimer
    STA !propellocked   

    LDA #$01
    STA !propelcharge
    
    RTL

main:
propel:
    JSL always
    
active:    
    LDA $9D  ; lock animation
    ORA $13d4|!addr   ; pause
    ORA $75			;Swimming?
    ora !riding_yoshi
      
    
    BEQ +
    RTL
    
+   LDA $72
    BNE +
    RTL
   
+   LDA !propelcharge
    beq +

.charge
    LDA !player : CMP #!waluigi : BNE .return

    lda $18
    and #$80  ; A only
    beq .return
    
.propeljump
    LDA #$00
    STA !propelcharge
    LDA #!propeltime
    STA !propeltimer
    LDA #$21     ;What sound to play		
	STA $1DFC|!addr	;Sound Bank to use

+
.testpropeltimer
    LDA !propeltimer
    beq .locked
    dec A
    STA !propeltimer
    beq +
    lda #!propelspeed
    STA $7D
    STZ $7B
    
    LDA #$04        ;\ 
    STA $13EE|!addr ; | Simulate sliding
    LDA #$01        ; |
    STA $13ED|!addr ;/
    
    LDA #$0B ;#$B3        ;\  Set the pose
    STA $13E0|!addr 
    bra .return
    + STZ $7D
    
.locked
    LDA $15
    AND #$BF
    STA $15
    LDA #$10        ;\  Set the pose
    STA $13E0|!addr   
.return
    rtl
    
clear:
    LDA #$00
    STA !propeltimer
    STA !propellocked   
    RTL
    
    
;; we want to refresh the charges even if the character isn't active
always:
    lda $72              ; Refresh charges if grounded
    beq +

    lda $75              ; Refresh charges in water
    bne +
    
    LDA !enemybouncetrigger : BNE +

    RTL

+   lda #$01
    STA !propelcharge
    LDA #$00
    STA !propeltimer    ;;;;;;;;;;;;;;;  
    STA !propellocked   
   
    RTL