; Speeds (right, left)

!Radius = $10  ; radius of circle
!Speed = $04   ; rotation speed


; check which of these are actually used

			!RAM_SpriteYLo		= !D8
			!RAM_SpriteXLo		= !E4

			!RAM_SpriteYHi		= !14D4
			!RAM_SpriteXHi		= !14E0


; four misc sprite tables to store the center location
			!RAM_CenterYLo		= !1504
			!RAM_CenterXLo		= !1510
			!RAM_CenterYHi		= !1570
			!RAM_CenterXHi		= !1594


			!RAM_ExtraBits 		= !7FAB10
			!RAM_NewSpriteNum	= !7FAB9E




print "INIT ",pc
    %SubHorzPos()           ; face mario initially
    TYA
    STA !157C,x
    
    
    LDA #$00			;\ set initial angle ($0000-$01FF)
	STA !151C,x			; | $151C is the high byte
	LDA #$00			; |
	STA !1602,x			;/ $161C is the low byte

    LDA #!Radius
    STA !187B,x

; set center to initial location
    LDA !RAM_SpriteYLo,x		
	STA !RAM_CenterYLo,x		
    LDA !RAM_SpriteXLo,x		
    STA !RAM_CenterXLo,x
	LDA !RAM_SpriteYHi,x		
	STA !RAM_CenterYHi,x
    LDA !RAM_SpriteXHi,x		
    STA !RAM_CenterXHi,x

	RTL				; return


print "MAIN ",pc
    PHB : PHK : PLB
    JSR SpriteCode
    PLB
    RTL



SpriteCode:
    LDA !14C8,x             ; return if sprite status != 8
    CMP #$08
    BNE Return
    LDA $9D                 ; return if sprites locked
    BNE Return
    LDA #$00
    %SubOffScreen()         ; only process sprite while on screen    
    
    JSR Circle
    RTS
    
Return:
    JSR Graphics
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


    LDA #$46			; set the sprite tilemap
    STA $0302|!Base2,y			;
    
    

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




CODE_02D800:		NOP				;\ this routine exists for the sole purpose of wasting cycles
			NOP				; | while the multiplication or division registers do their work
			NOP				; |
			NOP				; |
			NOP				; |
			NOP				;/
Return02D806:		RTS				; return


Circle:

    
            LDA #$04
CODE_02D643:		CLC				;\ update angle depending on direction of rotation
			ADC !1602,x			; | $1602,x is used to store the low byte of the ball n' chain angle
			STA !1602,x			; |
			LDA #$00
			ADC !151C,x			; | and $151C,x for the high byte
			AND #$01			; |
			STA !151C,x			; |
CODE_02D653:		LDA !151C,x			; |
			STA $01				; | $00-$01 = ball n' chain angle
			LDA !1602,x			; |
			STA $00				;/




			REP #$30			; set 16-bit mode for accumulator and registers


			LDA $00				;\ $02-$03 = ball n' chain angle + 90 degrees
			CLC				; |
			ADC #$0080			; |
			AND #$01FF			; |
			STA $02				;/


			LDA $00				;\ $04-$05 = cosines of ball n' chain angle
			AND #$00FF			; |
			ASL				; |
			TAX				; |
			LDA $07F7DB,x			; | this is SMW's trigonometry table
			STA $04				;/
 

			LDA $02				;\ $06-$07 = cosines of ball n' chain angle + 90 degrees = sines for ball n' chain angle
			AND #$00FF			; |
			ASL				; |
			TAX				; |
			LDA $07F7DB,x			; |
			STA $06				;/

			SEP #$30			; set 8-bit mode for accumulator and registers


			LDX $15E9|!Base2			; get sprite index
            
                
            if !SA1
            STZ $2250
			LDA $04				;\ multiply $04...
			STA $2251
            STZ $2252			; |
			LDA !187B,x			; |
			LDY $05				; |\ if $05 is 1, no need to do the multiplication
			BNE CODE_02D6A3			; |/
			STA $2253			; | ...with radius of circle ($187B,x)
            STZ $2254
			NOP
            BRA $00
			ASL $2306			; Product/Remainder Result (Low Byte)
			LDA $2307			; Product/Remainder Result (High Byte)
            else
			LDA $04				;\ multiply $04...
			STA $4202			; |
			LDA !187B,x			; |
			LDY $05				; |\ if $05 is 1, no need to do the multiplication
			BNE CODE_02D6A3			; |/
			STA $4203			; | ...with radius of circle ($187B,x)
			JSR CODE_02D800			;/ waste some cycles while the result is calculated
			ASL $4216			; Product/Remainder Result (Low Byte)
			LDA $4217			; Product/Remainder Result (High Byte)
            endif
			ADC #$00			
CODE_02D6A3:		LSR $01				
			BCC CODE_02D6AA			
			EOR #$FF			
			INC A				
CODE_02D6AA:		STA $04				
            if !SA1
            STZ $2250
			LDA $06				;\ multiply $06...
			STA $2251 			; |
            STZ $2252
			LDA !187B,x			; |
			LDY $07				; |\ if $07 is 1, no need to do the multiplication
			BNE CODE_02D6C6			; |/
			STA $2253
            STZ $2254			; | ...with raidus of circle ($187B,x)
			NOP
            BRA $00
			ASL $2306			; Product/Remainder Result (Low Byte)
			LDA $2307			; Product/Remainder Result (High Byte)
            else
			LDA $06				;\ multiply $06...
			STA $4202 			; |
			LDA !187B,x			; |
			LDY $07				; |\ if $07 is 1, no need to do the multiplication
			BNE CODE_02D6C6			; |/
			STA $4203			; | ...with raidus of circle ($187B,x)
			JSR CODE_02D800			;/ waste some cycles while the result is calculated
			ASL $4216			; Product/Remainder Result (Low Byte)
			LDA $4217			; Product/Remainder Result (High Byte)
            endif
			ADC #$00			
CODE_02D6C6:		LSR $03				
			BCC CODE_02D6CD			
			EOR #$FF			
			INC A				
CODE_02D6CD:		STA $06				



AddOffset:
			
			STZ $00				;
			LDA $04				; |   x offset low byte
			BPL CODE_02D6E8			; |
			DEC $00				; |
CODE_02D6E8:		CLC				; |
			ADC !RAM_CenterXLo,x		; | + x position of rotation center low byte
            STA !RAM_SpriteXLo,x		;/  = sprite x position low byte

			;PHP				;\
			;PHA				; |
			;SEC				; |
			;SBC !1534,x			; |
			;STA !1528,x			; |
			;PLA				; |
			;STA !1534,x			; |
			;PLP				;/

			LDA !RAM_CenterXHi,x		;\    x position of rotation center high byte
			ADC $00				; | + adjustment for screen boundaries
			STA !RAM_SpriteXHi,x		;/  = x position of sprite high byte
			STZ $01				;
			LDA $06				; |   y offset low byte
			BPL CODE_02D70B			; |
			DEC $01				; |
CODE_02D70B:		CLC				; |
			ADC !RAM_CenterYLo,x		; | + y position of rotation center low byte
			STA !RAM_SpriteYLo,x		;/  = sprite y position low byte

			LDA !RAM_CenterYHi,x		;\    y position of center of rotation high byte
			ADC $01				; | + adjustment for screen boundaries
			STA !RAM_SpriteYHi,x		;/  = sprite y position high byte



    JSR Graphics

    ;JSL $018032|!BankB      ; interact with other sprites
    JSL $01A7DC|!BankB      ; check for mario/sprite contact





    RTS