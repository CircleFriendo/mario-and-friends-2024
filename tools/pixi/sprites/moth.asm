; Speeds (right, left)

Tilemap:
db $08,$0A

!YSpeedUpdateFreq = $01   ;/ Valid values: $00,$01,$03,$07,$0F,$1F,$3F,$7F,$FF.
                          ; For example, bigger YFreq values will result in "higher" sine wave patterns.
                       
!YAcceleration    = $01
!MaxYSpeed        = $0C
                          
YAcceleration:
    db -!YAcceleration,!YAcceleration
    
MaxYSpeed:
    db -!MaxYSpeed,!MaxYSpeed

print "INIT ",pc
    %SubHorzPos()           ; face mario initially
    TYA
    STA !157C,x
    STZ !1602,x

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


    LDA !1602,x
    INC
    STA !1602,x

    AND #$40                ; 0 if animation frame number is > 8, 1 if <= 8
    
    YMovement:
if !YSpeedUpdateFreq != $00
    lda $14                 ;\ Change speed every other frame.
    and #!YSpeedUpdateFreq  ;|
    bne +                   ;/
endif
    lda !1594,x             ;\ Handle Y acceleration.
    and #$01                ;|
    tay                     ;|
    lda !AA,x               ;|
    clc                     ;|
    adc YAcceleration,y     ;|
    sta !AA,x               ;|
    cmp MaxYSpeed,y         ;|
    bne +                   ;|
    inc !1594,x             ;/
+   jsl $01801A|!bank       ; Update Y position without gravity.
    
    
    
    ;JSL $01802A|!BankB      ; update position based on speed values
    JSL $018032|!BankB      ; interact with other sprites
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
    
    LDA $14                 ; $14 is the animation frame number
    AND #$04                ; 0 if animation frame number is > 8, 1 if <= 8
    LSR A
    LSR A
    
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
