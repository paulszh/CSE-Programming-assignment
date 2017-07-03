//Author Zhouhang Shao & Haocheng Liang
//ECE 111 final project
//This design will run in 2006 cycles and have 97.77mHz Fmax
//The area is around 4165 in total

module super_hash_processor(input logic clk, reset_n, start, 
  input logic [1:0] opcode,
  input logic [31:0] message_addr, size, output_addr,
  output logic done, mem_clk, mem_we,
  output logic [15:0] mem_addr,
  output logic [31:0] mem_write_data,
  input logic [31:0] mem_read_data);
  
  logic [6:0] count;

  logic [12:0] message_size; //store the message size(in bits)

  logic [15:0] number_of_blocks; //record how many blocks need to be calculated 

  logic [8:0] number_of_last_bytes; //used for the last 512-bit block

  logic [12:0] read_addr;

  logic [12:0] write_addr;

  logic [31:0] h[8]; 

  logic [31:0] w[16]; 
  logic [31:0] w_temp;

  logic [1:0] op; //the opcode, might be deleted later

  logic pad_zero,pad_one; //indicate that we are processing the last block

  logic [255:0] hash_code;  //store the hash op at each iteration

  logic [31:0] hash_code_out[8];

  logic [6:0] num_round;

  logic start_next_block;

  //START_NEXT_BLOCK = 3'b101,


  assign mem_clk = clk;
    // Select the memory address based on the mem_we(the indicate bit)
    assign mem_addr = (mem_we == 0)? read_addr : write_addr;

    assign num_round = (opcode == 1)? 8'd80 : 8'd64;

    assign h[0] = hash_code[255:224]; //used for SHA2
    assign h[1] = hash_code[223:192];
    assign h[2] = hash_code[191:160];
    assign h[3] = hash_code[159:128]; //used for SHA1
    assign h[4] = hash_code[127:96]; //used for MD5
    assign h[5] = hash_code[95:64];
    assign h[6] = hash_code[63:32];
    assign h[7] = hash_code[31:0];


    enum logic [2:0] {IDLE=3'b000, READ_1=3'b001,  READ_2= 3'b010, COMPUTE=3'b011, WRITE=3'b100, READ_3 = 3'b111} state;
    
    //SHA 1 constant
    //parameter int sha1_init[0:4] = `{
    //32'h67452301, 32'hefcdab89, 32'h98badcfe, 32'h10325476, 32'hc3d2e1f0
    //}

    //SHA 2 constant
    //parameter int sha2_init[0:7] = `{
    //32'h6a09e667, 32'hbb67ae85, 32'h3c6ef372, 32'ha54ff53a, 32'h510e527f,32'h9b05688c,32'h1f83d9ab,32'h5be0cd19
    //}

    parameter int sha2_constant[0:63] = '{
    32'h428a2f98, 32'h71374491, 32'hb5c0fbcf, 32'he9b5dba5, 32'h3956c25b, 32'h59f111f1, 32'h923f82a4, 32'hab1c5ed5,
    32'hd807aa98, 32'h12835b01, 32'h243185be, 32'h550c7dc3, 32'h72be5d74, 32'h80deb1fe, 32'h9bdc06a7, 32'hc19bf174,
    32'he49b69c1, 32'hefbe4786, 32'h0fc19dc6, 32'h240ca1cc, 32'h2de92c6f, 32'h4a7484aa, 32'h5cb0a9dc, 32'h76f988da,
    32'h983e5152, 32'ha831c66d, 32'hb00327c8, 32'hbf597fc7, 32'hc6e00bf3, 32'hd5a79147, 32'h06ca6351, 32'h14292967,
    32'h27b70a85, 32'h2e1b2138, 32'h4d2c6dfc, 32'h53380d13, 32'h650a7354, 32'h766a0abb, 32'h81c2c92e, 32'h92722c85,
    32'ha2bfe8a1, 32'ha81a664b, 32'hc24b8b70, 32'hc76c51a3, 32'hd192e819, 32'hd6990624, 32'hf40e3585, 32'h106aa070,
    32'h19a4c116, 32'h1e376c08, 32'h2748774c, 32'h34b0bcb5, 32'h391c0cb3, 32'h4ed8aa4a, 32'h5b9cca4f, 32'h682e6ff3,
    32'h748f82ee, 32'h78a5636f, 32'h84c87814, 32'h8cc70208, 32'h90befffa, 32'ha4506ceb, 32'hbef9a3f7, 32'hc67178f2
    };

      // MD5 S constants
    parameter byte S[0:63] = '{
        8'd7, 8'd12, 8'd17, 8'd22, 8'd7, 8'd12, 8'd17, 8'd22, 8'd7, 8'd12, 8'd17, 8'd22, 8'd7, 8'd12, 8'd17, 8'd22,
        8'd5, 8'd9,  8'd14, 8'd20, 8'd5, 8'd9,  8'd14, 8'd20, 8'd5, 8'd9,  8'd14, 8'd20, 8'd5, 8'd9,  8'd14, 8'd20,
        8'd4, 8'd11, 8'd16, 8'd23, 8'd4, 8'd11, 8'd16, 8'd23, 8'd4, 8'd11, 8'd16, 8'd23, 8'd4, 8'd11, 8'd16, 8'd23,
        8'd6, 8'd10, 8'd15, 8'd21, 8'd6, 8'd10, 8'd15, 8'd21, 8'd6, 8'd10, 8'd15, 8'd21, 8'd6, 8'd10, 8'd15, 8'd21
    };
    // MD5 K constants
    parameter int md5_constant[0:63] = '{
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


    

    always_ff @(posedge clk or negedge reset_n) begin
      if(!reset_n) begin
        state <= IDLE;
      end else begin
        case(state)
          IDLE:
          begin
            if (done == 1) begin
              done <= 0;
              state <= IDLE;
             end else if(start) begin
                  //$display("message_addr = %x, output_addr=%x", message_addr, output_addr);
                  state <= READ_1; 
                  //calculate number of blocks

                  message_size <= size << 3;  

                  number_of_blocks <= determine_num_blocks(size);
                  $display("message size in byte: %d", size);
                  $display("number_of_blocks is %d", determine_num_blocks(size));
                  //assign the mesage address and output address
                  read_addr <= message_addr;

                  //start_next_block <= 0
                  
                  mem_we <= 0;    //set to read

                  pad_zero <= 0;

                  pad_one <= 0;

                  count <= 0;
                  
                  number_of_last_bytes <= size % 64;    

                  //initialize the value of h0,h1,h2,h3, MD5 will run first
                  //MD5 ONLY USES hash_code_out[4][5][6][7]
                  if(opcode == 0) begin 
                    hash_code[127:0] <= 128'h67452301efcdab8998badcfe10325476;
                    hash_code_out[0] <= 32'h00000000;
                    hash_code_out[1] <= 32'h00000000;
                    hash_code_out[2] <= 32'h00000000;
                    hash_code_out[3] <= 32'h00000000;
                    hash_code_out[4] <= 32'h67452301;
                    hash_code_out[5] <= 32'hefcdab89;
                    hash_code_out[6] <= 32'h98badcfe;
                    hash_code_out[7] <= 32'h10325476;
                    $display("START TO PROCESS MD5");
                    $display("The read address %d", message_addr);
                end else if(opcode == 1) begin

                    $display("START TO PROCESS SHA1");
                    $display("The read address %d", message_addr);

                    //SHA1 ONLY USES hash_code_out[3][4][5][6][7]
                    hash_code[159:0]<= 160'h67452301efcdab8998badcfe10325476c3d2e1f0;
                    hash_code_out[0] <= 32'h00000000;
                    hash_code_out[1] <= 32'h00000000;
                    hash_code_out[2] <= 32'h00000000;
                    hash_code_out[3] <= 32'h67452301;
                    hash_code_out[4] <= 32'hefcdab89;
                    hash_code_out[5] <= 32'h98badcfe;
                    hash_code_out[6] <= 32'h10325476;
                    hash_code_out[7] <= 32'hc3d2e1f0;

                end else if (opcode == 2)begin 

                    $display("START TO PROCESS SHA256");
                    $display("The read address %d", message_addr);
                    //assign the mesage address and output address
              
                    hash_code <= 256'h6a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd19;
                    hash_code_out[0] <= 32'h6a09e667;
                    hash_code_out[1] <= 32'hbb67ae85;
                    hash_code_out[2] <= 32'h3c6ef372;
                    hash_code_out[3] <= 32'ha54ff53a;
                    hash_code_out[4] <= 32'h510e527f;
                    hash_code_out[5] <= 32'h9b05688c;
                    hash_code_out[6] <= 32'h1f83d9ab;
                    hash_code_out[7] <= 32'h5be0cd19;
                end
              end else if (start_next_block == 1) begin
                 //       $display("hash_code out in previous block for SHA256: %x%x%x%x%x%x%x%x", hash_code_out[0],
                // hash_code_out[1],hash_code_out[2],hash_code_out[3],hash_code_out[4],hash_code_out[5],
                // hash_code_out[6],hash_code_out[7]);
        hash_code <= {hash_code_out[0],hash_code_out[1],hash_code_out[2],
        hash_code_out[3],hash_code_out[4],hash_code_out[5],
        hash_code_out[6],hash_code_out[7]};


        count <= 0;

        state <= READ_1;

        mem_we <= 0;

              end
          end

          READ_1: 
          begin

             state <= READ_2;
             
             read_addr <= read_addr + 1;

          end


          READ_2:
          begin
              state <= READ_3;
              read_addr <= read_addr + 1; //in this state, we already get the first word sfrom the memory 
              if(pad_zero) begin
                w[0] <= 32'h00000000;
                w_temp <= 32'h00000000;
              end else begin
                w[0] <= changeEndian(mem_read_data); //count should be 0 here
                w_temp <= changeEndian(mem_read_data);
              end
              count <= count+1;
              // $display("READ: %x WITH IDX: %d", changeEndian(mem_read_data), count);
              // $display("READ 1 STATE: The read address %d", read_addr-1);
              // if(pad_one) begin
              //   number_of_last_bytes <= number_of_last_bytes - 4; 
              // end
          end
             
          READ_3:
          begin
             //$display("READ 2 STATE: The read address %d and output address %d", message_addr, output_addr)
             //$display("pad_1, pad_zero %d %d %d ", pad_one, pad_zero, count);
            if(count<num_round+1) begin
              if(pad_one && count < 16) begin 

                if(pad_zero) begin
                  if(count == 15 && number_of_blocks == 1) begin
                    $display("padd message size");
                    w[count] <= message_size;
                    w_temp <= message_size;
                  end else begin 
                    $display("PADDING: %x", 32'h00000000);
                    w[count] <= 32'h00000000;
                    w_temp <= 32'h00000000;
                  end
                 
                end else if((number_of_last_bytes/4) > 0) begin
                   w[count] <= changeEndian(mem_read_data);
                   w_temp <= changeEndian(mem_read_data);
                   number_of_last_bytes <= number_of_last_bytes - 4; 
                   $display("READ: %x WITH IDX: %d", changeEndian(mem_read_data), count);
                //$display("READ 1 STATE: The read address %d", read_addr-1);
                    read_addr <= read_addr + 1;
                end else begin
                    $display("Number of last bytes should be 1, but is %d", number_of_last_bytes);
                    //$display("READ: %x, read_addr", mem_read_data, read_addr);
                    $display("READ 1 STATE: The read address %d", read_addr-1);
                    if (number_of_last_bytes == 1) begin      //pad 1 at the end
                      w[count]<=((changeEndian(mem_read_data) & 32'hFF000000) | 32'h00800000);
                      w_temp<=((changeEndian(mem_read_data) & 32'hFF000000) | 32'h00800000);
                    end else if (number_of_last_bytes == 2) begin 
                      w[count]<=((changeEndian(mem_read_data) & 32'hFFFF0000) | 32'h00008000);
                      w_temp<=((changeEndian(mem_read_data) & 32'hFFFF0000) | 32'h00008000);
                    end else if (number_of_last_bytes == 3) begin
                      w[count]<=((changeEndian(mem_read_data) & 32'hFFFFFF00) | 32'h00000080);
                      w_temp<=((changeEndian(mem_read_data) & 32'hFFFFFF00) | 32'h00000080);
                    end else begin
                      w[count]<= 32'h80000000;
                      w_temp <= 32'h80000000;
                      $display("READ: %x", 32'h80000000);
                    end
                    read_addr <= read_addr + 1;
                    pad_zero <= 1;
                end
              end else if(count<16) begin  //the number case: read data for 16 times 
                      w[count] <= changeEndian(mem_read_data); //get data from memory and store in w
                      w_temp <= changeEndian(mem_read_data);
                      $display("READ: %x WITH IDX: %d", changeEndian(mem_read_data), count);
                      //count <= count + 1;
                      read_addr <= read_addr + 1;  //update the memory address
              end else begin  //count == 16
                      //state <= COMPUTE;
                      // 600 alut less, 90.63 mhz 
                      //if((count) < num_round+1)begin
                        if(opcode == 1) begin
                            w[(count)%16] <= extend_w_sha1(count);
                            w_temp <= extend_w_sha1(count);
                        end 
                        else if(opcode == 2) begin
                            w[(count)%16] <= extend_w_sha256(count);
                            w_temp <= extend_w_sha256(count);
                        end
                        else begin
                            w_temp <= extend_w_md5(count);
                        end
                      //end

              end

              //calculate the w[] for previous cycle
              if(opcode == 0) begin 
                  hash_code[127:0] <= hash_op_md5(h[4],h[5],h[6],h[7],w_temp,count-1);
              end else if (opcode == 1) begin 
                  hash_code[159:0] <= hash_op_sha1(h[3],h[4],h[5],h[6],h[7],w_temp,count-1);            
              end else begin
                  hash_code <= hash_op_sha256(h[0],h[1],h[2],h[3],h[4],h[5],h[6],h[7],w_temp,count-1);             
              end

              count <= count + 1;
            end else begin 
              number_of_blocks <= number_of_blocks - 1;
              hash_code_out[7] <= hash_code_out[7] + h[7];
              hash_code_out[6] <= hash_code_out[6] + h[6];
              hash_code_out[5] <= hash_code_out[5] + h[5];
              hash_code_out[4] <= hash_code_out[4] + h[4];
              hash_code_out[3] <= hash_code_out[3] + h[3];
              hash_code_out[2] <= hash_code_out[2] + h[2];
              hash_code_out[1] <= hash_code_out[1] + h[1];
              hash_code_out[0] <= hash_code_out[0] + h[0];


              //$display("number_of_blocks = %d, number_of_last_bytes = %d", number_of_blocks, number_of_last_bytes);
              if(number_of_blocks == 3 && number_of_last_bytes > 55)begin

                pad_one <= 1;
                number_of_last_bytes <= number_of_last_bytes - 4; 
                state <= IDLE;
                start_next_block <= 1;
              //Then the next block is the last block
              end else if(number_of_blocks == 2 && number_of_last_bytes < 56) begin

                  pad_one <= 1;
                  number_of_last_bytes <= number_of_last_bytes - 4; 

                  state <= IDLE;
                  start_next_block <= 1;
              end else if(number_of_blocks == 1) begin //already at the last block, start to write in next state
                  state <= WRITE;
                  start_next_block <= 0;
                  write_addr <= output_addr-1;
                  count <= 0;
              end else begin
                  state <= IDLE;
                  start_next_block <= 1;
              end

              //block_complete <= 1;
              read_addr <= read_addr - 1;
            end 
          end


          WRITE:
          begin
            $display("praparing to write");
            //$display("current op is", opcode);

              if (opcode == 0 && count < 4) begin //write to memory 4 times for MD5
                   mem_we <= 1; //start to write
                   count <= count + 1;
                   mem_write_data <= hash_code_out[count+4];
                   write_addr <= write_addr + 1;
                  //state <= WRITE;
              end else if (opcode == 1 && count < 5) begin //write to memory 5 times for SHA1
                  //state <= WRITE;
                   mem_we <= 1; //start to write
                   count <= count + 1;
                   mem_write_data <= hash_code_out[count+3];
                   write_addr <= write_addr + 1;
                
              end else if (opcode == 2 && count < 8) begin //write to memory 8 times for SHA256
                   mem_we <= 1; //start to write
                  count <= count + 1;
                   mem_write_data <= hash_code_out[count];
                   write_addr <= write_addr + 1;
       
              end else begin
                //$display("DONE DONE DONE DONE",);

                state <= IDLE;
                done <= 1;
              end
            end
          
          
        endcase
      end
    end

    function logic [31:0] changeEndian(input logic [31:0] value);
      changeEndian = {value[7:0], value[15:8], value[23:16], value[31:24]};
    endfunction


    // function logic [31:0] leftRotate (input logic [31:0] toRotate);
    //   leftRotate = {toRotate[30:0],toRotate[31]};
    // endfunction

    function logic [31:0] rightrotate(input logic [31:0] x,input logic [7:0] r);
      rightrotate = (x >> r) | (x << (32-r));
    endfunction

    function logic [31:0] extend_w_sha256(input logic [7:0] count);
      logic [31:0] s0;
      logic [31:0] s1;
      
      s0 = rightrotate(w[(((count)%16)+1)%16],7) ^ rightrotate(w[(((count)%16)+1)%16],18) 
    ^ (w[(((count)%16)+1)%16] >> 3);  //w[i-15]
      s1 = rightrotate(w[(((count)%16)+14)%16],17)^ rightrotate(w[(((count)%16)+14)%16],19) 
    ^ (w[(((count)%16)+14)%16] >> 10);  //w[i-2]
    
      extend_w_sha256 = s1 + s0 + w[(((count)%16)+9)%16]+ w[((count)%16)];
    endfunction


    function logic [31:0] extend_w_md5(input logic [7:0] num);
      logic [7:0] temp;
        if (num <= 15)
          temp = num;
        else if (num <= 31)
          temp = (5*num + 1) % 16;
        else if (num <= 47)
          temp = (3*num + 5) % 16;
        else
          temp = (7*num) % 16;

        extend_w_md5 = w[temp];

    endfunction

    function logic [31:0] extend_w_sha1(input logic [7:0] count);
      extend_w_sha1 = rightrotate( w[((count)%16)] ^ w[(((count)%16)+2)%16] ^ w[(((count)%16)+8)%16] ^ w[(((count)%16)+13)%16],31);
    endfunction



    function logic [15:0] determine_num_blocks(input logic [31:0] size);

      logic [31:0] number_of_bits; 

      number_of_bits = size << 3;

      number_of_bits = number_of_bits + 64;

      number_of_bits = number_of_bits/512;

      determine_num_blocks = number_of_bits[15:0] + 1;
    endfunction


    //hash_op function for SHA2
    function logic [255:0] hash_op_sha256(input logic [31:0] a, b, c, d, e, f, g, h, w,
    input logic [7:0] t);

    logic [31:0] s1,s0,k,ch,maj,t1,t2;

      //$display("input value: %x, %x, %x, %x, %x, %x, %x, %x, %x, %x",a, b, c, d, e, f, g, h, w,t);
      s1 = rightrotate(e, 6) ^ rightrotate(e, 11) ^ rightrotate(e, 25)  ;
      ch = (e & f) ^ ((~e) & g);
      //$display("sha2 constant :%x", sha2_constant[t]);
      t1 = h + s1 + ch + w + sha2_constant[t];
      s0 = rightrotate(a, 2) ^ rightrotate(a, 13) ^ rightrotate(a, 22);
      maj = (a & b) ^ (a & c) ^ (b & c);
      t2 = s0 + maj;

      hash_op_sha256 = {t1 + t2, a, b, c, d + t1, e, f, g};

    endfunction


      //hash_op function for md5
    function logic [127:0] hash_op_md5(input logic [31:0] a, b, c, d, w,
    input logic [7:0] t);

      logic [31:0] t1, t2,f; // internal signals
      begin
        if (t <= 15)
          f = (b & c) | ((~b) & d);
        else if (t <= 31)
          f = (d & b) | ((~d) & c);
        else if (t <= 47)
          f = b ^ c ^ d;
        else
          f = c ^ (b | (~d));

        t1 = a + f + md5_constant[t] + w;
        t2 = b + ((t1 << S[t])|(t1 >> (32-S[t])));
        hash_op_md5 = {d, t2, b, c};
      end

    endfunction


  function logic [159:0] hash_op_sha1(input logic [31:0] a, b, c, d, e, w,
    input logic [7:0] t);

       logic [31:0] a1;
       //logic [15:0] b1;
       logic [31:0] c1;
       logic [31:0] temp;
       logic [31:0] k;

       logic [31:0] f;
       if(t >= 0 && t <= 19) begin
        f = (b & c)|((~b) & d); 
        k = 32'h5A827999;  
       end 
       else if(t >19 && t <= 39) begin
        f = b ^ c ^ d; 
        k = 32'h6ED9EBA1;   
       end
       else if(t >39 && t <= 59) begin
        f = (b & c)|(b & d) | (c & d );
        k = 32'h8F1BBCDC;

       end
       else begin //if(t >59 && t <= 79)
        f = b ^ c ^ d;   
        k = 32'hCA62C1D6;
       end

       //temp = {a[26:0],a[31:27]};
       temp = a << 5 | a >> 27;
       a1 = temp + f + e + k + w;
       //c1={b[1:0],b[31:2]};
       c1 = b << 30 | b >> 2;

       hash_op_sha1 = {a1, a, c1, c, d};
       //$display("%x %x %x %x %x",a1, a, c1, c, d);
   endfunction
endmodule


