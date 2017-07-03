

module sha256(input logic clk, reset_n, start,
	input logic [31:0] message_addr, size, output_addr,
	output logic done, mem_clk, mem_we,
	output logic [15:0] mem_addr,
	output logic [31:0] mem_write_data,
	input logic [31:0] mem_read_data);

  logic [31:0] temp;    

	logic [7:0] number_of_words;   //number of words left in a 512 blocks

  logic [7:0] count;

    //Logic [7:0] count_w;

  logic [31:0] message_size; //store the message size(in bits)

  logic [15:0] number_of_blocks; //record how many blocks need to be calculated 

  logic [8:0] number_of_last_bytes; //used for the last 512-bit block

  logic [31:0] read_addr;

  logic [31:0] write_addr;

  logic [31:0] h[8]; 

  logic [31:0] w[16]; 

    //logic [31:0] k[64];  //different k to calculate hash_op at each round

  logic pad_zero,pad_one; //indicate that we are processing the last block

  logic block_complete; //indicate when one block processing is finished

  logic [255:0] hash_code;  //store the hash op at each iteration
  logic [31:0] hash_code_out[8];


  assign mem_clk = clk;
    // Select the memory address based on the mem_we(the indicate bit)
    assign mem_addr = (mem_we == 0)? read_addr[15:0] : write_addr[15:0];

    assign h[0] = hash_code[255:224];
    assign h[1] = hash_code[223:192];
    assign h[2] = hash_code[191:160];
    assign h[3] = hash_code[159:128];
    assign h[4] = hash_code[127:96];
    assign h[5] = hash_code[95:64];
    assign h[6] = hash_code[63:32];
    assign h[7] = hash_code[31:0];


    enum logic [2:0] {IDLE=3'b000, READ_1=3'b001,  READ_2= 3'b010, COMPUTE=3'b011, WRITE=3'b100} state;
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


    //assign done = (count == 0)? 1 : 0; // assign the value of done based on the count

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

            count <= 8'd0;
            
            number_of_words <= 8'd0;
            
            number_of_last_bytes <= size % 64;    

            //initialize the value of h0,h1,h2,h3,h4,h5,h6,h7,h8
            hash_code_out[0] <= 32'h6a09e667;
            hash_code_out[1] <= 32'hbb67ae85;
            hash_code_out[2] <= 32'h3c6ef372;
            hash_code_out[3] <= 32'ha54ff53a;
            hash_code_out[4] <= 32'h510e527f;
            hash_code_out[5] <= 32'h9b05688c;
            hash_code_out[6] <= 32'h1f83d9ab;
            hash_code_out[7] <= 32'h5be0cd19;

            hash_code <= 256'h6a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd19;

            

            end else if (block_complete) begin
              	//before we start to process the next block, we reset the counter and indicate bit
              	$display("Preparing for next block");
              	$display("hash_code out in IDLE state: %x%x%x%x%x%x%x%x", hash_code_out[0],hash_code_out[1],
              		hash_code_out[2],hash_code_out[3],hash_code_out[4],hash_code_out[5],hash_code_out[6],
              		hash_code_out[7]);
              	count <= 0;
              	hash_code <= {hash_code_out[0],hash_code_out[1],hash_code_out[2],
              	hash_code_out[3],hash_code_out[4],hash_code_out[5],
              	hash_code_out[6],hash_code_out[7]};
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
            if(count<64) begin

              if(number_of_words < 64)begin
               w[number_of_words%16] <= extend_w(w,count);
               number_of_words <= number_of_words + 1;
              end

              //$display("count value : %d", count);
              hash_code <= hash_op_sha2(h[0],h[1],h[2],h[3],h[4],h[5],h[6],h[7],w[count%16],count);             
              //$display("hash_code: %x",hash_op_sha2(h[0],h[1],h[2],h[3],h[4],h[5],h[6],h[7],w[count%16],count));
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
              read_addr = read_addr - 1;
            end
          end


          WRITE:
          begin
            if(count == 0) begin
             $display("hash_code out before writing: %x%x%x%x%x%x%x%x", hash_code_out[0],hash_code_out[1],
              hash_code_out[2],hash_code_out[3],hash_code_out[4],hash_code_out[5],hash_code_out[6],
              hash_code_out[7]);
             state <= WRITE;
               	mem_we <= 1; //start to write
               	count <= count + 1;
               	mem_write_data <= hash_code_out[0];
         		end else if (count < 8) begin //write to memory 8 times
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


    function logic [31:0] leftRotate (input logic [31:0] toRotate);
      leftRotate = {toRotate[30:0],toRotate[31]};
    endfunction

    function logic [31:0] rightrotate(input logic [31:0] x,input logic [7:0] r);
      rightrotate = (x >> r) | (x << (32-r));
    endfunction

    function logic [31:0] extend_w(input logic [31:0] w[16], input logic [7:0] count);
      logic [31:0] s0;
      logic [31:0] s1;
      
      s0 = rightrotate(w[(((count)%16)+1)%16],7) ^ rightrotate(w[(((count)%16)+1)%16],18) 
  	^ (w[(((count)%16)+1)%16] >> 3);  //w[i-15]
      s1 = rightrotate(w[(((count)%16)+14)%16],17)^ rightrotate(w[(((count)%16)+14)%16],19) 
  	^ (w[(((count)%16)+14)%16] >> 10);  //w[i-2]
  	
      extend_w = w[((count)%16)] + s0 + w[(((count)%16)+9)%16]+ s1;
    endfunction

    function logic [15:0] determine_num_blocks(input logic [31:0] size);

    	logic [31:0] number_of_bits; 

    	number_of_bits = size << 3;

    	number_of_bits = number_of_bits + 64;

    	number_of_bits = number_of_bits/512;

    	determine_num_blocks = number_of_bits[15:0] + 1;
    endfunction


  //hash_op function for SHA2
    function logic [255:0] hash_op_sha2(input logic [31:0] a, b, c, d, e, f, g, h, w,
    input logic [7:0] t);

    logic [31:0] s1,s0,k,ch,maj,t1,t2;

      //$display("input value: %x, %x, %x, %x, %x, %x, %x, %x, %x, %x",a, b, c, d, e, f, g, h, w,t);
      s1 = rightrotate(e, 6) ^ rightrotate(e, 11) ^ rightrotate(e, 25)	;
      ch = (e & f) ^ ((~e) & g);
      //$display("sha2 constant :%x", sha2_constant[t]);
      t1 = h + s1 + ch + sha2_constant[t] + w;
      s0 = rightrotate(a, 2) ^ rightrotate(a, 13) ^ rightrotate(a, 22);
      maj = (a & b) ^ (a & c) ^ (b & c);
      t2 = s0 + maj;

      hash_op_sha2 = {t1 + t2, a, b, c, d + t1, e, f, g};

    endfunction
endmodule
