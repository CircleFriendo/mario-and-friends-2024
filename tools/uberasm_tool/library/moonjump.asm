
  ;;; Because luigi has lower gravity, you get a moon jump
    ;;; If you switch to luigi after jumping
    ;;; So we nerf that
    ;;; Technically the same thing happens when you switch 
    ;;; away from wario but it's not as bad so we leave it.

fix:
    LDA $7D
    BPL +
    EOR #$FF
    LSR
    EOR #$FF
    STA $7D
    
+   RTL