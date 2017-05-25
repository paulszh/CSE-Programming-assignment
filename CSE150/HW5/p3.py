import collections
from string import ascii_uppercase
import time
from itertools import izip
import math
import numpy as np

T, N         = 258, 50;
xtable       = [[0 for n in range(N)] for t in range(T)]
RgivenZ      = [[0 for x in range(4)] for n in range(N)]
Z            = [0 for x in range(4)]
titles       = [0 for n in range(N)]
popularities = [0 for n in range(N)]
titles_pop   = {}
pr           = [0 for t in range(T)]
pit          = [[0 for t in range(T)] for x in range(4)]
iterations   = [0, 1 , 2, 4, 8, 16, 32, 64, 128]

with open("hw5_movieRatings.txt") as ratings_x:
    i = int(0)
    for line in ratings_x:
        j = int(0)
        for xij in line.split():
            xtable[i][j] = xij.strip()
            j+=1
        i+=1

with open("hw5_movieTitles.txt") as movies:
    i = int(0)
    for title in movies:
    	titles[i] = title.strip()
    	i+=1

with open("hw5_probRgivenZ_init.txt") as R_Z:
    i = int(0)
    for line in R_Z:
        j = int(0)
        for xij in line.split():
            xij = xij.strip()
            RgivenZ[i][j] = float(xij)
            j+=1
        i+=1


with open("hw5_probZ_init.txt") as probZ:
    i = int(0)
    for z in probZ:
        z = z.strip()
        Z[i] = float(z)
        i+=1


def getPopularities():
    for n in range(N):
        numRecom = float(0)
        numSaw   = float(0)
        for t in range(T):
            if xtable[t][n] == "1":
                numRecom += 1
                numSaw   += 1
            else:
                if xtable[t][n] == "0":
                    numSaw +=1
        popularities[n] = numRecom/numSaw
        titles_pop[titles[n]] = popularities[n]

    t = sorted(titles_pop.iteritems(), key=lambda x:x[1])
    for x in t:
        print "{0}: {1}".format(*x)

def getPR():
    print ('Z is:',Z)
    for t in range(T):
        pr[t] = float(0)
        for i in range(4):
            prz = float(1)
            for j in range(N):
                if xtable[t][j] == "1":
                    prz *= RgivenZ[j][i]
                else:
                    if xtable[t][j] == "0":
                        prz *= (1 - RgivenZ[j][i])
            pr[t] += Z[i] * prz

    return pr

def eStep():
    itsum = float(0)
    # currentPR = getPR()
    for t in range(T):
        for i in range(4):
            prz = float(1)
            for j in range(N):
                if xtable[t][j] == "1":
                    prz *= RgivenZ[j][i]
                else:
                    if xtable[t][j] == "0":
                        prz *= (1 - RgivenZ[j][i])
            pit[i][t] = Z[i] * prz / pr[t]
    print(pit[0][0])
    print(pit[1][0])
    print(pit[2][0])
    print(pit[3][0])

def mStep():
    summation  = [0 for i in range(4)]

    # update P(Z=i)
    for i in range(4):
        summation[i] = float(0)     
        for t in range(T):
            summation[i] += pit[i][t]
        Z[i] = summation[i] / T

    # update R given Z
    for i in range(4):
        for j in range(N):
            sum1 = float(0)
            sum2 = float(0)
            for t in range(T):
                if xtable[t][j] == "1":
                    sum1 += pit[i][t]
                else:
                    if xtable[t][j] == "?":
                        sum2 += pit[i][t]*RgivenZ[j][i]
            RgivenZ[j][i] = (sum1 + sum2) / summation[i]
    print (RgivenZ[1])
    print ('')


def getLikelihood():
    currentPR = getPR()
    likelihood = float(0)

    for i in range(T):
        print (currentPR[i])
        likelihood += np.log(currentPR[i])

    return likelihood / T



def iterate(it):
    count = int(0)
    for i in range(it+1):
        if i == iterations[count]:
            print "{0}: {1}\n".format(i, getLikelihood())
            count += 1
        if i != it:    
            eStep()
            mStep()

iterate(3)

def checkMyself():
    result = {}
    me = int(67)
    
    for j in range(N):
        if xtable[67][j] == "?":
            summation = float(0)
            for i in range(4):
                summation += pit[i][me]*RgivenZ[j][i]
            result[titles[j]] = summation
    t = sorted(result.iteritems(), key=lambda x:-x[1])
    for x in t:
        print "{0}: {1}".format(*x)

checkMyself()
    




    
