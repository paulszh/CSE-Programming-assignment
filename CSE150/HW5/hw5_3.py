import collections
import math
import numpy as np

ML = []
my_movie_list = {}
student_rating = []
movieTitle = []
movie_rating = []
pid = []
r_giv_z = []  #50 * 4 every movie liked by different movie goers
r_giv_z_copy = [[None for i in range(4)] for j in range(50)]
rt_giv_z = [None] * 258	

rt_giv_z_without_sum = [[None for i in range(4)] for j in range(258)]
z = [float(0.25)] * 4
pit = [[None for i in range(4)] for j in range(258)]

with open ('hw5_probRgivenZ_init.txt') as f1:
	for line in f1:
		line = line.split();
		currline = []
		for p in line:
			currline.append(float(p))
		r_giv_z.append(currline) 


with open ('hw5_movieTitles.txt') as f3:
	for line in f3:
		movieTitle.append(line.strip())
		
f3.close()

with open ('hw5_movieRatings.txt') as f4:
	for line in f4:
		line = line.split();
		currline = []
		for p in line:
			currline.append(p)
		student_rating.append(currline)
		

def sanity_check():
	for c in range (0,len(movieTitle)):
		movieDB = {}
		seen = int(0)
		recmd = int(0)
		for l in range (0,len(student_rating)):
			if(student_rating[l][c] == '1' or student_rating[l][c] == '0'):
				seen+=1 
				if(student_rating[l][c] == '1'):
					recmd+=1
		if(seen != 0):
			movie_rating.append(float(recmd/seen))	
		else:
			movie_rating.append(float(0))
		
	movieDB = dict(zip(movieTitle,movie_rating))	
	for word_pair in sorted(movieDB.items(), key=lambda x: x[1],reverse=False):
		print(word_pair);

def posterity_prob():	
	for t in range (len(rt_giv_z)): #258
		sum_of_product = float(0)
		rt_giv_z[t] = 0.0
		for i in range (len(z)): # 4 
			product = float(1)
			for j in range (len(r_giv_z)): #50
				if(student_rating[t][j] == '1'):
					product *= r_giv_z[j][i]
				if(student_rating[t][j] == '0'):
					product *= (1-r_giv_z[j][i])
			rt_giv_z_without_sum[t][i] = z[i] * product;
			rt_giv_z[t] += z[i] * product
		
def log_likelihood():
	L = float(0)
	posterity_prob()

	for t in range (len(student_rating)):
		L += math.log(rt_giv_z[t])
	return L/len(student_rating)	
	

def estep():
		for t in range (len(pit)):
			for i in range (len(pit[0])):
				pit[t][i] = rt_giv_z_without_sum[t][i]/rt_giv_z[t]
def mstep():
	#update p(z == i)
	
	for i in range (len(pit[0])):   #4
		sum_over_t = float(0)
		for t in range (len(pit)):	#258
			sum_over_t += pit[t][i]
		z[i] = float(sum_over_t/len(pit))
		
	#calcuating for different z value
	for i in range (4):
		for j in range (len(student_rating[0])): #50
			sum_left = float(0)
			sum_right = float(0)
			for t in range (len(pit)):  #258
				if(student_rating[t][j] == '1'):
					sum_left += pit[t][i]
				if(student_rating[t][j] == '?'):
					sum_right += pit[t][i] * r_giv_z[j][i]
			r_giv_z[j][i] = (sum_left + sum_right)/(z[i] * len(pit));
			
#	print(r_giv_z[0])
					
def EM_algorithm(itr):
	for num_iter in range (itr):
		ML.append(log_likelihood())	
		estep()
		mstep()

def print_result():
	print (0, ':', ML[0]);
	for i in range (0,8):
		print (str(2**i), ':', str(ML[2**i]))


def my_movie_recommendation():
#	My pid is on row 9
	for j in range (len(r_giv_z)):
		exp_rating = float(0)
		for i in range (len(pit[0])):
			if (student_rating[8][j] == '?'):
				exp_rating += pit[8][i] * r_giv_z[j][i]
		my_movie_list[movieTitle[j]] = exp_rating
	print (sorted(my_movie_list.items(), key=lambda x: x[1], reverse=True))		
				
	
sanity_check();
EM_algorithm(129)	
print_result()
my_movie_recommendation()
