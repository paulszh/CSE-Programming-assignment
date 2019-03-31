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

xSeg3 p2 p3 interconnect_segment

xSeg4 p3 p4 interconnect_segment

xInv1 p4 p5 VDD VSS INVX32

xSeg5 p5 p6 interconnect_segment

xSeg6 p6 p7 interconnect_segment

xSeg7 p7 p8 interconnect_segment

xSeg8 p8 p9 interconnect_segment

xSeg9 p9 p10 interconnect_segment

xInv2 p10 p11 VDD VSS INVX32

xSeg10 p11 p12 interconnect_segment

xSeg11 p12 p13 interconnect_segment

xSeg12 p13 p14 interconnect_segment

xSeg13 p14 p15 interconnect_segment

xSeg14 p15 p16 interconnect_segment

xSeg15 p16 p17 interconnect_segment

xSeg16 p17 p18 interconnect_segment

xSeg17 p18 p19 interconnect_segment

xSeg18 p19 p20 interconnect_segment

xSeg19 p20 p21 interconnect_segment

xSeg20 p21 p22 interconnect_segment

xSeg21 p22 p23 interconnect_segment

xSeg22 p23 p24 interconnect_segment

xSeg23 p24 p25 interconnect_segment

xSeg24 p25 p26 interconnect_segment

xSeg25 p26 p27 interconnect_segment

xSeg26 p27 p28 interconnect_segment

xSeg27 p28 p29 interconnect_segment

xSeg28 p29 p30 interconnect_segment

xSeg29 p30 p31 interconnect_segment

xSeg30 p31 p32 interconnect_segment

xSeg31 p32 p33 interconnect_segment

xSeg32 p33 p34 interconnect_segment

xSeg33 p34 p35 interconnect_segment

xSeg34 p35 p36 interconnect_segment

xSeg35 p36 p37 interconnect_segment

xSeg36 p37 OUT interconnect_segment

cReceiver OUT 0 5e-15

.measure tran out_slew trig v(OUT) val=0.12 rise=1 targ v(OUT) val=1.08 rise=1

.measure tran buffer_1_in_slew trig v(p4) val=0.12 rise=1 targ v(p4) val=1.08 rise=1
.measure tran buffer_1_out_slew trig v(p5) val=1.08 fall=1 targ v(p5) val=0.12 fall=1
.measure tran buffer_2_in_slew trig v(p10) val=1.08 fall=1 targ v(p10) val=0.12 fall=1
.measure tran buffer_2_out_slew trig v(p11) val=0.12 rise=1 targ v(p11) val=1.08 rise=1


* the total delay from p0 to OUT
.measure tran rise_delay trig v(p0) val=0.6 rise=1 targ v(OUT) val=0.6 rise=1
* power estimation (for interconnect length of 2.5mm)
.measure tran iavg avg i(VDD) from 500p to 650p 
* power estimation (for interconnect length of 9mm)
*.measure tran iavg avg i(VDD) from 500p to 1000p 
.measure power param='-1.0*iavg*1.2'

.tran 1p 5000p 

.end