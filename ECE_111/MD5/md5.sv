

module md5(input logic clk, reset_n, start,
  input logic [31:0] message_addr, size, output_addr,
  output logic done, mem_clk, mem_we,
  output logic [15:0] mem_addr,
  output logic [31:0] mem_write_data,
  input logic [31:0] mem_read_data);

  logic [31:0] temp;    

  logic [7:0] number_of_words;   //number of words left in a 512 blocks

  int count;

  logic [31:0] message_size; //store the message size(in bits)

  logic [15:0] number_of_blocks; //record how many blocks need to be calculated 

  logic [8:0] number_of_last_bytes; //used for the last 512-bit block

  logic [31:0] read_addr;

  logic [31:0] write_addr;

  logic [31:0] h[4]; 

  logic [31:0] w[16]; 

  logic pad_zero,pad_one; //indicate that we are processing the last block

  logic block_complete; //indicate when one block processing is finished

  logic [127:0] hash_code;  //store the hash op at each iteration 128 for MD5 algorithm

  logic [31:0] hash_code_out[4];

  parameter logic[7:0] S[0:63] = '{
      8'd7, 8'd12, 8'd17, 8'd22, 8'd7, 8'd12, 8'd17, 8'd22, 8'd7, 8'd12, 8'd17, 8'd22, 8'd7, 8'd12, 8'd17, 8'd22,
      8'd5, 8'd9,  8'd14, 8'd20, 8'd5, 8'd9,  8'd14, 8'd20, 8'd5, 8'd9,  8'd14, 8'd20, 8'd5, 8'd9,  8'd14, 8'd20,
      8'd4, 8'd11, 8'd16, 8'd23, 8'd4, 8'd11, 8'd16, 8'd23, 8'd4, 8'd11, 8'd16, 8'd23, 8'd4, 8'd11, 8'd16, 8'd23,
      8'd6, 8'd10, 8'd15, 8'd21, 8'd6, 8'd10, 8'd15, 8'd21, 8'd6, 8'd10, 8'd15, 8'd21, 8'd6, 8'd10, 8'd15, 8'd21
  };
  // MD5 K constants
  parameter logic[31:0] md5_constant[0:63] = '{
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



    assign mem_clk = clk;
    // Select the memory address based on the mem_we(the indicate bit)
    assign mem_addr = (mem_we == 0)? read_addr[15:0] : write_addr[15:0];

    assign h[0] = hash_code[127:96];
    assign h[1] = hash_code[95:64];
    assign h[2] = hash_code[63:32];
    assign h[3] = hash_code[31:0];


    enum logic [2:0] {IDLE=3'b000, READ_1=3'b001,  READ_2= 3'b010, COMPUTE=3'b011, WRITE=3'b100} state;
    


    always_ff @(posedge clk or negedge reset_n) begin
      if(!reset_n) begin
        state <= IDLE;
      end else begin
        case(state)
          IDLE:
          begin
            if(start) begin
              //$display("message_addr = %x, output_addr=%x", message_addr, output_addr);
            state <= READ_1; 
            //calculate number of blocks

            message_size <= size << 3;  

            number_of_blocks <= determine_num_blocks(size);
            $display("message size in byte: %d", size);
            $display("number_of_blocks is %d", determine_num_blocks(size));
            //assign the mesage address and output address
            read_addr <= message_addr;
            
            write_addr <= output_addr;
            
            mem_we <= 0;    //set to read

            pad_zero <= 0;

            pad_one <= 0;
            
            block_complete <= 0;  //set indicate bit to false

            count <= 0;
            
            number_of_words <= 8'd0;
            
            number_of_last_bytes <= size % 64;    

            //initialize the value of h0,h1,h2,h3,h4,h5,h6,h7,h8
            hash_code_out[0] <= 32'h67452301;
            hash_code_out[1] <= 32'hefcdab89;
            hash_code_out[2] <= 32'h98badcfe;
            hash_code_out[3] <= 32'h10325476;

            hash_code <= 128'h67452301efcdab8998badcfe10325476;

            

            end else if (block_complete) begin
                //before we start to process the next block, we reset the counter and indicate bit
                count <= 0;
                hash_code <= {hash_code_out[0],hash_code_out[1],hash_code_out[2],hash_code_out[3]};
                
                block_complete <= 0;

                number_of_words <= 0;

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
            if(pad_one && number_of_words < 16) begin 

              if(pad_zero) begin
               pad_zero_and_message_size(message_size,number_of_words);
               state <= COMPUTE;
               count <= 0;
            end else if((number_of_last_bytes/4) > 0) begin
               w[number_of_words] <= changeEndian(mem_read_data);
               number_of_last_bytes <= number_of_last_bytes - 4; 
               $display("READ: %x WITH IDX: %d", changeEndian(mem_read_data), number_of_words);
               read_addr <= read_addr + 1;
            end else begin
                    //$display("Number of last bytes should be 0, but is %d", number_of_last_bytes);
                    $display("READ: %x", mem_read_data);
                    if (number_of_last_bytes == 1) begin      //pad 1 at the end
                      w[number_of_words]<=((changeEndian(mem_read_data) & 32'hFF000000) | 32'h00800000);
                    end else if (number_of_last_bytes == 2) begin 
                      w[number_of_words]<=((changeEndian(mem_read_data) & 32'hFFFF0000) | 32'h00008000);
                    end else if (number_of_last_bytes == 3) begin
                      w[number_of_words]<=((changeEndian(mem_read_data) & 32'hFFFFFF00) | 32'h00000080);
                    end else if (number_of_last_bytes == 0) begin
                      w[number_of_words]<= 32'h80000000;
                    end
                    pad_zero <= 1;
                  end
                  number_of_words <= number_of_words + 1;
            end else if(number_of_words<16) begin  //the number case: read data for 16 times 
                    w[number_of_words] <= changeEndian(mem_read_data); //get data from memory and store in w
                    $display("READ: %x WITH IDX: %d", changeEndian(mem_read_data), number_of_words);
                    number_of_words <= number_of_words + 1;
                    read_addr <= read_addr + 1;  //update the memory address
                  end else begin
                   state <= COMPUTE;
            end
          end
               
          COMPUTE:
          begin
            //the initial value of count is 0 here
            if(count<64) begin

              hash_code <= hash_op(h[0],h[1],h[2],h[3],extend_w(count),count); 
              //$display(extend_w(count));
              //$display("count value : %d", count);
              //$display("hash_code: %x",hash_op_sha2(h[0],h[1],h[2],h[3],h[4],h[5],h[6],h[7],w[count%16],count));
              count <= count + 1;
            end else begin

              number_of_blocks <= number_of_blocks - 1;

              hash_code_out[3] <= hash_code_out[3] + h[3];
              hash_code_out[2] <= hash_code_out[2] + h[2];
              hash_code_out[1] <= hash_code_out[1] + h[1];
              hash_code_out[0] <= hash_code_out[0] + h[0];

              //$display("number_of_blocks = %d, number_of_last_bytes = %d", number_of_blocks, number_of_last_bytes);
              if(number_of_blocks == 3 && number_of_last_bytes > 55)begin

                pad_one <= 1;

                state <= IDLE;
              //Then the next block is the last block
              end else if(number_of_blocks == 2 && number_of_last_bytes < 56) begin

                  pad_one <= 1;

                  state <= IDLE;
              end else if(number_of_blocks == 1) begin //already at the last block, start to write in next state
                  state <= WRITE;
                  count <= 0;
              end else begin
                  state <= IDLE;
              end

              block_complete <= 1;
              read_addr = read_addr - 1; //important, need to decrease the address by one
            end
          end


          WRITE:
          begin
            if(count == 0) begin
             //$display("hash_code out before writing: %x%x%x%x", hash_code_out[0],hash_code_out[1],
              //hash_code_out[2],hash_code_out[3];
					      state <= WRITE;
                mem_we <= 1; //start to write
                count <= count + 1;
                mem_write_data <= hash_code_out[0];
            end else if (count < 4) begin //write to memory 8 times
                mem_write_data <= hash_code_out[count];
                write_addr <= write_addr + 1;
                count <= count + 1;
                state <= WRITE;
            end else begin
              state <= IDLE;
              done <= 1;
            end
          end
        endcase 
      end
    end


    function void pad_zero_and_message_size(input logic [31:0] message_size, input logic [7:0] idx);
      logic [7:0] i;

      if (number_of_blocks > 1) begin
        $display("Padding one and zero for the second last block");
        for (i = 0; i < 16; i++) begin
          if (i >= idx)
            w[i] = 32'b0;
        end
      end else if (number_of_blocks == 1) begin  //if last block
        //$display("idx should be 0 but is %d", idx);
        $display("Padding zero and size for the last block");
        for (i = 0; i < 14; i++) begin
          if (i >= idx)
            w[i] = 32'b0;
        end 
        w[14] = 32'h00000000;
        w[15] = message_size;
      end 

      number_of_words = 15;
    endfunction

    function logic [31:0] changeEndian(input logic [31:0] value);
      changeEndian = {value[7:0], value[15:8], value[23:16], value[31:24]};
    endfunction

    
    //t is the count
    function logic [31:0] extend_w(input logic [7:0] num);
      logic [7:0] temp;
        if (num <= 15)
          temp = num;
        else if (num <= 31)
          temp = (5*num + 1) % 16;
        else if (num <= 47)
          temp = (3*num + 5) % 16;
        else
          temp = (7*num) % 16;

        extend_w = w[temp];

    endfunction

    function logic [15:0] determine_num_blocks(input logic [31:0] size);

      logic [31:0] number_of_bits; 

      number_of_bits = size << 3;

      number_of_bits = number_of_bits + 64;

      number_of_bits = number_of_bits/512;

      determine_num_blocks = number_of_bits[15:0] + 1;
    endfunction
      // MD5 S constants

  //hash_op function for SHA2
    function logic [127:0] hash_op(input logic [31:0] a, b, c, d, w,
    input logic [7:0] t);

        logic [31:0] t1, t2, f; // internal signals
        if (t <= 15)
          f = (b & c) | ((~b) & d);
        else if (t <= 31)
          f = (d & b) | ((~d) & c);
        else if (t <= 47)
          f = b ^ c ^ d;
        else
          f = c ^ (b | (~d));

        t1 = a + f + w + md5_constant[t];
        t2 = b + ((t1 << S[t])|(t1 >> (32-S[t])));
        hash_op = {d, t2, b, c};

    endfunction



endmodule

