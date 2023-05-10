**Name: Mitran Andrei-Gabriel**
**Group: 313CA**

## ACS Cat Invasion - Homework 2

### Description:

* simple: Iterates through the plain string, adding step to each char and
writing the encrypted chars at enc_string. If the ASCII code is greater than
the ASCII code of 'Z', subtracts step + 26, then adds step again.
* points_distance: Since the points have either their x or y equal, the program
gets the difference between the nonequal coordinates. It always gets a positive
difference. The result is written at the given address.
* road: Calls points_difference for each point and its succesor in the vector
of points. Writes the results at the specified addresses.
* is_square: Checks if every distance is a prefect square then writes 1 or 0 at
the specified addresses. It does this by checking each perfect square until
whether it is confirmed that the distance is one, or that it is situated
between two perfect squares.
* beaufort: Without using tabula_recta, one can notice that the ecryption
algorithm is solely based on enc_string[i] = (key[i] - plain[i]) + 'A' if
(key[i] - plain[i]) >= 0 or  enc_string[i] = 26 + (key[i] - plain[i]) + 'A'
if (key[i] - plain[i]) < 0. Knowing this, the program iterates through the
plain string and gets the encrypted one easily. The key is repeated if key_len
< plain_len.
* spiral: If one can iterate through the matrix in a spiral, the encryption is:
enc_string[i] = plain[i] + a[i], where a is the matrix and i is the current
step of iteration. The algorithm of going along spirally in a matrix is
described in more detail in the comments of spiral.asm.
