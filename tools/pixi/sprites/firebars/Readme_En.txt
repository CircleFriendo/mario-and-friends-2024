Customizable Circles
by Isikoro

You can make various Fire Bar and RotoDisc and Ball'n Chain and Rotating Platform with this one.

However, as far as cookies and gluggles are concerned, this is superior in some areas.
RotoDisc ....... https://www.smwcentral.net/?p=section&a=details&id=20573
Ball'n Chain ... https://www.smwcentral.net/?p=section&a=details&id=28157

You can make the following settings.


Extra Bits	:Initial rotation direction
　2 = Clockwise
　3 = Counterclockwise


Extra Byte 1
bit0-4 : Number of fireballs or chains + 1 and RotoDisc radius (in increments of 8 tiles)　( bit0-3 for Rotating Platforms )

bit5 ( except for Rotating Platforms ):　Fireball size
　00 = Small（8x8）
　01 = Big（16x16）(By default, the larger fireball graphics are from the GFX25).

bit4-5 ( for Rotating Platforms ) : Width of the lift
　00 = 16x32
　01 = 16x48
　10 = 16x64
　11 = 16x80
  (By default, the platform graphics used from SP3.)

bit6-7 (If Extra Prop 2 = $00)
If the pendulum movement flag is clear, ON / OFF interlocking flag
　00 = No ON/OFF interlocking.
　01 = The rotation direction is reversed by switching ON/OFF.
　10 = It will stop when it is ON.
　11 = It will stop when it is OFF.
If the pendulum movement flag is set, the direction of gravity with respect to the firebar
　00 = Bottom
　01 = Left
　10 = Top
　11 = Right


Extra Byte 2 (If Extra Prop 2 = $00)
bit0-6	:　Initial rotation speed

bit7	:　Direction to shift when appearing（Effective when Extra Prop is 01 or above）
　0 = Shifts to the right for vertical levels and down for horizontal levels.
　1 = Shifts to the left for vertical levels and up for horizontal levels.



Extra Byte 3 (If Extra Prop 2 = $00)
bit0-7	:　Initial angle（It shifts clockwise by the numerical value.）
　	:　00 = Horizontal right
	:　80 = Horizontal left


Extra Byte 4 (If Extra Prop 2 = $00)
bit0-6　:　Pendulum movement flag
　A pendulum exercise is performed with 01 or more.
　The larger the value, the faster the rotation speed increases and decreases.
　It cannot be used together with ON / OFF interlocking.
　Depending on the initial angle and initial rotation speed, it is possible to keep the rotating indefinitely.

bit7	:　Layer 2 interlocking flag
　When set to 1, the center axis will be scrolled together with layer 2.
　The initial position is also shifted according to the position of layer 2.



Extra Prop 1
　Bits 0-5 determine the type of sprite.
  00...Firebar
　01...RotoDisc
　02...Ball'n'Chain
　03...Rotating Platform
　When bit-6 is set to 1, the sprite can shift its position according to its length when it appears.
　This prevents the sprite from overlapping with the player at the same time it appears and taking damage.
　There is a sprite at the destination of the shift,
　Extra Byte 1", "Extra Byte 3", "Extra Bits", "Extra Prop 1" and "Extra Prop 2" are identical to the source sprite, and !
　14C8,x is 08, the original sprite is erased.
　If bit-7 is set to 1, it clears one space between chains. Applies only to Ball'n'Chain and Rotating Platform.

Extra Prop 2
  01 or more to get the current angle from the specified RAM.

  In addition, it is shifted by the amount of the value in Extra Byte 2.
  (Extra Bits = 2 for clockwise, 3 for anti-clockwise)
  Regardless of the width of the value to be acquired, #$80 shifts it 180 degrees.
　
  Extra Byte 3 is the lower byte of the address of the specified RAM, 
  and Extra Byte 4 specifies the upper byte of the address of the specified RAM.

　Extra Prop 2 bits 0-6 specify the bank.
  Sets the width of the value to be obtained with bit7. (0=8bit , 1=16bit)
  For 8-bit widths, #$80 rotates 180 degrees
  For 16-bit widths, #$1000 rotates 180 degrees.

  When acquiring angles from RAM, bit 6 of Extra Byte 1 becomes the Layer 2 linkage flag, 
  and bit 7 sets the center axis shift direction at the time of appearance. (When Extra Prop 1 is 01 or higher)


Graphics to use
                     | SP3 | SP4 |
---------------------|-----|-----|
Firebar (small)      | any | any |
Firebar (big)        | any |  25 |
RotoDisc (small/big) |   * | any |
Ball'n'Chain (small) | any |   * |
Ball'n'Chain (big)   | any |   3 |
Rotating Platform    |  13 |   5 |

* The graphics included with this sprite ("RotoDisc and Small Ball.bin").