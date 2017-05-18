import collections
import math
import matplotlib.pyplot as plt
import numpy as np

x_table = []
y_table = []
p_i = []
ML = []
MS = []
y_giv_x = [None] * 267

#Read data from File
with open ('hw5_noisyOr_x.txt') as f1:
	for line in f1: 
		line = line[:-1].split()
		currline = []
		for number in line:
			currline.append(int(number))
		x_table.append(currline)
f1.close()

with open('hw5_noisyOr_y.txt') as f2:
	for line in f2:
		y_table.append(int(line))
	
for idx in range (0,len(x_table[0])):
	p_i.append(float(1/23))
 		
def EM_upate(column):
	pi = float(0)
	count_x = 0;
	for t in range (0,len(y_table)):
		if(x_table[t][column] == 1):
			count_x += 1
			if(y_table[t] == 1):
				pi += (p_i[column])/(y_giv_x[t])
#				print(y_given_x(t))			
	return pi/count_x	
			
def y_given_x():
	
	for t in range (len(y_table)):
		product = float(1)
		for i in range (0,len(x_table[0])):
			product *= math.pow((1-p_i[i]),x_table[t][i])
		product = 1- product;
		y_giv_x[t] = product;

	

def log_likelihood():
	y_given_x()
	L = float(0)
	for i in range (0,len(y_table)):
		if(y_table[i] == 1):
			L += math.log(y_giv_x[i])
		else:
			L += math.log(1-y_giv_x[i])
	return L/len(y_table)
				
#print(y_given_x(1))
#print(o_log_likelihood())
def get_num_mistakes():
	count = int(0)
	for t in range (len(y_table)):
		if(y_giv_x[t] >= 0.5 and y_table[t] == 0):
			count+=1
		if(y_giv_x[t] <= 0.5 and y_table[t] == 1):
			count+=1
	
	return count
		
	
	
	
def EM_Algorithm(iter):
	for i in range (0,iter):
		L = log_likelihood();
#		print('num of mistakes: ', get_num_mistakes())
		ML.append(L);
		MS.append(get_num_mistakes())
		#For each column
		for j in range(0,len(x_table[0])):
			p_i[j] = EM_upate(j);
			
def print_result():
	print (ML[0],MS[0]);
	for i in range (0,9):
		print (str(ML[2**i]),str(MS[2**i]))
EM_Algorithm(512)	
print_result()
#
#
#print (ML[1])
#print (ML[2]);
#print (ML[3]);

		
	
	
	


