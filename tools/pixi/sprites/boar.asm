; Speeds (right, left)
SpeedX:
    db $08,$F8
ChargeSpeed:
    db $28,$D8
BonkSpeedX:
    db $F4,$0C

!State = !1504 ;internal sprite state
!ySpeed = !AA  ;
!xSpeed = !B6  ;
!facing = !157C;
!oldfacing = !C2  ; used to detect collisions while charging
!hopSpeedY = $C2;
!bonkSpeedY = $D8;

!hCheckDistance = $0060
!hCheckDistanceSub = $00C1


print "INIT ",pc
    %SubHorzPos()           ; face mario initially
    TYA
    STA !facing,x
    STZ !State,x
	
	; if extra bit is set, start in idle state
	lda !7FAB10,x
    and #$04
    beq +
	lda #6 : sta !State,x
	+
    
    RTL

print "MAIN ",pc
    PHB : PHK : PLB
    JSR SpriteCode
    PLB
    RTL

SpriteCode:
    JSR Graphics
    
    LDA !14C8,x             ; return if sprite status != 8
    CMP #$08
    BNE Return1
    LDA $9D                 ; return if sprites locked
    BNE Return1
    LDA #$00
    %SubOffScreen()         ; only process sprite while on screen

GotoState:
    LDA !State,x                     ; Get state byte
    ASL A : TAX
    JMP.w (States,X)

States:
    dw StateWalking      ; 0
    dw StateHop          ; 1
    dw StateHopFall      ; 2
    dw StateCharge       ; 3
    dw StateBonk         ; 4
    dw StateBonkFall     ; 5
	dw StateIdle		 ; 6 (if extra bit is set, start in this state)

Return1:
    RTS
	
StateWalking:
    LDX $15E9|!Base2     ; reload x
    
    JSR CheckSeeMario
    BEQ ContinueWalking
	LDA #$20 : STA $7DF9	; hop sfx
    INC !State,x
    
ContinueWalking:
    LDA !1588,x             ; don't set speeds if not on the ground
    AND #$04                
    BEQ NotOnGround    
	LDA #1 : STA !151C,x 	; on ground flag, used to turn us around at ledges
    LDA #$10                ; y speed = 10
    STA !ySpeed,x               
    LDY !facing,x             
    LDA SpeedX,y            ; x speed depends on direction
    STA !xSpeed,x               ;
	BRA AfterLedgeCheck
NotOnGround:
	LDA !151C,x				; if on ground flag set, turn around now that we are off the ledge
	STZ !151C,x				; clear on ground flag
	BNE +
AfterLedgeCheck:
    LDA !1588,x             ; check if sprite is touching object side
    AND #$03                
    BEQ GotoShared 
	+
	LDA !xSpeed,X	
    EOR.b #$FF				; flip x-speed
    INC A
    STA !xSpeed,X
    LDA !157C,x             
    EOR #$01                ; flip sprite direction
    STA !157C,x  
    BRA GotoShared              ; Jump to Shared Routines

StateHop:
    LDX $15E9|!Base2     ; reload x
    LDA #$00
    STA !xSpeed,x
    LDA #!hopSpeedY
    STA !ySpeed,x 
    
    INC !State,x       
    BRA GotoShared              ; Jump to Shared Routines

StateHopFall:
    LDX $15E9|!Base2     ; reload x

    LDA !1588,x             ; don't set speeds if not on the ground
    AND #$04                
    BEQ Shared
	LDA #$25 : STA $7DF9	; charge sfx
    LDA !facing,x : STA !oldfacing,x
    INC !State,x
    BRA GotoShared

StateCharge:
    LDX $15E9|!Base2     ; reload x
    
    LDY !facing,x             
    LDA ChargeSpeed,y            ; x speed depends on direction
    STA !xSpeed,x               ;
    TYA
    EOR !oldfacing,x
    BNE ++
    LDA !1588,x             ; check if sprite is touching object side
    AND #$03                
    BNE + 
    BRA GotoShared
    ++
    LDA !oldfacing,x
    STA !facing,x         ; undo turnaround
    + INC !State,x
    BRA GotoShared

GotoShared:
    BRA Shared

StateBonk:
    LDX $15E9|!Base2     ; reload x
    
    LDA !oldfacing,x
    STA !facing,x
    
    LDY !facing,x
    LDA BonkSpeedX,y
    STA !xSpeed,x
    
    LDA #!bonkSpeedY
    STA !ySpeed,x 
    INC !State,x  
    BRA Shared

StateBonkFall:
    LDX $15E9|!Base2     ; reload x
    
    LDA !oldfacing,x
    STA !facing,x
    
    LDA !1588,x             ; don't set speeds if not on the ground
    AND #$04                
    BEQ Shared
    LDA !facing,x             
    EOR #$01
    STA !facing,x
    STZ !State,x
    
    BRA Shared
	
StateIdle:
	LDX $15E9|!Base2     ; reload x
    JSR CheckSeeMario
    BEQ Shared
	LDA #$20 : STA $7DF9	; hop sfx
    LDA #1 : STA !State,x
	BRA Shared

Shared:
    JSL $01802A|!BankB      ; update position based on speed values
    JSL $018032|!BankB      ; interact with other sprites
    JSL $01A7DC|!BankB      ; check for mario/sprite contact
Return:
    RTS


; Checks

CheckSeeMario:

    
    ; if mario is less than 8 tiles away in front
    %SubHorzPos()           ; face mario initially
	TYA
    EOR !facing,x
    BNE ReturnFalse
	REP #$20
    LDA $0E
	SBC #!hCheckDistance
	SEP #$20
	BPL ReturnFalse
	REP #$20
	ADC #!hCheckDistanceSub
	SEP #$20
	BMI ReturnFalse 
    
    ; if mario is within one tile vertically
    %SubVertPos()           ; vertical distance in 0E/0F
    LDA $0F
    SBC #$01
    BPL ReturnFalse
    ADC #$21
    BMI ReturnFalse    
    
ReturnTrue:
    REP #$02  ; Set Zero Flag	
    RTS
ReturnFalse:
    SEP #$02  ; Clear Zero Flag
    RTS


    



Graphics:
    %GetDrawInfo()          ; after: Y = index to sprite OAM ($300)
                            ;      $00 = sprite x position relative to screen border
                            ;      $01 = sprite y position relative to screen border

    LDA !157C,x             ; $02 = sprite direction
    STA $02

    LDA $00                 ; set x position of the tile
    STA $0300|!Base2,y

    LDA $01                 ; set y position of the tile
    STA $0301|!Base2,y

    PHX                     ; set tile number
    
    LDA !1588,x             ; don't set speeds if not on the ground
    AND #$04  
    BEQ Odd
    
    LDA $14                 ; $14 is the animation frame number
    AND #$08                ; 0 if animation frame number is > 8, 1 if <= 8
    TAX
    LDA #$28                ; tile A8 will be used if it's in animation frame 1-8
    CPX #$08
    BEQ Even
Odd:
    LDA #$2A                ; AA if it's 9-16
Even:
    PLX
    STA $0302|!Base2,y

    LDA !15F6,x             ; get sprite palette info
    PHX
    LDX $02                 ; flip the tile if the sprite direction is 0
    BNE NoFlip
    ORA #$40
NoFlip:
    PLX
    ORA $64                 ; add in the priority bits from the level settings
    STA $0303|!Base2,y      ; set properties

    INY                     ; get the index to the next slot of the OAM
    INY                     ; (this is needed if you wish to draw another tile)
    INY
    INY

    LDY #$02                ; #$02 means the tiles are 16x16
    LDA #$00                ; This means we drew one tile
    JSL $01B7B3|!BankB
    RTS