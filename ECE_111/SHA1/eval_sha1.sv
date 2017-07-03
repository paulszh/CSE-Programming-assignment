// This code is for PROTOTYPING ONLY to evaluate
// the critical path through the Wt computation
// and the hash computation (sha1_op).
//
// This code DOES NOT implement the sha1 project.
//
// To prevent the compiler from eliminating registers,
// the always_ff statement will assign to a, b, ...
// t, and the w array.

module eval_sha1(input logic clk, reset_n,
                 input logic [31:0] data,
                output logic [159:0] hash);

logic      [ 31:0]  w[0:15];
logic      [ 31:0]  wt;
logic      [ 31:0]  a, b, c, d, e;
logic      [  7:0]  t;

// ---------------------------------------------------------------------------------------

// SHA1 f
function logic [31:0] sha1_f(input logic [7:0] t);
begin
   if (t <= 19)
       sha1_f = (b & c) | ((~b) & d);
   else if (t <= 39)
       sha1_f = b ^ c ^ d;
   else if (t <= 59)
       sha1_f = (b & c) | (b & d) | (c & d);
   else
       sha1_f = b ^ c ^ d;
end
endfunction

// SHA1 k
function logic [31:0] sha1_k(input logic [7:0] t);
begin
   if (t <= 19)
       sha1_k = 32'h5a827999;
   else if (t <= 39)
       sha1_k = 32'h6ed9eba1;
   else if (t <= 59)
       sha1_k = 32'h8f1bbcdc;
   else
       sha1_k = 32'hca62c1d6;
end
endfunction

// SHA1 hash round
function logic [159:0] sha1_op(input logic [31:0] a, b, c, d, e, w,
                               input logic [7:0] t);
   logic [31:0] temp, tc; // internal signals
begin
   temp = ((a << 5)|(a >> 27)) + sha1_f(t) + e + sha1_k(t) + w;
   tc = ((b << 30)|(b >> 2));
   sha1_op = {temp, a, tc, c, d};
end
endfunction

// ---------------------------------------------------------------------------------------

// left rotation
function logic [31:0] leftrotate(input logic [31:0] x);
begin
    leftrotate = (x << 1) | (x >> 31);
end
endfunction

// ---------------------------------------------------------------------------------------

assign wt = leftrotate(w[13] ^ w[8] ^ w[2] ^ w[0]);
assign hash = {a, b, c, d, e};

always_ff @(posedge clk, negedge reset_n)
begin
    if (!reset_n) begin
        // this code ensures compiler keeps registers "a .. e" and "t"
        a <= 32'h67452301;
        b <= 32'hEFCDAB89;
        c <= 32'h98BADCFE;
        d <= 32'h10325476;
        e <= 32'hC3D2E1F0;
        t <= 0;
    end else begin
        {a, b, c, d, e} <= sha1_op(a, b, c, d, e, wt, t);
        
        // this code ensures compiler keeps registers for "t" and "w[0:15]"
        t <= t + 1;
        for (int i=0; i<15; i++) w[i] <= w[i+1];
        w[15] <= data;
    end
end
endmodule
