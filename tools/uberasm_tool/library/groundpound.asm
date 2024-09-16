;Ground Pound UberASM
;this one gives ground pound ability that acts the same as yellow yoshi + shell/yoshi + yellow shell.

incsrc "../../../shared/freeram.asm"
incsrc "../../../shared/characters.asm"

;Frame used during ground pound
!GroundPndFrame = $1C		;

!GroundPndSpeed = $60		;downward speed during ground pound

!GroundPndAirStay = $08		;how long stay in air before dropping
!GroundPoundDelay = $0A		;how long player is unable to activate ground pound again after cancelling

!GroundPndStartSound = $23
!GroundPndStartBank = $1DF9|!addr


 
!ControllerTrigger = $18
!ButtonTrigger = $80       ; A button


init:
clear:
    LDA #$00
    STA !GroundPndTimer
    STA !GroundPndFlag	
    RTL


NoPoundAndDelay:
    LDA #$00
    STA !GroundPndTimer

NoPound:
LDA #$00
STA !GroundPndFlag		;disable ground pound (branch out of bounds edition).
RTL

main:
LDA $9D				;freeze flag (hurt, pickup power-up, growing yoshi, etc.)
LDA $13D4|!addr			;no pause
ORA $1426|!addr			;no message box (which stops action)
BNE .Re

LDA $74				;no climbing
ORA $1407|!addr			;no flying
ORA $75				;can't ground pound underwater
ORA $1470|!addr			;\not when carrying an item
ORA $148F|!addr			;/
ORA $187A|!addr			;not when riding a yoshi (don't feel like offsetting position + yellow shell/yoshi shenanigans)
ORA $1493|!addr			;not when goal
BNE NoPound			;reset ground pound state if any of this is true

LDA $71				;check various player animations, like death, entering level via pipe, door, and etc.
BNE NoPound 			;

LDA !GroundPndFlag		;
BNE .GroundPoundin		;

LDA $72				;can only ground pound when in air
BEQ NoPoundAndDelay		;

LDA !GroundPndTimer		;delay
BNE .ReTimer			;


LDA !player : CMP #!luigi : BNE .Re ; Luigi only

LDA !ControllerTrigger		;check for controller input that triggers ground pound
AND #!ButtonTrigger		;
BEQ .Re				;

LDA #!GroundPndAirStay		;
STA !GroundPndTimer		;set short timer to stay in air


  LDA !GroundPndFlag
  INC A
  STA !GroundPndFlag		;

STZ $140D|!addr			;disable spinjump
STZ $73				;no duck jump
LDA #$24
STA $72					;break sprint jump state
STZ $13E4|!addr			;something about run-jumping
STZ $14A6|!addr			;no cape swinging allowed
JSR DisableSomeButtons		;frame perfect cape swing

LDA #!GroundPndStartSound	;play sound
STA !GroundPndStartBank		;

STZ $7D				;no Y Spd

.Re
RTL				;

.ReTimer
LDA !GroundPndTimer		
DEC A
STA !GroundPndTimer
RTL				;

.GroundPoundin
STZ $7B				;no X Spd

JSR DisableSomeButtons		;no X/Y and left/right input

LDA #!GroundPndFrame		;set ground pound frame
STA $13E0|!addr			;

LDA !GroundPndTimer		;stay in air for a little bit
BEQ .Move			;untill timer is zero
DEC A
STA !GroundPndTimer		;tick timer

LDA $7D				;chuck and disco shell
BMI .NoPoundAndDelay		;

STZ $7D				;
BRA .CheckGround		;fix ground rising up thing

.Move

        LDA #$04        ;\ 
        STA $13EE|!addr ; | Simulate sliding
        LDA #$01        ; |
        STA $13ED|!addr ;/

.Checks
LDA $7D				;if we stomped something or gained upward speed in any way...
BMI .NoPoundAndDelay		;stop ground pound


  LDA #!GroundPndSpeed
  STA $7D				;

.CheckGround
LDA $77				;check if we touch a ground
AND #$04			;
BEQ .Re				;

;perform stomp man
;before we do that offset player's pos so it looks correct
LDA $96 : PHA			;
SEC : SBC #$10			;
STA $96				;

LDA $97 : PHA			;
SBC #$00			;
STA $97				;

JSL $0286BF|!bank		;cause quake and stuff
PLA : STA $97			;restore position
PLA : STA $96			;

.NoPoundAndDelay
LDA #$00
STA !GroundPndFlag		;disable ground pound.

LDA #!GroundPoundDelay
STA !GroundPndTimer
RTL


DisableSomeButtons:
LDA #$43			;disable left and right direction buttons
TRB $16				;
TRB $15				;can't hold X/Y (to make sure player doesn't grab anything during ground pound and cancel it)
RTS