// This code is for PROTOTYPING ONLY to evaluate
// the critical path through the Wt computation
// and the hash computation (md5_op).
//
// This code DOES NOT implement the md5 project.
//
// To prevent the compiler from eliminating registers,
// the always_ff statement will assign to a, b, ...
// t, and the w array.

module eval_md5(input logic clk, reset_n,
                input logic [31:0] data,
               output logic [127:0] hash);

logic      [ 31:0]  w[0:15];
logic      [ 31:0]  wt;
logic      [ 31:0]  a, b, c, d;
logic      [  7:0]  t;

// ---------------------------------------------------------------------------------------

// MD5 S constants
parameter byte S[0:63] = '{
    8'd7, 8'd12, 8'd17, 8'd22, 8'd7, 8'd12, 8'd17, 8'd22, 8'd7, 8'd12, 8'd17, 8'd22, 8'd7, 8'd12, 8'd17, 8'd22,
    8'd5, 8'd9,  8'd14, 8'd20, 8'd5, 8'd9,  8'd14, 8'd20, 8'd5, 8'd9,  8'd14, 8'd20, 8'd5, 8'd9,  8'd14, 8'd20,
    8'd4, 8'd11, 8'd16, 8'd23, 8'd4, 8'd11, 8'd16, 8'd23, 8'd4, 8'd11, 8'd16, 8'd23, 8'd4, 8'd11, 8'd16, 8'd23,
    8'd6, 8'd10, 8'd15, 8'd21, 8'd6, 8'd10, 8'd15, 8'd21, 8'd6, 8'd10, 8'd15, 8'd21, 8'd6, 8'd10, 8'd15, 8'd21
};

// MD5 K constants
parameter int md5_k[0:63] = '{
    32'hd76aa478, 32'he8c7b756, 32'h242070db, 32'hc1bdceee,
    32'hf57c0faf, 32'h4787c62a, 32'ha8304613, 32'hfd469501,
    32'h698098d8, 32'h8b44f7af, 32'hffff5bb1, 32'h895cd7be,
    32'h6b901122, 32'hfd987193, 32'ha679438e, 32'h49b40821,
    32'hf61e2562, 32'hc040b340, 32'h265e5a51, 32'he9b6c7aa,
    32'hd62f105d, 32'h02441453, 32'hd8a1e681, 32'he7d3fbc8,
    32'h21e1cde6, 32'hc33707d6, 32'hf4d50d87, 32'h455a14ed,
    32'ha9e3e905, 32'hfcefa3f8, 32'h676f02d9, 32'h8d2a4c8a,
    32'hfffa3942, 32'h8771f681, 32'h6d9d6122, 32'hfde5380c,
    32'ha4beea44, 32'h4bdecfa9, 32'hf6bb4b60, 32'hbebfbc70,
    32'h289b7ec6, 32'heaa127fa, 32'hd4ef3085, 32'h04881d05,
    32'hd9d4d039, 32'he6db99e5, 32'h1fa27cf8, 32'hc4ac5665,
    32'hf4292244, 32'h432aff97, 32'hab9423a7, 32'hfc93a039,
    32'h655b59c3, 32'h8f0ccc92, 32'hffeff47d, 32'h85845dd1,
    32'h6fa87e4f, 32'hfe2ce6e0, 32'ha3014314, 32'h4e0811a1,
    32'hf7537e82, 32'hbd3af235, 32'h2ad7d2bb, 32'heb86d391
};

// MD5 g
function logic[3:0] md5_g(input logic [7:0] t);
begin
   if (t <= 15)
       md5_g = t;
   else if (t <= 31)
       md5_g = (5*t + 1) % 16;
   else if (t <= 47)
       md5_g = (3*t + 5) % 16;
   else
       md5_g = (7*t) % 16;
end
endfunction

// MD5 f
function logic[31:0] md5_f(input logic [7:0] t);
begin
    if (t <= 15)
        md5_f = (b & c) | ((~b) & d);
    else if (t <= 31)
        md5_f = (d & b) | ((~d) & c);
    else if (t <= 47)
        md5_f = b ^ c ^ d;
    else
        md5_f = c ^ (b | (~d));
end
endfunction

// MD5 hash round
function logic[127:0] md5_op(input logic [31:0] a, b, c, d, w,
                             input logic [7:0] t);
    logic [31:0] t1, t2; // internal signals
begin
    t1 = a + md5_f(t) + md5_k[t] + w;
    t2 = b + ((t1 << S[t])|(t1 >> (32-S[t])));
    md5_op = {d, t2, b, c};
end
endfunction

// ---------------------------------------------------------------------------------------

assign wt = w[md5_g(t)];
assign hash = {a, b, c, d};

always_ff @(posedge clk, negedge reset_n)
begin
    if (!reset_n) begin
        // this code ensures compiler keeps registers "a .. d" and "t"
        a <= 32'h67452301;
        b <= 32'hEFCDAB89;
        c <= 32'h98BADCFE;
        d <= 32'h10325476;
        t <= 0;
    end else begin
        {a, b, c, d} <= md5_op(a, b, c, d, wt, t);

        // this code ensures compiler keeps registers for "t" and "w[0:15]"
        t <= t + 1;
        if (t <= 16) begin
            for (int i=0; i<15; i++) w[i] <= w[i+1];
            w[15] <= data;
        end
    end
end

endmodule
