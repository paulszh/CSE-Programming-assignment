* buffered net sim
.include '65nm_bulk.pm'
.include 'invx4.cdl'
.include 'invx8.cdl'
.include 'invx16.cdl'
.include 'invx32.cdl'

.OPTIONS LIST NODE POST
.OPTION METHOD=GEAR
.OP

VSS VSS 0 DC 0V
VDD VDD VSS DC 1.2V
VI IN 0 pwl( 0 0v 500p 0v 510p 1.2v 5000p 1.2v )

.subckt interconnect_segment A B
rDis1 A B 2
cDis1 B 0 6.15e-14
.ends

* subckt instantiations must start with the character 'x'
* do not modify the following two lines
xInvA IN pInt1 VDD VSS INVX32
xInvB pInt1 p0 VDD VSS INVX32
xSeg1 p0 p1 interconnect_segment

xSeg2 p1 p2 interconnect_segment

xInv1 p2 p3 VDD VSS INVX16

xSeg3 p3 p4 interconnect_segment

xInv2 p4 p5 VDD VSS INVX16

xSeg4 p5 p6 interconnect_segment

xSeg5 p6 p7 interconnect_segment

xInv3 p7 p8 VDD VSS INVX32

xSeg6 p8 p9 interconnect_segment

xSeg7 p9 p10 interconnect_segment

xSeg8 p10 p11 interconnect_segment

xSeg9 p11 p12 interconnect_segment

xSeg10 p12 p13 interconnect_segment

xInv4 p13 p14 VDD VSS INVX32

xSeg11 p14 p15 interconnect_segment

xSeg12 p15 p16 interconnect_segment

xSeg13 p16 p17 interconnect_segment

xInv5 p17 p18 VDD VSS INVX32

xSeg14 p18 p19 interconnect_segment

xSeg15 p19 p20 interconnect_segment

xSeg16 p20 p21 interconnect_segment

xSeg17 p21 p22 interconnect_segment

xSeg18 p22 p23 interconnect_segment

xInv6 p23 p24 VDD VSS INVX32

xSeg19 p24 p25 interconnect_segment

xSeg20 p25 p26 interconnect_segment

xSeg21 p26 p27 interconnect_segment

xInv7 p27 p28 VDD VSS INVX32

xSeg22 p28 p29 interconnect_segment

xSeg23 p29 p30 interconnect_segment

xSeg24 p30 p31 interconnect_segment

xSeg25 p31 p32 interconnect_segment

xSeg26 p32 p33 interconnect_segment

xInv8 p33 p34 VDD VSS INVX32

xSeg27 p34 p35 interconnect_segment

xSeg28 p35 p36 interconnect_segment

xSeg29 p36 p37 interconnect_segment

xInv9 p37 p38 VDD VSS INVX32

xSeg30 p38 p39 interconnect_segment

xSeg31 p39 p40 interconnect_segment

xSeg32 p40 p41 interconnect_segment

xSeg33 p41 p42 interconnect_segment

xInv10 p42 p43 VDD VSS INVX32

xSeg34 p43 p44 interconnect_segment

xSeg35 p44 p45 interconnect_segment

xSeg36 p45 OUT interconnect_segment

cReceiver OUT 0 5e-15

.measure tran out_slew trig v(OUT) val=0.12 rise=1 targ v(OUT) val=1.08 rise=1

.measure tran buffer_1_in_slew trig v(p2) val=0.12 rise=1 targ v(p2) val=1.08 rise=1
.measure tran buffer_1_out_slew trig v(p3) val=1.08 fall=1 targ v(p3) val=0.12 fall=1
.measure tran buffer_2_in_slew trig v(p4) val=1.08 fall=1 targ v(p4) val=0.12 fall=1
.measure tran buffer_2_out_slew trig v(p5) val=0.12 rise=1 targ v(p5) val=1.08 rise=1
.measure tran buffer_3_in_slew trig v(p7) val=0.12 rise=1 targ v(p7) val=1.08 rise=1
.measure tran buffer_3_out_slew trig v(p8) val=1.08 fall=1 targ v(p8) val=0.12 fall=1
.measure tran buffer_4_in_slew trig v(p13) val=1.08 fall=1 targ v(p13) val=0.12 fall=1
.measure tran buffer_4_out_slew trig v(p14) val=0.12 rise=1 targ v(p14) val=1.08 rise=1
.measure tran buffer_5_in_slew trig v(p17) val=0.12 rise=1 targ v(p17) val=1.08 rise=1
.measure tran buffer_5_out_slew trig v(p18) val=1.08 fall=1 targ v(p18) val=0.12 fall=1
.measure tran buffer_6_in_slew trig v(p23) val=1.08 fall=1 targ v(p23) val=0.12 fall=1
.measure tran buffer_6_out_slew trig v(p24) val=0.12 rise=1 targ v(p24) val=1.08 rise=1
.measure tran buffer_7_in_slew trig v(p27) val=0.12 rise=1 targ v(p27) val=1.08 rise=1
.measure tran buffer_7_out_slew trig v(p28) val=1.08 fall=1 targ v(p28) val=0.12 fall=1
.measure tran buffer_8_in_slew trig v(p33) val=1.08 fall=1 targ v(p33) val=0.12 fall=1
.measure tran buffer_8_out_slew trig v(p34) val=0.12 rise=1 targ v(p34) val=1.08 rise=1
.measure tran buffer_9_in_slew trig v(p37) val=0.12 rise=1 targ v(p37) val=1.08 rise=1
.measure tran buffer_9_out_slew trig v(p38) val=1.08 fall=1 targ v(p38) val=0.12 fall=1
.measure tran buffer_10_in_slew trig v(p42) val=1.08 fall=1 targ v(p42) val=0.12 fall=1
.measure tran buffer_10_out_slew trig v(p43) val=0.12 rise=1 targ v(p43) val=1.08 rise=1


* the total delay from p0 to OUT
.measure tran rise_delay trig v(p0) val=0.6 rise=1 targ v(OUT) val=0.6 rise=1
* power estimation (for interconnect length of 2.5mm)
.measure tran iavg avg i(VDD) from 500p to 650p 
* power estimation (for interconnect length of 9mm)
*.measure tran iavg avg i(VDD) from 500p to 1000p 
.measure power param='-1.0*iavg*1.2'

.tran 1p 5000p 

.end