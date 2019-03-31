import os
# num_buffer = 2;
num_seg = 36;

# xInv1 p1 p2 VDD VSS INVX32
# xSeg6 p0 p1 interconnect_segment
inv_position = open('pos.txt', "r")
pos = list();
inv_size = list();

line1 = inv_position.readline();
line2 = inv_position.readline();

for number1 in line1.split():
    pos.append(int(number1))
for number2 in line2.split():
    inv_size.append(int(number2))

num_buffer = len(pos);
TOTAL_PORT_NUM = num_buffer + num_seg;
filename = "buffer_net_9mm_%d.sp" %num_buffer
h = open(filename , "w")
h.close();

inv_idx = 1;
seg_idx = 1;
port_num_in = 0;
port_num_out = 0;
# "xSeg%d p%d p%d interconnect_segment" %seg_idx %port_num_in %port_num_out;
# print "xSeg%s p%s p%s interconnect_segment" %(seg_idx, port_num_in, port_num_out)
# print "xInv%s p%s p%s VDD VSS INVX32" %(inv_idx, port_num_in, port_num_out)

command = "cat file1.txt >> buffer_net_9mm_%d.sp" %num_buffer
os.system(command)
os.system('cat %s' %filename)


h = open(filename , "ab")
h.write('\n');

idx = 0
for i in range (0,TOTAL_PORT_NUM-1):
    if (idx < len(pos) and seg_idx - 1 == pos[idx]): 
        h.write('xInv%s p%s p%s VDD VSS INVX%s\n\n' %(idx+1, port_num_in, port_num_in + 1, inv_size[idx]))
        port_num_in = port_num_in + 1
        idx = idx + 1;
    else:
        h.write("xSeg%s p%s p%s interconnect_segment\n\n" %(seg_idx, port_num_in, port_num_in+1))
        seg_idx += 1
        port_num_in = port_num_in + 1
h.write("xSeg%s p%s OUT interconnect_segment\n\n" %(seg_idx, port_num_in))

h.write("cReceiver OUT 0 5e-15\n\n")

h.write(".measure tran out_slew trig v(OUT) val=0.12 rise=1 targ v(OUT) val=1.08 rise=1\n\n")
# .measure tran buffer_1_in_slew trig v(p1) val=0.12 rise=1 targ v(p1) val=1.08 rise=1
# .measure tran buffer_1_out_slew trig v(p2) val=1.08 fall=1 targ v(p2) val=0.12 fall=1
# .measure tran buffer_2_in_slew trig v(p5) val=1.08 fall=1 targ v(p5) val=0.12 fall=1
# .measure tran buffer_2_out_slew trig v(p6) val=0.12 rise=1 targ v(p6) val=1.08 rise=1

rise = True

for i in range (0,len(pos)):
    if (rise):
        h.write(".measure tran buffer_%d_in_slew trig v(p%d) val=0.12 rise=1 targ v(p%d) val=1.08 rise=1\n" %(i+1, pos[i] + i, pos[i] + i))
        h.write(".measure tran buffer_%d_out_slew trig v(p%d) val=1.08 fall=1 targ v(p%d) val=0.12 fall=1\n" %(i+1,pos[i] + i + 1, pos[i] + i + 1))
    else:
        h.write(".measure tran buffer_%d_in_slew trig v(p%d) val=1.08 fall=1 targ v(p%d) val=0.12 fall=1\n" % (i+1, pos[i] + i, pos[i] + i))
        h.write(".measure tran buffer_%d_out_slew trig v(p%d) val=0.12 rise=1 targ v(p%d) val=1.08 rise=1\n" %(i+1,pos[i] + i + 1, pos[i] + i + 1))
    rise = not rise
        
h.write('\n\n')
h.close();
command = "cat file2.txt >> buffer_net_9mm_%d.sp" %num_buffer
os.system(command)

command = "hspice buffer_net_9mm_%d.sp" %num_buffer
os.system(command)
command = "cat buffer_net_9mm_%d.mt0" %num_buffer
os.system(command)


