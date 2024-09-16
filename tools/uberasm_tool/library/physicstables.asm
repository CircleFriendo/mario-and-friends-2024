
;;; cape values

dive_speed_mario:
		db $01,$10,$30,$30,$38,$38,$40  
        
air_catch_speed_mario:       
		db $00,$00,$00,$F8,$F8,$F8,$F4,$F0,$C8,$02,$01


dive_speed_luigi:
		db $01,$0C,$10,$10,$14,$14,$40  
        
air_catch_speed_luigi:       
		db $00,$00,$F4,$F0,$C8,$C8,$C8,$C8,$C8,$02,$01


dive_speed_peach:
		db $01,$04,$08,$0C,$10,$20,$30  
        
air_catch_speed_peach:      
        ;   00  08  10  18  20  28  30
		db $00,$F8,$F8,$F4,$F0,$F8,$C8,$C8,$C8,$02,$01


dive_speed_daisy:
		db $01,$10,$20,$28,$30,$38,$40  
        
air_catch_speed_daisy:       
		;   00  08  10  18  20  28  30  38  40
		db $00,$00,$00,$F4,$F4,$F0,$E8,$E0,$C8,$02,$01


dive_speed_wario:
		db $01,$10,$30,$40,$48,$50,$50  
        
air_catch_speed_wario:     
        ;   00  08  10  18  20  28  30  38  40  48  50 
		db $00,$00,$00,$F8,$F8,$F8,$F4,$F0,$F0,$E8,$C8


dive_speed_waluigi:
		db $01,$10,$30,$30,$38,$38,$40  
        
air_catch_speed_waluigi:       
		db $00,$00,$00,$F8,$F8,$F8,$F4,$F0,$C8,$02,$01



!spinjumpenableflag = $7f9e08   ;FreeRAM

!jump_speed         = $7f9f00   ;FreeRAM
!neutral_decel      = $7f9f03   ;FreeRAM
!neutral_decel_ice  = $7f9f06   ;FreeRAM
!accel              = $7f9f09   ;FreeRAM
!accel_ice          = $7f9f0C   ;FreeRAM
!max_x_speed        = $7f9f0F   ;FreeRAM
!gravity            = $7f9f12   ;FreeRAM
!dive_speed         = $7f9f15   ;FreeRAM
!air_catch_speed    = $7f9f18   ;FreeRAM
!pea_bouncer_ab     = $7f9f1B   ;FreeRAM
!pea_bouncer_noab   = $7f9f1E   ;FreeRAM



!pmeter_speed       = $7f9f30   ;FreeRAM
!pspeed_pose        = $7f9f31   ;FreeRAM
!noteblock_bounce   = $7f9f32   ;FreeRAM
!turnblock_bounce   = $7f9f33   ;FreeRAM
!spring_bounce_low  = $7f9f34   ;FreeRAM
!spring_bounce_high = $7f9f35   ;FreeRAM
!diagonal_pipe      = $7f9f36   ;FreeRAM
!rope_jump          = $7f9f37   ;FreeRAM
!enemy_bounce_low   = $7f9f38   ;FreeRAM
!enemy_bounce_high  = $7f9f39   ;FreeRAM
!water_jump         = $7F9f3A   ;FreeRAM
!wallrun_jump       = $7f9f3B	;FreeRAM
!climb_jump_low     = $7f9f3C   ;FreeRAM
!climb_jump_high    = $7f9f3D   ;FreeRAM
!yoshi_knocked_off  = $7f9f3E   ;FreeRAM

!yoshi_dismount_speed_high  = $7f9f40   ;FreeRAM
!yoshi_dismount_speed_low   = $7f9f41   ;FreeRAM
!yoshi_dismount_speed_right = $7f9f42   ;FreeRAM
!yoshi_dismount_speed_left  = $7f9f43   ;FreeRAM

;;;; character physics settings

default:

    LDA #$01 : STA !spinjumpenableflag
    
    LDA #$BD : STA !jump_speed
    LDA #$D2 : STA !jump_speed+1
    LDA #$00 : STA !jump_speed+2
    
    LDA #$CD : STA !neutral_decel
    LDA #$D2 : STA !neutral_decel+1
    LDA #$00 : STA !neutral_decel+2
    
    LDA #$09 : STA !neutral_decel_ice
    LDA #$D3 : STA !neutral_decel_ice+1
    LDA #$00 : STA !neutral_decel_ice+2

    LDA #$45 : STA !accel
    LDA #$D3 : STA !accel+1
    LDA #$00 : STA !accel+2

    LDA #$3D : STA !accel_ice
    LDA #$D4 : STA !accel_ice+1
    LDA #$00 : STA !accel_ice+2

    LDA #$35 : STA !max_x_speed
    LDA #$D5 : STA !max_x_speed+1
    LDA #$00 : STA !max_x_speed+2

    LDA #$A5 : STA !gravity
    LDA #$D7 : STA !gravity+1
    LDA #$00 : STA !gravity+2
    
    LDA #$C8 : STA !dive_speed
    LDA #$D7 : STA !dive_speed+1
    LDA #$00 : STA !dive_speed+2
    
    LDA #$D9 : STA !air_catch_speed
    LDA #$D7 : STA !air_catch_speed+1
    LDA #$00 : STA !air_catch_speed+2
    
    LDA #$FF : STA !pea_bouncer_ab
    LDA #$CD : STA !pea_bouncer_ab+1
    LDA #$02 : STA !pea_bouncer_ab+2
    
    LDA #$07 : STA !pea_bouncer_noab
    LDA #$CE : STA !pea_bouncer_noab+1
    LDA #$02 : STA !pea_bouncer_noab+2
    
    
    LDA #$23 : STA !pmeter_speed
    LDA #$2F : STA !pspeed_pose
    LDA #$A0 : STA !noteblock_bounce
    LDA #$D0 : STA !turnblock_bounce
    LDA #$B0 : STA !spring_bounce_low
    LDA #$80 : STA !spring_bounce_high
    LDA #$C0 : STA !diagonal_pipe
    LDA #$D0 : STA !enemy_bounce_low
    LDA #$A8 : STA !enemy_bounce_high
    LDA #$AA : STA !water_jump
    LDA #$E0 : STA !wallrun_jump
    LDA #$B0 : STA !rope_jump
    LDA #$F0 : STA !climb_jump_low
    LDA #$B0 : STA !climb_jump_high
    LDA #$C0 : STA !yoshi_knocked_off
    LDA #$A0 : STA !yoshi_dismount_speed_high
    LDA #$C0 : STA !yoshi_dismount_speed_low
    LDA #$10 : STA !yoshi_dismount_speed_right
    LDA #$F0 : STA !yoshi_dismount_speed_left
    
    RTL

luigi:
    JSL default
    JSL low_gravity_short
    JSL low_gravity_jump
    JSL slippery
    LDA #$00 : STA !spinjumpenableflag
    RTL
    
daisy:
    JSL default
    JSL short
    JSL cape_daisy
    LDA #$00 : STA !spinjumpenableflag  
    RTL
   
peach:
    JSL default
    JSL tight
    JSL cape_peach
    LDA #$1A : STA !pmeter_speed
    LDA #$21 : STA !pspeed_pose
    LDA #$00 : STA !spinjumpenableflag
    RTL
    
wario: 
    JSL default
    JSL high_gravity
    JSL heavy  
    JSL cape_wario  
    LDA #$02 : STA !spinjumpenableflag
    
    RTL

waluigi:
    JSL default
    JSL low_gravity_short
    JSL waluigi_gravity
    JSL slow_accel
    JSL cape_waluigi
    LDA #$00 : STA !spinjumpenableflag
    RTL

short:
    LDA.b #jump_speed_short     : STA !jump_speed
    LDA.b #jump_speed_short>>8  : STA !jump_speed+1
    LDA.b #jump_speed_short>>16 : STA !jump_speed+2

    RTL
    
waluigi_gravity:
    LDA.b #jump_speed_waluigi     : STA !jump_speed
    LDA.b #jump_speed_waluigi>>8  : STA !jump_speed+1
    LDA.b #jump_speed_waluigi>>16 : STA !jump_speed+2
    
    LDA.b #gravity_waluigi : STA !gravity
    LDA.b #gravity_waluigi>>8 : STA !gravity+1
    LDA.b #gravity_waluigi>>16 : STA !gravity+2
    
    LDA.b #pea_bouncer_ab_waluigi : STA !pea_bouncer_ab
    LDA.b #pea_bouncer_ab_waluigi>>8 : STA !pea_bouncer_ab+1
    LDA.b #pea_bouncer_ab_waluigi>>16 : STA !pea_bouncer_ab+2
    
    LDA.b #pea_bouncer_noab_waluigi : STA !pea_bouncer_noab
    LDA.b #pea_bouncer_noab_waluigi>>8 : STA !pea_bouncer_noab+1
    LDA.b #pea_bouncer_noab_waluigi>>16 : STA !pea_bouncer_noab+2
    
    LDA #$AE : STA !noteblock_bounce
    LDA #$D6 : STA !turnblock_bounce
    LDA #$BF : STA !spring_bounce_low
    LDA #$97 : STA !spring_bounce_high
    LDA #$B6 : STA !diagonal_pipe
    LDA #$D8 : STA !enemy_bounce_low
    LDA #$B4 : STA !enemy_bounce_high
    LDA #$BB : STA !water_jump
    LDA #$BF : STA !rope_jump
    LDA #$E9 : STA !climb_jump_low
    LDA #$BF : STA !climb_jump_high
    LDA #$CA : STA !yoshi_knocked_off
    
    RTL
    
low_gravity_short:
    LDA.b #jump_speed_luigi_short     : STA !jump_speed
    LDA.b #jump_speed_luigi_short>>8  : STA !jump_speed+1
    LDA.b #jump_speed_luigi_short>>16 : STA !jump_speed+2
    
    LDA.b #gravity_luigi : STA !gravity
    LDA.b #gravity_luigi>>8 : STA !gravity+1
    LDA.b #gravity_luigi>>16 : STA !gravity+2
    
    LDA.b #dive_speed_luigi : STA !dive_speed
    LDA.b #dive_speed_luigi>>8 : STA !dive_speed+1
    LDA.b #dive_speed_luigi>>16 : STA !dive_speed+2    
    
    LDA.b #air_catch_speed_luigi : STA !air_catch_speed
    LDA.b #air_catch_speed_luigi>>8 : STA !air_catch_speed+1
    LDA.b #air_catch_speed_luigi>>16 : STA !air_catch_speed+2
        
    LDA.b #pea_bouncer_ab_luigi : STA !pea_bouncer_ab
    LDA.b #pea_bouncer_ab_luigi>>8 : STA !pea_bouncer_ab+1
    LDA.b #pea_bouncer_ab_luigi>>16 : STA !pea_bouncer_ab+2
    
    LDA.b #pea_bouncer_noab_luigi : STA !pea_bouncer_noab
    LDA.b #pea_bouncer_noab_luigi>>8 : STA !pea_bouncer_noab+1
    LDA.b #pea_bouncer_noab_luigi>>16 : STA !pea_bouncer_noab+2
    
    LDA #$C6 : STA !noteblock_bounce
    LDA #$E2 : STA !turnblock_bounce
    LDA #$D2 : STA !spring_bounce_low
    LDA #$B6 : STA !spring_bounce_high
    LDA #$CC : STA !diagonal_pipe
    LDA #$E4 : STA !enemy_bounce_low
    LDA #$CA : STA !enemy_bounce_high
    LDA #$CF : STA !water_jump
    LDA #$E2 : STA !wallrun_jump
    LDA #$D2 : STA !rope_jump
    LDA #$F0 : STA !climb_jump_low
    LDA #$D2 : STA !climb_jump_high
    LDA #$DA : STA !yoshi_knocked_off
    
    LDA #$CA : STA !yoshi_dismount_speed_high
    LDA #$DA : STA !yoshi_dismount_speed_low
    LDA #$0A : STA !yoshi_dismount_speed_right
    LDA #$F6 : STA !yoshi_dismount_speed_left
    
    
    RTL

cape_peach:
    LDA.b #dive_speed_peach : STA !dive_speed
    LDA.b #dive_speed_peach>>8 : STA !dive_speed+1
    LDA.b #dive_speed_peach>>16 : STA !dive_speed+2    
    
    LDA.b #air_catch_speed_peach : STA !air_catch_speed
    LDA.b #air_catch_speed_peach>>8 : STA !air_catch_speed+1
    LDA.b #air_catch_speed_peach>>16 : STA !air_catch_speed+2

    RTL

cape_daisy:
    LDA.b #dive_speed_daisy : STA !dive_speed
    LDA.b #dive_speed_daisy>>8 : STA !dive_speed+1
    LDA.b #dive_speed_daisy>>16 : STA !dive_speed+2    
    
    LDA.b #air_catch_speed_daisy : STA !air_catch_speed
    LDA.b #air_catch_speed_daisy>>8 : STA !air_catch_speed+1
    LDA.b #air_catch_speed_daisy>>16 : STA !air_catch_speed+2

    RTL

cape_wario:
    LDA.b #dive_speed_wario : STA !dive_speed
    LDA.b #dive_speed_wario>>8 : STA !dive_speed+1
    LDA.b #dive_speed_wario>>16 : STA !dive_speed+2    
    
    LDA.b #air_catch_speed_wario : STA !air_catch_speed
    LDA.b #air_catch_speed_wario>>8 : STA !air_catch_speed+1
    LDA.b #air_catch_speed_wario>>16 : STA !air_catch_speed+2

    RTL

cape_waluigi:
    LDA.b #dive_speed_waluigi : STA !dive_speed
    LDA.b #dive_speed_waluigi>>8 : STA !dive_speed+1
    LDA.b #dive_speed_waluigi>>16 : STA !dive_speed+2    
    
    LDA.b #air_catch_speed_waluigi : STA !air_catch_speed
    LDA.b #air_catch_speed_waluigi>>8 : STA !air_catch_speed+1
    LDA.b #air_catch_speed_waluigi>>16 : STA !air_catch_speed+2

    RTL

low_gravity_jump:
    LDA.b #jump_speed_luigi     : STA !jump_speed
    LDA.b #jump_speed_luigi>>8  : STA !jump_speed+1
    LDA.b #jump_speed_luigi>>16 : STA !jump_speed+2
    
    RTL
 
high_gravity:
    LDA.b #jump_speed_heavy     : STA !jump_speed
    LDA.b #jump_speed_heavy>>8  : STA !jump_speed+1
    LDA.b #jump_speed_heavy>>16 : STA !jump_speed+2
    
    LDA.b #gravity_heavy : STA !gravity
    LDA.b #gravity_heavy>>8 : STA !gravity+1
    LDA.b #gravity_heavy>>16 : STA !gravity+2
    
    LDA #$C9 : STA !enemy_bounce_low
    LDA #$9A : STA !enemy_bounce_high
    
    
    RTL


slippery:
    
    LDA.b #neutral_decel_luigi : STA !neutral_decel
    LDA.b #neutral_decel_luigi>>8 : STA !neutral_decel+1
    LDA.b #neutral_decel_luigi>>16 : STA !neutral_decel+2
    
    LDA.b #neutral_decel_ice_luigi : STA !neutral_decel_ice
    LDA.b #neutral_decel_ice_luigi>>8 : STA !neutral_decel_ice+1
    LDA.b #neutral_decel_ice_luigi>>16 : STA !neutral_decel_ice+2

    LDA.b #accel_luigi : STA !accel
    LDA.b #accel_luigi>>8 : STA !accel+1
    LDA.b #accel_luigi>>16 : STA !accel+2

    LDA.b #accel_ice_luigi : STA !accel_ice
    LDA.b #accel_ice_luigi>>8 : STA !accel_ice+1
    LDA.b #accel_ice_luigi>>16 : STA !accel_ice+2

    LDA.b #max_x_speed_luigi : STA !max_x_speed
    LDA.b #max_x_speed_luigi>>8 : STA !max_x_speed+1
    LDA.b #max_x_speed_luigi>>16 : STA !max_x_speed+2

    LDA #$27 : STA !pspeed_pose
    
    RTL

heavy:
    JSL slippery
    
    LDA.b #accel_heavy : STA !accel
    LDA.b #accel_heavy>>8 : STA !accel+1
    LDA.b #accel_heavy>>16 : STA !accel+2

    RTL
  
slow_accel:
    LDA.b #accel_luigi : STA !accel
    LDA.b #accel_luigi>>8 : STA !accel+1
    LDA.b #accel_luigi>>16 : STA !accel+2

    LDA.b #accel_ice_luigi : STA !accel_ice
    LDA.b #accel_ice_luigi>>8 : STA !accel_ice+1
    LDA.b #accel_ice_luigi>>16 : STA !accel_ice+2
    
    RTL
  
tight:
    LDA.b #neutral_decel_tight : STA !neutral_decel
    LDA.b #neutral_decel_tight>>8 : STA !neutral_decel+1
    LDA.b #neutral_decel_tight>>16 : STA !neutral_decel+2
    
    LDA.b #accel_tight : STA !accel
    LDA.b #accel_tight>>8 : STA !accel+1
    LDA.b #accel_tight>>16 : STA !accel+2

    LDA.b #max_x_speed_tight : STA !max_x_speed
    LDA.b #max_x_speed_tight>>8 : STA !max_x_speed+1
    LDA.b #max_x_speed_tight>>16 : STA !max_x_speed+2

    RTL

    
jump_speed_short:
		db $B8,$00,$B6,$00,$B4,$00,$B2,$00  ; short jump speed
        db $B0,$00,$AE,$00,$AC,$00,$AA,$00  ; spin jump values not set
  
jump_speed_luigi:
  		db $D2,$D5,$D0,$D3,$CD,$D1,$CB,$CF  ; original luigi physics
		db $C9,$CE,$C7,$CB,$C4,$C9,$C2,$C6

jump_speed_luigi_short:
		db $D8,$00,$D6,$00,$D5,$00,$D4,$00  ; short jump luigi physics
		db $D2,$00,$D0,$00,$D1,$00,$D0,$00

jump_speed_waluigi:
  		db $C9,$00,$C6,$00,$C3,$00,$C2,$00  ; waluigi physics
		db $C0,$00,$BE,$00,$BC,$00,$BA,$00

		
neutral_decel_luigi:
		dw $FF67,$0099               ; no slope
		dw $FF00,$0100,$FF00,$0100   ; gradual slope  left/right
		dw $FE80,$00C0,$FF40,$0180   ; normal slope   left/right
		dw $FE00,$0040,$FFC0,$0200   ; steep slope    left/right
		dw $FE00,$0040,$FE00,$0040   ; left facing conveyor up/down
		dw $FFC0,$0200,$FFC0,$0200   ; right facing conveyor up/down
		dw $FC00,$FF00,$0100,$0400   ; very steep slope left/right
		dw $FF67,$0099,$FF67,$0099   ; flying left/right while holding left/right or holding right/left and tapping B

neutral_decel_ice_luigi:
		dw $FFED,$0013               ; no slope
		dw $FFED,$0013,$FFED,$0013   ; gradual slope  left/right
		dw $FFDA,$0013,$FFED,$0026   ; normal slope   left/right
		dw $FFB4,$0013,$FFED,$004C   ; steep slope    left/right
		dw $FFB4,$0013,$FFB4,$0013   ; left facing conveyor up/down
		dw $FFED,$004C,$FFED,$004C   ; right facing conveyor up/down
		dw $FECD,$FFB4,$004C,$0133   ; very steep slope left/right
		dw $FF67,$0099,$FF67,$0099   ; flying left/right while holding left/right or holding right/left and tapping B

accel_luigi:
		dw $FE80,$FE80,$0180,$0180   ; no slope
		dw $FE80,$FE80,$0180,$0180   ; gradual slope left
		dw $FE80,$FE80,$0180,$0180    ; gradual slope right
		dw $FE80,$FE80,$0140,$0140   ; normal slope left
		dw $FEC0,$FEC0,$0180,$0180   ; normal slope right
		dw $FE80,$FE80,$0100,$0100   ; steep slope left
		dw $FF00,$FF00,$0180,$0180   ; steep slope right
		dw $FE80,$FE80,$0100,$0100   ; left facing conveyor up
		dw $FE80,$FE80,$0100,$0100   ; left facing conveyor down
		dw $FF00,$FF00,$0180,$0180   ; right facing converyor up
		dw $FF00,$FF00,$0180,$0180   ; right facing converyor down
		dw $FC00,$FC00,$FD00,$FD00   ; very steep slope left
		dw $0300,$0300,$0400,$0400   ; very steep slopr right
		dw $FC00,$FC00,$0600,$0600   ; 16 bytes flying left while holding left
		dw $FA00,$FA00,$0400,$0400   ;          flying right while holding right
		dw $FF80,$0080,$FF00,$0100   ; ; 24 bytes sliding accelerations
		dw $FE80,$0180,$FE80,$FE80
		dw $0180,$0180,$FE80,$0280
		dw $FEC0,$FD80,$0140,$0280   ; turning decelerations
		dw $FD80,$FB00,$0280,$0500
		dw $FD80,$FB00,$0280,$0500
		dw $FD40,$FA80,$0240,$0480
		dw $FDC0,$FB80,$02C0,$0580
		dw $FD00,$FA00,$0200,$0400
		dw $FE00,$FC00,$0300,$0600
		dw $FD00,$FA00,$0200,$0400
		dw $FD00,$FA00,$0200,$0400
		dw $FE00,$FC00,$0300,$0600
		dw $FE00,$FC00,$0300,$0600
		dw $FD00,$FA00,$FD00,$FA00
		dw $0300,$0600,$0300,$0600


accel_ice_luigi:
		dw $FF80,$FE80,$0080,$0180
		dw $FF80,$FE80,$0080,$0180
		dw $FF80,$FE80,$0080,$0180
		dw $FE80,$FE80,$0080,$0140
		dw $FF80,$FEC0,$0180,$0180
		dw $FE80,$FE80,$0080,$0100
		dw $FF80,$FF00,$0180,$0180
		dw $FE80,$FE80,$0080,$0100
		dw $FE80,$FE80,$0080,$0100
		dw $FF80,$FF00,$0180,$0180
		dw $FF80,$FF00,$0180,$0180
		dw $FC00,$FC00,$FE00,$FD00
		dw $0300,$0300,$0400,$0400
		dw $FC00,$FC00,$0080,$0080
		dw $FF80,$FF80,$0400,$0400
		dw $FF80,$0080,$FF00,$0100
		dw $FE80,$0180,$FE80,$FE80
		dw $0180,$0180,$FE80,$0280
		dw $FFE0,$FEC0,$0020,$0140
		dw $FFE0,$FEC0,$0020,$0140
		dw $FFE0,$FEC0,$0020,$0140
		dw $FFC0,$FEA0,$0020,$0120
		dw $FFE0,$FEE0,$0040,$0160
		dw $FE80,$FE80,$0020,$0100
		dw $FFE0,$FF00,$0180,$0180
		dw $FE80,$FE80,$0020,$0100
		dw $FE80,$FE80,$0020,$0100
		dw $FFE0,$FF00,$0180,$0180
		dw $FFE0,$FF00,$0180,$0180
		dw $FE80,$FE80,$FE80,$FE80
		dw $0180,$0180,$0180,$0180

max_x_speed_luigi:
		db $EC,$14,$DC,$24,$DC,$24,$D8,$28
		; copy of mario table
		db $EC,$14,$DC,$24,$DC,$24,$D0,$30
		db $EC,$14,$DC,$24,$DC,$24,$D0,$30
		db $E8,$12,$DC,$20,$DC,$20,$D0,$2C
		db $EE,$18,$E0,$24,$E0,$24,$D4,$30
		db $DC,$10,$DC,$1C,$DC,$1C,$D0,$28
		db $F0,$24,$E4,$24,$E4,$24,$D8,$30
		db $DC,$10,$DC,$1C,$DC,$1C,$D0,$28
		db $DC,$10,$DC,$1C,$DC,$1C,$D0,$28
		db $F0,$24,$E4,$24,$E4,$24,$D8,$30
		db $F0,$24,$E4,$24,$E4,$24,$D8,$30
		db $DC,$F0,$DC,$F8,$DC,$F8,$D0,$FC
		db $10,$24,$08,$24,$08,$24,$04,$30
		db $D0,$08,$D0,$08,$D0,$08,$D0,$08
		db $F8,$30,$F8,$30,$F8,$30,$F8,$30
		db $F8,$08,$F0,$10,$F4,$04,$E8,$08
		db $F0,$10,$E0,$20,$EC,$0C,$D8,$18
		db $D8,$28,$D4,$2C,$D0,$30,$D0,$D0
		db $30,$30,$E0,$20
		
gravity_luigi:
		db $02,$01,$04,$10,$F4,$01,$01,$01,$02,$06

gravity_waluigi:
        db $04,$02,$04,$10,$F4,$01,$02,$02,$05,$06


        
pea_bouncer_ab_luigi:
		db $D6,$D4,$D0,$CC,$C8,$C2,$BC,$B8

pea_bouncer_noab_luigi:
		db $00,$00,$F6,$F0,$E4,$DE,$DA,$D4

pea_bouncer_ab_waluigi:
		db $C5,$C2,$BC,$B6,$B1,$A8,$A0,$9A

pea_bouncer_noab_waluigi:
		db $00,$00,$F2,$E9,$D8,$D0,$CA,$C2


neutral_decel_tight:
 		dw $FE80,$0180               ; no slope
		dw $FF00,$0100,$FF00,$0100   ; gradual slope  left/right
		dw $FE80,$00C0,$FF40,$0180   ; normal slope   left/right
		dw $FE00,$0040,$FFC0,$0200   ; steep slope    left/right
		dw $FE00,$0040,$FE00,$0040   ; left facing conveyor up/down
		dw $FFC0,$0200,$FFC0,$0200   ; right facing conveyor up/down
		dw $FC00,$FF00,$0100,$0400   ; very steep slope left/right
		dw $FF00,$0100,$FF00,$0100   ; flying left/right while holding left/right or holding right/left and tapping B

 
accel_tight:   

        dw $FDC0,$FDC0,$0240,$0240   ; no slope                ;;;;;
		dw $FDC0,$FDC0,$0240,$0240   ; gradual slope left      ;;;;;
		dw $FDC0,$FDC0,$0240,$0240    ; gradual slope right    ;;;;;
		
        
        
        dw $FE80,$FE80,$0140,$0140   ; normal slope left
		dw $FEC0,$FEC0,$0180,$0180   ; normal slope right
		dw $FE80,$FE80,$0100,$0100   ; steep slope left
		dw $FF00,$FF00,$0180,$0180   ; steep slope right
		dw $FE80,$FE80,$0100,$0100   ; left facing conveyor up
		dw $FE80,$FE80,$0100,$0100   ; left facing conveyor down
		dw $FF00,$FF00,$0180,$0180   ; right facing converyor up
		dw $FF00,$FF00,$0180,$0180   ; right facing converyor down
		dw $FC00,$FC00,$FD00,$FD00   ; very steep slope left
		dw $0300,$0300,$0400,$0400   ; very steep slopr right
		dw $FC00,$FC00,$0600,$0600   ; 16 bytes flying left while holding left
		dw $FA00,$FA00,$0400,$0400   ;          flying right while holding right
		dw $FF80,$0080,$FF00,$0100   ; ; 24 bytes sliding accelerations
		dw $FE80,$0180,$FE80,$FE80
		dw $0180,$0180,$FE80,$0280
		dw $FC40,$F880,$03C0,$0780    ; quicker turnarounds
		
        dw $FD80,$FB00,$0280,$0500
		dw $FD80,$FB00,$0280,$0500
		dw $FD40,$FA80,$0240,$0480
		dw $FDC0,$FB80,$02C0,$0580
		dw $FD00,$FA00,$0200,$0400
		dw $FE00,$FC00,$0300,$0600
		dw $FD00,$FA00,$0200,$0400
		dw $FD00,$FA00,$0200,$0400
		dw $FE00,$FC00,$0300,$0600
		dw $FE00,$FC00,$0300,$0600
		dw $FD00,$FA00,$FD00,$FA00
		dw $0300,$0600,$0300,$0600

max_x_speed_tight:   
		;  $EC,$14,$DC,$24,$DC,$24,$D0,$30   ; default mario speed
        ; three quarters max speed
        ;db $F1,$0F,$E5,$1B,$E5,$1B,$DC,$24  ; no slope   
        db $F1,$0F,$E2,$1E,$E2,$1E,$DC,$24  ; no slope   
		db $F1,$0F,$E2,$1E,$E2,$1E,$DC,$24  ; gradual slope left
		db $F1,$0F,$E2,$1E,$E2,$1E,$DC,$24  ; gradual slope right
        
        
		db $E8,$12,$DC,$20,$DC,$20,$D0,$2C
		db $EE,$18,$E0,$24,$E0,$24,$D4,$30
		db $DC,$10,$DC,$1C,$DC,$1C,$D0,$28
		db $F0,$24,$E4,$24,$E4,$24,$D8,$30
		db $DC,$10,$DC,$1C,$DC,$1C,$D0,$28
		db $DC,$10,$DC,$1C,$DC,$1C,$D0,$28
		db $F0,$24,$E4,$24,$E4,$24,$D8,$30
		db $F0,$24,$E4,$24,$E4,$24,$D8,$30
		db $DC,$F0,$DC,$F8,$DC,$F8,$D0,$FC
		db $10,$24,$08,$24,$08,$24,$04,$30
		db $D0,$08,$D0,$08,$D0,$08,$D0,$08
		db $F8,$30,$F8,$30,$F8,$30,$F8,$30
		db $F8,$08,$F0,$10,$F4,$04,$E8,$08
		db $F0,$10,$E0,$20,$EC,$0C,$D8,$18
		db $D8,$28,$D4,$2C,$D0,$30,$D0,$D0
		db $30,$30,$E0,$20

jump_speed_heavy:
        db $A4,$00,$A2,$00,$9F,$00,$9D,$00  ; heavy jump speed
        db $9A,$00,$98,$00,$94,$00,$90,$00  ; spin jump values not set
       
       
accel_heavy:
        dw $FEE0,$FEE0,$0120,$0120   ; no slope
		dw $FEE0,$FEE0,$0120,$0120   ; gradual slope left
		dw $FEE0,$FEE0,$0120,$0120   ; gradual slope right
		
        dw $FE80,$FE80,$0140,$0140   ; normal slope left
		dw $FEC0,$FEC0,$0180,$0180   ; normal slope right
		dw $FE80,$FE80,$0100,$0100   ; steep slope left
		dw $FF00,$FF00,$0180,$0180   ; steep slope right
		dw $FE80,$FE80,$0100,$0100   ; left facing conveyor up
		dw $FE80,$FE80,$0100,$0100   ; left facing conveyor down
		dw $FF00,$FF00,$0180,$0180   ; right facing converyor up
		dw $FF00,$FF00,$0180,$0180   ; right facing converyor down
		dw $FC00,$FC00,$FD00,$FD00   ; very steep slope left
		dw $0300,$0300,$0400,$0400   ; very steep slopr right
		dw $FC00,$FC00,$0600,$0600   ; 16 bytes flying left while holding left
		dw $FA00,$FA00,$0400,$0400   ;          flying right while holding right
		dw $FF80,$0080,$FF00,$0100   ; ; 24 bytes sliding accelerations
		dw $FE80,$0180,$FE80,$FE80
		dw $0180,$0180,$FE80,$0280
		dw $FEC0,$FD80,$0140,$0280   ; turning decelerations
		dw $FD80,$FB00,$0280,$0500
		dw $FD80,$FB00,$0280,$0500
		dw $FD40,$FA80,$0240,$0480
		dw $FDC0,$FB80,$02C0,$0580
		dw $FD00,$FA00,$0200,$0400
		dw $FE00,$FC00,$0300,$0600
		dw $FD00,$FA00,$0200,$0400
		dw $FD00,$FA00,$0200,$0400
		dw $FE00,$FC00,$0300,$0600
		dw $FE00,$FC00,$0300,$0600
		dw $FD00,$FA00,$FD00,$FA00
		dw $0300,$0600,$0300,$0600

gravity_heavy:
        db $06,$04,$04,$10,$F4,$01,$03,$04,$05,$06   ; heavy gravity 
        