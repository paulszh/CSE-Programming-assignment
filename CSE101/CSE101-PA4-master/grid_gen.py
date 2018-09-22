import random
from datetime import datetime
import sys

N = 5000
M = 5000
S_r = 50
S_c = 50
D_r = 4950
D_c = 4950
H = 1.0
O = 0.0

#####################################
#   DO NOT MODIFY BELOW THIS LINE   #
#####################################

filename = 'GRID_{0}_{1}_{2}_{3}'.format(N, M, O, H)

output_file = open(filename, 'w')

v_o = 0

output_file.write('{0} {1}\n'.format(N, M))
output_file.write('{0} {1}\n'.format(S_r, S_c))
output_file.write('{0} {1}\n'.format(D_r, D_c))
output_file.write('{0}\n'.format(H))

random.seed(datetime.now())

for r in range(0, N):
	for c in range(0, M):
		if random.random() < O:
			output_file.write('{0} {1}\n'.format(r, c))

