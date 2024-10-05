;Customized Firebar
;by Isikoro

Fireball_Tile:	db $2C,$2D,$2C,$2D	;Small
				db $A6,$AA,$A6,$AA	;Big
Fireball_Prop:	db $04,$04,$C4,$C4	;Small
				db $05,$05,$C5,$C5	;Big

RotoDisc_Tile:		db $00				;Small
					db $02,$04,$22,$24	;Big
RotoDisc_Prop:		db $01				;Small
					db $01,$01,$01,$01	;Big
RotoDisc_XOffset:	db $00,$F8,$08,$F8,$08
RotoDisc_YOffset:	db $FF,$F7,$F7,$07,$07

Chain_TileProp:	db $3D	;Small_Tile
				db $02	;Small_Prop
				db $E8	;Big_Tile
				db $03	;Big_Prop
				db $A2	;Platform_Tile
				db $03	;Platform_Prop
				db $A2	;Platform_Tile
				db $03	;Platform_Prop
Ball_Tile:		db $20	;Small
				db $EA,$EA,$EA,$EA	;Big
Ball_Prop:		db $03	;Small
				db $03,$43,$83,$C3	;Big
Ball_XOffset:	db $FC,$F8,$08,$F8,$08
Ball_YOffset:	db $FC,$F8,$F8,$08,$08

Lift_Tile:		db $60,$61,$62
Lift_Prop:		db $03,$03,$03

Lift_RightOnly:	dw $FFE8,$FFE0,$FFD8,$FFD0
Lift_RightOut:	dw $0108,$0110,$0118,$0120
Lift_Tile_Minus: dw $00F8,$00F0,$00E8,$00E0
Lift_XClipShift: dw $0000,$FFF0,$FFE8,$FFE0
Lift_LeftShift:  db $10,$20,$30,$40

Clip_Size:		db $06,$00,$0C
Clip_Disp:		dw $0001,$0002
Obj_TileNum:	db $04,$10,$08,$0C,$10,$14

!X_Spacing = $0DC9|!Base2
!Y_Spacing = $0DD1|!Base2
!X_Contact = $0DCB|!Base2
!Y_Contact = $0DCD|!Base2

					print "INIT ",pc
					STZ $0E
					LDA #$80 : STA !1588,x
					LDA #$04 : STA !1602,x
					LDA !extra_prop_1,x
					AND #$3F : ASL : STA !1534,x
					TAY
					LDA #$27 : STA !1662,x
					LDA !extra_byte_1,x	
					STA !AA,x
					
					CPY #$06 : BNE Init_NotPlat
					LDY #$01
					AND #$30 : BNE + : LDA #$08 : BRA ++	; 横２タイル幅
+					CMP #$10 : BNE + : LDA #$04 : BRA ++	; 横３タイル幅
+					INY
					CMP #$20 : BNE + : LDA #$33 : BRA ++	; 横４タイル幅
+					LDA #$05								; 横５タイル幅
++					STA !1662,x
					
					STY $0E
					LDA !AA,x : AND #$0F : STA !160E,x : INC : TAY
					LDA !extra_prop_1,x : ASL
					TYA
					BRA Plat_Chain
					
Init_NotPlat:		CPY #$02 : BEQ Init_RotoDisc
					CPY #$04 : BNE Init_NotBall
					LDY #$03 : STY $0E
Init_NotBall:		BIT #$20 : BNE Big_Chain
					STZ !1602,x : STZ !1662,x
					AND #$1F : STA !160E,x
					LDA !E4,x : ORA #$04 : STA !E4,x
					LDA !D8,x : ORA #$04 : STA !D8,x
					BRA +
Init_RotoDisc:		BIT #$20 : BNE Big_RotoDisc
					STZ !1602,x : STZ !1662,x
Big_RotoDisc:		AND #$1F : ASL #3 : STA !160E,x
					LDA !AA,x : AND #$1F : LSR : BRA Disc_Dist
					
Big_Chain:			AND #$1F : STA !160E,x		;ファイアボールの数－１
+					LDA !extra_prop_1,x : ASL
					LDA !160E,x
Plat_Chain:			BCC + : ASL					; １個分間隔フラグ
					LDY !1534,x : CPY #$04 : BNE +
					CLC : ADC #$03
+					LDY !1602,x : BNE Disc_Dist		; 鎖の大きさ
					LDY !1534,x : CPY #$04 : BNE Disc_Dist-1
					CLC : ADC #$03 : STZ $0E
					LSR
Disc_Dist:			SEC : SBC #$02 : CLC : ADC $0E
					BPL $02 : LDA #$00
					REP #$21 : AND #$00FF
					ASL #4 : SEP #$20
					STA !15F6,x : XBA : STA !1FD6,x	;画面外生存可能範囲
					
					LDA !extra_byte_2,x	: STA $0F
					AND #$7F : STA !B6,x
					
					LDA !extra_bits,x : AND #$04
					BEQ +
					LDA !B6,x : EOR #$FF : INC : STA !B6,x
					
+					LDA !extra_byte_3,x : TAY
					ASL #5 : ORA #$08 : STA !C2,x
					TYA : LSR #3 : STA !1504,x
					
					LDA !extra_prop_2,x
					BEQ .UnUsed_Table
					LDA !extra_byte_1,x	: STA $0F
					AND #$40 : STA !1594,x
					BRA Init_Not_Pendulum
.UnUsed_Table:		LDA !extra_byte_4,x
					TAY : LSR #4 : STA $00
					TYA : ASL #4 : ORA $00
					STA !extra_byte_4,x
					AND #$08 : STA !1594,x
					
					TYA
					AND #$F7 : BEQ Init_Not_Pendulum
					
					LDA !extra_bits,x : AND #$FB
					LDY !B6,x : BMI +
					ORA #$04
+					STA !extra_bits,x
					
Init_Not_Pendulum:	LDA !E4,x : STA $04	: LDA !14E0,x : STA $05
					LDA !D8,x : STA $06 : LDA !14D4,x : STA $07
					
					LDA !1594,x : BEQ +
					
					REP #$20
					
					SEC : LDA $1E : SBC $1466|!Base2 : STA $00
					SEC : LDA $20 : SBC $1468|!Base2 : STA $02
					
					SEC : LDA $1462|!Base2 : SBC $1466|!Base2 : STA $0A
					SEC : LDA $1464|!Base2 : SBC $1468|!Base2 : STA $0C
					
					CLC : LDA $04 : ADC $0A : STA $04
					CLC : LDA $06 : ADC $0C : STA $06
					
					SEP #$20
					
					STA !D8,x : XBA : STA !14D4,x
					LDA $04 : STA !E4,x : LDA $05 : STA !14E0,x
					
+					LDA !extra_prop_1,x : AND #$40
					BEQ No_Shift
					
					LDA $5B : LSR
					BCS Shift_Vert
					
					LDA !14E0,x : XBA : LDA !E4,x
					LDY $0F : BMI Shift_Left
Shift_Right:		CLC : ADC !15F6,x : STA !E4,x
					LDA !14E0,x : ADC !1FD6,x : STA !14E0,x
					BRA Overlap_Check
					
Shift_Left:			SEC : SBC !15F6,x : STA !E4,x
					LDA !14E0,x : SBC !1FD6,x : STA !14E0,x
					BRA Overlap_Check
					
Shift_Vert:			LDA !D8,x : LDY $0F : BMI Shift_Top
Shift_Bottom:		CLC : ADC !15F6,x : STA !D8,x
					LDA !14D4,x : ADC !1FD6,x : STA !14D4,x
					BRA Overlap_Check
					
Shift_Top:			SEC : SBC !15F6,x : STA !D8,x
					LDA !14D4,x : SBC !1FD6,x : STA !14D4,x
					BRA Overlap_Check
					
Overlap:			LDX $15E9|!Base2
Shift_Erase:		LDA #$80 : STA !14E0,x : STA !14D4,x
					STA !15A0,x
					%SubOffScreenWithDistance()
No_Shift:			RTL

Overlap_Check:		LDA !extra_byte_1,x : STA $0C
					LDA !extra_byte_3,x : STA $0D
					LDA !extra_bits,x : STA $0B
					LDA !extra_prop_1,x : STA $09
					LDA !extra_prop_2,x : AND #$7F : STA $0A
					LDA !7FAB9E,x : STA $0F : TXY
					LDX #!SprSize-1
.Loops:				CPX $15E9|!Base2 : BEQ .Next
					LDA !7FAB9E,x
					CMP $0F : BEQ .Position_Check
.Next:				DEX : BPL .Loops
					LDX $15E9|!Base2
					RTL

.Position_Check:	LDA !extra_byte_1,x : CMP $0C : BNE .Next
					LDA !extra_byte_3,x : CMP $0D : BNE .Next
					LDA !extra_bits,x : CMP $0B : BNE .Next
					LDA !extra_prop_1,x : CMP $09 : BNE .Next
					LDA !extra_prop_2,x : AND #$7F : CMP $0A : BNE .Next
					LDA !14C8,x : CMP #$08 : BNE .Next
					LDA !1594,y : BEQ +
					CPX $15E9|!Base2 : BCC .Layer2_Interlocking
+					LDA !D8,x : CMP !D8,y : BNE .Next
					LDA !14D4,x : CMP !14D4,y : BNE .Next
					LDA !E4,x : CMP !E4,y
.Next_:				BNE .Next : LDA !14E0,x
-					CMP !14E0,y : BNE .Next
					JMP Overlap
.Layer2_Interlocking:
					SEC
					LDA !D8,y : SBC $02 : EOR !D8,x : BNE .Next
					LDA !14D4,y : SBC $03 : EOR !14D4,x : BNE .Next
					SEC
					LDA !E4,y : SBC $00 : EOR !E4,x : BNE .Next_
					LDA !14E0,y : SBC $01 : BRA -
					
                    print "MAIN ",pc
                    PHB : PHK : PLB
                    JSR START_SPRITE_CODE
					LDA !1594,x : BEQ +
					LDA $9D : BNE +
					REP #$20
					SEC : LDA $1E : SBC $1466|!Base2 : STA $00
					SEC : LDA $20 : SBC $1468|!Base2 : STA $02
					SEP #$20
					CLC
					LDA !D8,x : ADC $02 : STA !D8,x
					LDA !14D4,x : ADC $03 : STA !14D4,x
					CLC
					LDA !E4,x : ADC $00 : STA !E4,x
					LDA !14E0,x : ADC $01 : STA !14E0,x
+                   PLB : RTL
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Carry_Offset:		db $00,$FF
					
START_SPRITE_CODE:	LDA $13D8|!Base2 : STA $08
					LDA !14E0,x : STA $09
					LDA $5B : AND #$01
					BEQ .Horizontal
					STA !14E0,x					;レイヤー２と共に動かして
.Horizontal:		LDA #$40 : STA $13D8|!Base2 ;コースから出ても消えないように
					LDA !1602,x : STA $D7 		;ファイアボール又は鎖のサイズが小なら00、大なら04
					LDA !160E,x : STA $0C			;ファイアボール又は鎖の数－１・クッキーの中心軸との距離
					LDA !1FD6,x : XBA : LDA !15F6,x
					REP #$20
					%SubOffScreenWithDistance()
					
					LDA $09 : STA !14E0,x
					LDA $08 : STA $13D8|!Base2
					
					LDA !extra_prop_2,x : BEQ UnUsed_Table
					BMI Table_16Bit
					AND #$7F : STA $0B
					LDA !extra_byte_3,x : STA $09
					LDA !extra_byte_4,x : STA $0A
					LDA [$09]
					CLC : ADC !extra_byte_2,x
					TAY
					LDA !extra_bits,x
					AND #$04 : BEQ Table_Clockwise
					TYA : EOR #$FF : INC : TAY
Table_Clockwise:	TYA : LSR #3 : XBA
					TYA : ASL #5 : ORA #$08
					BRA Use_Table
Table_16Bit:		AND #$7F : STA $0B
					LDA !extra_byte_3,x : STA $09
					LDA !extra_byte_4,x : STA $0A
					LDA !extra_bits,x : AND #$04 : PHA
					REP #$20
					LDA !extra_byte_2-1,x : AND #$FF00 : LSR #3
					CLC : ADC [$09] 
					PLY : BEQ Use_Table+2
					EOR #$FFFF : INC
					BRA Use_Table+2
					
UnUsed_Table:		LDA !1504,x : XBA : LDA !C2,x
Use_Table:			REP #$20
					LSR #4 : STA $04
					DEC : LSR : SEP #$21
					SBC #$C0 : STA $0F
					LDA !extra_byte_1,x : AND #$C0
					STA $0E
					SEC
					LDA $0F : SBC $0E : STA $0F
					
Circle:				LDA !1534,x : TXY : TAX
					JMP (.Routines,x)
					
.Routines:			dw .Firebar
					dw .RotoDisc
					dw .Ball_n_Chain
					dw .Rotating_Platform
					
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					
.Firebar:			REP #$30
					LDA $04
					AND #$00FF : ASL : TAX		;cos_index
					EOR #$0100 : TAY			;sin_index
					LDA $04 : LSR : STA $D5
					LDA $07F7DB|!BankB,x
					ASL #3
					TYX					;sin
					
					LDY $D4
					BPL $04 : EOR #$FFFF : INC
					STA !Y_Spacing		;Vertical spacing between fireballs

					LDA $07F7DB|!BankB,x
					ASL #3
					
					CPY #$C000
					BPL $04 : EOR #$FFFF : INC
					STA !X_Spacing		;Horizontal spacing between fireballs
					SEP #$30
					
					LDX $15E9|!Base2
					
					JMP Circle_Return
					
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					
.RotoDisc:		if !sa1
					STZ $2250 : STZ $0D
				endif
					REP #$30
					LDA $04
					AND #$00FF : ASL : TAX		;cos_index
					EOR #$0100 : TAY			;sin_index
					LDA $04 : LSR : STA $D5
					LDA $07F7DB|!BankB,x
				if !sa1
					STA $2251
					LDA $0C : STA $2253
					STZ $0A
					TYX					;sin
					LDA $2306
				else
					STA !Y_Spacing
					SEP #$20 : STA $211B
					XBA : STA $211B
					LDA $0C : LSR : STA $211C
					REP #$20
					BCS $03 : STZ !Y_Spacing
					STZ $0A
					TYX					;sin
					LDA $2134 : ASL
					CLC : ADC !Y_Spacing
				endif
					BEQ $0A
					LDY $D4
					BPL $06 : EOR #$FFFF : INC : DEC $0A
					STA !Y_Spacing		;Vertical spacing between fireballs
					LDY $D4

					LDA $07F7DB|!BankB,x
				if !sa1
					STA $2251
					LDA $0C : STA $2253
					REP #$20
					STZ $08
					LDA $2306
				else
					STA !X_Spacing
					SEP #$20 : STA $211B
					XBA : STA $211B
					LDA $0C : LSR : STA $211C
					REP #$20
					BCS $03 : STZ !X_Spacing
					STZ $08
					LDA $2134 : ASL
					CLC : ADC !X_Spacing
				endif
					BEQ $0B
					CPY #$C000
					BPL $06 : EOR #$FFFF : INC : DEC $08
					STA !X_Spacing		;Horizontal spacing between fireballs
					
					SEP #$30
					
					LDX $15E9|!Base2
					
					JMP Circle_Return
					
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					
.Rotating_Platform:	LDA !157C,y : STA $07
					LDA !1510,y : STA $06
					LDA !15B8,y : STA $09
					LDA !1588,y : STA $08
.Ball_n_Chain:		REP #$30
					STX $0D
					LDA $04
					AND #$00FF : ASL : TAX		;cos_index
					EOR #$0100 : TAY			;sin_index
					LDA $04 : LSR : STA $D5
					LDA $07F7DB|!BankB,x
					LDX $D4
					BPL $04 : EOR #$FFFF : INC
					STA !Y_Contact
					TYX					;sin
					LDA $07F7DB|!BankB,x
					LDX $D4 : CPX #$C000
					BPL $04 : EOR #$FFFF : INC
					STA !X_Contact
					LDX $0D : CPX #$0004 : BNE +
					STA $06 : LDA !Y_Contact : BRA $02
+					LDA $08
					ASL #2 : STA $0DCF|!Base2 : ASL
					STA !Y_Spacing		;Vertical spacing between fireballs
					CLC : ADC $0DCF|!Base2 : STA $0DCF|!Base2
					LDA $06
					ASL #2 : STA $0DC7|!Base2 : ASL
					STA !X_Spacing		;Horizontal spacing between fireballs
					CLC : ADC $0DC7|!Base2 : STA $0DC7|!Base2
					SEP #$30
					
					LDX $15E9|!Base2
					
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					
Circle_Return:		LDA !14C8,x	: CMP #$08 : BNE RETURN_
					LDA $9D : BNE RETURN_
					LDA !extra_prop_2,x : BNE RETURN_
					
					LDA !extra_byte_4,x : TAY
					AND #$F7 : BEQ Not_Pendulum
					AND #$07 : STA $05
					TYA : AND #$F0 : STA $06 ; Accumulating fraction bits for fixed point Rotational speed.
					LDY $0F : CPY #$7F : BEQ ++
					BCS To_Counter
					
To_Clockwise:		LDA !151C,x : ADC $06 : STA !151C,x
					LDA !B6,x : ADC $05 : STA !B6,x
					LDA !extra_bits,x
					BCC Pendulum_Return : ORA #$04 : STA !extra_bits,x
					BRA Pendulum_Return
					
++					LDA !extra_bits,x
					BRA Pendulum_Return
					
To_Counter:			LDA !151C,x : SBC $06 : STA !151C,x
					LDA !B6,x : SBC $05 : STA !B6,x
					LDA !extra_bits,x
					BCS Pendulum_Return : AND #$FB : STA !extra_bits,x
					
Pendulum_Return:	LDY #$00
					AND #$04 : BNE $01 : DEY
+					LDA !B6,x : CLC : ADC !C2,x : STA !C2,x
					TYA : ADC !1504,x : STA !1504,x
RETURN_:			BRA RETURN
					
Not_Pendulum:		LDY #$00
					LDA !AA,x : BIT #$C0
					BEQ ONOFF_Unrelated
					BPL ONOFF_Inversion
					
					CLC : AND #$40 : ROL #3 : EOR $14AF|!Base2 : BEQ RETURN
					
ONOFF_Inversion:	LDA $14AF|!Base2 : BEQ ONOFF_Unrelated
					LDA !B6,x : EOR #$FF : INC : BRA +
					
ONOFF_Unrelated:	LDA !B6,x
+					BPL $01 : DEY
					CLC : ADC !C2,x : STA !C2,x
					TYA : ADC !1504,x : STA !1504,x
RETURN:				

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; graphics routine 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SUB_GFX:			LDA !1534,x : TAX
					JMP (.Routines,x)
					
.Routines:			dw FireBar_GFX
					dw RotoDisc_GFX
					dw Ball_n_Chain_GFX
					dw Rotating_Platform_GFX
					
FireBar_GFX:		;	GetDrawInfo:
	LDX $15E9|!Base2
   STZ !186C,x
   LDA !14E0,x
   XBA
   LDA !E4,x
   REP #$20
   SEC : SBC $1A
   STA $0E
   CLC
   ADC.w #$0040
   CMP.w #$0180
   SEP #$20
   LDA $0F
   BEQ +
   LDA #$01
+  STA !15A0,x
   TDC
   ROL A
   STA !15C4,x

   LDA !14D4,x
   XBA
   LDA !190F,x
   AND #$20
   BEQ .CheckOnce
.CheckTwice
   LDA !D8,x
   REP #$21
   ADC.w #$001C
   SEC : SBC $1C
   SEP #$20
   LDA !14D4,x
   XBA
   BEQ .CheckOnce
   LDA #$02
.CheckOnce
   STA !186C,x
   LDA !D8,x
   REP #$21
   ADC.w #$000C
   SEC : SBC $1C
   SEP #$21
   SBC #$0D
   STA $D6
   XBA
   BEQ .OnScreenY
   INC !186C,x
.OnScreenY
   LDY !15EA,x
					LDA #$80
					STA $D5 : STA $0D			;Multiply the number by 16.
					
					STY $0F					;Fireball_Clipping
					
					JSL $03B664|!BankB
					LDA $01 : XBA : LDA $08
					STA $01 : XBA : STA $08
					LDA $03 : STA $0DCF|!Base2
					LDA $02 : STA $04
					STZ $05 : STZ $0DD0|!Base2
					
					LDA $D7 : LSR : TAY
					LDA Clip_Size,y : STA $0DC7|!Base2
					STZ $0DC8|!Base2
					LDA Clip_Disp,y
					CLC : ADC !E4,x : STA $02
					LDA !14E0,x : ADC #$00 : STA $03
					LDA Clip_Disp,y
					CLC : ADC !D8,x : STA $0A
					LDA !14D4,x : ADC #$00 : STA $0B
					
					REP #$21
					STZ $06
					LDA $1A : PHA : ADC Clip_Disp,y : STA $1A
					CLC
					LDA $1C : PHA : ADC Clip_Disp,y : STA $1C
					LDA.w #Chain_Shift : STA $0DE0|!Base2
					
					LDA !extra_prop_1-1,x : BPL $06
					ASL !X_Spacing : ASL !Y_Spacing
					
					SEP #$20
					
					LDA !X_Spacing+1 : BPL $02 : DEC $06
					LDA !Y_Spacing+1 : BPL $02 : DEC $07
					
					LDA $14 : AND #$0C : LSR #2
					ADC $D7 : TAX : STY $D7
					
					TYA : BEQ .Small
					
					PHX
					LDY $0F
					
					LDA $0E : STA $0300|!Base2,y
					LDA $D6 : STA $0301|!Base2,y
					
					REP #$21
					LDA $0D : ADC !X_Spacing : STA $0D
					CLC : LDA $D5 : ADC !Y_Spacing : STA $D5
					
					ASL !X_Spacing : ASL !Y_Spacing
					
					JSR XY_Shift
					
					PLX
					
.Small:				LDY $0F
					
					LDA Fireball_Tile,x
					STA $0DE2|!Base2
					LDA Fireball_Prop,x
					ORA $64 : STA $0DE3|!Base2
					
					STZ $0DD3|!Base2
					LDX $0C : CPX #$10 : BCS +
					LDA !B6,x : CMP #$40 : BPL +
					CMP #$C0 : BEQ +
					STA $0DD3|!Base2
+					LDA $D7 : BNE +
					JSR Chain_Shift_No_Contact
					BRA .Write_End
+					JSR Chain_Shift
					
.Write_End:			TAX
					LDA $D7 : STA $0460|!Base2,x
					
					REP #$21
					LDA $0DE2|!Base2 : STA $0302|!Base2,y
					LDA $0A : SBC $1C
					CMP #$00DF : BPL ..OverScreen
					CMP #$FFEF : BMI ..OverScreen
					SEC : LDA $02 : SBC $1A : BPL +
					INC $0460|!Base2,x
+					CMP #$0100 : BPL ..OverScreen
					CMP #$FFF0 : BPL ..OnScreen_X
					
..OverScreen:		LDA #$F000 : STA $0300|!Base2,y
..OnScreen_X:		LDX $15E9|!Base2
					
					PLA : STA $1C
					PLA : STA $1A
					SEP #$20
					
					RTS
					
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					
RotoDisc_GFX:		LDX $15E9|!Base2
					LDA !Y_Spacing : ASL
					LDA !D8,x : PHA : ADC !Y_Spacing+1 : STA !D8,x
					LDA !14D4,x : PHA : ADC $0A : STA !14D4,x
					LDA !X_Spacing : ASL
					LDA !E4,x : PHA : ADC !X_Spacing+1 : STA !E4,x
					LDA !14E0,x : PHA : ADC $08 : STA !14E0,x
					JSR .SUB_GFX
					JSL $01A7DC|!bank
					BCC .No_Contact
					%LoseYoshiOrHurt()
.No_Contact:		PLA : STA !14E0,x
					PLA : STA !E4,x
					PLA : STA !14D4,x
					PLA : STA !D8,x
					RTS

.SUB_GFX:			%GetDrawInfo()
					LDA $14 : AND #$1C : LSR : STA $02
					
					LDX $D7
					
..Loops:			LDA $00 : CLC
					ADC RotoDisc_XOffset,x : STA $0300|!Base2,y
					LDA $01 : CLC
					ADC RotoDisc_YOffset,x : STA $0301|!Base2,y
					
					LDA RotoDisc_Tile,x
					STA $0302|!Base2,y
					LDA RotoDisc_Prop,x
					ORA $02 : ORA $64 : STA $0303|!Base2,y
					
					INY #4
					
					DEX : CPX #$01 : BPL ..Loops
					
..Write_End:		LDX $15E9|!Base2
					
                    LDY #$02
                    LDA $D7 : BEQ $01
                    DEC
                    JSL $01B7B3|!bank
					
					RTS
					
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Rotating_Platform_GFX:
					;GetDrawInfo:
					LDX $15E9|!Base2
					STZ $D6
					LDA !extra_prop_1,x : ASL
					LDA $0C : INC : BCC +
					REP #$20
					ASL !X_Spacing : ASL !Y_Spacing
					SEP #$20
					ASL
+					STA $D5
				if !sa1
					STZ $2250 : STZ $0D
					REP #$20
					LDA !Y_Contact : STA $2251
					LDA $D5 : STA $2253
					SEP #$20
				else
					LDA !Y_Contact : STA $211B
					LDA !Y_Contact+1 : STA $211B
					LDA $D5 : STA $211C
				endif
					
					LDA !Y_Contact : STA !1588,x
					LDA !Y_Contact+1 : STA !15B8,x
					REP #$20
				if !sa1
					LDA $2306 : LSR #4
				else
					LDA $2134 : LSR #4
				endif
					LDY !Y_Contact+1 : BPL $03
					ORA #$F000 : DEC : STA !Y_Contact
					SEP #$20
				if !sa1
					REP #$20
					LDA !X_Contact : STA $2251
					LDA $D5 : STA $2253
					SEP #$20
				else
					LDA !X_Contact : STA $211B
					LDA !X_Contact+1 : STA $211B
					LDA $D5 : STA $211C
				endif
					LDA !X_Contact : STA !1510,x
					LDA !X_Contact+1 : STA !157C,x
					REP #$20
				if !sa1
					LDA $2306 : LSR #4
				else
					LDA $2134 : LSR #4
				endif
					LDY !X_Contact+1 : BPL $03
					ORA #$F000 : STA !X_Contact
					SEP #$20
					LDA !AA,x : AND #$30
					LSR #4 : ADC #$02
					BRA ++
Ball_n_Chain_GFX:
	LDX $15E9|!Base2
	LDA !extra_prop_1,x : BPL +
	REP #$21
	LDA $0DC7|!Base2 : ADC !X_Spacing : STA $0DC7|!Base2
	LDA $0DCF|!Base2 : CLC : ADC !Y_Spacing : STA $0DCF|!Base2
	ASL !X_Spacing : ASL !Y_Spacing
	SEP #$20
+	LDA !1602,x
	BEQ $02 : LDA #$01
++	STA $05
   STZ !186C,x
   LDA !14E0,x : PHA : STA $03
   XBA
   LDA !E4,x : PHA : STA $02
   REP #$20
   SEC : SBC $1A
   STA $0E
   CLC
   ADC.w #$0040
   CMP.w #$0180
   SEP #$20
   LDA $0F
   BEQ +
   LDA #$01
+  STA !15A0,x
   TDC
   ROL A
   STA !15C4,x

   LDA !14D4,x : PHA : STA $0B
   XBA
   LDA !190F,x
   AND #$20
   BEQ .CheckOnce
.CheckTwice
   LDA !D8,x
   REP #$21
   ADC.w #$001C
   SEC : SBC $1C
   SEP #$20
   LDA !14D4,x
   XBA
   BEQ .CheckOnce
   LDA #$02
.CheckOnce
   STA !186C,x
   LDA !D8,x : PHA : STA $0A
   REP #$21
   STZ $06
   ADC.w #$000C
   SEC : SBC $1C
   SEP #$21
   SBC #$0D
   STA $D6
   XBA
   BEQ .OnScreenY
   INC !186C,x
.OnScreenY
	LDY $05
	LDA !15EA,x : PHA			;スプライト自身の画描開始インデックス
	CLC : ADC Obj_TileNum,y
	TAY : PHA					;鎖の画描開始インデックス
					LDA #$80
					STA $D5 : STA $0D			;Multiply the number by 16.
					
					LSR $D7			; Size
					
					LDA !X_Spacing+1 : BPL $02 : DEC $06
					LDA !Y_Spacing+1 : BPL $02 : DEC $07
					
					LDA $0E : STA $0300|!Base2,y
					LDA $D6 : STA $0301|!Base2,y
					
					REP #$20
					
					LDA.w #Chain_Shift_No_Contact : STA $0DE0|!Base2
					
					LDX $D7 : BEQ .Small
					ASL !X_Spacing : ASL !Y_Spacing
					
.Small:				LDA $0DC7|!Base2,x : CLC : ADC $0D : STA $0D
					LDA $0DCF|!Base2,x : CLC : ADC $D5 : STA $D5
					
					JSR XY_Shift
					
					LDA $D7
					LDX $05 : CPX #$02
					BCC $01
					ASL : TAX
					
					LDA Chain_TileProp,x
					STA $0DE2|!Base2
					LDA Chain_TileProp+1,x
					ORA $64 : STA $0DE3|!Base2
					LDX $0C
					
					JSR Chain_Shift_No_Contact
					
.Chain_Write_End:	TAX
					LDA $D7 : STA $0460|!Base2,x
					
					LDA #$04 : STA $0F
					REP #$21
					LDA $0DE2|!Base2 : STA $0302|!Base2,y
					LDA $0A : SBC $1C
					CMP #$00DF : BPL ..OverScreen
					CMP #$FFEF : BMI ..OverScreen
					SEC : LDA $02 : SBC $1A : BPL +
					INC $0460|!Base2,x
+					CMP #$0100 : BPL ..OverScreen
					CMP #$FFF0 : BPL ..OnScreen_X
..OverScreen:		LDX #$00 : STX $0F

..OnScreen_X:		LDX $D7 : BEQ ..Small
					ASL $0DC7|!Base2 : ASL $0DCF|!Base2
..Small:			LDX $05 : CPX #$02 : BCC $03
					JMP Platform_GFX
					LDA $0D : ADC $0DC7|!Base2 : STA $0D
					CLC : LDA $D5 : ADC $0DCF|!Base2 : STA $D5
					
					JSR XY_Shift
					
					LDA $0F : BNE .Ball_Write
					LDA #$F0 : STA $0301|!Base2,y
					
.Ball_Write:		PLA : STA $01	;鎖の画描開始インデックス
					STY $00			;鎖の画描終了インデックス
					REP #$21
					LDA #$0202 : STA $06	; $06...LeftHalf ; $07...RightHalf
					LDY #$FF
					LDX $D7 : BEQ ..Small
					LDX #$03 : LDA $02 : SBC $1A
					CMP #$FFE7 : BMI ..OverScreen
					CMP #$0107 : BPL ..OverScreen
					CMP #$FFF7 : BPL + : STX $07 : STY $06 : BRA ++
+					CMP #$0007 : BPL + : STX $06 : BRA ++
+					CMP #$00F7 : BMI ++ : STY $07
++					SEC : LDA $0A : SBC $1C
					CMP #$FFE8 : BMI ..OverScreen
					CMP #$00E8 : BMI ..InScreen
					BRA ..OverScreen
..Small				LDX #$02
					LDA $0A : SEC : SBC #$0004 : STA $0A
					LDA $02 : SEC : SBC #$0004 : STA $02
					SEC : SBC $1A : BPL $01
					INX
					CMP #$FFF1 : BMI ..OverScreen
					CMP #$0100 : BPL ..OverScreen
					SEC : LDA $0A : SBC $1C
					CMP #$FFF0 : BMI ..OverScreen
					CMP #$00E0 : BMI ..InScreen_Small
..OverScreen:		PLY				;スプライト自身の画描開始インデックス
					SEP #$20
					BRA .Write_End
..InScreen_Small:	SEP #$20 : STX $05 : BRA +
..InScreen:			LDA $06 : STA $08
					SEP #$20 : STA $05
+					PLY				;スプライト自身の画描開始インデックス
					LDA $D7 : ASL : TAX
					
..Loops:			LDA $05,x : BMI ..No_Write : XBA
					PHX
					TYA : LSR #2 : TAX
					XBA : STA $0460|!Base2,x
					PLX
					LDA $D6 : ADC Ball_YOffset,x : STA $0301|!Base2,y
					LDA Ball_Tile,x : STA $0302|!Base2,y
					LDA Ball_Prop,x : ORA $64 : STA $0303|!Base2,y
					LDA $0E : CLC : ADC Ball_XOffset,x : STA $0300|!Base2,y
					INY #4
					DEX : CPX #$01 : BMI .Write_End
					BRA ..Loops
..No_Write:			DEX : CPX #$01 : BPL ..Loops
					
.Write_End:			JSR Tile_Swap
					
					LDA $02 : STA !E4,x
					LDA $03 : STA !14E0,x
					LDA $0A : STA !D8,x
					LDA $0B : STA !14D4,x
					
					JSL $01A7DC|!bank
					
					JMP XY_Write_Back
					
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					
Platform_GFX:		JSR XY_Shift
					
					LDA $0F : BNE .Lift_Write
					LDA #$F0 : STA $0301|!Base2,y
					
.Lift_Write:		PLA : STA $01	;鎖の画描開始インデックス
					STY $00			;鎖の画描終了インデックス
					LDX #$02 : STX $07	; 最初に$0460|!Base2,xに入れる値
					LDX $05 : DEX		; 総枚数－１
					TXA : DEC : ASL : TAY	; （総枚数－２）×２
					STZ $09
					LDA Lift_LeftShift-1,x
					LSR : STA $08		; 最初に描くタイルの位置
					REP #$21
					LDA !X_Contact
					ADC Lift_XClipShift,y
					STA !X_Contact
					SEC : LDA $0A : SBC $1C				; 画面内Ｙ座標
					CMP #$FFF0 : BMI .OverScreen
					CMP #$00E0 : BPL .OverScreen
					SEC : LDA $02 : SBC $1A : STA $0E	; 画面内Ｘ座標
					CMP Lift_RightOut,y : BPL .OverScreen
					SEC : SBC Lift_RightOnly,y
					BMI .OverScreen 	; 画面外。
					AND #$FFF0 : BNE +	; 左端のみ
					TAX : INC $07		; １枚だけ描く
+					LDA $0E				; 画面内Ｘ座標
					BMI .AllInScreen
					SEC : SBC Lift_Tile_Minus,y
					SEP #$20
					BCC .AllInScreen-2
					LSR #4 : STA $0F : TAY			; 減らす描画数－１
					LDA Lift_LeftShift,y : STA $09
					CLC : TXA : SBC $0F : TAX 		; 枚数－１
					BMI .OverScreen
					LDA $0E
					LDY #$01
					CPX #$00 : BNE .InScreen
					DEY : BRA .InScreen
					
.OverScreen:		PLY				;スプライト自身の描画開始インデックス
					SEP #$20
					BRA .Write_End
					
					LDA $0E
.AllInScreen:		LDY #$02
.InScreen:			SEP #$21
					STY $06 : SBC $09
					CLC : ADC $08 : STA $0E
					PLY				; スプライト自身の描画開始インデックス
					PHX				; 枚数－１
					LDX $06			; 最初に描くタイル
					BRA .Loops+3
					
.Loops:				PHX
					LDX #$01		;   リフトの真ん中etc
					LDA Lift_Tile,x : STA $0302|!Base2,y
					LDA Lift_Prop,x : ORA $64 : STA $0303|!Base2,y
					TYA : LSR #2 : TAX
					LDA $07 : STA $0460|!Base2,x
					LDA $D6 : STA $0301|!Base2,y
					LDA $0E : STA $0300|!Base2,y 
					TYA : ADC #$04 : TAY
					PLX : BEQ .Write_End
					LDA $07 : LSR
					BCS .Write_End	;	左へはみ出していれば描画終了
					LDA $0E : SBC #$0F : STA $0E
					BCS + : INC $07	;	左へはみ出した。
+					DEX : BNE .Loops
					PHX			;   リフトの右端
					BRA .Loops+3
.No_Write:			LDA $0E : SEC : SBC #$10 : STA $0E
					LDA $05 : BMI $01
					DEX #2
					BPL .Loops
					
.Write_End:			JSR Tile_Swap
					
					CLC : LDA !E4,x : ADC !X_Contact : STA !E4,x
					LDA !14E0,x : ADC !X_Contact+1 : STA !14E0,x
					CLC : LDA !D8,x : ADC !Y_Contact : STA !D8,x
					LDA !14D4,x : ADC !Y_Contact+1 : STA !14D4,x
					
					SEC
					LDA !E4,x : SBC !1570,x : STA !1528,x
					LDA !E4,x : STA !1570,x
					
					JSL $01B44F|!bank
					
XY_Write_Back:		PLA : STA !D8,x
					PLA : STA !14D4,x
					PLA : STA !E4,x
					PLA : STA !14E0,x
					
					RTS
					
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Chain_Shift:
.Loops:				;.Fireball_Contact:	; 内側→外側
					LDA $0DD3|!Base2 : BEQ .EveryFrame
					TXA : EOR $14 : LSR : BCC .No_Contact
.EveryFrame:		
	REP #$20
.checkX:
	LDA $00
	CMP $02
	BCC .checkXSub2
.checkXSub1:
	SBC $02
	CMP $0DC7|!Base2
	BCS .returnNoContact
	BRA .checkY
.checkXSub2:
	LDA $02
	SEC : SBC $00
	CMP $04
	BCS .returnNoContact
.checkY:
	LDA $08
	CMP $0A
	BCC .checkYSub2
.checkYSub1:
	SBC $0A
	CMP $0DC7|!Base2
	BCS .returnNoContact
.returnContact:
	SEP #$20
.Contact:			PHY
					LDA $187A|!Base2
					BEQ .No_Yoshi : %LoseYoshiOrHurt()
					BRA .Yoshi_Ran_away
.No_Yoshi:			JSL $00F5B7|!BankB
.Yoshi_Ran_away:	PLY
					BRA .No_Contact
-					RTS
.checkYSub2:
    LDA $0A
    SEC : SBC $08
    CMP $0DCF|!Base2
    BCC .returnContact
.returnNoContact:
    SEP #$20
.No_Contact:		LDA $0E : STA $0300|!Base2,y
					LDA $D6 : STA $0301|!Base2,y
					
					TYA : LSR #2
					DEX : BMI -
					PHX
					
					TAX
					LDA $D7 : STA $0460|!Base2,x
					
					LDA #$04 : STA $0F
					REP #$21
					LDA $0DE2|!Base2 : STA $0302|!Base2,y
					SEC : LDA $02 : SBC $1A : BPL +
					INC $0460|!Base2,x
+					CMP #$0100 : BPL .OverScreen
					CMP #$FFF0 : BMI .OverScreen
					SEC : LDA $0A : SBC $1C
					CMP #$00E0 : BPL .OverScreen
					CMP #$FFF0 : BPL .OnScreen_X
					
.OverScreen:		LDX #$00 : STX $0F
					
.OnScreen_X:		CLC : LDA $0D : ADC !X_Spacing : STA $0D
					CLC : LDA $D5 : ADC !Y_Spacing : STA $D5
					
					SEP #$21
					LDA $0E : SBC $0300|!Base2,y
					TAX	: BEQ $02 : LDX $06
					CLC : ADC $02 : STA $02
					TXA : ADC $03 : STA $03
					
					SEC
					LDA $D6 : SBC $0301|!Base2,y
					TAX	: BEQ $02 : LDX $07
					CLC : ADC $0A : STA $0A
					TXA : ADC $0B : STA $0B
					
					CLC : TYA : ADC $0F : TAY
					PLX
					
					JMP ($0DE0|!Base2)
					
XY_Shift:			SEP #$21
					LDA $0E : SBC $0300|!Base2,y
					TAX	: BEQ $02 : LDX $06
					CLC : ADC $02 : STA $02
					TXA : ADC $03 : STA $03
					
					SEC
					LDA $D6 : SBC $0301|!Base2,y
					TAX	: BEQ $02 : LDX $07
					CLC : ADC $0A : STA $0A
					TXA : ADC $0B : STA $0B
					RTS
					
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Tile_Swap:			LDX $00			;鎖の画描終了インデックス
-					CPY $01 : BEQ +	;鎖の画描開始インデックス
					REP #$20
					LDA $0300|!Base2,x : STA $0300|!Base2,y
					LDA $0302|!Base2,x : STA $0302|!Base2,y
					SEP #$20
					LDA #$F0 : STA $0301|!Base2,x
					PHX : PHY
					TYA : LSR #2 : TAY
					TXA : LSR #2 : TAX
					LDA $0460|!Base2,x : STA $0460|!Base2,y
					PLY : PLX
					CPX $01 : BEQ + ; X から Y へ移す
					DEX #4 : INY #4 : BRA -
+					LDX $15E9|!Base2
					RTS