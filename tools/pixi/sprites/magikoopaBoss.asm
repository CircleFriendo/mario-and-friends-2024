;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Magikoopa boss
; 
; If extra bit set - secret exit upon defeat, otherwise normal exit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!HP = 5				; should be pretty obvious

!Music = $03	     		; Music that plays after defeating boss.

!MagicNumber = $20              ; The vanilla sprite to generate (Magikoopa magic).
!WandTile = $99                 ; The sprite tile to use for the wand.

!MagicSFX = $10                 ; Sound effect to play when shooting magic.
!MagicBank = $1DF9

!HitSound = $28
!HitSndBank = $1DFC

!HitIdleTime = $30		;how long it flashes when got hit

!sprite_state = !C2
!sprite_direction = !157C
!HitPointsRAM = !160E
!HitTimer = !1564
!BlinkState = !1594

!RAM_FrameCounter = $13
!RAM_ScreenBndryXLo = $1A
!RAM_ScreenBndryXHi = $1B
!RAM_ScreenBndryYLo = $1C
!RAM_ScreenBndryYHi = $1D
!RAM_SpritesLocked = $9D
!OAM_DispX = $0300|!Base2
!OAM_DispY = $0301|!Base2
!OAM_Tile = $0302|!Base2
!OAM_Prop = $0303|!Base2
!OAM_Tile3DispX = $0308|!Base2
!OAM_Tile3DispY = $0309|!Base2
!OAM_Tile3 = $030A|!Base2
!OAM_Tile3Prop = $030B|!Base2

Tilemap:
    db $A0,$C0
    db $A0,$C0
    db $A4,$C4
    db $A4,$C4
    db $A0,$C0
    db $A0,$C0

Y_Disp:
    db $10,$00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; sprite init JSL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print "INIT ",pc
;probably don't need this, since I imagine you don't need more than 1 magikoopa boss on the same screen
;    PHB : PHK : PLB
;    LDY.b #!SprSize-3           ; setup loop
;.loop
;    CPY $15E9|!Base2            ;\ if sprite being checked is this one,
;    BEQ .next                   ;/ branch
;    LDA !14C8,y                 ;\ if sprite being checked is non-existant,
;    BEQ .next                   ;/ branch
;    PHX
;    TYX
;    LDA !7FAB9E,x               ;\ if sprite being checked isn't Magikoopa,
;    PLX                         ; |    
;    CMP !7FAB9E,x               ; |
;    BNE .next                   ;/ branch
;    STZ !14C8,x                 ; if code gets here, there is another Magikoopa active, so this one is destroyed
;    PLB
;    RTL

;.next
;    DEY                         ; decrease loop counter
;    BPL .loop                   ; if sprites left to check, branch
;    STZ $18BF|!Base2            ; activate sprite

    LDA #!HP
    STA !HitPointsRAM,x
;    PLB
    RTL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; sprite code JSL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print "MAIN ",pc
    PHB : PHK : PLB
    JSR Magikoopa
    PLB
    RTL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; main
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Magikoopa:
    LDA #$01
    STA !15D0,x

LDA !sprite_state,x			;don't disappear in an instant when offscreen horizontally when took damage
CMP #$04
BEQ .NoDisappear

    LDA !sprite_off_screen_horz,x       ;\ if sprite not offscreen,
    BEQ +                               ;/ branch
        STZ !sprite_state,x             ; else, reset sprite state
+   LDA !sprite_state,x
    ;AND #$03

.NoDisappear
    JSL $0086DF|!BankB

MagiKoopaPtrs:
    dw StateSearching               ; searching for a spot
    dw StateAppearing               ; appearing
    dw StateAttacking               ; attacking
    dw StateDisappearing            ; disappearing
    dw StateGotHit		    ; got hit, immune to shit and disappear (or die if hit enough times)

;DeadState:
;   JSR Graphics
;   RTS

StateSearching:
    ;LDA $18BF|!Base2                ;\ if sprite not deactivated,
    ;BEQ .active                     ;/ branch
    ;STZ !14C8,x                     ; else, destroy sprite
    ;RTS                             ; return

.active
    LDA !RAM_SpritesLocked          ;\ if sprites locked,
    BNE .return                     ;/ return
    LDY #$24                        ;\ something to do with colour addition?
    STY $40                         ;/
    LDA !1540,x                     ;\ if still waiting after disappearing,
    BNE .return                     ;/ return
    JSL $01ACF9|!BankB              ; get random number
    CMP #$D1                        ;\ if random number more than D1,
    BCS .return                     ;/ return
    CLC                             ;\ else, use it to determine sprite y position
    ADC !RAM_ScreenBndryYLo         ; |
    AND #$F0                        ; |
    STA !sprite_y_low,x             ; |
    LDA !RAM_ScreenBndryYHi         ; |
    ADC #$00                        ; |
    STA !sprite_y_high,x            ;/
    JSL $01ACF9|!BankB              ;\ get another random number
    CLC                             ; | and use it to determine sprite x position
    ADC !RAM_ScreenBndryXLo         ; |
    AND #$F0                        ; |
    STA !sprite_x_low,x             ; |
    LDA !RAM_ScreenBndryXHi         ; |
    ADC #$00                        ; |
    STA !sprite_x_high,x            ;/
    %SubHorzPos()                   ;\ if sprite closer to Mario than 0x20 pixels,
    LDA $0E                         ; |
    CLC                             ; |
    ADC #$20                        ; |
    CMP #$40                        ; |
    BCC .return                     ;/ return
    STZ !sprite_speed_y,x           ; clear sprite y speed
    LDA #$01                        ;\ set sprite x speed
    STA !sprite_speed_x,x           ;/
    JSL $019138|!BankB              ; interact with objects
    LDA !sprite_blocked_status,x    ;\ if sprite not on ground,
    AND #$04                        ; |
    BEQ .return                     ;/ return
    LDA $1862|!Base2                ;\ if high byte of "acts like" setting of the block that sprite is touching isn't 0 (if block solid),
    BNE .return                     ;/ return
    INC !sprite_state,x             ; go to next sprite state
    STZ !1570,x
    JSR CheckMagic
    %SubHorzPos()                   ;\ make sprite face Mario
    TYA                             ; |
    STA !sprite_direction,x         ;/
.return
    RTS                             ; return

StateAppearing:
    JSR CheckPalette
    STZ !1602,x                     ; set graphics frame to use
    JSR Graphics
    RTS                             ; return

FrameBit:
    db $04,$02,$00

Wand_X_Offset:
    db $10,$F8

StateAttacking:
    STZ !15D0,X
    JSR CustomInteractions
    ;JSL $01803A|!BankB              ; interact with Mario and with other sprites
    %SubHorzPos()                   ;\ make sprite face Mario
    TYA                             ; |
    STA !sprite_direction,x         ;/
    LDA !1540,x                     ;\ if not time to change sprite state,
    BNE +                           ;/ branch
    INC !sprite_state,x             ; go to next sprite state
CheckMagic:
    LDY #$34                        ;\ more colour addition stuff
    STY $40                         ;/
+   CMP #$40                        ;\ if not time to generate magic,
    BNE ++                          ;/ branch
    PHA                             ; preserve sprite state timer
    LDA !RAM_SpritesLocked          ;\ if sprites locked
    ORA !sprite_off_screen_horz,x   ; | or sprite is offscreen,
    BNE +                           ;/ branch
        JSR SpawnMagic              ; generate magic
+   PLA                             ; retrieve sprite state timer
++  LSR A                           ;\ use sprite state timer to determine graphics frame to use
    LSR A                           ; | in some very complicated manner
    LSR A                           ; |
    LSR A                           ; |
    LSR A                           ; |
    LSR A                           ; |
    TAY                             ; | get seventh bit of sprite state timer into y register
    PHY                             ; | and preserve it
    LDA !1540,x                     ; |
    LSR #3                          ; |
    AND #$01                        ; | get fourth bit of sprite state timer
    ORA FrameBit,y               ; | add in seventh bit
    STA !1602,x                     ;/ and use it to determine sprite graphics frame to use
    JSR Graphics
    LDA !1602,x                     ;\ if sprite graphics frame less than 0x4,
    SEC : SBC #$02                  ; |
    CMP #$02                        ; |
    BCC +                           ;/ branch
    LSR A                           ;\ if it's less than 
    BCC +                           ;/ branch
    LDA !sprite_oam_index,x         ;\ place head tile one pixel lower
    TAX                             ; |
    INC !OAM_DispY,x                ;/
    LDX $15E9|!Base2                ; load sprite index
+   PLY                             ;\ retrieve seventh bit of sprite state timer
    CPY #$01                        ; | if it's clear,
    BNE +                           ;/ branch
        JSR SparkleEffect           ; sparkle effect
+
ShowWandMaybe:
    LDA !1602,x                     ;\ if sprite graphics frame less than 0x4,
    CMP #$04                        ; |
    BCC .return                     ;/ return
    LDY !sprite_direction,x         ;\ use sprite direction to determine x position of wand tile
    LDA !sprite_x_low,x             ; |
    CLC                             ; |
    ADC Wand_X_Offset,y               ; |
    SEC                             ; |
    SBC !RAM_ScreenBndryXLo         ; |
    LDY !sprite_oam_index,x         ; |
    STA !OAM_Tile3DispX,y           ;/
    LDA !sprite_y_low,x             ;\ set y position of wand tile
    SEC                             ; |
    SBC !RAM_ScreenBndryYLo         ; |
    CLC : ADC #$10                  ; |
    STA !OAM_Tile3DispY,y           ;/
    LDA !sprite_direction,x         ;\ set properties of wand tile
    LSR A                           ; |
    LDA #$00                        ; |
    BCS +                           ; |
        ORA #$40                    ; |
+   ORA $64                         ; |
    ORA !sprite_oam_properties,x    ; |
    STA !OAM_Tile3Prop,y            ;/
    LDA.b #!WandTile                ;\ set wand tile number
    STA !OAM_Tile3,y                ;/
    TYA                             ;\ ...divide OAM index by four?
    LSR A                           ; |
    LSR A                           ; |
    TAY                             ;/
    LDA #$00                        ;\ set wand tile size
    ORA !sprite_off_screen_horz,x   ; |
    STA $0462|!Base2,y              ;/
.return
    RTS                             ; return

StateDisappearing:
    JSR Disappear
    JSR Graphics
    RTS                             ; return

StateGotHit:
LDA !BlinkState,x			;if set, don't show up
BNE .NoGFX

	JSR Graphics
	;JSR ShowWandMaybe		;maybe it showed a wand. (this is commented because originally it was set to fall down upon death and the wand still wraps around... but it doesn't fall anymore. whatever)

.NoGFX
LDA !RAM_SpritesLocked
BNE .Re

	LDA !HitTimer,x		;if should display hit animation, cycle palette
	BNE .CyclePalette	;well, "cycle"

	LDA !HitPointsRAM,x	;check HP
	BEQ .Die		;die if 0

	DEC !sprite_state,x	;set to disappear
	STZ !BlinkState,x	;show up next time
	RTS

;earlier idea was to cycle palette, but I changed it to a normal blinking
.CyclePalette
LDA $14
AND #$03			;frequency
BNE .Re

LDA !BlinkState,x		;appear or disappear
EOR #$01
STA !BlinkState,x

.Re
RTS

.Die
;spin kill death. i would've used falling down death, but it turns out SMW reverts palettes back on goal, which means magikoopa's palette can get messed up
LDA #$04		; sprite state = 04
STA !14C8,x		; spin-jump killed

LDA #$1F		; set spin jump animation timer
STA !1540,x		;

JSL $07FC3B|!BankB	; show star animation

LDA #$08		;
STA $1DF9|!Base2	; play spin-jump sound effect

LDA !extra_bits,x
AND #$04
BEQ .Goal

INC $1DEA|!addr		;secret exit

.Goal
DEC $13C6|!Base2        ; prevent Mario from walking at the level end
LDA #$FF                ; \ set goal
STA $1493|!Base2        ; /

LDA #!Music             ; \ set ending music
STA $1DFB|!Base2        ; /
RTS

SpawnMagic:
    LDY.b #!SprSize-3               ; setup loop
-   LDA !14C8,y                     ;\ check if sprite slot is free
    BEQ +                           ;/ if so, branch
    DEY                             ;\ if not, check next slot
    BPL -                           ;/
    RTS                             ; if no slots left, return

+   LDA.b #!MagicSFX                ;\ sound effect
    STA.w !MagicBank|!Base2         ;/ 
    LDA #$08                        ;\ set sprite status
    STA !14C8,y                     ;/ 
    LDA.b #!MagicNumber             ;\ set sprite number       
    STA.w !9E,y                     ;/
    LDA !sprite_x_low,x             ;\ set sprite x position
    STA.w !E4,y                     ; |
    LDA !sprite_x_high,x            ; |
    STA !sprite_x_high,y            ;/
    LDA !sprite_y_low,x             ;\ set sprite y position
    CLC : ADC #$0A                  ; |
    STA.w !D8,y                     ; |
    LDA !sprite_y_high,x            ; |
    ADC #$00                        ; |
    STA !sprite_y_high,y            ;/
    TYX                       
    JSL $07F7D2|!BankB              ; clear out old sprite values
    LDA #$20
    JSR Aiming                      ; aiming routine
    LDX $15E9|!Base2                ; load sprite index
    LDA $00                         ;\ set sprite speeds
    STA.w !AA,y                     ; |
    LDA $01                         ; |
    STA.w !B6,y                     ;/
    RTS                             ; return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; aiming routine
; input: accumulator should be set to total speed (x+y)
; output: $00 = y speed, $01 = x speed
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Aiming:
    STA $01
    PHX                     ;\ preserve sprite indexes of Magikoopa and magic
    PHY                     ;/
    %SubVertPos()           ; $0E = vertical distance to Mario
    STY $02                 ; $02 = vertical direction to Mario
    LDA $0F                 ;\ $0C = vertical distance to Mario, positive
    BPL +                   ; |
        EOR #$FF            ; |
        CLC : ADC #$01      ; |
+   STA $0C                 ;/
    %SubHorzPos()           ; $0F = horizontal distance to Mario
    STY $03                 ; $03 = horizontal direction to Mario
    LDA $0E                 ;\ $0D = horizontal distance to Mario, positive
    BPL +                   ; |
        EOR #$FF            ; |
        CLC : ADC #$01      ; |
+   STA $0D
    LDY #$00
    LDA $0D                 ;\ if vertical distance less than horizontal distance,
    CMP $0C                 ; |
    BCS +                   ;/ branch
        INY                 ; set y register
        PHA                 ;\ switch $0C and $0D
        LDA $0C             ; |
        STA $0D             ; |
        PLA                 ; |
        STA $0C             ;/
+   STZ $0B                 ;\ zero out $00 and $0B
    STZ $00                 ;/
    LDX $01                 ;\ divide $0C by $0D?
-   LDA $0B                 ; |\ if $0C + loop counter is less than $0D,
    CLC : ADC $0C           ; | |
    CMP $0D                 ; | |
    BCC +                   ; |/ branch
        SBC $0D             ; | else, subtract $0D
        INC $00             ; | and increase $00
+   STA $0B                 ; |
    DEX                     ; |\ if still cycles left to run,
    BNE -                   ;/ / go to start of loop
    TYA                     ;\ if $0C and $0D was not switched,
    BEQ +                   ;/ branch
        LDA $00             ;\ else, switch $00 and $01
        PHA                 ; |
        LDA $01             ; |
        STA $00             ; |
        PLA                 ; |
        STA $01             ;/
+   LDA $00                 ;\ if horizontal distance was inverted,
    LDY $02                 ; | invert $00
    BEQ +                   ; |
        EOR #$FF            ; |
        CLC : ADC #$01      ; |
        STA $00             ;/
+   LDA $01                 ;\ if vertical distance was inverted,
    LDY $03                 ; | invert $01
    BEQ +                   ; |
        EOR #$FF            ; |
        CLC : ADC #$01      ; |
        STA $01             ;/
+   PLY                     ;\ retrieve Magikoopa and magic sprite indexes
    PLX                     ;/
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Disappear:
    LDA !1540,x                 ;\ only run code every third frame
    BNE .return                 ; |
    LDA #$02                    ; |
    STA !1540,x                 ;/
    DEC !1570,x 
    LDA !1570,x                 ;\ if palette changing done,
    BNE .palette                ;/ branch
    ;INC !sprite_state,x         ; go to next sprite state
    STZ !sprite_state,x
    LDA #$10                    ;\ set time until next appeareance
    STA !1540,x                 ;/
    PLA                         ;\ return directly from main routine, skipping graphics routine
    PLA                         ;/
.return 
    RTS                         ; return

.palette
    JMP ChangePalette

CheckPalette:
    LDA !1540,x                     ;\ only run code every fifth frame
    BNE .return                     ; |
    LDA #$04                        ; |
    STA !1540,x                     ;/
    INC !1570,x                
    LDA !1570,x                     ;\ if palette changing done,
    CMP #$09                        ; |
    BNE +                           ;/ branch
        LDY #$24                    ;\ again, colour addition stuff
        STY $40                     ;/
+   CMP #$09                        ;\ if palette changing done, (...again?)
    BNE ChangePalette               ;/ branch
    INC !sprite_state,x             ; go to next sprite state
    LDA #$70                        ;\ set time before appearing again
    STA !1540,x                     ;/
.return
    RTS                             ; return

ChangePalette:
    LDA !1570,x                 ;\ get colour table offset
    DEC A                       ; |
    ASL #4                      ; |
    TAX                         ;/
    STZ $00                     ; setup loop
    LDY $0681|!Base2            ; get initial palette offset
-   LDA Palettes,x              ;\ set new colour
    STA $0684|!Base2,y          ;/
    INY                         ; increase palette offset
    INX                         ; increase colour table offset
    INC $00                     ; increase loop counter
    LDA $00                     ;\ if still colours left to change,
    CMP #$10                    ; |
    BNE -                       ;/ go to start of loop
    LDX $0681|!Base2            ;\ yay for doing stuff to unknown RAM addresses!
    LDA #$10                    ; |
    STA $0682|!Base2,x          ; |
    LDA #$F0                    ; |
    STA $0683|!Base2,x          ; |
    STZ $0694|!Base2,x          ; |
    TXA                         ; |
    CLC : ADC #$12              ; |
    STA $0681|!Base2            ;/
    LDX $15E9|!Base2            ; retrieve sprite index
    RTS                         ; return

Palettes:
    db $FF,$7F,$4A,$29,$00,$00,$00,$14
    db $00,$20,$92,$7E,$0A,$00,$2A,$00
    db $FF,$7F,$AD,$35,$00,$00,$00,$24
    db $00,$2C,$2F,$72,$0D,$00,$AD,$00
    db $FF,$7F,$10,$42,$00,$00,$00,$30
    db $00,$38,$CC,$65,$50,$00,$10,$01
    db $FF,$7F,$73,$4E,$00,$00,$00,$3C
    db $41,$44,$69,$59,$B3,$00,$73,$01
    db $FF,$7F,$D6,$5A,$00,$00,$00,$48
    db $A4,$50,$06,$4D,$16,$01,$D6,$01
    db $FF,$7F,$39,$67,$00,$00,$42,$54
    db $07,$5D,$A3,$40,$79,$01,$39,$02
    db $FF,$7F,$9C,$73,$00,$00,$A5,$60
    db $6A,$69,$40,$34,$DC,$01,$9C,$02
    db $FF,$7F,$FF,$7F,$00,$00,$08,$6D
    db $CD,$75,$00,$28,$3F,$02,$FF,$02

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Graphics routine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Graphics:
    %GetDrawInfo()
    LDA !1602,x                     ;\ use graphics frame to determine initial tile table offset
    ASL A                           ; |
    STA $03                         ;/
    LDA !sprite_direction,x
    STA $02
    PHX                             ; preserve sprite index
    LDX #$01                        ; setup loop counter
-   LDA $01                         ;\ set y position of tile
    CLC : ADC Y_Disp,x              ; |
    STA !OAM_DispY,y                ;/
    LDA $00                         ;\ set x position of tile
    STA !OAM_DispX,y                ;/
    PHX                             ; preserve loop counter
    LDX $03                         ; get tilemap index
    LDA Tilemap,x                   ;\ set tile number
    STA !OAM_Tile,y                 ;/
    LDX $15E9|!Base2                ; load sprite index
    LDA !15F6,x                     ; load sprite graphics properties
    PLX                             ; retrieve loop counter
    PHY                             ; preserve OAM index
    LDY $02                         ;\ if sprite facing right,
    BNE +                           ; |
        EOR #$40                    ;/ flip tile
+   PLY                             ; retrieve OAM index
    ORA $64                         ; add in level properties
    STA !OAM_Prop,Y                 ; set tile properties
    INY #4
    INC $03
    DEX                             ; decrease loop counter
    BPL -                           ; if still tiles left to draw, go to start of loop
    PLX                             ; retrieve sprite index
    LDY #$02                        ; the tiles written were 16x16
    LDA #$01                        ; we wrote two tiles
    JSL $01B7B3|!BankB
    RTS                             ; return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SparkleEffect:
    LDA !RAM_FrameCounter               ;\ only run code every fourth frame
    AND #$03                            ; |
    ORA !sprite_off_screen_vert,x       ; | if sprite offscreen vertically
    ORA !RAM_SpritesLocked              ; | or sprites locked,
    BNE .return                         ;/ return
    JSL $01ACF9|!BankB                  ;\ #$02 = sprite xpos low byte + random number between 0x-5 and 0xB
    AND #$0F                            ; |
    CLC                                 ; |
    LDY #$00                            ; |
    ADC #$FC                            ; |
    BPL +                               ; |
        DEY                             ; |
+   CLC                                 ; |
    ADC !sprite_x_low,x                 ; |
    STA $02                             ;/
    TYA                                 ;\ if $02 means an offscreen location?
    ADC !sprite_x_high,x                ; |
    PHA                                 ; |
    LDA $02                             ; |
    CMP !RAM_ScreenBndryXLo             ; |
    PLA                                 ; |
    SBC !RAM_ScreenBndryXHi             ; |
    BNE .return                         ;/ return
    LDA $148E|!Base2                    ;\ #$00 = sprite ypos low byte + random number between 0x-2 and 0xD
    AND #$0F                            ; |
    CLC : ADC #$FE                      ; |
    ADC !sprite_y_low,x                 ; |
    STA $00                             ;/
    LDA !sprite_y_high,x                ;\ #$01 = sprite ypos high byte with changes for earlier random number
    ADC #$00                            ; |
    STA $01                             ;/
    JSL $0285BA|!BankB                  ; sparkle effect
.return
    RTS

;custom interactions for thrown stuff and player stomping (should minus one hitpoint)
CustomInteractions:
;first check for sprites interaction

		    LDY #!SprSize-1         ; 
.LOOP		    LDA !14C8,y             ; \ if the sprite status is..
		    CMP #$09                ;  | ...shell-like
		    BEQ .PROCESS_SPRITE      ; /
		    CMP #$0A                ; \ ...throwned shell-like
		    BEQ .PROCESS_SPRITE      ; /
.NEXT_SPRITE	    DEY                     ;
		    BPL .LOOP                ; ...otherwise, loop
		    BRA .PlayerIntCheck

.PROCESS_SPRITE	    PHX                     ; push x
		    TYX                     ; transfer x to y
		    JSL $03B6E5|!BankB      ; get sprite clipping B routine
		    PLX                     ; pull x
		    JSL $03B69F|!BankB      ; get sprite clipping A routine
		    JSL $03B72B|!BankB      ; check for contact routine
		    BCC .NEXT_SPRITE         ;

		    PHX                     ; push x
		    TYX                     ; transfer x to y

		    STZ !14C8,x             ; destroy the sprite

		    LDA !E4,x               ; \ setup block properties
                    STA $9A                 ;  |
                    LDA !14E0,x             ;  |
                    STA $9B                 ;  |
                    LDA !D8,x               ;  |
                    STA $98                 ;  |
                    LDA !14D4,x             ;  |
                    STA $99                 ; /

		    PHB                     ; \ set the exploding block routine
		    LDA #$02                ;  |
		    PHA                     ;  |
		    PLB                     ;  |
		    LDA #$FF                ;  | $FF = set flashing palette
		    JSL $028663|!BankB      ;  |
		    PLB                     ; /

		    PLX                     ; pull x
BRA .GotHit

.PlayerIntCheck
JSL $01A7DC|!bank
BCC .Re

%SubVertPos()
LDA $0E
CMP #$E6                ;  |     ... sprite wins
BMI .MaybeHit

.Hurt
;hurt player.
JSL $00F5B7|!BankB

.Re
RTS

.MaybeHit
LDA $7D
BMI .Hurt

JSL $01AA33|!BankB	; boost the player's speed
JSL $01AB99|!BankB

.GotHit
LDA #!HitSound
STA !HitSndBank|!addr

LDA #$04				;got hit state
STA !sprite_state,x

DEC !HitPointsRAM,x

LDA #!HitIdleTime
STA !HitTimer,x

STZ !1540,x

	JSR Graphics			;don't disappear for a frame
	JSR ShowWandMaybe		;

;but terminate further codes stuff
PLA
PLA
RTS