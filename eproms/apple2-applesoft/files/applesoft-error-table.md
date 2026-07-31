# Applesoft BASIC error message table

Recovered from `mostek_D0.bin`, $D260 onward.

**Note the string convention.** Applesoft stores messages as plain ASCII with
bit 7 set on the **last** character (`FO R2` = `FOR`). Integer BASIC does the
exact opposite: bit 7 set on **every** character, cleared on the last. Two
inverted conventions in the same address space -- independent evidence that these
are unrelated codebases (Woz vs Microsoft), not successive versions of one.

```
    $D260  NEXT WITHOUT FOR
    $D270  SYNTAX
    $D276  RETURN WITHOUT GOSUB
    $D28A  OUT OF DATA
    $D295  ILLEGAL QUANTITY
    $D2A5  OVERFLOW
    $D2AD  OUT OF MEMORY
    $D2BA  UNDEF'D STATEMENT
    $D2CB  BAD SUBSCRIPT
    $D2D8  REDIM'D ARRAY
    $D2E5  DIVISION BY ZERO
    $D2F5  ILLEGAL DIRECT
    $D303  TYPE MISMATCH
    $D310  STRING TOO LONG
    $D31F  FORMULA TOO COMPLEX
    $D332  CAN'T CONTINUE
    $D340  UNDEF'D FUNCTION
    $D350   ERROR
    $D358   IN 
    $D35E  BREAK
```
