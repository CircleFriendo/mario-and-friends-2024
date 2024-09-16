incsrc "../../../shared/freeram.asm"
incsrc "../../../shared/characters.asm"

;;   Wario Dash Parameters
!dashspeed          = $38           ;   The dash speed
!DashTime           = $1F          ;   Time you will dash for
!DashCooldown       = !DashTime+$30          ;   Time before you can dash again
!DashJumpYSpeed		= $98	; Normal jump speed


                            
; These are default sounds for SMW without AddmusicK. 
;!JumpSound = $01    ; Sound to play for air normal jumps
;!JumpSoundPort = $1DFA+!addr ; location to activate jump sounds

; Use these instead if using AddmusicK
!JumpSound = $2B    ; Sound to play for normal jumps
!JumpSoundPort = $1DF9+!addr ; location to activate jump sounds

!dashbutton         = $80           ;\  The button you use  
!dashbutton_ram     = $18           ;/  See https://www.smwcentral.net/?p=memorymap&game=smw&u=0&address=7E0016-7E0018
!no_small       = 0             ;   Whether you can dash while small or no
 
init:
    LDA #$00
    STA !DashTimer
    STA !DashCooldownTimer
    RTL

clear:
    LDA #$00
    STA !DashTimer
    RTL
    
    
; Wario Dash - by K3fka

main:

    JSL always
        

active:
        LDA $13D4|!addr ; |  paused
        ORA $9D         ; |
        BNE End

        LDA !DashTimer   ;\  We're not dashing if our dash timer is zero
        BEQ Check2      ;/
        DEC A
        STA !DashTimer
        BNE dashing
        STZ $13ED|!addr ;\  Stop sliding
        STZ $13EE|!addr ;/
        
        if read1($01D746) == $1A   ; play grinder sound effect
                LDA #$1A
                STA $1DF9|!addr
        else
                LDA #$04
                STA $1DFA|!addr
        endif
        
        RTL
        
dashing:
        
        LDA $73         ; |
        ;ORA $72         ;\    on the ground flag
        ORA $74         ; |
        ORA $75         ; | Cancel the dash under certain conditions
        ORA $1470|!addr ; |
        ORA $148F|!addr ; |
        ORA $187A|!addr ; |
        BNE Cancel      ;/
        
        
        LDA $16         ; jump cancel
        AND #$80
        BNE JumpCancel
        
        LDA #$04        ;\ 
        STA $13EE|!addr ; | Simulate sliding
        LDA #$01        ; |
        STA $13ED|!addr ;/
        LDA #$0D ;#$B3        ;\  Set the pose
        STA $13E0|!addr ;/
        LDA $15         ;\ byetUDLR
        AND #$30        ; only enable start and select
        STA $15
        LDA $16
        AND #$30        ; only enable start and select
        STA $16
        STZ $17         ; |axlr----
        STZ $18         ;/
        
        LDA #$70        ; give p speed
        STA $13E4
        
        LDY #!dashspeed     ;\ 
        LDA $76         ; Player Direction
        BNE DashL       ; | Dash
        LDY.b #-!dashspeed  ; |
DashL:                  ; |
        STY $7B         ;/
WallCheck:
        LDA $77         
        AND #$03        ; | Check to see if we're touching a wall
        BEQ End         
        
        STZ $7B         ;   Stop moving
Cancel:
        LDA #$00
        STA !DashTimer   ;\  Zero out the timers
        STA !DashCooldownTimer   ;/
End:
        RTL

JumpCancel:
        LDA #!DashJumpYSpeed		; Jump up
        STA $7D
	
        LDA #!JumpSound
        STA !JumpSoundPort
        
        BRA Cancel

Check2:
        LDA !DashCooldownTimer
        BEQ ButtonCheck ;/
        
        RTL

always:
    LDA $13D4|!addr ; |  paused
    ORA $9D         ; |
    BNE +
    LDA !DashCooldownTimer   ;\  If the cooldown timer is zero, start the dash
    BEQ +
    DEC A
    STA !DashCooldownTimer   ;   If not, decrease the cooldown timer
    +
    RTL
    
ButtonCheck:

        LDA !player : CMP #!wario : BNE End  ; Wario only

        LDA !dashbutton_ram ;\ 
        AND #!dashbutton    ; | Jump to the end if we're NOT pressing X
        BEQ End         ;/
        if !no_small
                LDA $19 ;\   Or if we are small
                BEQ End ;/
        endif
BeginDash:
                    ; |Cancel the dash under certain conditions
        LDA $72         ;\  in the air flag
        ORA $73         ; | ducking flag
        ORA $74         ; | climbing flag
        ORA $75         ;   water flag
        ORA $1470|!addr ; | carrying item flag
        ORA $148F|!addr ; | holding item flag
        ORA $187A|!addr ; | riding yoshi flag
        ORA $13D4|!addr ; | paused flag
        ORA $9D         ; | animation locked flag
        BNE Cancel      ;/
        LDA #!DashTime  ;\  Set the dash timer
        STA !DashTimer   ;/
        LDA #!DashCooldown   ;\  Set the cooldown timer
        STA !DashCooldownTimer   ;/
        
        LDA #$26   ; play swooper sound effect
        STA $1DFC|!addr
        
        STZ $14A6|!addr     ; end cape spin
        
        RTL