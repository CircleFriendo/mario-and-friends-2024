;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; generic projectile
;;
;; Uses first extra bit: NO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Tilemap table
TILEMAP:
db $A0,$C0		;frame 1, frame 2

;Sprite speeds
SpeedX:	
	db $20,$E0	;right, left

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; sprite init JSL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        print "INIT ",pc
        PHY
        %SubHorzPos()
        TYA
        STA !157C,x
        PLY
        RTL                 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; sprite code JSL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        print "MAIN ",pc
        PHB                     
        PHK                     
        PLB                     
        JSR MainSub
        PLB                     
        RTL                     

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; sprite main code 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MainSub:	
	JSR SubGfx		; Draw Sprite
        LDA !14C8,x             
        CMP #$08                
        BNE RETURN              
        LDA $9D                 ; Return if sprites locked
        BNE RETURN              

	LDA #$00
	%SubOffScreen()

        LDY !157C,x             ; Set X speed based on direction
        LDA SpeedX,y		
        STA !B6,x
                                        
	JSL $018022|!BankB	;Update X position based on speed (no gravity/object interaction)

	JSL $01A7DC|!BankB      ;check for mario/sprite contact
RETURN:
	RTS             
                  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; sprite graphics routine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SubGfx:
		    %GetDrawInfo()

                    LDA !157C,x             ; \ $02 = direction
                    STA $02                 ; /

                    LDA $14                 ; \ 
                    LSR #3                  ;  |
                    CLC                     ;  |
                    ADC $15E9|!Base2        ;  |
                    AND #$01                ;  |
                    STA $03                 ;  | $03 = index to frame start (0 or 1)
                    PHX                     ; /

LOOP_START_2:
		    REP #$20
		    LDA $00
                    STA $0300|!Base2,y
		    SEP #$20

                    LDX $03                 ; \ store tile
                    LDA TILEMAP,x           ;  |
                    STA $0302|!Base2,y      ; /

		    LDX $15E9|!Base2
                    LDA !15F6,x             ; tile properties yxppccct, format
                    LDX $02                 ; \ if direction == 0...
                    BNE NO_FLIP             ;  |
                    ORA #$40                ; /    ...flip tile
NO_FLIP:            ORA $64                 ; add in tile priority of level
                    STA $0303|!Base2,y      ; store tile properties

                    PLX                     ; pull, X = sprite index
                    LDY #$02                ; \ 460 = 2 (all 16x16 tiles)
                    LDA #$00                ;  | A = (number of tiles drawn - 1)
                    JSL $01B7B3|!BankB      ; / don't draw if offscreen
                    RTS                     ; return