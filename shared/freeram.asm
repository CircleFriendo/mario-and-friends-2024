
includeonce

; Large blocks of ram
if read1($00FFD5) == $23
    !objectool_level_flags_freeram = $409400    ; 13 bytes
    !toggles_freeram_bank = $409450             ; 16 bytes reserved, 6 used
    !retry_freeram =  $40A400
else
    !objectool_level_flags_freeram = $7FA400    ; 13 bytes
    !toggles_freeram_bank = $7FA450             ; 16 bytes reserved, 6 used
    !retry_freeram = $7FB400
endif

;; objectool flags
!characterflags = !objectool_level_flags_freeram
!disableswitchflag = !objectool_level_flags_freeram
!disableswitchbit = $40
!startcharacterflags = !objectool_level_flags_freeram+1

;; player ability freeram

!GroundPndFlag      = $7f9e00	;FreeRAM  
!GroundPndTimer     = $7f9e01	;FreeRAM 
!FC                 = $7f9e02	;FreeRAM 
!scuttle            = $7f9e03   ;FreeRAM
!floatcharge        = $7f9e04   ;FreeRAM
!floattimer         = $7f9e05   ;FreeRAM
!DashTimer          = $7f9e06   ;FreeRAM
!DashCooldownTimer  = $7f9e07   ;FreeRAM 
!spinjumpenableflag = $7f9e08   ;FreeRAM
!fluttercharge      = $7f9e09   ;FreeRAM
!fluttertimer       = $7f9e0a	;FreeRAM   
!propelcharge       = $7f9e0b   ;FreeRAM 
!propellocked       = $7f9e0c   ;FreeRAM    
!propeltimer        = $7f9e0d   ;FreeRAM
!enemybouncetrigger = $7f9e0e   ;FreeRAM

;; character freeram

!player             = $7f9e10   ;FreeRAM
!lastplayer         = $7f9e11   ;FreeRAM




;; physics freeram

;;; Three bytes each to store addresses
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


;;; one byte each
!pmeter_speed       = $7f9f30   ;FreeRAM
!pspeed_pose        = $7f9f31   ;FreeRAM
!noteblock_bounce   = $7f9f32   ;FreeRAM
!turnblock_bounce   = $7f9f33   ;FreeRAM
!spring_bounce_low  = $7f9f34   ;FreeRAM
!spring_bounce_high = $7f9f35   ;FreeRAM
!diagonal_pipe      = $7f9f36   ;FreeRAM
!rope_jump          = $7f9f37   ;FreeRAM
!enemy_bounce_low   = $7f9f38	;FreeRAM
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


; Resource Freeram
!block_duplication_freeram = $13E6|!addr ; 2 bytes
!capespin_direction_freeram = $1869|!addr ; 2 bytes
!double_hit_fix_freeram = $1DFD|!addr ; 1 byte
!screen_scrolling_pipes_freeram = $18C5|!addr ; 5 bytes
!skull_raft_fix_freeram = $18E6|!addr ; 1 byte
!sprite_scroll_fix_position_freeram = $0DC3|!addr ; 4 bytes
!sprite_scroll_fix_displacement_freeram = $1487|!addr ; 4 bytes
!triangles_fix_freeram = $14BE|!addr ; 1 byte


