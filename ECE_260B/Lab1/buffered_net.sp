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
rDis1 A i1 17.5
cDis1 i1 0 3.375e-14
rDis2 i1 B 17.5
cDis2 B 0 3.375e-14
.ends

* subckt instantiations must start with the character 'x'
* do not modify the following two lines
xInvA IN pInt1 VDD VSS INVX32
xInvB pInt1 p0 VDD VSS INVX32

xSeg1 p0 p1 interconnect_segment

xInv1 p1 p2 VDD VSS INVX32

xSeg2 p2 p3 interconnect_segment

xSeg3 p3 p4 interconnect_segment

xSeg4 p4 p5 interconnect_segment

xInv2 p5 p6 VDD VSS INVX16

xSeg5 p6 OUT interconnect_segment

cReceiver OUT 0 5e-15

* output slew
.measure tran out_slew trig v(OUT) val=0.12 rise=1 targ v(OUT) val=1.08 rise=1

* measure the slew 
.measure tran buffer_1_in_slew trig v(p1) val=0.12 rise=1 targ v(p1) val=1.08 rise=1
.measure tran buffer_1_out_slew trig v(p2) val=1.08 fall=1 targ v(p2) val=0.12 fall=1
.measure tran buffer_2_in_slew trig v(p5) val=1.08 fall=1 targ v(p5) val=0.12 fall=1
.measure tran buffer_2_out_slew trig v(p6) val=0.12 rise=1 targ v(p6) val=1.08 rise=1

* the total delay from p0 to OUT
.measure tran rise_delay trig v(p0) val=0.6 rise=1 targ v(OUT) val=0.6 rise=1
* power estimation (for interconnect length of 2.5mm)
.measure tran iavg avg i(VDD) from 500p to 650p 
* power estimation (for interconnect length of 9mm)
*.measure tran iavg avg i(VDD) from 500p to 1000p 
.measure power param='-1.0*iavg*1.2'

.tran 1p 5000p 

.end
