;;@name Physics Patch


lorom
header

incsrc "../../shared/freeram.asm"

!player_x_subspeed = $7A
!player_x_speed = $7B
!player_y_speed = $7D
!riding_yoshi = $187A

!spinjumpflag = $140D

   

org $00D640
    autoclean jml spin_jump_hijack
    NOP #3
spin_jump_hijack_ret_normal_jump:
    bra $15
spin_jump_hijack_ret:

 
org $00EA84
    autoclean jml water_spin_jump_hijack
    NOP

org $01E695
    autoclean jml spring_spin_jump_hijack
    NOP
spring_spin_jump_hijack_ret:


org $00D663
		autoclean jml jump_hijack
		nop
	jump_hijack_ret:


org $00D77C
		jml neutral_decel_hijack
		nop
	neutral_decel_hijack_ret_mario:
	
	
org $00D6F8
		jml accel_hijack
		nop
	
	
org $00D742
		jml accel_hijack_2
		nop
		nop
	accel_hijack_2_ret_mario:

org $00D71C
        jml pmeter_hijack
        nop #5
        pmeter_hijack_ret:

org $00D948
		jml gravity_hijack
	gravity_hijack_ret:
	
	
org $00D892
		jml dive_speed_hijack
		nop
   dive_speed_hijack_ret:


org $00D958
       jml air_catch_speed_hijack
	air_catch_speed_hijack_ret1:
		lda $D7D9,y
	air_catch_speed_hijack_ret2:
	
	
org $00D014
		jml pspeed_pose_hijack
	pspeed_pose_hijack_ret1:
		adc #$03
	pspeed_pose_hijack_ret2:


org $02916C
		jml noteblock_bounce_hijack
	noteblock_bounce_hijack_ret:


org $028773
        jml turnblock_bounce_hijack
	turnblock_bounce_hijack_ret:


org $01E68D
        jml spring_bounce_hijack
	spring_bounce_hijack_ret_mario:
	
	
org $01E6A4
	spring_bounce_hijack_ret_luigi1:
        sty $1406
	spring_bounce_hijack_ret_luigi2:


org $02CDE7
		jml pea_bouncer_ab_hijack
		nop
	pea_bouncer_ab_hijack_ret:


org $02CFE5
		jml pea_bouncer_noab_hijack
		nop
	pea_bouncer_noab_hijack_ret:


org $00DB9C
		jml climb_jump_hijack
	climb_jump_hijack_ret_mario:
		lda $DABB,y
	climb_jump_hijack_ret_luigi:


org $01DA33
		jml rope_jump_hijack
	rope_jump_hijack_ret:


org $00D2B6
		jml diagonal_pipe_hijack


org $01AA37
		jml enemy_bounce_hijack
	enemy_bounce_hijack_ret_mario:
		bpl enemy_bounce_hijack_ret_luigi
		lda #$A8
	enemy_bounce_hijack_ret_luigi:


org $00EA9B
		jml water_jump_hijack
	water_jump_hijack_ret_mario:
		lda #$AA
	water_jump_hijack_ret_luigi:
		

org $00D23A
		jml vert_pipe_eject_fix
	vert_pipe_eject_fix_ret:
	


org $01EDB1
		jml yoshi_dismount_speed_hijack
	yoshi_dismount_speed_ret_mario:
		
org $01EDC1
	yoshi_dismount_speed_ret_luigi:


	
org $01F729
		jsl yoshi_knocked_off_speed_hijack
	
org $02A490
		jsl yoshi_knocked_off_speed_hijack
		
		
org $00EB6B
		jml wallrun_jump_hijack
	wallrun_jump_hijack_ret_mario:
		lda #$E0
	wallrun_jump_hijack_ret_luigi:
	

freecode

;;; spinjumpenableflag values:
;;; 0 Regular jump on A
;;; 1 Spin jump on A
;;; 2 No jump on A

spring_spin_jump_hijack:
    LDA !spinjumpenableflag
    STA !spinjumpflag
    JML spring_spin_jump_hijack_ret
    

water_spin_jump_hijack:
    LDA !spinjumpenableflag
    BNE .enablespinjump
.regularjump
    JML $00EA92
.enablespinjump
    DEC A
    BNE .regularjump

    LDA $148F
    BNE .regularjump    
    JML $00EA89
    

spin_jump_hijack:
    
    LDA !spinjumpenableflag
    BNE .enablespinjump

    LDA $187A  ; riding yoshi
    BNE .disablespinjump

.regularjump   
    JML spin_jump_hijack_ret_normal_jump
    
.enablespinjump
    DEC A
    BNE .disablespinjump

    LDA.w $148f       ; object holding flag
    BNE .regularjump


    LDA #$01
    STA !spinjumpflag
    JML spin_jump_hijack_ret
.disablespinjump
    JML $00D61E

jump_hijack:
        LDA !jump_speed   : STA $00
        LDA !jump_speed+1 : STA $01
        LDA !jump_speed+2 : STA $02
        
        lda !riding_yoshi
        beq +
        LDA #$BD : STA $00
        LDA #$D2 : STA $01
        LDA #$00 : STA $02
        +
        TXY : LDA [$00],y : sta !player_y_speed
        
		jml jump_hijack_ret
        
        
neutral_decel_hijack:
    
        rep #$20
    
        LDA !neutral_decel_ice   : STA $00
        LDA !neutral_decel_ice+1 : STA $01
        LDA !neutral_decel_ice+2 : STA $02
        
        
        LDA [$00],y 
        STA $04

        LDA !neutral_decel   : STA $00
        LDA !neutral_decel+1 : STA $01
        LDA !neutral_decel+2 : STA $02
        LDA [$00],y 
        STA $06
                
        lda !riding_yoshi
        
        beq +
        sep #$20
        LDA.b #$09 : STA $00
        LDA.b #$D3 : STA $01
        LDA.b #$00 : STA $02
        rep #$20
        LDA [$00],y 
        STA $04
        
        sep #$20
        LDA.b #$CD : STA $00
        LDA.b #$D2 : STA $01
        LDA.b #$00 : STA $02
        rep #$20
        LDA [$00],y 
        STA $06
        +
        
        SEP #$20
        lda $1493
        ora $72
        rep #$20
	
        bne +
	    
        LDA $04   ;lda.w neutral_decel_ice,y
    	bit $85
		bmi ++
	
    +   LDA.w $06   ;lda.w neutral_decel,y
    
    ++	clc
		adc !player_x_subspeed
		sta !player_x_subspeed
		sec
		sbc $00D5C9,x    ; autoslide speeds
		
        eor $06 ;neutral_decel,y
            
		bmi +
		jml $00D79D
	+	jml $00D7A2   
        
        
        
accel_hijack:
        PHA   ;; uses A value
        
        ;;;; offset by one (uses the high byte of a two-byte value)
        ;;;; values are stored in $01 so we use $03-$05
        LDA !accel : STA $03
        LDA !accel+1 : STA $04
        LDA !accel+2 : STA $05
        
        TXY : INY : LDA [$03],y 
        
        STA $06
        
        lda !riding_yoshi
        beq +
        
        LDA #$45 : STA $03
        LDA #$D3 : STA $04
        LDA #$00 : STA $05
        
        TXY : INY : LDA [$03],y 
        
        STA $06        
        
        + PLA
		
		eor $06
        bpl +
		jml $00D6FD
	+
		jml $00D713
    


accel_hijack_2:

        LDA !max_x_speed   : STA $00
        LDA !max_x_speed+1 : STA $01
        LDA !max_x_speed+2 : STA $02
        
        lda !riding_yoshi
        beq +
        LDA #$35 : STA $00
        LDA #$D5 : STA $01
        LDA #$00 : STA $02
        +
        LDA [$00],y 
        STA $04                 
        
        rep #$20
        
        TXY
        
        LDA !accel   : STA $00
        LDA !accel+1 : STA $01
        LDA !accel+2 : STA $02
        LDA [$00],y 
        STA $06   
        
        LDA !accel_ice   : STA $00
        LDA !accel_ice+1 : STA $01
        LDA !accel_ice+2 : STA $02
        LDA [$00],y 
        STA $08       
        
        lda !riding_yoshi
        beq +
        sep #$20
        LDA.b #$45 : STA $00
        LDA.b #$D3 : STA $01
        LDA.b #$00 : STA $02
        rep #$20
        LDA [$00],y 
        STA $06
        
        sep #$20
        LDA.b #$3D : STA $00
        LDA.b #$D4 : STA $01
        LDA.b #$00 : STA $02
        rep #$20
        LDA [$00],y 
        STA $08
        +
        
     	sep #$20
        
		lda !player_x_speed
		sec
		sbc.w $04 ;max_x_speed,y
		beq ++
		eor.w $04 ;max_x_speed,y
		bpl ++
		rep #$20
		lda.w $06 ;accel_luigi,x
		ldy $85
		beq +
		ldy $72
		bne +
		lda.w $08 ;accel_ice_luigi,x
	+	
		jml $00D75F
		
	++
		jml $00D76B 


gravity_hijack:
		;; using Y
        
        pha
		
        LDA !gravity   : STA $00
        LDA !gravity+1 : STA $01
        LDA !gravity+2 : STA $02
         
        lda !riding_yoshi
		bne .default
		
        lda $71
		cmp #$09
		beq .default          ;;; dying

        bra +
        .default
        LDA #$A5 : STA $00
        LDA #$D7 : STA $01
        LDA #$00 : STA $02
        +

        pla
        
		clc
		adc [$00],y
		
        jml gravity_hijack_ret        
        

dive_speed_hijack:
        PHA
        
        LDA !dive_speed   : STA $00
        LDA !dive_speed+1 : STA $01
        LDA !dive_speed+2 : STA $02
        LDA [$00],y : STA $00
        
        
        PLA        
        cmp $00
		bcc +
		lda $00
	+	jml $00D89A


air_catch_speed_hijack:
        PHA
        
        LDA !air_catch_speed   : STA $00
        LDA !air_catch_speed+1 : STA $01
        LDA !air_catch_speed+2 : STA $02
        
        PLA

        lsr
		lsr
		lsr
		tay
		lda [$00],y
        jml air_catch_speed_hijack_ret2
        
pea_bouncer_ab_hijack:
        LDA !pea_bouncer_ab   : STA $00
        LDA !pea_bouncer_ab+1 : STA $01
        LDA !pea_bouncer_ab+2 : STA $02
    
        lda !riding_yoshi
		beq +
        LDA #$FF : STA $00
        LDA #$CD : STA $01
        LDA #$02 : STA $02
        +
        lda [$00],y : sta !player_y_speed
        
		jml pea_bouncer_ab_hijack_ret
	
        
pea_bouncer_noab_hijack:
        LDA !pea_bouncer_noab   : STA $00
        LDA !pea_bouncer_noab+1 : STA $01
        LDA !pea_bouncer_noab+2 : STA $02
    
        lda !riding_yoshi
		beq +
        LDA #$07 : STA $00
        LDA #$CE : STA $01
        LDA #$02 : STA $02
        +
        
        lda [$00],y : sta !player_y_speed
        
		jml pea_bouncer_noab_hijack_ret





;;;;;; Single value hijacks:

pmeter_hijack:  
        LDA !riding_yoshi
        BNE ++
 
        LDA $7B ; RAM_MarioSpeedX    If moving rightwards 
        BPL +     
        EOR.B #$FF                ;\Invert
        INC A                     ;/        
        +       
        CMP !pmeter_speed
        jml pmeter_hijack_ret
        
    ++  LDA $7B ; RAM_MarioSpeedX    If moving rightwards 
        BPL +     
        EOR.B #$FF                ;\Invert
        INC A                     ;/        
        +       
        CMP.B #$23
        jml pmeter_hijack_ret
        
pspeed_pose_hijack:
        PHA
        LDA !pspeed_pose : STA $00
        
        lda !riding_yoshi
		beq +
        LDA #$2F : STA $00
    +   PLA
        cpx $00 
		bcc .to_ret2
		jml pspeed_pose_hijack_ret1
        
        
	.to_ret2
		jml pspeed_pose_hijack_ret2
        
 noteblock_bounce_hijack:     
        lda !noteblock_bounce : sta !player_y_speed
        lda !riding_yoshi
		beq +
        LDA #$A0 : STA !player_y_speed
    +   jml noteblock_bounce_hijack_ret
        

turnblock_bounce_hijack:
        lda !turnblock_bounce : sta !player_y_speed
		lda !riding_yoshi
		beq +
        LDA #$D0 : STA !player_y_speed
    +   jml turnblock_bounce_hijack_ret
        
spring_bounce_hijack:
        lda !spring_bounce_low : TAY
		lda !riding_yoshi
		beq +
        LDY #$B0
    +   lda $17		
		bpl +
		lda !spinjumpenableflag     ;;; spin jump adjust here
		sta $140D
		bra ++
	+
		lda $15
		bpl +
	++
		lda #$0B
		sta $72
        LDA !spring_bounce_high
		TAY
        lda !riding_yoshi
		beq ++
        LDY #$80
    ++   
		jml spring_bounce_hijack_ret_luigi1
	+
		jml spring_bounce_hijack_ret_luigi2
        
diagonal_pipe_hijack:
        lda !diagonal_pipe : sta !player_y_speed
        lda !riding_yoshi
		beq +
        LDA #$C0 : STA !player_y_speed
    +   jml $00DC2D

enemy_bounce_hijack:
        LDA #$01 : STA !enemybouncetrigger
        lda !riding_yoshi
        BNE ++
        lda !enemy_bounce_low
		bit $15
		bpl +
		lda !enemy_bounce_high
	+	
        jml enemy_bounce_hijack_ret_luigi
    ++  lda #$D0
		bit $15
		bpl +
		lda #$A8
	+	
        jml enemy_bounce_hijack_ret_luigi
    
    
water_jump_hijack:
        lda #$0B
		sta $72
        lda !riding_yoshi
        BNE +
        lda !water_jump
		jml water_jump_hijack_ret_luigi
    +   LDA #$AA
        jml water_jump_hijack_ret_luigi
        
 
 
vert_pipe_eject_fix:
		ldy $88
		beq .finished
		jml vert_pipe_eject_fix_ret
		
	.finished:
		bcc .entering
		stz !player_y_speed
		jml $00D26A
		
	.entering
		jml $00D273

wallrun_jump_hijack:
		lda #$24
		sta $72
        lda !wallrun_jump
		jml wallrun_jump_hijack_ret_luigi
        
rope_jump_hijack:
        lda !rope_jump
		sta !player_y_speed
		jml rope_jump_hijack_ret

climb_jump_hijack:
        lda #$0B
		sta $72
        LDA !climb_jump_high
        CPY #$00
        BEQ +
        LDA !climb_jump_low
+       jml climb_jump_hijack_ret_luigi


yoshi_dismount_speed_hijack:
		lda !player_x_speed
		sta $B6,x
        
        lda !yoshi_dismount_speed_high
		ldy $72         ; player is in the air flag
		bne +
		phk
		pea.w .jslrtsreturn-1
		pea.w $0180CA-1
		jml $01AD30
		.jslrtsreturn
		phx
		tyx
        
        lda !yoshi_dismount_speed_right
        cpy #$00
        beq ++
        LDA !yoshi_dismount_speed_left
    ++	sta !player_x_speed
        
		lda !yoshi_dismount_speed_low
		plx
	+	jml yoshi_dismount_speed_ret_luigi 
        
        
yoshi_knocked_off_speed_hijack:
		lda !yoshi_knocked_off
		sta !player_y_speed
		rtl
        
        
        
    