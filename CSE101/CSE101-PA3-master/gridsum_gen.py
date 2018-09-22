# GridSum test case generator for PA 3
import random
import sys

N = 5000
Q = 100000

# DO NOT MODIFY BELOW
filename = 'GEN_GRID_{0}_{1}'.format(N, Q)

output_file = open(filename, 'w')

output_file.write(str(N) + '\n')

for i in range(N):
    for j in range(N - 1):
        output_file.write('{0} '.format(str(random.randint(1, 50))))
    output_file.write('{0}\n'.format(str(random.randint(1, 50))))

for q in range(Q):
    xcoors = [random.randint(0,N-1), random.randint(0,N-1)]
    ycoors = [random.randint(0,N-1), random.randint(0,N-1)]
    xcoors.sort()
    ycoors.sort()
    output_file.write('{0} {1} {2} {3}\n'.format(xcoors[0], ycoors[0], xcoors[1], ycoors[1]))

output_file.close()
