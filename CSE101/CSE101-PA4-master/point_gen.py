import random
import sys

# N represents how many points to generate
# X represents the max value for any x or y where 0 <= x,y <= X
#
# Note that N <= X^2 has to be true, otherwise the script will not stop

N = 5000
X = 1000

# DO NOT MODIFY BELOW
filename = 'POINTS_{0}_{1}'.format(N, X)

output_file = open(filename, 'w')

points = set()

while len(points) < N:
    points.add((random.randint(0, X), random.randint(0,X)))

for pt in points:
    output_file.write('{0} {1}\n'.format(pt[0], pt[1]))

output_file.close()
