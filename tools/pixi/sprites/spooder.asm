; Speeds (right, left)
SpeedX:
    db $08,$F8
    
JumpSpeedX:
    db $20,$E0

!State = !sprite_misc_c2        ; 0 Walking 
                                ; 1 Waiting
                    
!WaitTimer = !1540    ; Time to wait before attacking

print "INIT ",pc
    %SubHorzPos()           ; face mario initially
    TYA
    STA !157C,x
    STZ !State,x
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



    LDA !1588,x             ; don't set speeds if not on the ground
    AND #$04                
    BEQ Falling  

    lda !State,x
    bne Waiting

Walking:

    LDA !WaitTimer,x
    bne Continue

    %SubHorzPos()     ; get distance from mario
    LDA $0E                  
    CLC                       
    ADC #$40                
    CMP #$80                ; if between #$-40 and #$40
    BCS Continue          
    INC !State,x     ; Set to waiting
    LDA #$10        ; Set timer
    STA !WaitTimer,x             

    STZ !B6,x
    
    bra Process

Waiting:

    %SubHorzPos()           ; face mario
    TYA
    STA !157C,x

    LDA !WaitTimer,x
    bne Process
    
    DEC !State,x
    
Jump:
    LDA #$D0                ; y speed = d0
    STA !AA,x               
    LDY !157C,x             
    LDA JumpSpeedX,y            ; x speed depends on direction
    STA !B6,x               ;
    
    bra Process

Falling:
    LDA #$30
    STA !WaitTimer,x
    bra Process

Continue:
    
    LDA #$10                ; y speed = 10
    STA !AA,x               
    LDY !157C,x             
    LDA SpeedX,y            ; x speed depends on direction
    STA !B6,x               ;
    
    LDA !1588,x             ; check if sprite is touching object side
    AND #$03                
    BEQ Process
    LDA !157C,x             
    EOR #$01                ; flip sprite direction
    STA !157C,x    
    
Process:


    JSL $01802A|!BankB      ; update position based on speed values
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


; Set Animation Frame

    LDA #$42
    STA $0302|!Base2,y
    
    LDA !1588,x             ; don't set speeds if not on the ground
    AND #$04                
    BEQ Palette
    
     
    LDA #$44
    STA $0302|!Base2,y
    LDA !State,x
    bne Palette
    
    PHX                     ; set tile number
   
    LDA $14                 ; $14 is the animation frame number
    AND #$08                ; 0 if animation frame number is > 8, 1 if <= 8
    TAX
    LDA #$22                ; tile A8 will be used if it's in animation frame 1-8
    CPX #$08
    BEQ Even
    LDA #$24                ; AA if it's 9-16
Even:
    PLX
    STA $0302|!Base2,y


Palette:

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
