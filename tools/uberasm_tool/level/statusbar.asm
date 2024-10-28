
!StatusBar = $7e0ef9
!StatusBarStar  = $7e0ef4
!StatusBarLives = $7e0F15
!StatusBarStars = $7e0f1B
!StatusBarCoins = $7e0f10
!StatusBarScore = $7e0f2f


init:
    LDA #$FC
    STA !StatusBarLives
    STA !StatusBarLives+1
    STA !StatusBarLives+2
    STA !StatusBarLives+3
    STA !StatusBarStar
    STA !StatusBarStars
    STA !StatusBarStars+1
    STA !StatusBarStars+4
    STA !StatusBarScore

    RTL