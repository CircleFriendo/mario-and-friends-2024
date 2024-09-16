incsrc "../../../shared/freeram.asm"

main: 
    JSL switch_Main

DetectSwitch:
    LDA !player
    CMP !lastplayer
    BEQ +  
    STA !lastplayer
 
    LDA #$0B   ; character select sound
    STA $1DFC
     
+  
    RTL