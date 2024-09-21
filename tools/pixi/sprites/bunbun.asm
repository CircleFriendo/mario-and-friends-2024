; Speeds (right, left)
SpeedX:
    db $10,$F0
Tilemap:
db $02,$04



print "INIT ",pc
    %SubHorzPos()           ; face mario initially
    TYA
    STA !157C,x
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
    BNE Return
    LDA $9D                 ; return if sprites locked
    BNE Return
    LDA #$00
    %SubOffScreen()         ; only process sprite while on screen


LDA !1588,x			;
AND #$08			; these 5 lines of code were not in the original sprite
BEQ .NoTouchCeiling		; this prevents the Bunbun from jumping through the ceiling
STZ !AA,x			;
.NoTouchCeiling			;

    STZ !1602,x


    LDA !1588,x             ; don't set speeds if not on the ground
    AND #$04                
    BEQ InAir   

    STZ !B6,x
    STZ !AA,x
    LDA !1540,x
    BNE DontJump
    
    
Jump:
    LDA #$60
    STA !1540,x
    
    LDA #$D0               ; y speed 
    STA !AA,x
    
    
    
    BRA DontJump
    
InAir:

    LDY !157C,x             
    LDA SpeedX,y            ; x speed depends on direction
    STA !B6,x               ;

    LDA #$01
    STA !1602,x
    
DontJump:
    LDA !1588,x             ; check if sprite is touching object side
    AND #$03                
    BEQ DontChangeDirection 
    LDA !157C,x             
    EOR #$01                ; flip sprite direction
    STA !157C,x   
    
DontChangeDirection:
    JSL $01802A|!BankB      ; update position based on speed values
    ;JSL $018032|!BankB      ; interact with other sprites
    JSL $01A7DC|!BankB      ; check for mario/sprite contact
Return:
    RTS

Graphics:
    %GetDrawInfo()          ; after: Y = index to sprite OAM ($300)
                            ;      $00 = sprite x position relative to screen boarder
                            ;      $01 = sprite y position relative to screen boarder
                            
                            
    
                            

    LDA !157C,x             ; $02 = sprite direction
    STA $02

    LDA $00                 ; set x position of the tile
    STA $0300|!Base2,y

    LDA $01                 ; set y position of the tile
    STA $0301|!Base2,y


    LDA !1602,x			;
    TAX				;
    LDA Tilemap,x			; set the sprite tilemap
    STA $0302|!Base2,y			;
    
    LDX $15E9|!Base2			;


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
